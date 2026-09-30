package com.project.dao;

import com.project.config.DBContext;
import com.project.model.Review;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashSet;
import java.util.Optional;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object Implementation: Review Operations (UC10)
 * Package: com.project.dao
 *
 * All write operations (insert / update) run inside a manual transaction that
 * also recalculates homestays.rating_avg and homestays.review_count atomically.
 */
public class ReviewDAOImpl implements ReviewDAO {

    private static final Logger LOGGER = Logger.getLogger(ReviewDAOImpl.class.getName());

    // ── UC10: Submit new review ────────────────────────────────────────────

    @Override
    public boolean insertReview(Review review) {
        String insertSql =
            "INSERT INTO reviews " +
            "(booking_id, customer_id, homestay_id, " +
            " rating_cleanliness, rating_service, rating_location, rating_value, " +
            " rating_overall, comment) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        String recalcSql =
            "UPDATE homestays " +
            "SET rating_avg   = (SELECT AVG(r.rating_overall) FROM reviews r WHERE r.homestay_id = ?), " +
            "    review_count = (SELECT COUNT(*)               FROM reviews r WHERE r.homestay_id = ?) " +
            "WHERE homestay_id = ?";

        Connection conn = null;
        try {
            conn = DBContext.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, review.getBookingId());
                ps.setInt(2, review.getCustomerId());
                ps.setInt(3, review.getHomestayId());
                ps.setInt(4, review.getRatingCleanliness());
                ps.setInt(5, review.getRatingService());
                ps.setInt(6, review.getRatingLocation());
                ps.setInt(7, review.getRatingValue());
                ps.setBigDecimal(8, review.getRatingOverall());
                ps.setString(9, review.getComment());

                if (ps.executeUpdate() == 0) { conn.rollback(); return false; }

                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) review.setReviewId(keys.getInt(1));
                }
            }

            recalc(conn, recalcSql, review.getHomestayId());
            conn.commit();
            return true;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in insertReview bookingId=" + review.getBookingId(), e);
            rollbackQuietly(conn);
        } finally {
            closeQuietly(conn);
        }
        return false;
    }

    // ── UC10 Edit: Update existing review ─────────────────────────────────

    @Override
    public boolean updateReview(Review review) {
        // customer_id in WHERE clause = security guard: only owner of the review
        String updateSql =
            "UPDATE reviews " +
            "SET rating_cleanliness = ?, rating_service = ?, rating_location = ?, " +
            "    rating_value = ?, rating_overall = ?, comment = ? " +
            "WHERE review_id = ? AND customer_id = ?";

        String recalcSql =
            "UPDATE homestays " +
            "SET rating_avg   = (SELECT AVG(r.rating_overall) FROM reviews r WHERE r.homestay_id = ?), " +
            "    review_count = (SELECT COUNT(*)               FROM reviews r WHERE r.homestay_id = ?) " +
            "WHERE homestay_id = ?";

        Connection conn = null;
        try {
            conn = DBContext.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                ps.setInt(1, review.getRatingCleanliness());
                ps.setInt(2, review.getRatingService());
                ps.setInt(3, review.getRatingLocation());
                ps.setInt(4, review.getRatingValue());
                ps.setBigDecimal(5, review.getRatingOverall());
                ps.setString(6, review.getComment());
                ps.setInt(7, review.getReviewId());
                ps.setInt(8, review.getCustomerId());

                if (ps.executeUpdate() == 0) { conn.rollback(); return false; }
            }

            recalc(conn, recalcSql, review.getHomestayId());
            conn.commit();
            return true;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in updateReview reviewId=" + review.getReviewId(), e);
            rollbackQuietly(conn);
        } finally {
            closeQuietly(conn);
        }
        return false;
    }

    // ── UC10: Duplicate guard ──────────────────────────────────────────────

    @Override
    public boolean hasReviewed(int bookingId) {
        String sql = "SELECT 1 FROM reviews WHERE booking_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in hasReviewed bookingId=" + bookingId, e);
        }
        return false;
    }

    // ── Booking list: which bookings has this customer reviewed? ───────────

    @Override
    public Set<Integer> getReviewedBookingIdsByCustomer(int customerId) {
        Set<Integer> ids = new HashSet<>();
        String sql = "SELECT booking_id FROM reviews WHERE customer_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) ids.add(rs.getInt("booking_id"));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getReviewedBookingIdsByCustomer customerId=" + customerId, e);
        }
        return ids;
    }

    // ── Booking detail: load existing review for display ──────────────────

    @Override
    public Optional<Review> getReviewByBookingId(int bookingId) {
        String sql =
            "SELECT r.review_id, r.booking_id, r.customer_id, r.homestay_id, " +
            "       r.rating_cleanliness, r.rating_service, r.rating_location, r.rating_value, " +
            "       r.rating_overall, r.comment, r.owner_reply, r.owner_replied_at, r.created_at, " +
            "       u.full_name, u.avatar_url " +
            "FROM reviews r " +
            "JOIN users u ON r.customer_id = u.user_id " +
            "WHERE r.booking_id = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(mapReview(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getReviewByBookingId bookingId=" + bookingId, e);
        }
        return Optional.empty();
    }

    // ── Private helpers ────────────────────────────────────────────────────

    /** Re-run the aggregate recalc statement for a given homestayId. */
    private void recalc(Connection conn, String sql, int homestayId) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, homestayId);
            ps.setInt(2, homestayId);
            ps.setInt(3, homestayId);
            ps.executeUpdate();
        }
    }

    private void rollbackQuietly(Connection conn) {
        if (conn != null) try { conn.rollback(); } catch (SQLException ex) { /* ignored */ }
    }

    private void closeQuietly(Connection conn) {
        if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) { /* ignored */ }
    }

    private Review mapReview(ResultSet rs) throws SQLException {
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
        return r;
    }
}
