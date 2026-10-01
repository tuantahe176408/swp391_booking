package com.project.dao;

import com.project.config.DBContext;
import com.project.model.Room;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object Implementation: Room Operations
 * Package: com.project.dao
 */
public class RoomDAOImpl implements RoomDAO {

    private static final Logger LOGGER = Logger.getLogger(RoomDAOImpl.class.getName());

    private Room mapRoom(ResultSet rs) throws SQLException {
        Room r = new Room();
        r.setRoomId(rs.getInt("room_id"));
        r.setRoomTypeId(rs.getInt("room_type_id"));
        r.setRoomNumber(rs.getString("room_number"));
        String statusStr = rs.getString("status");
        r.setStatus(statusStr != null ? Room.Status.valueOf(statusStr) : Room.Status.AVAILABLE);
        r.setCreatedAt(rs.getTimestamp("created_at"));
        // Transient from JOIN
        try { r.setRoomTypeName(rs.getString("room_type_name")); } catch (SQLException ignored) {}
        try { r.setBasePrice(rs.getBigDecimal("base_price")); } catch (SQLException ignored) {}
        try { r.setHomestayId(rs.getInt("homestay_id")); } catch (SQLException ignored) {}
        return r;
    }

    @Override
    public List<Room> getRoomsByHomestayId(int homestayId) {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT r.*, rt.name AS room_type_name, rt.base_price, rt.homestay_id " +
                     "FROM rooms r JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
                     "WHERE rt.homestay_id = ? ORDER BY rt.name, r.room_number";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, homestayId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRoom(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getRoomsByHomestayId: " + homestayId, e);
        }
        return list;
    }

    @Override
    public List<Room> getRoomsByRoomTypeId(int roomTypeId) {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT r.*, rt.name AS room_type_name, rt.base_price, rt.homestay_id " +
                     "FROM rooms r JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
                     "WHERE r.room_type_id = ? ORDER BY r.room_number";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomTypeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRoom(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getRoomsByRoomTypeId: " + roomTypeId, e);
        }
        return list;
    }

    @Override
    public List<Room> getAvailableRooms(int homestayId, int roomTypeId, String checkinDate, String checkoutDate) {
        List<Room> list = new ArrayList<>();
        /*
         * Logic: Lấy phòng AVAILABLE của room_type này, loại trừ:
         * 1. Phòng đã được assigned cho booking CHECKED_IN (đang có khách ở)
         * 2. Phòng đã được assigned cho booking CONFIRMED trong khoảng ngày trùng
         * 
         * Với booking CONFIRMED chưa assigned (assigned_room_id = NULL):
         * → Không block phòng cụ thể, nhưng cần đếm số lượng để kiểm tra availability
         *    (việc này xử lý ở tầng Service khi customer đặt phòng)
         * 
         * Ở đây chỉ cần loại trừ phòng đã assigned (để lễ tân pick phòng giao cho khách)
         */
        String sql = "SELECT r.*, rt.name AS room_type_name, rt.base_price, rt.homestay_id " +
                     "FROM rooms r " +
                     "JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
                     "WHERE rt.homestay_id = ? AND r.room_type_id = ? AND r.status = 'AVAILABLE' " +
                     "AND r.room_id NOT IN (" +
                     "  SELECT b.assigned_room_id FROM bookings b " +
                     "  WHERE b.assigned_room_id IS NOT NULL " +
                     "  AND b.booking_status IN ('CONFIRMED','CHECKED_IN') " +
                     "  AND b.checkin_date < ? AND b.checkout_date > ?" +
                     ")";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, homestayId);
            ps.setInt(2, roomTypeId);
            ps.setString(3, checkoutDate);
            ps.setString(4, checkinDate);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRoom(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getAvailableRooms", e);
        }
        return list;
    }

    @Override
    public Optional<Room> getRoomById(int roomId) {
        String sql = "SELECT r.*, rt.name AS room_type_name, rt.base_price " +
                     "FROM rooms r LEFT JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
                     "WHERE r.room_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(mapRoom(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getRoomById: " + roomId, e);
        }
        return Optional.empty();
    }

    @Override
    public int insertRoom(Room r) {
        String sql = "INSERT INTO rooms (room_type_id, room_number, status) VALUES (?,?,?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, r.getRoomTypeId());
            ps.setString(2, r.getRoomNumber());
            ps.setString(3, r.getStatus() != null ? r.getStatus().name() : "AVAILABLE");
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in insertRoom", e);
        }
        return -1;
    }

    @Override
    public boolean updateRoomStatus(int roomId, Room.Status status) {
        String sql = "UPDATE rooms SET status=? WHERE room_id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status.name());
            ps.setInt(2, roomId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in updateRoomStatus", e);
        }
        return false;
    }

    @Override
    public boolean updateRoom(Room r) {
        String sql = "UPDATE rooms SET room_type_id=?, room_number=?, status=? WHERE room_id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, r.getRoomTypeId());
            ps.setString(2, r.getRoomNumber());
            ps.setString(3, r.getStatus() != null ? r.getStatus().name() : "AVAILABLE");
            ps.setInt(4, r.getRoomId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in updateRoom", e);
        }
        return false;
    }

    @Override
    public boolean deleteRoom(int roomId) {
        String sql = "DELETE FROM rooms WHERE room_id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in deleteRoom", e);
        }
        return false;
    }

    @Override
    public java.util.Map<Integer, Integer> getAvailableCountByType(int homestayId, String checkin, String checkout) {
        java.util.Map<Integer, Integer> map = new java.util.LinkedHashMap<>();
        /*
         * Logic đúng cho booking system:
         *   available_count = TỔNG phòng vật lý (bất kể status hiện tại)
         *                   − booking đang block ngày đó
         *
         * Tại sao dùng COUNT ALL thay vì chỉ AVAILABLE:
         *   - Phòng đang OCCUPIED hôm nay vẫn có thể đặt cho ngày tương lai
         *     (sau khi khách hiện tại check-out, phòng sẽ được dọn và giao lại)
         *   - Hệ thống là booking-based, không phải physical-status-based
         *   - Chỉ block khi CÓ booking ACTIVE (CONFIRMED/CHECKED_IN/PENDING chưa hết hạn)
         *     trùng khoảng ngày được yêu cầu
         *
         * Booking được tính là "block":
         *   CONFIRMED / CHECKED_IN → luôn block
         *   PENDING                → block nếu hold_expires_at chưa qua (giữ chỗ chờ thanh toán)
         *   CANCELLED / CHECKED_OUT / REFUNDED → không block
         */
        String sql =
            "SELECT rt.room_type_id, " +
            "  GREATEST(0, " +
            "    GREATEST(1, COALESCE((SELECT COUNT(*) FROM rooms r " +
            "              WHERE r.room_type_id = rt.room_type_id), 0)) " +   // ≥1 nếu room_type chưa có physical rooms
            "    - " +
            "    COALESCE((SELECT COUNT(*) FROM bookings b " +
            "              WHERE b.room_type_id   = rt.room_type_id " +
            "                AND b.homestay_id    = rt.homestay_id " +
            "                AND b.checkin_date   < ? " +
            "                AND b.checkout_date  > ? " +
            "                AND ( " +
            "                    b.booking_status IN ('CONFIRMED', 'CHECKED_IN') " +
            "                    OR ( b.booking_status = 'PENDING' " +
            "                         AND (b.hold_expires_at IS NULL " +
            "                              OR b.hold_expires_at > NOW()) ) " +
            "                ) " +
            "             ), 0) " +
            "  ) AS available_count " +
            "FROM room_types rt " +
            "WHERE rt.homestay_id = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, checkout);
            ps.setString(2, checkin);
            ps.setInt(3, homestayId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int roomTypeId     = rs.getInt("room_type_id");
                    int availableCount = rs.getInt("available_count");
                    map.put(roomTypeId, availableCount);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getAvailableCountByType: homestayId=" + homestayId, e);
        }
        return map;
    }

    /**
     * UC13: Room Matrix — tải tất cả phòng kèm thông tin khách đang CHECKED_IN.
     *
     * <p>Dùng correlated subquery để tìm booking liên quan nhất cho mỗi phòng:
     * <ol>
     *   <li>Ưu tiên booking CHECKED_IN (khách đang ở)</li>
     *   <li>Fallback: CONFIRMED có assigned_room_id và đang trong khoảng ngày ở</li>
     * </ol>
     * Điều kiện {@code checkout_date > CURDATE()} đảm bảo không hiện booking đã kết thúc.
     */
    @Override
    public List<Room> getRoomsForMatrix(int homestayId) {
        List<Room> list = new ArrayList<>();
        String sql =
            "SELECT r.room_id, r.room_type_id, r.room_number, r.status, r.created_at, " +
            "       rt.name AS room_type_name, rt.base_price, rt.homestay_id, " +
            "       b.guest_name AS current_guest_name, b.booking_code AS current_booking_code, " +
            "       b.booking_id AS current_booking_id " +
            "FROM rooms r " +
            "JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
            "LEFT JOIN bookings b ON b.booking_id = ( " +
            "    SELECT b2.booking_id FROM bookings b2 " +
            "    WHERE b2.assigned_room_id = r.room_id " +
            "      AND ( " +
            "           b2.booking_status = 'CHECKED_IN' " +                     /* khách đang ở — không cần check ngày */
            "           OR ( " +
            "               b2.booking_status = 'CONFIRMED' " +                  /* pre-assigned — chỉ hiện trong khoảng ngày */
            "               AND b2.checkin_date  <= CURDATE() " +
            "               AND b2.checkout_date >= CURDATE() " +
            "           ) " +
            "      ) " +
            "    ORDER BY CASE b2.booking_status WHEN 'CHECKED_IN' THEN 0 ELSE 1 END, " +
            "             b2.checkin_date ASC " +
            "    LIMIT 1 " +
            ") " +
            "WHERE rt.homestay_id = ? " +
            "ORDER BY rt.name, r.room_number";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, homestayId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Room r = mapRoom(rs);
                    r.setCurrentGuestName(rs.getString("current_guest_name"));
                    r.setCurrentBookingCode(rs.getString("current_booking_code"));
                    int bId = rs.getInt("current_booking_id");
                    r.setCurrentBookingId(rs.wasNull() ? null : bId);
                    list.add(r);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getRoomsForMatrix: homestayId=" + homestayId, e);
        }
        return list;
    }
}
