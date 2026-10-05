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
        v.setMinBookingAmount(rs.getBigDecimal("min_booking_amount"));
        v.setUsageLimit(rs.getInt("usage_limit"));
        v.setUsedCount(rs.getInt("used_count"));
        v.setStartDate(rs.getTimestamp("start_date"));
        v.setEndDate(rs.getTimestamp("end_date"));
        v.setActive(rs.getBoolean("is_active"));
        int createdBy = rs.getInt("created_by_user_id");
        v.setCreatedByUserId(rs.wasNull() ? null : createdBy);
        v.setCreatedAt(rs.getTimestamp("created_at"));
        return v;
    }

    @Override
    public Optional<Voucher> findByCode(String code) {
        String sql = "SELECT * FROM vouchers WHERE code = ? AND is_active = TRUE AND end_date >= NOW() AND start_date <= NOW()";
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
        String sql = "INSERT INTO vouchers (code, description, discount_type, discount_value, max_discount_amount, min_booking_amount, usage_limit, start_date, end_date, is_active, created_by_user_id) VALUES (?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, v.getCode().trim().toUpperCase());
            ps.setString(2, v.getDescription());
            ps.setString(3, v.getDiscountType().name());
            ps.setBigDecimal(4, v.getDiscountValue());
            ps.setBigDecimal(5, v.getMaxDiscountAmount());
            ps.setBigDecimal(6, v.getMinBookingAmount());
            ps.setInt(7, v.getUsageLimit());
            ps.setTimestamp(8, v.getStartDate());
            ps.setTimestamp(9, v.getEndDate());
            ps.setBoolean(10, v.isActive());
            if (v.getCreatedByUserId() != null) {
                ps.setInt(11, v.getCreatedByUserId());
            } else {
                ps.setNull(11, Types.INTEGER);
            }
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in insertVoucher: " + v.getCode(), e);
        }
        return -1;
    }

    @Override
    public boolean updateVoucher(Voucher v) {
        String sql = "UPDATE vouchers SET code=?, description=?, discount_type=?, discount_value=?, max_discount_amount=?, min_booking_amount=?, usage_limit=?, start_date=?, end_date=?, is_active=? WHERE voucher_id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getCode().trim().toUpperCase());
            ps.setString(2, v.getDescription());
            ps.setString(3, v.getDiscountType().name());
            ps.setBigDecimal(4, v.getDiscountValue());
            ps.setBigDecimal(5, v.getMaxDiscountAmount());
            ps.setBigDecimal(6, v.getMinBookingAmount());
            ps.setInt(7, v.getUsageLimit());
            ps.setTimestamp(8, v.getStartDate());
            ps.setTimestamp(9, v.getEndDate());
            ps.setBoolean(10, v.isActive());
            ps.setInt(11, v.getVoucherId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in updateVoucher: " + v.getVoucherId(), e);
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
            LOGGER.log(Level.SEVERE, "Error in toggleActive: " + voucherId, e);
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
            LOGGER.log(Level.SEVERE, "Error in deleteVoucher: " + voucherId, e);
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
            LOGGER.log(Level.SEVERE, "Error in incrementUsedCount: " + voucherId, e);
        }
        return false;
    }

    @Override
    public List<Voucher> searchVouchers(String keyword, String status, String discountType, int offset, int limit) {
        List<Voucher> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM vouchers WHERE 1=1 ");
        List<Object> params = buildVoucherFilterParams(sql, keyword, status, discountType);

        sql.append(" ORDER BY created_at DESC LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapVoucher(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in searchVouchers", e);
        }
        return list;
    }

    @Override
    public int countSearchVouchers(String keyword, String status, String discountType) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM vouchers WHERE 1=1 ");
        List<Object> params = buildVoucherFilterParams(sql, keyword, status, discountType);

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in countSearchVouchers", e);
        }
        return 0;
    }

    private List<Object> buildVoucherFilterParams(StringBuilder sql, String keyword, String status, String discountType) {
        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (LOWER(code) LIKE ? OR LOWER(description) LIKE ?) ");
            String kw = "%" + keyword.trim().toLowerCase() + "%";
            params.add(kw);
            params.add(kw);
        }
        if (status != null && !status.trim().isEmpty() && !"ALL".equalsIgnoreCase(status)) {
            if ("ACTIVE".equalsIgnoreCase(status)) {
                sql.append(" AND is_active = TRUE AND (end_date IS NULL OR end_date >= NOW()) ");
            } else if ("INACTIVE".equalsIgnoreCase(status)) {
                sql.append(" AND is_active = FALSE ");
            } else if ("EXPIRED".equalsIgnoreCase(status)) {
                sql.append(" AND end_date IS NOT NULL AND end_date < NOW() ");
            }
        }
        if (discountType != null && !discountType.trim().isEmpty() && !"ALL".equalsIgnoreCase(discountType)) {
            sql.append(" AND discount_type = ? ");
            params.add(discountType.trim().toUpperCase());
        }
        return params;
    }
}
