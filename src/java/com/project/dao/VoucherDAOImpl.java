package com.project.dao;

import com.project.config.DBContext;
import com.project.model.Voucher;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object Implementation: Voucher Operations
 * Package: com.project.dao
 */
public class VoucherDAOImpl implements VoucherDAO {

    private static final Logger LOGGER = Logger.getLogger(VoucherDAOImpl.class.getName());

    private Voucher mapVoucher(ResultSet rs) throws SQLException {
        Voucher v = new Voucher();
        v.setVoucherId(rs.getInt("voucher_id"));
        v.setCode(rs.getString("code"));
        v.setDescription(rs.getString("description"));
        String dtype = rs.getString("discount_type");
        v.setDiscountType(dtype != null ? Voucher.DiscountType.valueOf(dtype) : Voucher.DiscountType.PERCENTAGE);
        v.setDiscountValue(rs.getBigDecimal("discount_value"));
        v.setMaxDiscountAmount(rs.getBigDecimal("max_discount_amount"));
        v.setMinOrderAmount(rs.getBigDecimal("min_order_amount"));
        v.setTotalLimit(rs.getInt("total_limit"));
        v.setUsedCount(rs.getInt("used_count"));
        v.setExpiryDate(rs.getDate("expiry_date"));
        v.setActive(rs.getBoolean("is_active"));
        v.setCreatedAt(rs.getTimestamp("created_at"));
        return v;
    }

    @Override
    public Optional<Voucher> findByCode(String code) {
        String sql = "SELECT * FROM vouchers WHERE code = ? AND is_active = TRUE AND expiry_date >= CURDATE()";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code.trim().toUpperCase());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(mapVoucher(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in findByCode: " + code, e);
        }
        return Optional.empty();
    }

    @Override
    public List<Voucher> getAllVouchers() {
        List<Voucher> list = new ArrayList<>();
        String sql = "SELECT * FROM vouchers ORDER BY created_at DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapVoucher(rs));
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getAllVouchers", e);
        }
        return list;
    }

    @Override
    public int insertVoucher(Voucher v) {
        String sql = "INSERT INTO vouchers (code, description, discount_type, discount_value, max_discount_amount, min_order_amount, total_limit, expiry_date, is_active) VALUES (?,?,?,?,?,?,?,?,?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, v.getCode().toUpperCase());
            ps.setString(2, v.getDescription());
            ps.setString(3, v.getDiscountType().name());
            ps.setBigDecimal(4, v.getDiscountValue());
            ps.setBigDecimal(5, v.getMaxDiscountAmount());
            ps.setBigDecimal(6, v.getMinOrderAmount());
            ps.setInt(7, v.getTotalLimit());
            ps.setDate(8, v.getExpiryDate());
            ps.setBoolean(9, v.isActive());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in insertVoucher", e);
        }
        return -1;
    }

    @Override
    public boolean updateVoucher(Voucher v) {
        String sql = "UPDATE vouchers SET code=?, description=?, discount_type=?, discount_value=?, max_discount_amount=?, min_order_amount=?, total_limit=?, expiry_date=?, is_active=? WHERE voucher_id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getCode().toUpperCase());
            ps.setString(2, v.getDescription());
            ps.setString(3, v.getDiscountType().name());
            ps.setBigDecimal(4, v.getDiscountValue());
            ps.setBigDecimal(5, v.getMaxDiscountAmount());
            ps.setBigDecimal(6, v.getMinOrderAmount());
            ps.setInt(7, v.getTotalLimit());
            ps.setDate(8, v.getExpiryDate());
            ps.setBoolean(9, v.isActive());
            ps.setInt(10, v.getVoucherId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in updateVoucher", e);
        }
        return false;
    }

    @Override
    public boolean toggleActive(int voucherId, boolean active) {
        String sql = "UPDATE vouchers SET is_active=? WHERE voucher_id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, active);
            ps.setInt(2, voucherId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in toggleActive", e);
        }
        return false;
    }

    @Override
    public boolean deleteVoucher(int voucherId) {
        String sql = "DELETE FROM vouchers WHERE voucher_id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, voucherId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in deleteVoucher", e);
        }
        return false;
    }

    @Override
    public boolean incrementUsedCount(int voucherId) {
        String sql = "UPDATE vouchers SET used_count = used_count + 1 WHERE voucher_id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, voucherId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in incrementUsedCount", e);
        }
        return false;
    }
}
