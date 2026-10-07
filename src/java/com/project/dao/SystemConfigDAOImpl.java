package com.project.dao;

import com.project.config.DBContext;

import java.sql.*;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * DEFERRED — UC24 System Configuration DAO Implementation
 * ========================================================
 * Xem SystemConfigDAO.java để biết lý do tạm hoãn và hướng dẫn tái kích hoạt.
 * File này giữ nguyên để không mất công implement — chỉ cần uncomment khi cần.
 *
 * Package: com.project.dao
 */
public class SystemConfigDAOImpl implements SystemConfigDAO {

    private static final Logger LOGGER = Logger.getLogger(SystemConfigDAOImpl.class.getName());

    private static final String SQL_GET =
        "SELECT config_value FROM system_configs WHERE config_key = ?";

    private static final String SQL_GET_ALL =
        "SELECT config_key, config_value FROM system_configs ORDER BY config_key";

    private static final String SQL_UPSERT =
        "INSERT INTO system_configs (config_key, config_value) VALUES (?, ?) " +
        "ON DUPLICATE KEY UPDATE config_value = VALUES(config_value)";

    @Override
    public String get(String key) {
        if (key == null || key.isBlank()) return null;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_GET)) {
            ps.setString(1, key);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getString("config_value") : null;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SystemConfigDAO.get failed for key=" + key, e);
            return null;
        }
    }

    @Override
    public String get(String key, String defaultValue) {
        String val = get(key);
        return val != null ? val : defaultValue;
    }

    @Override
    public Map<String, String> getAll() {
        Map<String, String> result = new LinkedHashMap<>();
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_GET_ALL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                result.put(rs.getString("config_key"), rs.getString("config_value"));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SystemConfigDAO.getAll failed", e);
        }
        return result;
    }

    @Override
    public boolean set(String key, String value) {
        if (key == null || key.isBlank()) return false;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_UPSERT)) {
            ps.setString(1, key);
            ps.setString(2, value != null ? value : "");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SystemConfigDAO.set failed for key=" + key, e);
            return false;
        }
    }
}
