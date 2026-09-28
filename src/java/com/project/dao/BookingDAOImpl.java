package com.project.dao;

import com.project.config.DBContext;
import com.project.model.Booking;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object Implementation: Booking Operations
 * Package: com.project.dao
 */
public class BookingDAOImpl implements BookingDAO {

    private static final Logger LOGGER = Logger.getLogger(BookingDAOImpl.class.getName());

    private static final String BASE_SELECT =
            "SELECT b.booking_id, b.booking_code, b.customer_id, b.homestay_id, b.room_type_id, " +
            "b.assigned_room_id, b.guest_name, b.guest_email, b.guest_phone, b.guest_id_card_number, " +
            "b.checkin_date, b.checkout_date, b.total_nights, b.room_price_total, b.addon_price_total, " +
            "b.surcharge_total, b.voucher_id, b.discount_amount, b.final_total, b.booking_type, " +
            "b.booking_status, b.hold_expires_at, b.receptionist_id, b.cancellation_reason, " +
            "b.created_at, b.updated_at, " +
            "h.name AS homestay_name, h.address AS homestay_address, h.city AS homestay_city, " +
            "rt.name AS room_type_name, " +
            "(SELECT hi.image_url FROM homestay_images hi WHERE hi.homestay_id = h.homestay_id ORDER BY hi.is_primary DESC, hi.display_order ASC LIMIT 1) AS homestay_image " +
            "FROM bookings b " +
            "LEFT JOIN homestays h ON b.homestay_id = h.homestay_id " +
            "LEFT JOIN room_types rt ON b.room_type_id = rt.room_type_id ";

    @Override
    public List<Booking> getBookingsByCustomerId(int customerId) {
        List<Booking> list = new ArrayList<>();
        String sql = BASE_SELECT + "WHERE b.customer_id = ? ORDER BY b.created_at DESC";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapBooking(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getBookingsByCustomerId for customerId: " + customerId, e);
        }
        return list;
    }

    @Override
    public Optional<Booking> getBookingById(int bookingId) {
        String sql = BASE_SELECT + "WHERE b.booking_id = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapBooking(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getBookingById for bookingId: " + bookingId, e);
        }
        return Optional.empty();
    }

    @Override
    public Optional<Booking> getBookingByCode(String bookingCode) {
        String sql = BASE_SELECT + "WHERE b.booking_code = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, bookingCode);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapBooking(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getBookingByCode for bookingCode: " + bookingCode, e);
        }
        return Optional.empty();
    }

    @Override
    public boolean isEligibleForCancellation(int bookingId) {
        String sql = "SELECT booking_status, checkin_date FROM bookings WHERE booking_id = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String status   = rs.getString("booking_status");
                    java.sql.Date checkin = rs.getDate("checkin_date");

                    // Compare date strings only (yyyy-MM-dd) to avoid timezone/time-of-day issues
                    String todayStr   = java.time.LocalDate.now().toString();
                    String checkinStr = checkin != null ? checkin.toLocalDate().toString() : "";

                    // Allow cancel if PENDING or CONFIRMED and checkin >= today
                    if (("PENDING".equalsIgnoreCase(status) || "CONFIRMED".equalsIgnoreCase(status))
                            && checkinStr.compareTo(todayStr) >= 0) {
                        return true;
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking cancellation eligibility for bookingId: " + bookingId, e);
        }
        return false;
    }

    @Override
    public boolean cancelBooking(int bookingId, String reason) {
        String sql = "UPDATE bookings SET booking_status = 'CANCELLED', cancellation_reason = ?, updated_at = CURRENT_TIMESTAMP WHERE booking_id = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, reason);
            ps.setInt(2, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in cancelBooking for bookingId: " + bookingId, e);
        }
        return false;
    }

    @Override
    public boolean insertBooking(Booking booking) {
        String sql = "INSERT INTO bookings (booking_code, customer_id, homestay_id, room_type_id, " +
                     "guest_name, guest_email, guest_phone, checkin_date, checkout_date, total_nights, " +
                     "room_price_total, addon_price_total, surcharge_total, discount_amount, final_total, " +
                     "booking_type, booking_status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, booking.getBookingCode());
            if (booking.getCustomerId() != null) {
                ps.setInt(2, booking.getCustomerId());
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }
            ps.setInt(3, booking.getHomestayId());
            ps.setInt(4, booking.getRoomTypeId());
            ps.setString(5, booking.getGuestName());
            ps.setString(6, booking.getGuestEmail());
            ps.setString(7, booking.getGuestPhone());
            ps.setDate(8, booking.getCheckinDate());
            ps.setDate(9, booking.getCheckoutDate());
            ps.setInt(10, booking.getTotalNights());
            ps.setBigDecimal(11, booking.getRoomPriceTotal());
            ps.setBigDecimal(12, booking.getAddonPriceTotal());
            ps.setBigDecimal(13, booking.getSurchargeTotal());
            ps.setBigDecimal(14, booking.getDiscountAmount());
            ps.setBigDecimal(15, booking.getFinalTotal());
            ps.setString(16, booking.getBookingType() != null ? booking.getBookingType() : "ONLINE");
            ps.setString(17, booking.getBookingStatus() != null ? booking.getBookingStatus() : "PENDING");

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        booking.setBookingId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error inserting booking", e);
        }
        return false;
    }

    @Override
    public boolean updateBookingStatus(int bookingId, String status) {
        String sql = "UPDATE bookings SET booking_status = ?, updated_at = CURRENT_TIMESTAMP WHERE booking_id = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating booking status for bookingId: " + bookingId, e);
        }
        return false;
    }

    // ── UC20: Owner booking queries ──────────────────────────────────────────

    @Override
    public List<Booking> getBookingsByOwner(int ownerId, Integer homestayId, String status,
                                             String fromDate, String toDate,
                                             int offset, int limit) {
        List<Booking> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_SELECT);
        sql.append("WHERE h.owner_id = ? ");

        List<Object> params = new ArrayList<>();
        params.add(ownerId);

        if (homestayId != null && homestayId > 0) {
            sql.append("AND b.homestay_id = ? ");
            params.add(homestayId);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND b.booking_status = ? ");
            params.add(status.trim().toUpperCase());
        }
        if (fromDate != null && !fromDate.trim().isEmpty()) {
            sql.append("AND b.checkin_date >= ? ");
            params.add(fromDate.trim());
        }
        if (toDate != null && !toDate.trim().isEmpty()) {
            sql.append("AND b.checkin_date <= ? ");
            params.add(toDate.trim());
        }
        sql.append("ORDER BY b.created_at DESC LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapBooking(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getBookingsByOwner for ownerId=" + ownerId, e);
        }
        return list;
    }

    @Override
    public int countBookingsByOwner(int ownerId, Integer homestayId, String status,
                                     String fromDate, String toDate) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM bookings b " +
                "LEFT JOIN homestays h ON b.homestay_id = h.homestay_id " +
                "WHERE h.owner_id = ? ");

        List<Object> params = new ArrayList<>();
        params.add(ownerId);

        if (homestayId != null && homestayId > 0) {
            sql.append("AND b.homestay_id = ? ");
            params.add(homestayId);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND b.booking_status = ? ");
            params.add(status.trim().toUpperCase());
        }
        if (fromDate != null && !fromDate.trim().isEmpty()) {
            sql.append("AND b.checkin_date >= ? ");
            params.add(fromDate.trim());
        }
        if (toDate != null && !toDate.trim().isEmpty()) {
            sql.append("AND b.checkin_date <= ? ");
            params.add(toDate.trim());
        }

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in countBookingsByOwner for ownerId=" + ownerId, e);
        }
        return 0;
    }

    private Booking mapBooking(ResultSet rs) throws SQLException {
        Booking b = new Booking();
        b.setBookingId(rs.getInt("booking_id"));
        b.setBookingCode(rs.getString("booking_code"));
        int customerId = rs.getInt("customer_id");
        b.setCustomerId(rs.wasNull() ? null : customerId);
        b.setHomestayId(rs.getInt("homestay_id"));
        b.setRoomTypeId(rs.getInt("room_type_id"));
        int assignedRoomId = rs.getInt("assigned_room_id");
        b.setAssignedRoomId(rs.wasNull() ? null : assignedRoomId);
        b.setGuestName(rs.getString("guest_name"));
        b.setGuestEmail(rs.getString("guest_email"));
        b.setGuestPhone(rs.getString("guest_phone"));
        b.setGuestIdCardNumber(rs.getString("guest_id_card_number"));
        b.setCheckinDate(rs.getDate("checkin_date"));
        b.setCheckoutDate(rs.getDate("checkout_date"));
        b.setTotalNights(rs.getInt("total_nights"));
        b.setRoomPriceTotal(rs.getBigDecimal("room_price_total"));
        b.setAddonPriceTotal(rs.getBigDecimal("addon_price_total"));
        b.setSurchargeTotal(rs.getBigDecimal("surcharge_total"));
        int voucherId = rs.getInt("voucher_id");
        b.setVoucherId(rs.wasNull() ? null : voucherId);
        b.setDiscountAmount(rs.getBigDecimal("discount_amount"));
        b.setFinalTotal(rs.getBigDecimal("final_total"));
        b.setBookingType(rs.getString("booking_type"));
        b.setBookingStatus(rs.getString("booking_status"));
        b.setHoldExpiresAt(rs.getTimestamp("hold_expires_at"));
        int receptionistId = rs.getInt("receptionist_id");
        b.setReceptionistId(rs.wasNull() ? null : receptionistId);
        b.setCancellationReason(rs.getString("cancellation_reason"));
        b.setCreatedAt(rs.getTimestamp("created_at"));
        b.setUpdatedAt(rs.getTimestamp("updated_at"));

        // Transient joined data
        b.setHomestayName(rs.getString("homestay_name"));
        b.setHomestayAddress(rs.getString("homestay_address"));
        b.setHomestayCity(rs.getString("homestay_city"));
        b.setRoomTypeName(rs.getString("room_type_name"));
        b.setHomestayImageUrl(rs.getString("homestay_image"));

        return b;
    }
}
