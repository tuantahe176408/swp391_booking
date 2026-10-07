package com.project.dao;

import com.project.config.DBContext;
import com.project.model.StaffInfo;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * JDBC Implementation: Receptionist Staff Management (UC21)
 * Package: com.project.dao
 *
 * Tables:
 *   receptionist_staff (staff_id, user_id UNIQUE, homestay_id, assigned_at)
 *   users              (user_id, full_name, email, avatar_url, is_active, must_change_password, updated_at, created_at)
 *   homestays          (homestay_id, owner_id, name)
 */
public class StaffDAOImpl implements StaffDAO {

    private static final Logger LOGGER = Logger.getLogger(StaffDAOImpl.class.getName());

    // ── Query constants ────────────────────────────────────────────────────

    private static final String SQL_GET_STAFF_BY_OWNER =
        "SELECT u.user_id, u.full_name, u.email, u.avatar_url, u.is_active, " +
        "       u.must_change_password, u.updated_at, u.created_at, " +
        "       rs.homestay_id, h.name AS homestay_name " +
        "FROM receptionist_staff rs " +
        "JOIN users     u ON u.user_id      = rs.user_id " +
        "JOIN homestays h ON h.homestay_id  = rs.homestay_id " +
        "WHERE h.owner_id = ? " +
        "ORDER BY u.full_name ASC";

    private static final String SQL_IS_STAFF_OF_OWNER =
        "SELECT 1 " +
        "FROM receptionist_staff rs " +
        "JOIN homestays h ON h.homestay_id = rs.homestay_id " +
        "WHERE rs.user_id = ? AND h.owner_id = ? " +
        "LIMIT 1";

    private static final String SQL_ASSIGN =
        "INSERT INTO receptionist_staff (user_id, homestay_id) VALUES (?, ?) " +
        "ON DUPLICATE KEY UPDATE homestay_id = VALUES(homestay_id)";

    private static final String SQL_COUNT_ACTIVE =
        "SELECT COUNT(*) FROM receptionist_staff rs " +
        "JOIN users     u ON u.user_id      = rs.user_id " +
        "JOIN homestays h ON h.homestay_id  = rs.homestay_id " +
        "WHERE h.owner_id = ? AND u.is_active = TRUE AND u.must_change_password = FALSE";

    private static final String SQL_COUNT_PENDING =
        "SELECT COUNT(*) FROM receptionist_staff rs " +
        "JOIN users     u ON u.user_id      = rs.user_id " +
        "JOIN homestays h ON h.homestay_id  = rs.homestay_id " +
        "WHERE h.owner_id = ? AND u.is_active = TRUE AND u.must_change_password = TRUE";

    private static final String SQL_COUNT_MANAGED_HOMESTAYS =
        "SELECT COUNT(DISTINCT rs.homestay_id) " +
        "FROM receptionist_staff rs " +
        "JOIN homestays h ON h.homestay_id = rs.homestay_id " +
        "WHERE h.owner_id = ?";

    // ── Interface methods ──────────────────────────────────────────────────

    @Override
    public List<StaffInfo> getStaffByOwnerId(int ownerId) {
        List<StaffInfo> result = new ArrayList<>();
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_GET_STAFF_BY_OWNER)) {
            ps.setInt(1, ownerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "getStaffByOwnerId failed for ownerId=" + ownerId, e);
        }
        return result;
    }

    @Override
    public boolean isStaffAssignedToOwner(int userId, int ownerId) {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_IS_STAFF_OF_OWNER)) {
            ps.setInt(1, userId);
            ps.setInt(2, ownerId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                "isStaffAssignedToOwner failed for userId=" + userId + ", ownerId=" + ownerId, e);
        }
        return false;
    }

    @Override
    public boolean assignToHomestay(int userId, int homestayId) {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_ASSIGN)) {
            ps.setInt(1, userId);
            ps.setInt(2, homestayId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                "assignToHomestay failed for userId=" + userId + ", homestayId=" + homestayId, e);
        }
        return false;
    }

    @Override
    public int countActiveByOwnerId(int ownerId) {
        return queryCount(SQL_COUNT_ACTIVE, ownerId);
    }

    @Override
    public int countPendingByOwnerId(int ownerId) {
        return queryCount(SQL_COUNT_PENDING, ownerId);
    }

    @Override
    public int countManagedHomestaysByOwnerId(int ownerId) {
        return queryCount(SQL_COUNT_MANAGED_HOMESTAYS, ownerId);
    }

    // ── Helpers ────────────────────────────────────────────────────────────

    private int queryCount(String sql, int ownerId) {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "queryCount failed: " + sql, e);
        }
        return 0;
    }

    private StaffInfo mapRow(ResultSet rs) throws SQLException {
        StaffInfo s = new StaffInfo();
        s.setUserId(rs.getInt("user_id"));
        s.setFullName(rs.getString("full_name"));
        s.setEmail(rs.getString("email"));
        s.setAvatarUrl(rs.getString("avatar_url"));
        s.setActive(rs.getBoolean("is_active"));
        s.setMustChangePassword(rs.getBoolean("must_change_password"));
        s.setUpdatedAt(rs.getTimestamp("updated_at"));
        s.setCreatedAt(rs.getTimestamp("created_at"));
        s.setHomestayId(rs.getInt("homestay_id"));
        s.setHomestayName(rs.getString("homestay_name"));
        return s;
    }
}
