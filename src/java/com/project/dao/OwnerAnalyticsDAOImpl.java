package com.project.dao;

import com.project.config.DBContext;

import java.sql.*;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * JDBC Implementation: Owner Revenue & Occupancy Analytics (UC20)
 * Package: com.project.dao
 *
 * All queries are scoped to a specific owner via:
 *   JOIN homestays h ON b.homestay_id = h.homestay_id AND h.owner_id = ?
 *
 * Monetary values are returned as long (VNĐ).
 * Date range parameters are "yyyy-MM-dd"; null = unbounded.
 */
public class OwnerAnalyticsDAOImpl implements OwnerAnalyticsDAO {

    private static final Logger LOGGER = Logger.getLogger(OwnerAnalyticsDAOImpl.class.getName());

    /** Booking statuses that represent real revenue / occupancy. */
    private static final String SUCCESS_STATUSES = "'CONFIRMED','CHECKED_IN','CHECKED_OUT'";

    // ── KPI Metrics ───────────────────────────────────────────────────────

    @Override
    public long getTotalRevenue(int ownerId, Integer homestayId, String fromDate, String toDate) {
        String sql = "SELECT COALESCE(SUM(b.final_total), 0) " +
                     "FROM bookings b " +
                     "JOIN homestays h ON b.homestay_id = h.homestay_id AND h.owner_id = ?" +
                     " WHERE b.booking_status IN (" + SUCCESS_STATUSES + ")" +
                     buildHomestayClause(homestayId) +
                     buildDateClause("b.created_at", fromDate, toDate);
        return queryLong(sql, ownerId, homestayId, fromDate, toDate);
    }

    @Override
    public int countSuccessfulBookings(int ownerId, Integer homestayId, String fromDate, String toDate) {
        String sql = "SELECT COUNT(*) " +
                     "FROM bookings b " +
                     "JOIN homestays h ON b.homestay_id = h.homestay_id AND h.owner_id = ?" +
                     " WHERE b.booking_status IN (" + SUCCESS_STATUSES + ")" +
                     buildHomestayClause(homestayId) +
                     buildDateClause("b.created_at", fromDate, toDate);
        return (int) queryLong(sql, ownerId, homestayId, fromDate, toDate);
    }

    @Override
    public int countCancelledBookings(int ownerId, Integer homestayId, String fromDate, String toDate) {
        String sql = "SELECT COUNT(*) " +
                     "FROM bookings b " +
                     "JOIN homestays h ON b.homestay_id = h.homestay_id AND h.owner_id = ?" +
                     " WHERE b.booking_status = 'CANCELLED'" +
                     buildHomestayClause(homestayId) +
                     buildDateClause("b.created_at", fromDate, toDate);
        return (int) queryLong(sql, ownerId, homestayId, fromDate, toDate);
    }

    @Override
    public int countNewBookings(int ownerId, Integer homestayId, String fromDate, String toDate) {
        String sql = "SELECT COUNT(*) " +
                     "FROM bookings b " +
                     "JOIN homestays h ON b.homestay_id = h.homestay_id AND h.owner_id = ?" +
                     " WHERE b.booking_status <> 'PENDING'" +
                     buildHomestayClause(homestayId) +
                     buildDateClause("b.created_at", fromDate, toDate);
        return (int) queryLong(sql, ownerId, homestayId, fromDate, toDate);
    }

    @Override
    public int countNewReviews(int ownerId, Integer homestayId, String fromDate, String toDate) {
        String sql = "SELECT COUNT(*) " +
                     "FROM reviews r " +
                     "JOIN homestays h ON r.homestay_id = h.homestay_id AND h.owner_id = ?" +
                     (homestayId != null && homestayId > 0
                             ? " AND r.homestay_id = ?" : "") +
                     buildDateClause("r.created_at", fromDate, toDate);
        return (int) queryLong(sql, ownerId, homestayId, fromDate, toDate);
    }

    @Override
    public int countCheckedIn(int ownerId, Integer homestayId, String fromDate, String toDate) {
        String sql = "SELECT COUNT(*) " +
                     "FROM bookings b " +
                     "JOIN homestays h ON b.homestay_id = h.homestay_id AND h.owner_id = ?" +
                     " WHERE b.booking_status IN ('CHECKED_IN','CHECKED_OUT')" +
                     buildHomestayClause(homestayId) +
                     buildDateClause("b.created_at", fromDate, toDate);
        return (int) queryLong(sql, ownerId, homestayId, fromDate, toDate);
    }

    @Override
    public int countCheckedOut(int ownerId, Integer homestayId, String fromDate, String toDate) {
        String sql = "SELECT COUNT(*) " +
                     "FROM bookings b " +
                     "JOIN homestays h ON b.homestay_id = h.homestay_id AND h.owner_id = ?" +
                     " WHERE b.booking_status = 'CHECKED_OUT'" +
                     buildHomestayClause(homestayId) +
                     buildDateClause("b.created_at", fromDate, toDate);
        return (int) queryLong(sql, ownerId, homestayId, fromDate, toDate);
    }

    @Override
    public long getAverageDailyRate(int ownerId, Integer homestayId, String fromDate, String toDate) {
        // ADR = total revenue / total nights (for successful bookings)
        String sql = "SELECT COALESCE(SUM(b.final_total) / NULLIF(SUM(b.total_nights), 0), 0) " +
                     "FROM bookings b " +
                     "JOIN homestays h ON b.homestay_id = h.homestay_id AND h.owner_id = ?" +
                     " WHERE b.booking_status IN (" + SUCCESS_STATUSES + ")" +
                     buildHomestayClause(homestayId) +
                     buildDateClause("b.created_at", fromDate, toDate);
        return queryLong(sql, ownerId, homestayId, fromDate, toDate);
    }

    @Override
    public double getOccupancyRate(int ownerId, Integer homestayId, String fromDate, String toDate) {
        // Step 1: Sum of booked nights
        String sqlNights = "SELECT COALESCE(SUM(b.total_nights), 0) " +
                           "FROM bookings b " +
                           "JOIN homestays h ON b.homestay_id = h.homestay_id AND h.owner_id = ?" +
                           " WHERE b.booking_status IN (" + SUCCESS_STATUSES + ")" +
                           buildHomestayClause(homestayId) +
                           buildDateClause("b.checkin_date", fromDate, toDate);
        long bookedNights = queryLong(sqlNights, ownerId, homestayId, fromDate, toDate);

        // Step 2: Count total rooms
        String sqlRooms = "SELECT COUNT(r.room_id) " +
                          "FROM rooms r " +
                          "JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
                          "JOIN homestays h ON rt.homestay_id = h.homestay_id AND h.owner_id = ?" +
                          (homestayId != null && homestayId > 0 ? " AND h.homestay_id = ?" : "");
        long totalRooms;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlRooms)) {
            ps.setInt(1, ownerId);
            if (homestayId != null && homestayId > 0) ps.setInt(2, homestayId);
            try (ResultSet rs = ps.executeQuery()) {
                totalRooms = rs.next() ? rs.getLong(1) : 0L;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "getOccupancyRate rooms query failed", e);
            return 0.0;
        }

        // Step 3: Calculate days in period
        long daysInPeriod;
        try {
            LocalDate from = fromDate != null ? LocalDate.parse(fromDate) : LocalDate.now().withDayOfMonth(1);
            LocalDate to   = toDate   != null ? LocalDate.parse(toDate)   : LocalDate.now();
            daysInPeriod = Math.max(1, ChronoUnit.DAYS.between(from, to) + 1);
        } catch (Exception e) {
            daysInPeriod = 30;
        }

        long capacity = totalRooms * daysInPeriod;
        return capacity > 0 ? Math.round(bookedNights * 10000.0 / capacity) / 100.0 : 0.0;
    }

    // ── Chart Data ────────────────────────────────────────────────────────

    @Override
    public List<Object[]> getRevenueChartData(int ownerId, Integer homestayId,
                                               String fromDate, String toDate, String groupBy) {
        List<Object[]> result = new ArrayList<>();
        String dateFormat = "MONTH".equals(groupBy) ? "%Y-%m" : "%Y-%m-%d";

        String sql = "SELECT DATE_FORMAT(b.created_at, ?) AS period, " +
                     "       COALESCE(SUM(b.final_total), 0) AS revenue, " +
                     "       COUNT(*) AS cnt " +
                     "FROM bookings b " +
                     "JOIN homestays h ON b.homestay_id = h.homestay_id AND h.owner_id = ?" +
                     " WHERE b.booking_status IN (" + SUCCESS_STATUSES + ")" +
                     buildHomestayClause(homestayId) +
                     buildDateClause("b.created_at", fromDate, toDate) +
                     " GROUP BY period ORDER BY period";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            ps.setString(idx++, dateFormat);
            ps.setInt(idx++, ownerId);
            if (homestayId != null && homestayId > 0) ps.setInt(idx++, homestayId);
            if (fromDate != null) ps.setString(idx++, fromDate);
            if (toDate   != null) ps.setString(idx++, toDate);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(new Object[]{
                        rs.getString("period"),
                        rs.getLong("revenue"),
                        rs.getInt("cnt")
                    });
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "getRevenueChartData failed", e);
        }
        return result;
    }

    @Override
    public List<Object[]> getBookingStatusBreakdown(int ownerId, Integer homestayId,
                                                      String fromDate, String toDate) {
        List<Object[]> result = new ArrayList<>();
        String sql = "SELECT b.booking_status, COUNT(*) AS cnt " +
                     "FROM bookings b " +
                     "JOIN homestays h ON b.homestay_id = h.homestay_id AND h.owner_id = ?" +
                     " WHERE 1=1" +
                     buildHomestayClause(homestayId) +
                     buildDateClause("b.created_at", fromDate, toDate) +
                     " GROUP BY b.booking_status ORDER BY cnt DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            ps.setInt(idx++, ownerId);
            if (homestayId != null && homestayId > 0) ps.setInt(idx++, homestayId);
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
    public List<Object[]> getTopHomestaysByRevenue(int ownerId, String fromDate, String toDate, int limit) {
        List<Object[]> result = new ArrayList<>();
        String sql = "SELECT h.name, COALESCE(SUM(b.final_total), 0) AS revenue, COUNT(b.booking_id) AS cnt " +
                     "FROM homestays h " +
                     "LEFT JOIN bookings b ON b.homestay_id = h.homestay_id " +
                     "    AND b.booking_status IN (" + SUCCESS_STATUSES + ")" +
                     buildDateClause("b.created_at", fromDate, toDate) +
                     " WHERE h.owner_id = ?" +
                     " GROUP BY h.homestay_id, h.name ORDER BY revenue DESC LIMIT ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            if (fromDate != null) ps.setString(idx++, fromDate);
            if (toDate   != null) ps.setString(idx++, toDate);
            ps.setInt(idx++, ownerId);
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
    public List<Object[]> getRecentBookings(int ownerId, Integer homestayId, int limit) {
        List<Object[]> result = new ArrayList<>();
        String sql = "SELECT u.full_name, h.name AS homestay_name, " +
                     "       DATE_FORMAT(b.checkin_date, '%d/%m/%Y') AS checkin, " +
                     "       DATE_FORMAT(b.checkout_date, '%d/%m/%Y') AS checkout, " +
                     "       b.final_total, b.booking_status, " +
                     "       COALESCE(r.rating_overall, 0) AS rating, " +
                     "       b.booking_code, b.guest_name " +
                     "FROM bookings b " +
                     "JOIN homestays h ON b.homestay_id = h.homestay_id AND h.owner_id = ?" +
                     " LEFT JOIN users u ON b.customer_id = u.user_id " +
                     " LEFT JOIN reviews r ON r.booking_id = b.booking_id" +
                     (homestayId != null && homestayId > 0 ? " AND b.homestay_id = ?" : "") +
                     " ORDER BY b.created_at DESC LIMIT ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            ps.setInt(idx++, ownerId);
            if (homestayId != null && homestayId > 0) ps.setInt(idx++, homestayId);
            ps.setInt(idx, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    // Display guest_name (may be from booking form or user account)
                    String guestDisplay = rs.getString("full_name");
                    if (guestDisplay == null || guestDisplay.isBlank()) {
                        guestDisplay = rs.getString("guest_name");
                    }
                    result.add(new Object[]{
                        guestDisplay,
                        rs.getString("homestay_name"),
                        rs.getString("checkin"),
                        rs.getString("checkout"),
                        rs.getLong("final_total"),
                        rs.getString("booking_status"),
                        rs.getDouble("rating"),
                        rs.getString("booking_code")
                    });
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "getRecentBookings failed", e);
        }
        return result;
    }

    @Override
    public List<Object[]> getOwnerHomestays(int ownerId) {
        List<Object[]> result = new ArrayList<>();
        String sql = "SELECT homestay_id, name FROM homestays " +
                     "WHERE owner_id = ? AND status IN ('ACTIVE','INACTIVE','PENDING_APPROVAL') " +
                     "ORDER BY name";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(new Object[]{ rs.getInt("homestay_id"), rs.getString("name") });
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "getOwnerHomestays failed", e);
        }
        return result;
    }

    // ── Helpers ────────────────────────────────────────────────────────────

    /**
     * Build " AND b.homestay_id = ?" if homestayId is provided.
     */
    private static String buildHomestayClause(Integer homestayId) {
        return (homestayId != null && homestayId > 0) ? " AND b.homestay_id = ?" : "";
    }

    /**
     * Build date clause against a specific column.
     * Returns: " AND DATE(column) >= ? AND DATE(column) <= ?"
     */
    private static String buildDateClause(String column, String fromDate, String toDate) {
        StringBuilder sb = new StringBuilder();
        if (fromDate != null) sb.append(" AND DATE(").append(column).append(") >= ?");
        if (toDate   != null) sb.append(" AND DATE(").append(column).append(") <= ?");
        return sb.toString();
    }

    /**
     * Execute a COUNT or SUM query returning a single numeric value.
     * Binds: ownerId, [homestayId], [fromDate], [toDate].
     */
    private long queryLong(String sql, int ownerId, Integer homestayId,
                            String fromDate, String toDate) {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            ps.setInt(idx++, ownerId);
            if (sql.contains("AND b.homestay_id = ?") || sql.contains("AND r.homestay_id = ?")
                    || sql.contains("AND h.homestay_id = ?")) {
                if (homestayId != null && homestayId > 0) ps.setInt(idx++, homestayId);
            }
            if (fromDate != null) ps.setString(idx++, fromDate);
            if (toDate   != null) ps.setString(idx++, toDate);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getLong(1) : 0L;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "OwnerAnalyticsDAO queryLong failed: " + sql, e);
            return 0L;
        }
    }
}
