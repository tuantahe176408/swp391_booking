package com.project.dao;

import com.project.model.Review;

import java.util.Optional;
import java.util.Set;

/**
 * Data Access Object Interface: Review Operations (UC10)
 * Package: com.project.dao
 */
public interface ReviewDAO {

    /**
     * UC10: Insert a new review and atomically update the homestay's rating_avg
     * and review_count aggregate columns.
     *
     * @param review fully populated Review object (bookingId, customerId, homestayId,
     *               4 dimension ratings, ratingOverall, comment already set)
     * @return true if the insert + update both succeeded
     */
    boolean insertReview(Review review);

    /**
     * UC10: Check whether a review already exists for a given booking.
     * Used to enforce the one-review-per-booking constraint at application level
     * (the DB also has a UNIQUE constraint on booking_id).
     *
     * @param bookingId the booking to check
     * @return true if a review row already exists for this booking
     */
    boolean hasReviewed(int bookingId);

    /**
     * UC10 / Booking List: Return the set of booking IDs that the customer has
     * already reviewed.  Used by the booking list page to conditionally show
     * the "Viết đánh giá" button only for un-reviewed CHECKED_OUT bookings.
     *
     * @param customerId the logged-in customer's user_id
     * @return set of bookingId values that have a corresponding review row
     */
    Set<Integer> getReviewedBookingIdsByCustomer(int customerId);

    /**
     * UC10: Retrieve the review linked to a specific booking (for displaying
     * submitted review on the booking-detail page).
     *
     * @param bookingId the booking whose review is requested
     * @return Optional containing the Review, or empty if not yet reviewed
     */
    Optional<Review> getReviewByBookingId(int bookingId);

    /**
     * UC10 Edit: Update an existing review and atomically recalculate the
     * homestay's rating_avg aggregate.  Only the owner of the review
     * (matched by both reviewId AND customerId) may update it.
     *
     * @param review Review with reviewId, customerId, homestayId, all rating
     *               fields and comment already set to the new values
     * @return true if exactly one row was updated
     */
    boolean updateReview(Review review);
}
