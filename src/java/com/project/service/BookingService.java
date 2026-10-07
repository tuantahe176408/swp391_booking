package com.project.service;

import com.project.config.DBContext;
import com.project.dao.BookingDAO;
import com.project.dao.BookingDAOImpl;
import com.project.model.Booking;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Service Layer: Business Logic cho Booking (UC07, UC09)
 * Package: com.project.service
 */
public class BookingService {

    private static final Logger LOGGER = Logger.getLogger(BookingService.class.getName());
    private final BookingDAO bookingDAO;

    public BookingService() {
        this.bookingDAO = new BookingDAOImpl();
    }

    /**
     * Tạo booking mới với addons trong một transaction.
     * @return bookingId nếu thành công, -1 nếu thất bại
     */
    public int createBooking(Booking booking, List<Integer> addonIds) {
        Connection conn = null;
        try {
            conn = DBContext.getConnection();
            conn.setAutoCommit(false);

            // 1. Tạo booking code (unique dựa trên timestamp nano)
            String bookingCode = generateBookingCode();
            booking.setBookingCode(bookingCode);
            LOGGER.info("Creating booking with code: " + bookingCode);

            // Kiểm tra số lượng phòng khả dụng trong khoảng ngày trước khi ghi nhận
            String checkAvailSql = "SELECT " +
                    " (SELECT COUNT(*) FROM rooms r WHERE r.room_type_id = ? AND r.status != 'MAINTENANCE') - " +
                    " (SELECT COUNT(*) FROM bookings b WHERE b.room_type_id = ? AND b.homestay_id = ? " +
                    "   AND b.checkin_date < ? AND b.checkout_date > ? " +
                    "   AND (b.booking_status IN ('CONFIRMED', 'CHECKED_IN') OR (b.booking_status = 'PENDING' AND (b.hold_expires_at IS NULL OR b.hold_expires_at > NOW())))) AS remaining";
            try (PreparedStatement psAvail = conn.prepareStatement(checkAvailSql)) {
                psAvail.setInt(1, booking.getRoomTypeId());
                psAvail.setInt(2, booking.getRoomTypeId());
                psAvail.setInt(3, booking.getHomestayId());
                psAvail.setDate(4, booking.getCheckoutDate());
                psAvail.setDate(5, booking.getCheckinDate());
                try (ResultSet rsAvail = psAvail.executeQuery()) {
                    if (rsAvail.next()) {
                        int remaining = rsAvail.getInt("remaining");
                        if (remaining <= 0) {
                            LOGGER.warning("Booking rejected: no available rooms for room_type_id=" + booking.getRoomTypeId());
                            conn.rollback();
                            return -1;
                        }
                    }
                }
            }

            // 2. Insert booking
            String sqlBooking = "INSERT INTO bookings (booking_code, customer_id, homestay_id, room_type_id, " +
                    "guest_name, guest_email, guest_phone, checkin_date, checkout_date, total_nights, " +
                    "room_price_total, addon_price_total, voucher_id, discount_amount, final_total, " +
                    "booking_type, booking_status, hold_expires_at) " +
                    "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,DATE_ADD(NOW(), INTERVAL 1 MINUTE))";

            int newBookingId;
            try (PreparedStatement ps = conn.prepareStatement(sqlBooking, PreparedStatement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, bookingCode);
                ps.setInt(2, booking.getCustomerId());
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
                if (booking.getVoucherId() != null) ps.setInt(13, booking.getVoucherId());
                else ps.setNull(13, java.sql.Types.INTEGER);
                ps.setBigDecimal(14, booking.getDiscountAmount());
                ps.setBigDecimal(15, booking.getFinalTotal());
                ps.setString(16, booking.getBookingType());
                ps.setString(17, booking.getBookingStatus());
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (!rs.next()) { conn.rollback(); return -1; }
                    newBookingId = rs.getInt(1);
                }
            }

            // 3. Insert booking addons
            if (addonIds != null && !addonIds.isEmpty()) {
                String sqlAddon = "INSERT INTO booking_addons (booking_id, addon_id, quantity, unit_price, total_price) " +
                        "SELECT ?, addon_id, 1, price, price FROM addons WHERE addon_id = ?";
                try (PreparedStatement ps2 = conn.prepareStatement(sqlAddon)) {
                    for (int addonId : addonIds) {
                        ps2.setInt(1, newBookingId);
                        ps2.setInt(2, addonId);
                        ps2.addBatch();
                    }
                    ps2.executeBatch();
                }
            }

            conn.commit();
            return newBookingId;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in createBooking - rolling back. SQLState=" + e.getSQLState() + ", Code=" + e.getErrorCode() + ", Msg=" + e.getMessage(), e);
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { LOGGER.log(Level.SEVERE, "Rollback failed", ex); }
            return -1;
        } finally {
            try { if (conn != null) { conn.setAutoCommit(true); conn.close(); } } catch (SQLException e) { LOGGER.log(Level.WARNING, "Error closing connection", e); }
        }
    }

    private String generateBookingCode() {
        String date = java.time.LocalDate.now().format(java.time.format.DateTimeFormatter.ofPattern("yyyyMMdd"));
        String seq  = String.format("%04d", (int)(System.nanoTime() % 9999) + 1);
        return "BK-" + date + "-" + seq;
    }
}
