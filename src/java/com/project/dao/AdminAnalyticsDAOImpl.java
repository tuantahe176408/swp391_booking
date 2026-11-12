package com.project.dao;

import com.project.config.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * JDBC Implementation: Platform Analytics & Financials (UC25)
 * Package: com.project.dao
 *
 * All monetary values returned as long (VNĐ, no decimals needed for display).
 * Date range parameters are "yyyy-MM-dd" ISO strings; null = unbounded.
 */
public class AdminAnalyticsDAOImpl implements AdminAnalyticsDAO {

    private static final Logger LOGGER = Logger.getLogger(AdminAnalyticsDAOImpl.class.getName());

    // Statuses that represent real revenue
    private static final String SUCCESS_STATUSES = "'CONFIRMED','CHECKED_IN','CHECKED_OUT'";

    // ── KPI Metrics ───────────────────────────────────────────────────────

    @Override
    public long getTotalGmv(String fromDate, String toDate) {
        String sql = "SELECT COALESCE(SUM(final_total), 0) FROM bookings " +
                     "WHERE booking_status IN (" + SUCCESS_STATUSES + ")" +
                     buildDateClause(fromDate, toDate);
        return queryLong(sql, fromDate, toDate);
    }

    @Override
    public int countSuccessfulBookings(String fromDate, String toDate) {
        String sql = "SELECT COUNT(*) FROM bookings " +
                     "WHERE booking_status IN (" + SUCCESS_STATUSES + ")" +
                     buildDateClause(fromDate, toDate);
        return (int) queryLong(sql, fromDate, toDate);
    }

    @Override
    public int countCancelledBookings(String fromDate, String toDate) {
        String sql = "SELECT COUNT(*) FROM bookings " +
                     "WHERE booking_status = 'CANCELLED'" +
                     buildDateClause(fromDate, toDate);
        return (int) queryLong(sql, fromDate, toDate);
    }

    @Override
    public int countTotalBookings(String fromDate, String toDate) {
        String sql = "SELECT COUNT(*) FROM bookings " +
                     "WHERE booking_status <> 'PENDING'" +
                     buildDateClause(fromDate, toDate);
        return (int) queryLong(sql, fromDate, toDate);
    }

    // ── Platform Totals ───────────────────────────────────────────────────

    @Override
    public int countActiveHomestays() {
        return (int) queryLong("SELECT COUNT(*) FROM homestays WHERE status = 'ACTIVE'",
                               null, null);
    }

    @Override
    public int countOwners() {
        return (int) queryLong("SELECT COUNT(*) FROM users WHERE role = 'OWNER' AND is_active = TRUE",
                               null, null);
    }

    @Override
    public int countCustomers() {
        return (int) queryLong("SELECT COUNT(*) FROM users WHERE role = 'CUSTOMER' AND is_active = TRUE",
                               null, null);
    }

    // ── Chart Data ────────────────────────────────────────────────────────

    @Override
    public List<Object[]> getChartData(String fromDate, String toDate, String groupBy) {
        List<Object[]> result = new ArrayList<>();

        // SQL date format and label format depend on groupBy
        String dateFormat = "MONTH".equals(groupBy)
                ? "%Y-%m"      // "2026-10" — used for sorting + matching
                : "%Y-%m-%d";  // "2026-10-15" for daily

        String sql = "SELECT DATE_FORMAT(created_at, ?) AS period, " +
                     "       COALESCE(SUM(final_total), 0) AS gmv, " +
                     "       COUNT(*) AS cnt " +
                     "FROM bookings " +
                     "WHERE booking_status IN (" + SUCCESS_STATUSES + ")" +
                     buildDateClause(fromDate, toDate) +
                     " GROUP BY period ORDER BY period";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, dateFormat);
            int idx = 2;
            if (fromDate != null) ps.setString(idx++, fromDate);
            if (toDate   != null) ps.setString(idx++, toDate);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(new Object[]{
                        rs.getString("period"),
                        rs.getLong("gmv"),
                        rs.getInt("cnt")
                    });
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "AdminAnalyticsDAO.getChartData failed", e);
        }
        return result;
    }

    // ── New Chart Methods ──────────────────────────────────────────────────

    @Override
    public List<Object[]> getBookingStatusBreakdown(String fromDate, String toDate) {
        List<Object[]> result = new ArrayList<>();
        String sql = "SELECT booking_status, COUNT(*) AS cnt " +
                     "FROM bookings " +
                     "WHERE 1=1" + buildDateClause(fromDate, toDate) +
                     " GROUP BY booking_status ORDER BY cnt DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            if (fromDate != null) ps.setString(idx++, fromDate);
            if (toDate   != null) ps.setString(idx++, toDate);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(new Object[]{ rs.getString("booking_status"), rs.getInt("cnt") });
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "getBookingStatusBreakdown failed", e);
        }
        return result;
    }

    @Override
    public List<Object[]> getPaymentMethodBreakdown(String fromDate, String toDate) {
        List<Object[]> result = new ArrayList<>();
        String sql = "SELECT p.payment_method, COUNT(*) AS cnt " +
                     "FROM payments p " +
                     "JOIN bookings b ON p.booking_id = b.booking_id " +
                     "WHERE p.payment_status = 'SUCCESS'" + buildDateClause("b.created_at", fromDate, toDate) +
                     " GROUP BY p.payment_method ORDER BY cnt DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            if (fromDate != null) ps.setString(idx++, fromDate);
            if (toDate   != null) ps.setString(idx++, toDate);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(new Object[]{ rs.getString("payment_method"), rs.getInt("cnt") });
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "getPaymentMethodBreakdown failed", e);
        }
        return result;
    }

    @Override
    public List<Object[]> getTopHomestaysByRevenue(String fromDate, String toDate, int limit) {
        List<Object[]> result = new ArrayList<>();
        String sql = "SELECT h.name, COALESCE(SUM(b.final_total), 0) AS revenue, COUNT(b.booking_id) AS cnt " +
                     "FROM homestays h " +
                     "LEFT JOIN bookings b ON b.homestay_id = h.homestay_id " +
                     "    AND b.booking_status IN (" + SUCCESS_STATUSES + ")" +
                     buildDateClause("b.created_at", fromDate, toDate) +
                     " GROUP BY h.homestay_id, h.name " +
                     " ORDER BY revenue DESC LIMIT ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            if (fromDate != null) ps.setString(idx++, fromDate);
            if (toDate   != null) ps.setString(idx++, toDate);
            ps.setInt(idx, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(new Object[]{ rs.getString("name"), rs.getLong("revenue"), rs.getInt("cnt") });
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "getTopHomestaysByRevenue failed", e);
        }
        return result;
    }

    @Override
    public List<Object[]> getNewUsersPerMonth(String fromDate, String toDate) {
        List<Object[]> result = new ArrayList<>();
        String sql = "SELECT DATE_FORMAT(created_at, '%Y-%m') AS month, COUNT(*) AS cnt " +
                     "FROM users " +
                     "WHERE role = 'CUSTOMER'" + buildDateClause(fromDate, toDate) +
                     " GROUP BY month ORDER BY month";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            if (fromDate != null) ps.setString(idx++, fromDate);
            if (toDate   != null) ps.setString(idx++, toDate);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(new Object[]{ rs.getString("month"), rs.getInt("cnt") });
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "getNewUsersPerMonth failed", e);
        }
        return result;
    }

    // ── Booking Detail Table ──────────────────────────────────────────────

    @Override
    public int countUniqueBookingCustomers(String fromDate, String toDate) {
        String sql = "SELECT COUNT(DISTINCT customer_id) FROM bookings " +
                     "WHERE customer_id IS NOT NULL" + buildDateClause(fromDate, toDate);
        return (int) queryLong(sql, fromDate, toDate);
    }

    @Override
    public int countNewCustomers(String fromDate, String toDate) {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'CUSTOMER'" +
                     buildDateClause(fromDate, toDate);
        return (int) queryLong(sql, fromDate, toDate);
    }

    @Override
    public List<Object[]> getBookingList(String fromDate, String toDate, int offset, int limit) {
        List<Object[]> result = new ArrayList<>();
        String sql = "SELECT b.booking_code, b.guest_name, b.guest_phone, " +
                     "       h.name AS homestay_name, " +
                     "       b.checkin_date, b.checkout_date, b.total_nights, " +
                     "       b.final_total, b.booking_status, b.created_at " +
                     "FROM bookings b " +
                     "JOIN homestays h ON b.homestay_id = h.homestay_id " +
                     "WHERE 1=1" + buildDateClause("b.created_at", fromDate, toDate) +
                     " ORDER BY b.created_at DESC LIMIT ? OFFSET ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            if (fromDate != null) ps.setString(idx++, fromDate);
            if (toDate   != null) ps.setString(idx++, toDate);
            ps.setInt(idx++, limit);
            ps.setInt(idx,   offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(new Object[]{
                        rs.getString("booking_code"),    // [0]
                        rs.getString("guest_name"),      // [1]
                        rs.getString("guest_phone"),     // [2]
                        rs.getString("homestay_name"),   // [3]
                        rs.getDate("checkin_date"),      // [4]
                        rs.getDate("checkout_date"),     // [5]
                        rs.getInt("total_nights"),       // [6]
                        rs.getLong("final_total"),       // [7]
                        rs.getString("booking_status"),  // [8]
                        rs.getTimestamp("created_at")   // [9]
                    });
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "getBookingList failed", e);
        }
        return result;
    }

    @Override
    public int countBookingListRows(String fromDate, String toDate) {
        String sql = "SELECT COUNT(*) FROM bookings WHERE 1=1" +
                     buildDateClause(fromDate, toDate);
        return (int) queryLong(sql, fromDate, toDate);
    }

    // ── Helpers ────────────────────────────────────────────────────────────

    /**
     * Build date clause against a custom column (e.g. "b.created_at").
     */
    private static String buildDateClause(String column, String fromDate, String toDate) {
        StringBuilder sb = new StringBuilder();
        if (fromDate != null) sb.append(" AND DATE(").append(column).append(") >= ?");
        if (toDate   != null) sb.append(" AND DATE(").append(column).append(") <= ?");
        return sb.toString();
    }

    /**
     * Build " AND DATE(created_at) >= ? AND DATE(created_at) <= ?" clause.
     * One ? per non-null bound — caller binds fromDate then toDate once each.
     */
    private static String buildDateClause(String fromDate, String toDate) {
        return buildDateClause("created_at", fromDate, toDate);
    }

    /**
     * Execute a COUNT or SUM query that returns a single numeric value.
     * Binds fromDate then toDate positionally (matching buildDateClause order).
     */
    private long queryLong(String sql, String fromDate, String toDate) {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            if (fromDate != null) ps.setString(idx++, fromDate);
            if (toDate   != null) ps.setString(idx++, toDate);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getLong(1) : 0L;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "AdminAnalyticsDAO query failed: " + sql, e);
            return 0L;
        }
    }
}
