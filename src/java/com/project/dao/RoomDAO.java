package com.project.dao;

import com.project.model.Room;
import java.util.List;
import java.util.Optional;

/**
 * Data Access Object Interface: Room Operations
 * Package: com.project.dao
 */
public interface RoomDAO {
    List<Room> getRoomsByHomestayId(int homestayId);
    List<Room> getRoomsByRoomTypeId(int roomTypeId);
    List<Room> getAvailableRooms(int homestayId, int roomTypeId, String checkinDate, String checkoutDate);
    Optional<Room> getRoomById(int roomId);
    int insertRoom(Room room);
    boolean updateRoomStatus(int roomId, Room.Status status);
    boolean updateRoom(Room room);
    boolean deleteRoom(int roomId);
    /**
     * UC13: Load all rooms for Room Matrix display, JOIN with CHECKED_IN bookings
     * to show current guest info for OCCUPIED rooms.
     * Results sorted by room_type name then room_number.
     *
     * @param homestayId homestay của lễ tân phụ trách
     * @return danh sách Room với currentGuestName và currentBookingCode được điền nếu OCCUPIED
     */
    List<Room> getRoomsForMatrix(int homestayId);

    /**
     * UC03 Detail page: Tính số phòng còn trống theo từng room_type trong khoảng ngày.
     * <p>
     * Logic: availableCount = totalPhysicalRooms − activeBookings(CONFIRMED/CHECKED_IN overlapping dates)
     * <p>
     * Dùng để hiển thị badge "Hết phòng" và disable nút "Chọn phòng" trên trang chi tiết homestay.
     *
     * @param homestayId ID cơ sở homestay
     * @param checkin    ngày nhận phòng (yyyy-MM-dd) — start of requested stay
     * @param checkout   ngày trả phòng  (yyyy-MM-dd) — end of requested stay
     * @return Map&lt;roomTypeId, availableCount&gt;; availableCount &le; 0 → hết phòng
     */
    java.util.Map<Integer, Integer> getAvailableCountByType(int homestayId, String checkin, String checkout);
}
