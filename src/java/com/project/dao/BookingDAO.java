package com.project.dao;

import com.project.model.Booking;

import java.util.List;
import java.util.Optional;

/**
 * Data Access Object Interface: Booking Operations (UC07, UC09, UC12, UC13)
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
}
