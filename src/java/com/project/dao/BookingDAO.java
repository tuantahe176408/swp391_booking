package com.project.dao;

import com.project.model.Booking;

import java.util.List;
import java.util.Optional;

/**
 * Data Access Object Interface: Booking Operations (UC07, UC09, UC12, UC13, UC20)
 * Package: com.project.dao
 */
public interface BookingDAO {

    List<Booking> getBookingsByCustomerId(int customerId);

    Optional<Booking> getBookingById(int bookingId);

    Optional<Booking> getBookingByCode(String bookingCode);

    boolean isEligibleForCancellation(int bookingId);

    boolean cancelBooking(int bookingId, String reason);

    boolean insertBooking(Booking booking);

    boolean updateBookingStatus(int bookingId, String status);

    /**
     * UC20/UC17: Query bookings belonging to a specific owner with optional filters.
     *
     * @param ownerId   owner's user ID (matched via homestays.owner_id)
     * @param homestayId filter by specific homestay; 0 or null = all homestays of owner
     * @param status    booking_status filter; null = all statuses
     * @param fromDate  checkin_date >= fromDate; null = no lower bound (format: yyyy-MM-dd)
     * @param toDate    checkin_date <= toDate;   null = no upper bound (format: yyyy-MM-dd)
     * @param offset    pagination offset (0-based)
     * @param limit     max rows per page
     * @return list of bookings ordered by created_at DESC
     */
    List<Booking> getBookingsByOwner(int ownerId, Integer homestayId, String status,
                                     String fromDate, String toDate,
                                     int offset, int limit);

    /**
     * UC20: Count total matching bookings for pagination.
     * Same filter parameters as {@link #getBookingsByOwner}.
     */
    int countBookingsByOwner(int ownerId, Integer homestayId, String status,
                              String fromDate, String toDate);

    // ── UC12: Reception Check-in ──────────────────────────────────────────────

    /**
     * UC12: Tìm kiếm booking theo số điện thoại khách trong phạm vi một homestay.
     * Chỉ trả về booking có trạng thái CONFIRMED hoặc CHECKED_IN.
     *
     * @param phone      số điện thoại khách (guest_phone)
     * @param homestayId ID của homestay mà lễ tân phụ trách
     * @return danh sách booking phù hợp, tối đa 10 kết quả
     */
    List<Booking> searchBookingsByPhone(String phone, int homestayId);

    /**
     * UC12: Thao tác check-in nguyên tử (1 transaction):
     * <ol>
     *   <li>UPDATE bookings SET booking_status='CHECKED_IN', assigned_room_id, guest_id_card_number,
     *       guest_id_card_raw_data, receptionist_id WHERE booking_id AND booking_status='CONFIRMED'</li>
     *   <li>UPDATE rooms SET status='OCCUPIED' WHERE room_id = assignedRoomId</li>
     * </ol>
     *
     * @param bookingId      ID đơn đặt phòng (phải đang ở trạng thái CONFIRMED)
     * @param assignedRoomId room_id phòng vật lý giao cho khách
     * @param receptionistId user_id của lễ tân thực hiện check-in
     * @param idCardNumber   số CCCD/Passport (từ OCR hoặc nhập tay)
     * @param rawOcrJson     chuỗi JSON thô trả về từ OCR API (lưu vào guest_id_card_raw_data)
     * @return true nếu check-in thành công; false nếu booking không ở trạng thái CONFIRMED
     *         hoặc có lỗi DB
     */
    boolean checkinBooking(int bookingId, int assignedRoomId, int receptionistId,
                           String idCardNumber, String rawOcrJson);

    /**
     * UC12: Thao tác check-out nguyên tử (1 transaction):
     * <ol>
     *   <li>Kiểm tra booking tồn tại và đang ở trạng thái CHECKED_IN → lấy assigned_room_id</li>
     *   <li>UPDATE bookings SET booking_status='CHECKED_OUT' WHERE booking_id AND booking_status='CHECKED_IN'</li>
     *   <li>UPDATE rooms SET status='DIRTY' WHERE room_id = assigned_room_id (phòng cần dọn dẹp sau checkout)</li>
     * </ol>
     *
     * @param bookingId      ID đơn đặt phòng (phải đang CHECKED_IN)
     * @param receptionistId user_id của lễ tân thực hiện check-out
     * @return true nếu check-out thành công; false nếu booking không ở CHECKED_IN hoặc lỗi DB
     */
    boolean checkoutBooking(int bookingId, int receptionistId);

    /**
     * UC15: Walk-in booking — tạo đặt phòng + check-in ngay (1 atomic transaction):
     * <ol>
     *   <li>Tìm user theo phone (hoặc email); nếu chưa có, tạo tài khoản CUSTOMER mới</li>
     *   <li>Sinh booking_code dạng BK-W{yyyyMMdd}-XXXX</li>
     *   <li>INSERT bookings (booking_type=WALK_IN, booking_status=CHECKED_IN, assigned_room_id đã gán)</li>
     *   <li>UPDATE rooms SET status=OCCUPIED WHERE room_id AND status=AVAILABLE</li>
     * </ol>
     *
     * @param guestName      họ tên khách (lưu vào guest_name)
     * @param guestEmail     email khách (tuỳ chọn; dùng để tìm/tạo user)
     * @param guestPhone     SĐT bắt buộc (dùng để tìm/tạo user, lưu guest_phone)
     * @param homestayId     ID cơ sở homestay
     * @param roomTypeId     ID loại phòng (lấy từ phòng được chọn)
     * @param roomId         ID phòng vật lý được giao
     * @param checkinDate    ngày check-in (thường là hôm nay)
     * @param checkoutDate   ngày trả phòng
     * @param totalNights    số đêm ở
     * @param finalTotal     tổng tiền = giá/đêm × totalNights
     * @param receptionistId user_id lễ tân thực hiện
     * @return booking_code nếu thành công; null nếu phòng hết/lỗi DB
     */
    String createWalkInBooking(String guestName, String guestEmail, String guestPhone,
                                int homestayId, int roomTypeId, int roomId,
                                java.sql.Date checkinDate, java.sql.Date checkoutDate,
                                int totalNights, java.math.BigDecimal finalTotal,
                                int receptionistId);

    /**
     * System Service: Tự động huỷ các đơn PENDING đã hết thời gian giữ chỗ.
     * <p>
     * Điều kiện huỷ: {@code booking_status='PENDING' AND hold_expires_at < NOW()}
     * <p>
     * Được gọi định kỳ bởi {@link com.project.config.AppStartupListener} mỗi 5 phút.
     *
     * @return số đơn đã bị huỷ
     */
    int cancelExpiredPendingBookings();
}
