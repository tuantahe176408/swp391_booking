package com.project.dao;

import com.project.config.DBContext;
import com.project.model.Homestay;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object Implementation: Wishlist Operations
 * Package: com.project.dao
 */
public class WishlistDAOImpl implements WishlistDAO {

    private static final Logger LOGGER = Logger.getLogger(WishlistDAOImpl.class.getName());

    @Override
    public boolean addToWishlist(int userId, int homestayId) {
        String sql = "INSERT IGNORE INTO wishlists (user_id, homestay_id) VALUES (?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, homestayId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in addToWishlist", e);
        }
        return false;
    }

    @Override
    public boolean removeFromWishlist(int userId, int homestayId) {
        String sql = "DELETE FROM wishlists WHERE user_id = ? AND homestay_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, homestayId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in removeFromWishlist", e);
        }
        return false;
    }

    @Override
    public boolean isWishlisted(int userId, int homestayId) {
        String sql = "SELECT 1 FROM wishlists WHERE user_id = ? AND homestay_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, homestayId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in isWishlisted", e);
        }
        return false;
    }

    @Override
    public List<Homestay> getWishlistByUserId(int userId) {
        List<Homestay> list = new ArrayList<>();
        String sql = "SELECT h.homestay_id, h.owner_id, h.name, h.description, h.address, h.city, h.district, " +
                     "h.rating_avg, h.review_count, " +
                     "(SELECT image_url FROM homestay_images hi WHERE hi.homestay_id = h.homestay_id ORDER BY hi.is_primary DESC, hi.display_order ASC LIMIT 1) AS primary_image, " +
                     "(SELECT MIN(base_price) FROM room_types rt WHERE rt.homestay_id = h.homestay_id) AS min_price " +
                     "FROM wishlists w " +
                     "JOIN homestays h ON w.homestay_id = h.homestay_id " +
                     "WHERE w.user_id = ? ORDER BY w.created_at DESC";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Homestay h = new Homestay();
                    h.setHomestayId(rs.getInt("homestay_id"));
                    h.setOwnerId(rs.getInt("owner_id"));
                    h.setName(rs.getString("name"));
                    h.setDescription(rs.getString("description"));
                    h.setAddress(rs.getString("address"));
                    h.setCity(rs.getString("city"));
                    h.setDistrict(rs.getString("district"));
                    h.setRatingAvg(rs.getBigDecimal("rating_avg"));
                    h.setReviewCount(rs.getInt("review_count"));
                    h.setPrimaryImageUrl(rs.getString("primary_image"));
                    BigDecimal mp = rs.getBigDecimal("min_price");
                    h.setMinPrice(mp != null ? mp : BigDecimal.ZERO);
                    h.setWishlisted(true);
                    list.add(h);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getWishlistByUserId", e);
        }
        return list;
    }
}
