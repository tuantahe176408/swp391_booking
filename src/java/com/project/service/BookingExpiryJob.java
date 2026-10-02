package com.project.service;

import com.project.dao.BookingDAO;
import com.project.dao.BookingDAOImpl;

import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Scheduled Job: Auto-cancel PENDING bookings whose hold_expires_at has passed.
 *
 * <p>Implements {@link Runnable} — scheduled by {@link com.project.config.AppStartupListener}
 * via {@code ScheduledExecutorService.scheduleAtFixedRate()} every minute.
 *
 * <p>Delegates to {@link BookingDAO#cancelExpiredPendingBookings()} which performs a single
 * {@code UPDATE} statement:
 * {@code booking_status='PENDING' AND hold_expires_at < NOW()  →  CANCELLED}.
 *
 * Package: com.project.service
 */
public class BookingExpiryJob implements Runnable {

    private static final Logger LOGGER = Logger.getLogger(BookingExpiryJob.class.getName());

    private final BookingDAO bookingDAO;

    public BookingExpiryJob() {
        this.bookingDAO = new BookingDAOImpl();
    }

    @Override
    public void run() {
        try {
            int cancelled = bookingDAO.cancelExpiredPendingBookings();
            if (cancelled > 0) {
                LOGGER.info("[BookingExpiryJob] Auto-cancelled " + cancelled
                        + " expired PENDING booking(s).");
            }
        } catch (Exception e) {
            // Catch-all: scheduler suppresses uncaught exceptions and stops firing — must not throw
            LOGGER.log(Level.SEVERE, "[BookingExpiryJob] Unexpected error during expiry sweep.", e);
        }
    }
}
