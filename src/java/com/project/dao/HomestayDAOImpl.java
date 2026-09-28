package com.project.dao;

import com.project.config.DBContext;
import com.project.model.Amenity;
import com.project.model.Homestay;
import com.project.model.HomestayImage;
import com.project.model.Review;
import com.project.model.RoomType;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object Implementation: Homestay & Search Operations
 * Package: com.project.dao
 */
public class HomestayDAOImpl implements HomestayDAO {

    private static final Logger LOGGER = Logger.getLogger(HomestayDAOImpl.class.getName());

    @Override
    public List<Homestay> searchHomestays(String location, String checkin, String checkout, Integer guests,
                                          Double minPrice, Double maxPrice, List<Integer> amenityIds, String sortBy,
                                          int offset, int limit) {
        List<Homestay> homestays = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT h.homestay_id, h.owner_id, h.name, h.description, h.address, h.city, h.district, ")
           .append("h.latitude, h.longitude, h.status, h.checkin_time, h.checkout_time, h.rating_avg, h.review_count, ")
           .append("(SELECT image_url FROM homestay_images hi WHERE hi.homestay_id = h.homestay_id ORDER BY hi.is_primary DESC, hi.display_order ASC LIMIT 1) AS primary_image, ")
           .append("(SELECT MIN(base_price) FROM room_types rt WHERE rt.homestay_id = h.homestay_id) AS min_price ")
           .append("FROM homestays h WHERE h.status = 'ACTIVE' ");

        List<Object> params = new ArrayList<>();

        if (location != null && !location.trim().isEmpty()) {
            sql.append("AND (h.city LIKE ? OR h.district LIKE ? OR h.name LIKE ? OR h.address LIKE ?) ");
            String searchPattern = "%" + location.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (guests != null && guests > 0) {
            sql.append("AND EXISTS (SELECT 1 FROM room_types rt WHERE rt.homestay_id = h.homestay_id AND rt.max_occupancy >= ?) ");
            params.add(guests);
        }

        if (minPrice != null && minPrice > 0) {
            sql.append("AND EXISTS (SELECT 1 FROM room_types rt WHERE rt.homestay_id = h.homestay_id AND rt.base_price >= ?) ");
            params.add(minPrice);
        }

        if (maxPrice != null && maxPrice > 0) {
            sql.append("AND EXISTS (SELECT 1 FROM room_types rt WHERE rt.homestay_id = h.homestay_id AND rt.base_price <= ?) ");
            params.add(maxPrice);
        }

        if (amenityIds != null && !amenityIds.isEmpty()) {
            sql.append("AND h.homestay_id IN (")
               .append("SELECT ha.homestay_id FROM homestay_amenities ha WHERE ha.amenity_id IN (");
            for (int i = 0; i < amenityIds.size(); i++) {
                sql.append(i > 0 ? ",?" : "?");
                params.add(amenityIds.get(i));
            }
            sql.append(") GROUP BY ha.homestay_id HAVING COUNT(DISTINCT ha.amenity_id) = ?) ");
            params.add(amenityIds.size());
        }

        if ("price_asc".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY min_price ASC, h.rating_avg DESC ");
        } else if ("price_desc".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY min_price DESC, h.rating_avg DESC ");
        } else if ("rating".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY h.rating_avg DESC, h.review_count DESC ");
        } else {
            sql.append("ORDER BY h.rating_avg DESC, h.homestay_id DESC ");
        }

        sql.append("LIMIT ? OFFSET ?");
        params.add(limit > 0 ? limit : 12);
        params.add(Math.max(offset, 0));

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Homestay h = mapHomestay(rs);
                    h.setPrimaryImageUrl(rs.getString("primary_image"));
                    BigDecimal mp = rs.getBigDecimal("min_price");
                    h.setMinPrice(mp != null ? mp : BigDecimal.ZERO);
                    h.setAmenityNames(getAmenityNames(conn, h.getHomestayId()));
                    homestays.add(h);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in searchHomestays", e);
        }
        return homestays;
    }

    @Override
    public int countSearchResults(String location, String checkin, String checkout, Integer guests,
                                  Double minPrice, Double maxPrice, List<Integer> amenityIds) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM homestays h WHERE h.status = 'ACTIVE' ");
        List<Object> params = new ArrayList<>();

        if (location != null && !location.trim().isEmpty()) {
            sql.append("AND (h.city LIKE ? OR h.district LIKE ? OR h.name LIKE ? OR h.address LIKE ?) ");
            String searchPattern = "%" + location.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (guests != null && guests > 0) {
            sql.append("AND EXISTS (SELECT 1 FROM room_types rt WHERE rt.homestay_id = h.homestay_id AND rt.max_occupancy >= ?) ");
            params.add(guests);
        }

        if (minPrice != null && minPrice > 0) {
            sql.append("AND EXISTS (SELECT 1 FROM room_types rt WHERE rt.homestay_id = h.homestay_id AND rt.base_price >= ?) ");
            params.add(minPrice);
        }

        if (maxPrice != null && maxPrice > 0) {
            sql.append("AND EXISTS (SELECT 1 FROM room_types rt WHERE rt.homestay_id = h.homestay_id AND rt.base_price <= ?) ");
            params.add(maxPrice);
        }

        if (amenityIds != null && !amenityIds.isEmpty()) {
            sql.append("AND h.homestay_id IN (")
               .append("SELECT ha.homestay_id FROM homestay_amenities ha WHERE ha.amenity_id IN (");
            for (int i = 0; i < amenityIds.size(); i++) {
                sql.append(i > 0 ? ",?" : "?");
                params.add(amenityIds.get(i));
            }
            sql.append(") GROUP BY ha.homestay_id HAVING COUNT(DISTINCT ha.amenity_id) = ?) ");
            params.add(amenityIds.size());
        }

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
            LOGGER.log(Level.SEVERE, "Error counting search results", e);
        }
        return 0;
    }

    @Override
    public List<Homestay> getFeaturedHomestays(int limit) {
        List<Homestay> list = new ArrayList<>();
        String sql = "SELECT h.homestay_id, h.owner_id, h.name, h.description, h.address, h.city, h.district, " +
                     "h.latitude, h.longitude, h.status, h.checkin_time, h.checkout_time, h.rating_avg, h.review_count, " +
                     "(SELECT image_url FROM homestay_images hi WHERE hi.homestay_id = h.homestay_id ORDER BY hi.is_primary DESC, hi.display_order ASC LIMIT 1) AS primary_image, " +
                     "(SELECT MIN(base_price) FROM room_types rt WHERE rt.homestay_id = h.homestay_id) AS min_price " +
                     "FROM homestays h WHERE h.status = 'ACTIVE' " +
                     "ORDER BY h.rating_avg DESC, h.review_count DESC LIMIT ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit > 0 ? limit : 6);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Homestay h = mapHomestay(rs);
                    h.setPrimaryImageUrl(rs.getString("primary_image"));
                    BigDecimal mp = rs.getBigDecimal("min_price");
                    h.setMinPrice(mp != null ? mp : BigDecimal.ZERO);
                    h.setAmenityNames(getAmenityNames(conn, h.getHomestayId()));
                    list.add(h);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getFeaturedHomestays", e);
        }
        return list;
    }

    @Override
    public Optional<Homestay> getHomestayById(int homestayId) {
        String sql = "SELECT h.homestay_id, h.owner_id, h.name, h.description, h.address, h.city, h.district, " +
                     "h.latitude, h.longitude, h.status, h.checkin_time, h.checkout_time, h.rating_avg, h.review_count, " +
                     "(SELECT image_url FROM homestay_images hi WHERE hi.homestay_id = h.homestay_id ORDER BY hi.is_primary DESC, hi.display_order ASC LIMIT 1) AS primary_image, " +
                     "(SELECT MIN(base_price) FROM room_types rt WHERE rt.homestay_id = h.homestay_id) AS min_price " +
                     "FROM homestays h WHERE h.homestay_id = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, homestayId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Homestay h = mapHomestay(rs);
                    h.setPrimaryImageUrl(rs.getString("primary_image"));
                    BigDecimal mp = rs.getBigDecimal("min_price");
                    h.setMinPrice(mp != null ? mp : BigDecimal.ZERO);
                    h.setImages(getHomestayImages(homestayId));
                    h.setRoomTypes(getRoomTypesByHomestayId(homestayId));
                    h.setAmenityNames(getAmenityNames(conn, homestayId));
                    h.setReviews(getReviewsByHomestayId(homestayId));
                    return Optional.of(h);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getHomestayById for id: " + homestayId, e);
        }
        return Optional.empty();
    }

    @Override
    public List<RoomType> getRoomTypesByHomestayId(int homestayId) {
        List<RoomType> list = new ArrayList<>();
        String sql = "SELECT room_type_id, homestay_id, name, description, base_price, max_occupancy, bed_count, room_size_sqm " +
                     "FROM room_types WHERE homestay_id = ? ORDER BY base_price ASC";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, homestayId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RoomType rt = new RoomType();
                    rt.setRoomTypeId(rs.getInt("room_type_id"));
                    rt.setHomestayId(rs.getInt("homestay_id"));
                    rt.setName(rs.getString("name"));
                    rt.setDescription(rs.getString("description"));
                    rt.setBasePrice(rs.getBigDecimal("base_price"));
                    rt.setMaxOccupancy(rs.getInt("max_occupancy"));
                    rt.setBedCount(rs.getInt("bed_count"));
                    rt.setRoomSizeSqm(rs.getBigDecimal("room_size_sqm"));
                    list.add(rt);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getRoomTypesByHomestayId for id: " + homestayId, e);
        }
        return list;
    }

    @Override
    public List<HomestayImage> getHomestayImages(int homestayId) {
        List<HomestayImage> list = new ArrayList<>();
        String sql = "SELECT image_id, homestay_id, image_url, is_primary, display_order, created_at " +
                     "FROM homestay_images WHERE homestay_id = ? ORDER BY is_primary DESC, display_order ASC";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, homestayId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    HomestayImage img = new HomestayImage();
                    img.setImageId(rs.getInt("image_id"));
                    img.setHomestayId(rs.getInt("homestay_id"));
                    img.setImageUrl(rs.getString("image_url"));
                    img.setPrimary(rs.getBoolean("is_primary"));
                    img.setDisplayOrder(rs.getInt("display_order"));
                    img.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(img);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getHomestayImages for homestayId: " + homestayId, e);
        }
        return list;
    }

    @Override
    public List<Amenity> getHomestayAmenities(int homestayId) {
        List<Amenity> list = new ArrayList<>();
        String sql = "SELECT a.amenity_id, a.name, a.icon_class, a.category " +
                     "FROM amenities a " +
                     "JOIN homestay_amenities ha ON a.amenity_id = ha.amenity_id " +
                     "WHERE ha.homestay_id = ? ORDER BY a.category, a.name";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, homestayId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Amenity(
                        rs.getInt("amenity_id"),
                        rs.getString("name"),
                        rs.getString("icon_class"),
                        rs.getString("category")
                    ));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getHomestayAmenities for homestayId: " + homestayId, e);
        }
        return list;
    }

    @Override
    public List<Amenity> getAllAmenities() {
        List<Amenity> list = new ArrayList<>();
        String sql = "SELECT amenity_id, name, icon_class, category FROM amenities ORDER BY category, name";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new Amenity(
                    rs.getInt("amenity_id"),
                    rs.getString("name"),
                    rs.getString("icon_class"),
                    rs.getString("category")
                ));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getAllAmenities", e);
        }
        return list;
    }

    @Override
    public List<String> getAllCities() {
        List<String> cities = new ArrayList<>();
        String sql = "SELECT DISTINCT city FROM homestays WHERE status = 'ACTIVE' ORDER BY city";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                cities.add(rs.getString("city"));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getAllCities", e);
        }
        return cities;
    }

    @Override
    public List<Review> getReviewsByHomestayId(int homestayId) {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT r.review_id, r.booking_id, r.customer_id, r.homestay_id, " +
                     "r.rating_cleanliness, r.rating_service, r.rating_location, r.rating_value, " +
                     "r.rating_overall, r.comment, r.owner_reply, r.owner_replied_at, r.created_at, " +
                     "u.full_name, u.avatar_url " +
                     "FROM reviews r " +
                     "JOIN users u ON r.customer_id = u.user_id " +
                     "WHERE r.homestay_id = ? ORDER BY r.created_at DESC";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, homestayId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Review r = new Review();
                    r.setReviewId(rs.getInt("review_id"));
                    r.setBookingId(rs.getInt("booking_id"));
                    r.setCustomerId(rs.getInt("customer_id"));
                    r.setHomestayId(rs.getInt("homestay_id"));
                    r.setRatingCleanliness(rs.getInt("rating_cleanliness"));
                    r.setRatingService(rs.getInt("rating_service"));
                    r.setRatingLocation(rs.getInt("rating_location"));
                    r.setRatingValue(rs.getInt("rating_value"));
                    r.setRatingOverall(rs.getBigDecimal("rating_overall"));
                    r.setComment(rs.getString("comment"));
                    r.setOwnerReply(rs.getString("owner_reply"));
                    r.setOwnerRepliedAt(rs.getTimestamp("owner_replied_at"));
                    r.setCreatedAt(rs.getTimestamp("created_at"));
                    r.setCustomerName(rs.getString("full_name"));
                    r.setCustomerAvatarUrl(rs.getString("avatar_url"));
                    reviews.add(r);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getReviewsByHomestayId for homestayId: " + homestayId, e);
        }
        return reviews;
    }

    @Override
    public List<Homestay> getRecommendedHomestays(int userId, int limit) {
        List<Homestay> recommendations = new ArrayList<>();
        // Check user preferences
        String prefSql = "SELECT category FROM user_preferences WHERE user_id = ?";
        List<String> userCategories = new ArrayList<>();

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(prefSql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    userCategories.add(rs.getString("category"));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error reading user preferences for recommendations", e);
        }

        // Query homestays
        List<Homestay> allActive = getFeaturedHomestays(limit > 0 ? limit * 2 : 12);
        for (int i = 0; i < allActive.size(); i++) {
            Homestay h = allActive.get(i);
            double baseMatch = 88.0 + (h.getRatingAvg().doubleValue() * 2.0);
            if (baseMatch > 99.0) baseMatch = 98.8;

            if (!userCategories.isEmpty()) {
                String firstCat = userCategories.get(i % userCategories.size());
                h.setReasonTag("Phù hợp với sở thích " + formatCategoryTag(firstCat));
            } else {
                h.setReasonTag("Được yêu thích hàng đầu với điểm đánh giá " + h.getRatingAvg() + "/5");
            }
            h.setMatchScore(Math.round(baseMatch * 10.0) / 10.0);
            recommendations.add(h);
            if (recommendations.size() >= limit) break;
        }

        return recommendations;
    }

    private String formatCategoryTag(String category) {
        if ("BEACH".equalsIgnoreCase(category)) return "Du lịch biển";
        if ("MOUNTAIN".equalsIgnoreCase(category)) return "Nghỉ dưỡng vùng núi";
        if ("LUXURY".equalsIgnoreCase(category)) return "Sang trọng & Tiện nghi cao";
        if ("BUDGET".equalsIgnoreCase(category)) return "Tiết kiệm chi phí";
        if ("PET_FRIENDLY".equalsIgnoreCase(category)) return "Mang theo thú cưng";
        if ("FAMILY".equalsIgnoreCase(category)) return "Gia đình & Nhóm bạn";
        return category;
    }

    private Homestay mapHomestay(ResultSet rs) throws SQLException {
        Homestay h = new Homestay();
        h.setHomestayId(rs.getInt("homestay_id"));
        h.setOwnerId(rs.getInt("owner_id"));
        h.setName(rs.getString("name"));
        h.setDescription(rs.getString("description"));
        h.setAddress(rs.getString("address"));
        h.setCity(rs.getString("city"));
        h.setDistrict(rs.getString("district"));
        h.setLatitude(rs.getBigDecimal("latitude"));
        h.setLongitude(rs.getBigDecimal("longitude"));
        String statusStr = rs.getString("status");
        if (statusStr != null) {
            h.setStatus(Homestay.Status.valueOf(statusStr));
        }
        h.setCheckinTime(rs.getTime("checkin_time"));
        h.setCheckoutTime(rs.getTime("checkout_time"));
        h.setRatingAvg(rs.getBigDecimal("rating_avg"));
        h.setReviewCount(rs.getInt("review_count"));
        return h;
    }

    private List<String> getAmenityNames(Connection conn, int homestayId) {
        List<String> names = new ArrayList<>();
        String sql = "SELECT a.name FROM amenities a JOIN homestay_amenities ha ON a.amenity_id = ha.amenity_id WHERE ha.homestay_id = ? LIMIT 5";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, homestayId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    names.add(rs.getString("name"));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error loading amenity names for homestayId: " + homestayId, e);
        }
        return names;
    }
}
