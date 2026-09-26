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
    List<Room> getAvailableRooms(int homestayId, int roomTypeId, String checkinDate, String checkoutDate);
    Optional<Room> getRoomById(int roomId);
    int insertRoom(Room room);
    boolean updateRoomStatus(int roomId, Room.Status status);
    boolean updateRoom(Room room);
    boolean deleteRoom(int roomId);
}
