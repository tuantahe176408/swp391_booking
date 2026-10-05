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
import java.sql.Statement;
import java.sql.Time;
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

    // ── UC17/UC20: Owner homestay list ───────────────────────────────────────

    @Override
    public List<Homestay> getHomestaysByOwnerId(int ownerId) {
        List<Homestay> list = new ArrayList<>();
        String sql = "SELECT h.homestay_id, h.owner_id, h.name, h.description, h.address, h.city, " +
                     "h.district, h.latitude, h.longitude, h.status, h.rejection_reason, " +
                     "h.checkin_time, h.checkout_time, " +
                     "h.rating_avg, h.review_count, h.created_at, h.updated_at, " +
                     "(SELECT hi.image_url FROM homestay_images hi WHERE hi.homestay_id = h.homestay_id " +
                     " ORDER BY hi.is_primary DESC, hi.display_order ASC LIMIT 1) AS primary_image, " +
                     "(SELECT MIN(rt.base_price) FROM room_types rt WHERE rt.homestay_id = h.homestay_id) AS min_price, " +
                     "(SELECT COUNT(r.room_id) FROM rooms r " +
                     " JOIN room_types rt2 ON r.room_type_id = rt2.room_type_id " +
                     " WHERE rt2.homestay_id = h.homestay_id) AS room_count " +
                     "FROM homestays h WHERE h.owner_id = ? ORDER BY h.updated_at DESC";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, ownerId);
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
                    h.setCheckinTime(rs.getTime("checkin_time"));
                    h.setCheckoutTime(rs.getTime("checkout_time"));
                    h.setCreatedAt(rs.getTimestamp("created_at"));
                    h.setUpdatedAt(rs.getTimestamp("updated_at"));
                    h.setRejectionReason(rs.getString("rejection_reason"));
                    String statusStr = rs.getString("status");
                    if (statusStr != null) {
                        try { h.setStatus(Homestay.Status.valueOf(statusStr)); } catch (IllegalArgumentException ignored) {}
                    }
                    h.setPrimaryImageUrl(rs.getString("primary_image"));
                    BigDecimal minP = rs.getBigDecimal("min_price");
                    if (minP != null) h.setMinPrice(minP);
                    h.setRoomCount(rs.getInt("room_count"));
                    list.add(h);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getHomestaysByOwnerId for ownerId=" + ownerId, e);
        }
        return list;
    }

    @Override
    public int countHomestaysByOwnerAndStatus(int ownerId, Homestay.Status status) {
        String sql = (status == null)
            ? "SELECT COUNT(*) FROM homestays WHERE owner_id = ?"
            : "SELECT COUNT(*) FROM homestays WHERE owner_id = ? AND status = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            if (status != null) ps.setString(2, status.name());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in countHomestaysByOwnerAndStatus", e);
        }
        return 0;
    }

    @Override
    public boolean updateHomestay(Homestay hs) {
        // If currently REJECTED, reset to PENDING_APPROVAL on save (re-submit for review)
        String sql =
            "UPDATE homestays SET name=?, description=?, address=?, city=?, district=?, " +
            "checkin_time=?, checkout_time=?, " +
            "status = CASE WHEN status = 'REJECTED' THEN 'PENDING_APPROVAL' ELSE status END, " +
            "updated_at = CURRENT_TIMESTAMP " +
            "WHERE homestay_id = ? AND owner_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hs.getName());
            ps.setString(2, hs.getDescription());
            ps.setString(3, hs.getAddress());
            ps.setString(4, hs.getCity());
            ps.setString(5, hs.getDistrict());
            ps.setTime(6, hs.getCheckinTime());
            ps.setTime(7, hs.getCheckoutTime());
            ps.setInt(8, hs.getHomestayId());
            ps.setInt(9, hs.getOwnerId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in updateHomestay id=" + hs.getHomestayId(), e);
            return false;
        }
    }

    @Override
    public boolean updateHomestayStatus(int homestayId, int ownerId, Homestay.Status newStatus) {
        String sql = "UPDATE homestays SET status=?, updated_at=CURRENT_TIMESTAMP " +
                     "WHERE homestay_id=? AND owner_id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus.name());
            ps.setInt(2, homestayId);
            ps.setInt(3, ownerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in updateHomestayStatus id=" + homestayId, e);
            return false;
        }
    }

    // ── RoomType CRUD ─────────────────────────────────────────────────────────

    @Override
    public int insertHomestay(Homestay hs) {
        String sql = "INSERT INTO homestays (owner_id, name, description, address, city, district, " +
                     "checkin_time, checkout_time, status) " +
                     "VALUES (?,?,?,?,?,?,?,?,'PENDING_APPROVAL')";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, hs.getOwnerId());
            ps.setString(2, hs.getName());
            ps.setString(3, hs.getDescription());
            ps.setString(4, hs.getAddress());
            ps.setString(5, hs.getCity());
            ps.setString(6, hs.getDistrict());
            ps.setTime(7, hs.getCheckinTime() != null ? hs.getCheckinTime() : Time.valueOf("14:00:00"));
            ps.setTime(8, hs.getCheckoutTime() != null ? hs.getCheckoutTime() : Time.valueOf("12:00:00"));
            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) return keys.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in insertHomestay", e);
        }
        return -1;
    }

    @Override
    public int insertRoomType(RoomType rt) {
        String sql = "INSERT INTO room_types (homestay_id, name, description, base_price, " +
                     "max_occupancy, bed_count, room_size_sqm) VALUES (?,?,?,?,?,?,?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, rt.getHomestayId());
            ps.setString(2, rt.getName());
            ps.setString(3, rt.getDescription());
            ps.setBigDecimal(4, rt.getBasePrice());
            ps.setInt(5, rt.getMaxOccupancy());
            ps.setInt(6, rt.getBedCount());
            if (rt.getRoomSizeSqm() != null) ps.setBigDecimal(7, rt.getRoomSizeSqm());
            else ps.setNull(7, java.sql.Types.DECIMAL);
            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) return keys.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in insertRoomType", e);
        }
        return -1;
    }

    @Override
    public boolean updateRoomType(RoomType rt, int ownerId) {
        String sql = "UPDATE room_types rt " +
                     "JOIN homestays h ON rt.homestay_id = h.homestay_id " +
                     "SET rt.name=?, rt.description=?, rt.base_price=?, " +
                     "    rt.max_occupancy=?, rt.bed_count=?, rt.room_size_sqm=?, " +
                     "    rt.updated_at=CURRENT_TIMESTAMP " +
                     "WHERE rt.room_type_id=? AND h.owner_id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, rt.getName());
            ps.setString(2, rt.getDescription());
            ps.setBigDecimal(3, rt.getBasePrice());
            ps.setInt(4, rt.getMaxOccupancy());
            ps.setInt(5, rt.getBedCount());
            if (rt.getRoomSizeSqm() != null) ps.setBigDecimal(6, rt.getRoomSizeSqm());
            else ps.setNull(6, java.sql.Types.DECIMAL);
            ps.setInt(7, rt.getRoomTypeId());
            ps.setInt(8, ownerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in updateRoomType id=" + rt.getRoomTypeId(), e);
            return false;
        }
    }

    @Override
    public boolean deleteRoomType(int roomTypeId, int ownerId) {
        // Block if active bookings exist
        String checkSql = "SELECT COUNT(*) FROM bookings b " +
                          "WHERE b.room_type_id=? " +
                          "AND b.booking_status NOT IN ('CANCELLED','REFUNDED')";
        try (Connection conn = DBContext.getConnection()) {
            try (PreparedStatement chk = conn.prepareStatement(checkSql)) {
                chk.setInt(1, roomTypeId);
                try (ResultSet rs = chk.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) return false; // has active bookings
                }
            }
            String sql = "DELETE rt FROM room_types rt " +
                         "JOIN homestays h ON rt.homestay_id = h.homestay_id " +
                         "WHERE rt.room_type_id=? AND h.owner_id=?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, roomTypeId);
                ps.setInt(2, ownerId);
                return ps.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in deleteRoomType id=" + roomTypeId, e);
            return false;
        }
    }

    @Override
    public List<RoomType> getRoomTypesWithCountByHomestayId(int homestayId, int ownerId) {
        List<RoomType> list = new ArrayList<>();
        String sql = "SELECT rt.room_type_id, rt.homestay_id, rt.name, rt.description, " +
                     "rt.base_price, rt.max_occupancy, rt.bed_count, rt.room_size_sqm, " +
                     "rt.created_at, rt.updated_at, " +
                     "COUNT(r.room_id) AS room_count " +
                     "FROM room_types rt " +
                     "JOIN homestays h ON rt.homestay_id = h.homestay_id " +
                     "LEFT JOIN rooms r ON r.room_type_id = rt.room_type_id " +
                     "WHERE rt.homestay_id=? AND h.owner_id=? " +
                     "GROUP BY rt.room_type_id ORDER BY rt.name ASC";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, homestayId);
            ps.setInt(2, ownerId);
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
                    rt.setCreatedAt(rs.getTimestamp("created_at"));
                    rt.setUpdatedAt(rs.getTimestamp("updated_at"));
                    rt.setRoomCount(rs.getInt("room_count"));
                    list.add(rt);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getRoomTypesWithCountByHomestayId", e);
        }
        return list;
    }

    // ── Homestay Image Management (UC17 — Cloudinary) ─────────────────────────

    @Override
    public int insertHomestayImage(int homestayId, String imageUrl, boolean isPrimary, int displayOrder) {
        String sql = "INSERT INTO homestay_images (homestay_id, image_url, is_primary, display_order) " +
                     "VALUES (?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, homestayId);
            ps.setString(2, imageUrl);
            ps.setBoolean(3, isPrimary);
            ps.setInt(4, displayOrder);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in insertHomestayImage for homestayId=" + homestayId, e);
        }
        return -1;
    }

    @Override
    public boolean deleteHomestayImage(int imageId, int homestayId, int ownerId) {
        // Security: verify the homestay belongs to ownerId via JOIN before deleting
        String sql = "DELETE hi FROM homestay_images hi " +
                     "INNER JOIN homestays h ON hi.homestay_id = h.homestay_id " +
                     "WHERE hi.image_id = ? AND hi.homestay_id = ? AND h.owner_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, imageId);
            ps.setInt(2, homestayId);
            ps.setInt(3, ownerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in deleteHomestayImage id=" + imageId, e);
            return false;
        }
    }

    @Override
    public boolean setPrimaryHomestayImage(int imageId, int homestayId, int ownerId) {
        // Two-step in one transaction: unset all → set the target
        String unsetSql = "UPDATE homestay_images SET is_primary = 0 WHERE homestay_id = ?";
        String setSql   = "UPDATE homestay_images hi " +
                          "INNER JOIN homestays h ON hi.homestay_id = h.homestay_id " +
                          "SET hi.is_primary = 1 " +
                          "WHERE hi.image_id = ? AND hi.homestay_id = ? AND h.owner_id = ?";
        try (Connection conn = DBContext.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps1 = conn.prepareStatement(unsetSql);
                 PreparedStatement ps2 = conn.prepareStatement(setSql)) {
                ps1.setInt(1, homestayId);
                ps1.executeUpdate();
                ps2.setInt(1, imageId);
                ps2.setInt(2, homestayId);
                ps2.setInt(3, ownerId);
                boolean ok = ps2.executeUpdate() > 0;
                conn.commit();
                return ok;
            } catch (SQLException ex) {
                conn.rollback();
                throw ex;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in setPrimaryHomestayImage id=" + imageId, e);
            return false;
        }
    }

    @Override
    public Optional<HomestayImage> getHomestayImageById(int imageId) {
        String sql = "SELECT image_id, homestay_id, image_url, is_primary, display_order, created_at " +
                     "FROM homestay_images WHERE image_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, imageId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    HomestayImage img = new HomestayImage();
                    img.setImageId(rs.getInt("image_id"));
                    img.setHomestayId(rs.getInt("homestay_id"));
                    img.setImageUrl(rs.getString("image_url"));
                    img.setPrimary(rs.getBoolean("is_primary"));
                    img.setDisplayOrder(rs.getInt("display_order"));
                    img.setCreatedAt(rs.getTimestamp("created_at"));
                    return Optional.of(img);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getHomestayImageById id=" + imageId, e);
        }
        return Optional.empty();
    }

    // ── UC23: Admin Approval Operations ──────────────────────────────────────

    @Override
    public List<Homestay> findPendingApprovals() {
        return findAdminHomestays(null, "PENDING_APPROVAL", null, 0, 100);
    }

    @Override
    public List<Homestay> findAdminHomestays(String keyword, String status, String city, int offset, int limit) {
        List<Homestay> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT h.homestay_id, h.owner_id, h.name, h.address, h.city, h.district, " +
            "h.status, h.created_at, h.rejection_reason, " +
            "(SELECT hi.image_url FROM homestay_images hi " +
            " WHERE hi.homestay_id = h.homestay_id " +
            " ORDER BY hi.is_primary DESC, hi.display_order ASC LIMIT 1) AS primary_image, " +
            "u.full_name AS owner_name " +
            "FROM homestays h " +
            "JOIN users u ON u.user_id = h.owner_id " +
            "WHERE 1=1 "
        );
        List<Object> params = buildAdminHomestayFilterParams(sql, keyword, status, city);

        sql.append(" ORDER BY h.created_at DESC LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Homestay h = new Homestay();
                    h.setHomestayId(rs.getInt("homestay_id"));
                    h.setOwnerId(rs.getInt("owner_id"));
                    h.setName(rs.getString("name"));
                    h.setAddress(rs.getString("address"));
                    h.setCity(rs.getString("city"));
                    h.setDistrict(rs.getString("district"));
                    String statusStr = rs.getString("status");
                    if (statusStr != null) {
                        try { h.setStatus(Homestay.Status.valueOf(statusStr)); } catch (IllegalArgumentException ignored) {}
                    }
                    h.setCreatedAt(rs.getTimestamp("created_at"));
                    h.setRejectionReason(rs.getString("rejection_reason"));
                    h.setPrimaryImageUrl(rs.getString("primary_image"));
                    h.setOwnerName(rs.getString("owner_name"));
                    list.add(h);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in findAdminHomestays", e);
        }
        return list;
    }

    @Override
    public int countAdminHomestays(String keyword, String status, String city) {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) " +
            "FROM homestays h " +
            "JOIN users u ON u.user_id = h.owner_id " +
            "WHERE 1=1 "
        );
        List<Object> params = buildAdminHomestayFilterParams(sql, keyword, status, city);

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
            LOGGER.log(Level.SEVERE, "Error in countAdminHomestays", e);
        }
        return 0;
    }

    private List<Object> buildAdminHomestayFilterParams(StringBuilder sql, String keyword, String status, String city) {
        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (LOWER(h.name) LIKE ? OR LOWER(u.full_name) LIKE ? OR LOWER(h.address) LIKE ?) ");
            String kw = "%" + keyword.trim().toLowerCase() + "%";
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }
        if (status != null && !status.trim().isEmpty() && !"ALL".equalsIgnoreCase(status)) {
            sql.append(" AND h.status = ? ");
            params.add(status.trim().toUpperCase());
        }
        if (city != null && !city.trim().isEmpty() && !"ALL".equalsIgnoreCase(city)) {
            sql.append(" AND h.city = ? ");
            params.add(city.trim());
        }
        return params;
    }

    @Override
    public boolean adminUpdateHomestayStatus(int homestayId, Homestay.Status newStatus, String rejectionReason) {
        String sql = "UPDATE homestays SET status = ?, rejection_reason = ?, updated_at = CURRENT_TIMESTAMP " +
                     "WHERE homestay_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus.name());
            ps.setString(2, rejectionReason);
            ps.setInt(3, homestayId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in adminUpdateHomestayStatus id=" + homestayId, e);
            return false;
        }
    }
}
