package com.project.service;

import com.project.dao.BookingDAO;
import com.project.dao.BookingDAOImpl;
import com.project.dao.LoyaltyDAO;
import com.project.dao.LoyaltyDAOImpl;

import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Scheduled Job: Auto-cancel PENDING bookings whose hold_expires_at has passed.
 *
 * <p>Implements {@link Runnable} — scheduled by {@link com.project.config.AppStartupListener}
 * via {@code ScheduledExecutorService.scheduleAtFixedRate()} every minute.
 *
 * <p>Before cancelling, refunds any loyalty points that were redeemed for the
 * expired bookings.
 *
 * Package: com.project.service
 */
public class BookingExpiryJob implements Runnable {

    private static final Logger LOGGER = Logger.getLogger(BookingExpiryJob.class.getName());

    private final BookingDAO bookingDAO;
    private final LoyaltyDAO loyaltyDAO;

    public BookingExpiryJob() {
        this.bookingDAO = new BookingDAOImpl();
        this.loyaltyDAO = new LoyaltyDAOImpl();
    }

    @Override
    public void run() {
        try {
            // 1. Find bookings about to be cancelled so we can refund their loyalty pts
            List<Integer> expiredIds = bookingDAO.getExpiredPendingBookingIds();
            for (int bookingId : expiredIds) {
                try {
                    loyaltyDAO.refundRedeemedPoints(bookingId);
                } catch (Exception e) {
                    LOGGER.log(Level.WARNING, "[BookingExpiryJob] Loyalty refund error for booking " + bookingId, e);
                }
            }

            // 2. Bulk cancel all expired PENDING bookings
            int cancelled = bookingDAO.cancelExpiredPendingBookings();
            if (cancelled > 0) {
                LOGGER.info("[BookingExpiryJob] Auto-cancelled " + cancelled
                        + " expired PENDING booking(s). Loyalty refunded for " + expiredIds.size() + " booking(s).");
            }
        } catch (Exception e) {
            // Catch-all: scheduler suppresses uncaught exceptions and stops firing — must not throw
            LOGGER.log(Level.SEVERE, "[BookingExpiryJob] Unexpected error during expiry sweep.", e);
        }
    }
}
