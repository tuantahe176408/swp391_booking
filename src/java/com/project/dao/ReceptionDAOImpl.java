package com.project.dao;

import com.project.config.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * JDBC Implementation: Reception Staff Assignment Queries
 * Package: com.project.dao
 *
 * Table: receptionist_staff (staff_id, user_id UNIQUE, homestay_id, assigned_at)
 */
public class ReceptionDAOImpl implements ReceptionDAO {

    private static final Logger LOGGER = Logger.getLogger(ReceptionDAOImpl.class.getName());

    @Override
    public Integer getAssignedHomestayId(int userId) {
        String sql = "SELECT homestay_id FROM receptionist_staff WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("homestay_id");
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getAssignedHomestayId for userId=" + userId, e);
        }
        return null;
    }

    @Override
    public String getAssignedHomestayName(int userId) {
        String sql = "SELECT h.name " +
                     "FROM receptionist_staff rs " +
                     "JOIN homestays h ON h.homestay_id = rs.homestay_id " +
                     "WHERE rs.user_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("name");
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getAssignedHomestayName for userId=" + userId, e);
        }
        return null;
    }
}
