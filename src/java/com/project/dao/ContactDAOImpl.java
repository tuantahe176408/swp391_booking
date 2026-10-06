package com.project.dao;

import com.project.config.DBContext;
import com.project.model.ContactMessage;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * DAO Implementation: Contact Message Operations
 * Package: com.project.dao
 */
public class ContactDAOImpl implements ContactDAO {

    private static final Logger LOGGER = Logger.getLogger(ContactDAOImpl.class.getName());

    private ContactMessage map(ResultSet rs) throws SQLException {
        ContactMessage m = new ContactMessage();
        m.setMessageId(rs.getInt("message_id"));
        m.setSenderName(rs.getString("sender_name"));
        m.setSenderEmail(rs.getString("sender_email"));
        m.setSenderPhone(rs.getString("sender_phone"));
        m.setSubject(rs.getString("subject"));
        m.setMessage(rs.getString("message"));
        m.setResolved(rs.getBoolean("is_resolved"));
        int resolvedBy = rs.getInt("resolved_by");
        m.setResolvedBy(rs.wasNull() ? null : resolvedBy);
        m.setResolvedAt(rs.getTimestamp("resolved_at"));
        m.setCreatedAt(rs.getTimestamp("created_at"));
        try { m.setResolvedByName(rs.getString("resolved_by_name")); } catch (SQLException ignored) {}
        return m;
    }

    @Override
    public boolean insertMessage(ContactMessage msg) {
        String sql = "INSERT INTO contact_messages " +
                     "(sender_name, sender_email, sender_phone, subject, message) " +
                     "VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, msg.getSenderName());
            ps.setString(2, msg.getSenderEmail());
            ps.setString(3, msg.getSenderPhone());
            ps.setString(4, msg.getSubject());
            ps.setString(5, msg.getMessage());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in insertMessage", e);
            return false;
        }
    }

    @Override
    public List<ContactMessage> getMessages(Boolean resolved, int offset, int limit) {
        List<ContactMessage> list = new ArrayList<>();
        String where = (resolved == null) ? "" : " WHERE cm.is_resolved = ?";
        String sql = "SELECT cm.*, u.full_name AS resolved_by_name " +
                     "FROM contact_messages cm " +
                     "LEFT JOIN users u ON cm.resolved_by = u.user_id" +
                     where +
                     " ORDER BY cm.is_resolved ASC, cm.created_at DESC" +
                     " LIMIT ? OFFSET ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            if (resolved != null) ps.setBoolean(idx++, resolved);
            ps.setInt(idx++, limit);
            ps.setInt(idx,   offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getMessages", e);
        }
        return list;
    }

    @Override
    public int countMessages(Boolean resolved) {
        String where = (resolved == null) ? "" : " WHERE is_resolved = ?";
        String sql = "SELECT COUNT(*) FROM contact_messages" + where;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (resolved != null) ps.setBoolean(1, resolved);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in countMessages", e);
        }
        return 0;
    }

    @Override
    public Optional<ContactMessage> getMessageById(int messageId) {
        String sql = "SELECT cm.*, u.full_name AS resolved_by_name " +
                     "FROM contact_messages cm " +
                     "LEFT JOIN users u ON cm.resolved_by = u.user_id " +
                     "WHERE cm.message_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, messageId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(map(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getMessageById: " + messageId, e);
        }
        return Optional.empty();
    }

    @Override
    public boolean setResolved(int messageId, boolean resolved, int adminId) {
        String sql = resolved
            ? "UPDATE contact_messages SET is_resolved=TRUE,  resolved_by=?, resolved_at=NOW() WHERE message_id=?"
            : "UPDATE contact_messages SET is_resolved=FALSE, resolved_by=NULL, resolved_at=NULL WHERE message_id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (resolved) {
                ps.setInt(1, adminId);
                ps.setInt(2, messageId);
            } else {
                ps.setInt(1, messageId);
            }
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in setResolved: " + messageId, e);
            return false;
        }
    }
}
