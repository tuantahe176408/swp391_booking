package com.project.dao;

import java.util.List;
import java.util.Map;

/**
 * Data Access Object Interface: Owner Revenue & Occupancy Analytics (UC20)
 * Package: com.project.dao
 *
 * Tất cả query đều được lọc theo owner_id thông qua homestays.owner_id.
 * "Successful" bookings = CONFIRMED + CHECKED_IN + CHECKED_OUT.
 *
 * Date parameters are ISO strings "yyyy-MM-dd"; null means no bound.
 * homestayId = null or 0 means all homestays of this owner.
 */
public interface OwnerAnalyticsDAO {

    // ── KPI Metrics ───────────────────────────────────────────────────────

    /**
     * SUM(final_total) for successful bookings of owner within the period.
     * @param ownerId     owner's user_id
     * @param homestayId  specific homestay filter; null = all homestays of owner
     * @param fromDate    start date (yyyy-MM-dd), null = no lower bound
     * @param toDate      end date (yyyy-MM-dd), null = today
     */
    long getTotalRevenue(int ownerId, Integer homestayId, String fromDate, String toDate);

    /**
     * COUNT successful bookings. Same filters as getTotalRevenue.
     */
    int countSuccessfulBookings(int ownerId, Integer homestayId, String fromDate, String toDate);

    /**
     * COUNT cancelled bookings. Same filters as getTotalRevenue.
     */
    int countCancelledBookings(int ownerId, Integer homestayId, String fromDate, String toDate);

    /**
     * COUNT new bookings in the period (all non-PENDING statuses).
     * Same filters as getTotalRevenue.
     */
    int countNewBookings(int ownerId, Integer homestayId, String fromDate, String toDate);

    /**
     * COUNT reviews received in the period for this owner's homestays.
     * Same filters as getTotalRevenue.
     */
    int countNewReviews(int ownerId, Integer homestayId, String fromDate, String toDate);

    /**
     * Returns number of checked-in bookings in the period.
     */
    int countCheckedIn(int ownerId, Integer homestayId, String fromDate, String toDate);

    /**
     * Returns number of checked-out bookings in the period.
     */
    int countCheckedOut(int ownerId, Integer homestayId, String fromDate, String toDate);

    /**
     * Average nightly rate = SUM(final_total) / SUM(total_nights).
     * Returns 0 if no data.
     */
    long getAverageDailyRate(int ownerId, Integer homestayId, String fromDate, String toDate);

    /**
     * Occupancy rate = (SUM(total_nights of successful bookings in period) /
     *                   (COUNT(rooms) × days_in_period)) × 100.
     * Returns 0.0 if no rooms or period is 0 days.
     */
    double getOccupancyRate(int ownerId, Integer homestayId, String fromDate, String toDate);

    // ── Chart Data ────────────────────────────────────────────────────────

    /**
     * Revenue time-series chart data.
     * Each element is Object[3]: { String label, Long revenue, Integer bookingCount }
     *
     * @param groupBy  "DAY" | "MONTH"
     */
    List<Object[]> getRevenueChartData(int ownerId, Integer homestayId,
                                        String fromDate, String toDate, String groupBy);

    /**
     * Booking count per status (donut chart).
     * Each element is Object[2]: { String status, Integer count }
     */
    List<Object[]> getBookingStatusBreakdown(int ownerId, Integer homestayId,
                                              String fromDate, String toDate);

    /**
     * Top homestays by revenue (for owner that owns multiple homestays).
     * Each element is Object[3]: { String homestayName, Long revenue, Integer bookingCount }
     */
    List<Object[]> getTopHomestaysByRevenue(int ownerId, String fromDate, String toDate, int limit);

    // ── Recent Bookings Table ─────────────────────────────────────────────

    /**
     * Recent bookings for the owner (dashboard table).
     * Each element is Object[8]:
     *   { String guestName, String homestayName, String checkinDate,
     *     String checkoutDate, Long finalTotal, String bookingStatus,
     *     Double ratingOverall, String bookingCode }
     *
     * @param limit  number of rows to return (e.g. 10)
     */
    List<Object[]> getRecentBookings(int ownerId, Integer homestayId, int limit);

    // ── Owner Homestay List ───────────────────────────────────────────────

    /**
     * Returns all active homestays owned by this user.
     * Each element is Object[2]: { Integer homestayId, String name }
     */
    List<Object[]> getOwnerHomestays(int ownerId);
}
