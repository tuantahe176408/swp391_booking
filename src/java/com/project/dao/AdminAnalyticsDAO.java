package com.project.dao;

import java.util.List;

/**
 * Data Access Object Interface: Platform Analytics & Financials (UC25)
 * Package: com.project.dao
 *
 * All revenue metrics are derived from the bookings table (final_total).
 * "Successful" bookings = CONFIRMED + CHECKED_IN + CHECKED_OUT.
 *
 * Date parameters are ISO strings "yyyy-MM-dd"; null means no bound.
 */
public interface AdminAnalyticsDAO {

    // ── KPI Metrics ───────────────────────────────────────────────────────

    /** SUM(final_total) for successful bookings between fromDate and toDate. */
    long getTotalGmv(String fromDate, String toDate);

    /** COUNT of successful bookings in the period. */
    int countSuccessfulBookings(String fromDate, String toDate);

    /** COUNT of CANCELLED bookings in the period. */
    int countCancelledBookings(String fromDate, String toDate);

    /** COUNT of all non-PENDING bookings in the period. */
    int countTotalBookings(String fromDate, String toDate);

    // ── Platform Totals (all-time, no date filter) ────────────────────────

    int countActiveHomestays();
    int countOwners();
    int countCustomers();

    // ── Chart Data ────────────────────────────────────────────────────────

    /**
     * Returns time-series data for the main revenue chart.
     * Each element is Object[3]: { String label, Long gmv, Integer bookingCount }
     *
     * @param fromDate   start date (yyyy-MM-dd), null = no lower bound
     * @param toDate     end date (yyyy-MM-dd), null = today
     * @param groupBy    "DAY" | "MONTH" — controls SQL DATE_FORMAT and label format
     */
    List<Object[]> getChartData(String fromDate, String toDate, String groupBy);

    /**
     * Returns booking count per status for the donut chart.
     * Each element is Object[2]: { String status, Integer count }
     */
    List<Object[]> getBookingStatusBreakdown(String fromDate, String toDate);

    /**
     * Returns payment count per method (SUCCESS only) for the donut chart.
     * Each element is Object[2]: { String method, Integer count }
     */
    List<Object[]> getPaymentMethodBreakdown(String fromDate, String toDate);

    /**
     * Returns top N homestays by revenue (CHECKED_OUT bookings).
     * Each element is Object[3]: { String homestayName, Long revenue, Integer bookingCount }
     */
    List<Object[]> getTopHomestaysByRevenue(String fromDate, String toDate, int limit);

    /**
     * Returns new customer registrations grouped by month (always monthly, last 6 months).
     * Each element is Object[2]: { String monthLabel e.g. "2026-10", Integer count }
     */
    List<Object[]> getNewUsersPerMonth(String fromDate, String toDate);
}
