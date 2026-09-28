package com.project.dao;

import com.project.config.DBContext;
import com.project.model.DynamicPrice;

import java.math.BigDecimal;
import java.sql.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * DAO Implementation: Dynamic Pricing Calendar (UC18)
 * Package: com.project.dao
 */
public class CalendarDAOImpl implements CalendarDAO {

    private static final Logger LOGGER = Logger.getLogger(CalendarDAOImpl.class.getName());

    // ── getPriceMapByRoomTypesAndMonth ────────────────────────────────────────

    @Override
    public Map<String, DynamicPrice> getPriceMapByRoomTypesAndMonth(
            List<Integer> roomTypeIds, int year, int month) {

        Map<String, DynamicPrice> map = new LinkedHashMap<>();
        if (roomTypeIds == null || roomTypeIds.isEmpty()) return map;

        // Build IN (?,?,...) placeholders
        String placeholders = String.join(",", Collections.nCopies(roomTypeIds.size(), "?"));

        String sql =
            "SELECT dp.price_id, dp.room_type_id, dp.date, dp.price_multiplier, " +
            "       dp.custom_price, dp.is_locked, dp.created_at, " +
            "       rt.base_price " +
            "FROM dynamic_prices dp " +
            "JOIN room_types rt ON dp.room_type_id = rt.room_type_id " +
            "WHERE dp.room_type_id IN (" + placeholders + ") " +
            "  AND YEAR(dp.date) = ? AND MONTH(dp.date) = ? " +
            "ORDER BY dp.room_type_id, dp.date";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            int idx = 1;
            for (Integer id : roomTypeIds) ps.setInt(idx++, id);
            ps.setInt(idx++, year);
            ps.setInt(idx,   month);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DynamicPrice dp = mapRow(rs);
                    dp.computeEffectivePrice();
                    String key = dp.getRoomTypeId() + "_" + dp.getDate().toString();
                    map.put(key, dp);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getPriceMapByRoomTypesAndMonth", e);
        }
        return map;
    }

    // ── upsertDynamicPrice ────────────────────────────────────────────────────

    @Override
    public boolean upsertDynamicPrice(DynamicPrice dp) {
        String sql =
            "INSERT INTO dynamic_prices (room_type_id, date, price_multiplier, custom_price, is_locked) " +
            "VALUES (?, ?, ?, ?, ?) " +
            "ON DUPLICATE KEY UPDATE " +
            "  price_multiplier = VALUES(price_multiplier), " +
            "  custom_price     = VALUES(custom_price), " +
            "  is_locked        = VALUES(is_locked)";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, dp.getRoomTypeId());
            ps.setDate(2, dp.getDate());
            setBigDecimalOrNull(ps, 3, dp.getPriceMultiplier());
            setBigDecimalOrNull(ps, 4, dp.getCustomPrice());
            ps.setBoolean(5, dp.isLocked());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in upsertDynamicPrice", e);
            return false;
        }
    }

    // ── deleteDynamicPrice ────────────────────────────────────────────────────

    @Override
    public boolean deleteDynamicPrice(int roomTypeId, String date) {
        String sql = "DELETE FROM dynamic_prices WHERE room_type_id = ? AND date = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomTypeId);
            ps.setString(2, date);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in deleteDynamicPrice rt=" + roomTypeId + " date=" + date, e);
            return false;
        }
    }

    // ── bulkUpsert ────────────────────────────────────────────────────────────

    @Override
    public boolean bulkUpsert(List<Integer> roomTypeIds, List<String> dates,
                               BigDecimal priceMultiplier, BigDecimal customPrice, boolean isLocked) {

        if (roomTypeIds == null || roomTypeIds.isEmpty()
                || dates == null || dates.isEmpty()) return false;

        String sql =
            "INSERT INTO dynamic_prices (room_type_id, date, price_multiplier, custom_price, is_locked) " +
            "VALUES (?, ?, ?, ?, ?) " +
            "ON DUPLICATE KEY UPDATE " +
            "  price_multiplier = VALUES(price_multiplier), " +
            "  custom_price     = VALUES(custom_price), " +
            "  is_locked        = VALUES(is_locked)";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            for (Integer rtId : roomTypeIds) {
                for (String date : dates) {
                    ps.setInt(1, rtId);
                    ps.setString(2, date);
                    setBigDecimalOrNull(ps, 3, priceMultiplier);
                    setBigDecimalOrNull(ps, 4, customPrice);
                    ps.setBoolean(5, isLocked);
                    ps.addBatch();
                }
            }
            int[] results = ps.executeBatch();
            return results.length > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in bulkUpsert", e);
            return false;
        }
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    private DynamicPrice mapRow(ResultSet rs) throws SQLException {
        DynamicPrice dp = new DynamicPrice();
        dp.setPriceId(rs.getInt("price_id"));
        dp.setRoomTypeId(rs.getInt("room_type_id"));
        dp.setDate(rs.getDate("date"));
        BigDecimal mult = rs.getBigDecimal("price_multiplier");
        dp.setPriceMultiplier(rs.wasNull() ? null : mult);
        BigDecimal custom = rs.getBigDecimal("custom_price");
        dp.setCustomPrice(rs.wasNull() ? null : custom);
        dp.setLocked(rs.getBoolean("is_locked"));
        dp.setCreatedAt(rs.getTimestamp("created_at"));
        dp.setBasePrice(rs.getBigDecimal("base_price"));
        return dp;
    }

    private void setBigDecimalOrNull(PreparedStatement ps, int idx, BigDecimal val)
            throws SQLException {
        if (val == null) ps.setNull(idx, Types.DECIMAL);
        else             ps.setBigDecimal(idx, val);
    }
}
