package com.project.dao;

import com.project.config.DBContext;
import com.project.model.LoyaltyTransaction;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object Implementation: Loyalty Points System (UC-LOYALTY)
 *
 * <p>All multi-step writes run inside a single DB transaction
 * (conn.setAutoCommit(false) / commit / rollback pattern).</p>
 *
 * <p>Lazy migration: on first use, checks whether the loyalty columns and
 * the loyalty_transactions table exist and creates them if missing — same
 * approach as {@code UserDAOImpl#ensureMustChangePasswordColumnExists}.</p>
 *
 * Package: com.project.dao
 */
public class LoyaltyDAOImpl implements LoyaltyDAO {

    private static final Logger LOGGER = Logger.getLogger(LoyaltyDAOImpl.class.getName());

    // ── Lazy schema migration guard ──────────────────────────────────────────

    private static volatile boolean schemaMigrationDone = false;

    private static void ensureLoyaltySchema(Connection conn) {
        if (schemaMigrationDone) return;
        synchronized (LoyaltyDAOImpl.class) {
            if (schemaMigrationDone) return;

            // Add loyalty columns to users.
            // IF NOT EXISTS (MySQL 8.0.3+) is NOT used here for compatibility with MySQL 5.7.
            // Error code 1060 = "Duplicate column name" — means columns already exist, safe to ignore.
            try (Statement st = conn.createStatement()) {
                st.executeUpdate(
                    "ALTER TABLE users " +
                    "ADD COLUMN loyalty_points_balance INT NOT NULL DEFAULT 0, " +
                    "ADD COLUMN loyalty_total_earned    INT NOT NULL DEFAULT 0, " +
                    "ADD COLUMN loyalty_tier ENUM('BRONZE','SILVER','GOLD','PLATINUM') NOT NULL DEFAULT 'BRONZE'");
            } catch (SQLException e) {
                if (e.getErrorCode() != 1060) { // 1060 = Duplicate column name
                    LOGGER.log(Level.WARNING, "[Loyalty] Could not add loyalty columns (code=" + e.getErrorCode() + "): " + e.getMessage());
                }
                // 1060 means columns already exist → migration already ran → fine
            }

            // CREATE TABLE IF NOT EXISTS is supported on all MySQL versions.
            try (Statement st = conn.createStatement()) {
                st.executeUpdate(
                    "CREATE TABLE IF NOT EXISTS loyalty_transactions (" +
                    " transaction_id  INT AUTO_INCREMENT PRIMARY KEY," +
                    " user_id         INT NOT NULL," +
                    " booking_id      INT NULL," +
                    " points          INT NOT NULL," +
                    " transaction_type ENUM('EARN','REDEEM','REFUND','ADJUSTMENT') NOT NULL DEFAULT 'EARN'," +
                    " description     VARCHAR(255) NULL," +
                    " created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                    " FOREIGN KEY (user_id)    REFERENCES users(user_id)    ON DELETE CASCADE," +
                    " FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE SET NULL," +
                    " INDEX idx_loyalty_user (user_id)," +
                    " INDEX idx_loyalty_booking (booking_id)" +
                    ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci");
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "[Loyalty] Could not create loyalty_transactions table: " + e.getMessage());
            }

            schemaMigrationDone = true;
        }
    }

    // ── Core Write Operations ─────────────────────────────────────────────────

    @Override
    public boolean earnPoints(int userId, int bookingId, BigDecimal finalTotal, String tier) {
        int points = LoyaltyDAO.calculateEarnPoints(finalTotal, tier);
        if (points <= 0) return true; // nothing to award

        String desc = "Tích điểm đặt phòng #" + bookingId + " (" + tier + " ×"
                + (tier != null && tier.equalsIgnoreCase("PLATINUM") ? "2.0"
                        : tier != null && tier.equalsIgnoreCase("GOLD") ? "1.5"
                        : tier != null && tier.equalsIgnoreCase("SILVER") ? "1.25"
                        : "1.0") + ")";

        Connection conn = null;
        try {
            conn = DBContext.getConnection();
            ensureLoyaltySchema(conn);
            conn.setAutoCommit(false);

            // 1. Insert EARN transaction
            insertTransaction(conn, userId, bookingId, points, "EARN", desc);

            // 2. Update user balance + total earned
            String updateSql =
                "UPDATE users " +
                "SET loyalty_points_balance = loyalty_points_balance + ?, " +
                "    loyalty_total_earned   = loyalty_total_earned   + ? " +
                "WHERE user_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                ps.setInt(1, points);
                ps.setInt(2, points);
                ps.setInt(3, userId);
                ps.executeUpdate();
            }

            // 3. Recalculate and update tier
            int totalEarned = getTotalEarnedInTx(conn, userId);
            String newTier  = LoyaltyDAO.computeTier(totalEarned);
            updateTierInTx(conn, userId, newTier);

            conn.commit();
            LOGGER.info("[Loyalty] Earned " + points + " pts for user " + userId
                    + " (booking " + bookingId + "). New tier: " + newTier);
            return true;

        } catch (SQLException e) {
            rollback(conn);
            LOGGER.log(Level.SEVERE, "[Loyalty] earnPoints failed for userId=" + userId, e);
            return false;
        } finally {
            closeConn(conn);
        }
    }

    @Override
    public boolean redeemPoints(int userId, Integer bookingId, int points, String description) {
        if (points <= 0) return false;

        Connection conn = null;
        try {
            conn = DBContext.getConnection();
            ensureLoyaltySchema(conn);
            conn.setAutoCommit(false);

            // Verify sufficient balance
            int balance = getBalanceInTx(conn, userId);
            if (balance < points) {
                conn.rollback();
                LOGGER.warning("[Loyalty] Insufficient balance: user " + userId
                        + " has " + balance + " but tried to redeem " + points);
                return false;
            }

            // 1. Insert REDEEM transaction (negative points)
            insertTransaction(conn, userId, bookingId, -points, "REDEEM",
                    description != null ? description : "Dùng điểm thưởng đặt phòng");

            // 2. Deduct from balance (do NOT deduct total_earned — that's lifetime metric)
            String sql = "UPDATE users SET loyalty_points_balance = loyalty_points_balance - ? WHERE user_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, points);
                ps.setInt(2, userId);
                ps.executeUpdate();
            }

            conn.commit();
            LOGGER.info("[Loyalty] Redeemed " + points + " pts for user " + userId
                    + " (booking " + bookingId + ")");
            return true;

        } catch (SQLException e) {
            rollback(conn);
            LOGGER.log(Level.SEVERE, "[Loyalty] redeemPoints failed for userId=" + userId, e);
            return false;
        } finally {
            closeConn(conn);
        }
    }

    @Override
    public int refundRedeemedPoints(int bookingId) {
        // Find all REDEEM transactions for this booking (points are stored as negative)
        String selectSql =
            "SELECT user_id, points FROM loyalty_transactions " +
            "WHERE booking_id = ? AND transaction_type = 'REDEEM'";

        Connection conn = null;
        int totalRefunded = 0;
        try {
            conn = DBContext.getConnection();
            ensureLoyaltySchema(conn);
            conn.setAutoCommit(false);

            List<int[]> toRefund = new ArrayList<>(); // [userId, absPoints]
            try (PreparedStatement ps = conn.prepareStatement(selectSql)) {
                ps.setInt(1, bookingId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        int uid   = rs.getInt("user_id");
                        int pts   = Math.abs(rs.getInt("points")); // stored negative, refund positive
                        if (pts > 0) toRefund.add(new int[]{uid, pts});
                    }
                }
            }

            for (int[] entry : toRefund) {
                int uid = entry[0], pts = entry[1];

                // Insert REFUND transaction
                insertTransaction(conn, uid, bookingId, pts, "REFUND",
                        "Hoàn điểm do hủy đặt phòng #" + bookingId);

                // Add back to balance
                String updSql = "UPDATE users SET loyalty_points_balance = loyalty_points_balance + ? WHERE user_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(updSql)) {
                    ps.setInt(1, pts);
                    ps.setInt(2, uid);
                    ps.executeUpdate();
                }
                totalRefunded += pts;
            }

            conn.commit();
            if (totalRefunded > 0) {
                LOGGER.info("[Loyalty] Refunded " + totalRefunded + " pts for booking " + bookingId);
            }
            return totalRefunded;

        } catch (SQLException e) {
            rollback(conn);
            LOGGER.log(Level.SEVERE, "[Loyalty] refundRedeemedPoints failed for bookingId=" + bookingId, e);
            return 0;
        } finally {
            closeConn(conn);
        }
    }

    // ── Read Operations ───────────────────────────────────────────────────────

    @Override
    public int getBalance(int userId) {
        try (Connection conn = DBContext.getConnection()) {
            ensureLoyaltySchema(conn);
            return getBalanceInTx(conn, userId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[Loyalty] getBalance failed for userId=" + userId, e);
            return 0;
        }
    }

    @Override
    public int getTotalEarned(int userId) {
        String sql = "SELECT COALESCE(loyalty_total_earned, 0) FROM users WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ensureLoyaltySchema(conn);
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[Loyalty] getTotalEarned failed for userId=" + userId, e);
            return 0;
        }
    }

    @Override
    public String getTier(int userId) {
        String sql = "SELECT COALESCE(loyalty_tier, 'BRONZE') FROM users WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ensureLoyaltySchema(conn);
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getString(1) : "BRONZE";
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[Loyalty] getTier failed for userId=" + userId, e);
            return "BRONZE";
        }
    }

    @Override
    public List<LoyaltyTransaction> getHistory(int userId, int offset, int limit) {
        List<LoyaltyTransaction> list = new ArrayList<>();
        String sql =
            "SELECT lt.*, b.booking_code " +
            "FROM loyalty_transactions lt " +
            "LEFT JOIN bookings b ON lt.booking_id = b.booking_id " +
            "WHERE lt.user_id = ? " +
            "ORDER BY lt.created_at DESC " +
            "LIMIT ? OFFSET ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ensureLoyaltySchema(conn);
            ps.setInt(1, userId);
            ps.setInt(2, limit);
            ps.setInt(3, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[Loyalty] getHistory failed for userId=" + userId, e);
        }
        return list;
    }

    @Override
    public int countHistory(int userId) {
        String sql = "SELECT COUNT(*) FROM loyalty_transactions WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ensureLoyaltySchema(conn);
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[Loyalty] countHistory failed for userId=" + userId, e);
            return 0;
        }
    }

    // ── Private Helpers ───────────────────────────────────────────────────────

    private void insertTransaction(Connection conn, int userId, Integer bookingId,
                                   int points, String type, String description) throws SQLException {
        String sql =
            "INSERT INTO loyalty_transactions (user_id, booking_id, points, transaction_type, description) " +
            "VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            if (bookingId != null) ps.setInt(2, bookingId);
            else                   ps.setNull(2, Types.INTEGER);
            ps.setInt(3, points);
            ps.setString(4, type);
            ps.setString(5, description);
            ps.executeUpdate();
        }
    }

    private int getBalanceInTx(Connection conn, int userId) throws SQLException {
        String sql = "SELECT COALESCE(loyalty_points_balance, 0) FROM users WHERE user_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    private int getTotalEarnedInTx(Connection conn, int userId) throws SQLException {
        String sql = "SELECT COALESCE(loyalty_total_earned, 0) FROM users WHERE user_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    private void updateTierInTx(Connection conn, int userId, String tier) throws SQLException {
        String sql = "UPDATE users SET loyalty_tier = ? WHERE user_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tier);
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }

    private LoyaltyTransaction mapRow(ResultSet rs) throws SQLException {
        LoyaltyTransaction lt = new LoyaltyTransaction();
        lt.setTransactionId(rs.getInt("transaction_id"));
        lt.setUserId(rs.getInt("user_id"));
        int bid = rs.getInt("booking_id");
        lt.setBookingId(rs.wasNull() ? null : bid);
        lt.setPoints(rs.getInt("points"));
        String type = rs.getString("transaction_type");
        lt.setTransactionType(type != null
                ? LoyaltyTransaction.TransactionType.valueOf(type)
                : LoyaltyTransaction.TransactionType.EARN);
        lt.setDescription(rs.getString("description"));
        lt.setCreatedAt(rs.getTimestamp("created_at"));
        try { lt.setBookingCode(rs.getString("booking_code")); } catch (SQLException ignored) {}
        return lt;
    }

    private void rollback(Connection conn) {
        try { if (conn != null) conn.rollback(); } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "[Loyalty] Rollback failed", e);
        }
    }

    private void closeConn(Connection conn) {
        try {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "[Loyalty] Error closing connection", e);
        }
    }
}
