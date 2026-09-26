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
        r.setHomestayId(rs.getInt("homestay_id"));
        r.setRoomTypeId(rs.getInt("room_type_id"));
        r.setRoomNumber(rs.getString("room_number"));
        String statusStr = rs.getString("status");
        r.setStatus(statusStr != null ? Room.Status.valueOf(statusStr) : Room.Status.AVAILABLE);
        r.setNotes(rs.getString("notes"));
        r.setCreatedAt(rs.getTimestamp("created_at"));
        r.setUpdatedAt(rs.getTimestamp("updated_at"));
        // Transient from JOIN
        try { r.setRoomTypeName(rs.getString("room_type_name")); } catch (SQLException ignored) {}
        try { r.setBasePrice(rs.getBigDecimal("base_price")); } catch (SQLException ignored) {}
        return r;
    }

    @Override
    public List<Room> getRoomsByHomestayId(int homestayId) {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT r.*, rt.name AS room_type_name, rt.base_price " +
                     "FROM rooms r LEFT JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
                     "WHERE r.homestay_id = ? ORDER BY r.room_number";
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
    public List<Room> getAvailableRooms(int homestayId, int roomTypeId, String checkinDate, String checkoutDate) {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT r.*, rt.name AS room_type_name, rt.base_price " +
                     "FROM rooms r LEFT JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
                     "WHERE r.homestay_id = ? AND r.room_type_id = ? AND r.status = 'AVAILABLE' " +
                     "AND r.room_id NOT IN (" +
                     "  SELECT b.assigned_room_id FROM bookings b " +
                     "  WHERE b.assigned_room_id IS NOT NULL " +
                     "  AND b.booking_status NOT IN ('CANCELLED','REFUNDED') " +
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
        String sql = "INSERT INTO rooms (homestay_id, room_type_id, room_number, status, notes) VALUES (?,?,?,?,?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, r.getHomestayId());
            ps.setInt(2, r.getRoomTypeId());
            ps.setString(3, r.getRoomNumber());
            ps.setString(4, r.getStatus().name());
            ps.setString(5, r.getNotes());
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
        String sql = "UPDATE rooms SET status=?, updated_at=NOW() WHERE room_id=?";
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
        String sql = "UPDATE rooms SET room_type_id=?, room_number=?, status=?, notes=?, updated_at=NOW() WHERE room_id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, r.getRoomTypeId());
            ps.setString(2, r.getRoomNumber());
            ps.setString(3, r.getStatus().name());
            ps.setString(4, r.getNotes());
            ps.setInt(5, r.getRoomId());
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
}
