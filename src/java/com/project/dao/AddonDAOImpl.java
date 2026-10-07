package com.project.dao;

import com.project.config.DBContext;
import com.project.model.Addon;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object Implementation: Addon Operations
 * Package: com.project.dao
 */
public class AddonDAOImpl implements AddonDAO {

    private static final Logger LOGGER = Logger.getLogger(AddonDAOImpl.class.getName());

    private Addon mapAddon(ResultSet rs) throws SQLException {
        Addon a = new Addon();
        a.setAddonId(rs.getInt("addon_id"));
        a.setHomestayId(rs.getInt("homestay_id"));
        a.setName(rs.getString("name"));
        a.setDescription(rs.getString("description"));
        a.setPrice(rs.getBigDecimal("price"));
        a.setUnit(rs.getString("unit"));
        a.setAvailable(rs.getBoolean("is_available"));
        a.setCreatedAt(rs.getTimestamp("created_at"));
        // populated only when query JOINs homestays
        try { a.setHomestayName(rs.getString("homestay_name")); } catch (SQLException ignored) {}
        return a;
    }

    @Override
    public List<Addon> getAddonsByHomestayId(int homestayId) {
        List<Addon> list = new ArrayList<>();
        String sql = "SELECT * FROM addons WHERE homestay_id = ? AND is_available = TRUE ORDER BY name";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, homestayId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapAddon(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getAddonsByHomestayId: " + homestayId, e);
        }
        return list;
    }

    @Override
    public List<Addon> getAllAddonsByOwnerId(int ownerId) {
        List<Addon> list = new ArrayList<>();
        String sql = "SELECT a.*, h.name AS homestay_name " +
                     "FROM addons a " +
                     "JOIN homestays h ON h.homestay_id = a.homestay_id " +
                     "WHERE h.owner_id = ? " +
                     "ORDER BY h.name ASC, a.name ASC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapAddon(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getAllAddonsByOwnerId: " + ownerId, e);
        }
        return list;
    }

    @Override
    public boolean isAddonOwnedBy(int addonId, int ownerId) {
        String sql = "SELECT 1 FROM addons a JOIN homestays h ON h.homestay_id = a.homestay_id " +
                     "WHERE a.addon_id = ? AND h.owner_id = ? LIMIT 1";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, addonId);
            ps.setInt(2, ownerId);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in isAddonOwnedBy", e);
        }
        return false;
    }

    @Override
    public boolean hasActiveBookings(int addonId) {
        String sql = "SELECT COUNT(*) FROM booking_addons ba " +
                     "JOIN bookings b ON ba.booking_id = b.booking_id " +
                     "WHERE ba.addon_id = ? " +
                     "  AND b.booking_status NOT IN ('CANCELLED','CHECKED_OUT','REFUNDED')";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, addonId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in hasActiveBookings", e);
        }
        return false;
    }

    @Override
    public boolean toggleAvailable(int addonId, boolean available) {
        String sql = "UPDATE addons SET is_available = ? WHERE addon_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, available);
            ps.setInt(2, addonId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in toggleAvailable", e);
        }
        return false;
    }

    @Override
    public Optional<Addon> getAddonById(int addonId) {
        String sql = "SELECT * FROM addons WHERE addon_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, addonId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(mapAddon(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getAddonById: " + addonId, e);
        }
        return Optional.empty();
    }

    @Override
    public int insertAddon(Addon a) {
        String sql = "INSERT INTO addons (homestay_id, name, description, price, unit, is_available) VALUES (?,?,?,?,?,?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, a.getHomestayId());
            ps.setString(2, a.getName());
            ps.setString(3, a.getDescription());
            ps.setBigDecimal(4, a.getPrice());
            ps.setString(5, a.getUnit());
            ps.setBoolean(6, a.isAvailable());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in insertAddon", e);
        }
        return -1;
    }

    @Override
    public boolean updateAddon(Addon a) {
        String sql = "UPDATE addons SET name=?, description=?, price=?, unit=?, is_available=? WHERE addon_id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, a.getName());
            ps.setString(2, a.getDescription());
            ps.setBigDecimal(3, a.getPrice());
            ps.setString(4, a.getUnit());
            ps.setBoolean(5, a.isAvailable());
            ps.setInt(6, a.getAddonId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in updateAddon", e);
        }
        return false;
    }

    @Override
    public boolean deleteAddon(int addonId) {
        String sql = "DELETE FROM addons WHERE addon_id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, addonId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in deleteAddon", e);
        }
        return false;
    }
}
