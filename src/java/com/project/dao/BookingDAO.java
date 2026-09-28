package com.project.dao;

import com.project.model.Booking;

import java.util.List;
import java.util.Optional;

/**
 * Data Access Object Interface: Booking Operations (UC07, UC09, UC12, UC13, UC20)
 * Package: com.project.dao
 */
public interface BookingDAO {

    List<Booking> getBookingsByCustomerId(int customerId);

    Optional<Booking> getBookingById(int bookingId);

    Optional<Booking> getBookingByCode(String bookingCode);

    boolean isEligibleForCancellation(int bookingId);

    boolean cancelBooking(int bookingId, String reason);

    boolean insertBooking(Booking booking);

    boolean updateBookingStatus(int bookingId, String status);

    /**
     * UC20/UC17: Query bookings belonging to a specific owner with optional filters.
     *
     * @param ownerId   owner's user ID (matched via homestays.owner_id)
     * @param homestayId filter by specific homestay; 0 or null = all homestays of owner
     * @param status    booking_status filter; null = all statuses
     * @param fromDate  checkin_date >= fromDate; null = no lower bound (format: yyyy-MM-dd)
     * @param toDate    checkin_date <= toDate;   null = no upper bound (format: yyyy-MM-dd)
     * @param offset    pagination offset (0-based)
     * @param limit     max rows per page
     * @return list of bookings ordered by created_at DESC
     */
    List<Booking> getBookingsByOwner(int ownerId, Integer homestayId, String status,
                                     String fromDate, String toDate,
                                     int offset, int limit);

    /**
     * UC20: Count total matching bookings for pagination.
     * Same filter parameters as {@link #getBookingsByOwner}.
     */
    int countBookingsByOwner(int ownerId, Integer homestayId, String status,
                              String fromDate, String toDate);
}
