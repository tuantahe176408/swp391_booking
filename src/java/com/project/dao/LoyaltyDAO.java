package com.project.dao;

import com.project.model.LoyaltyTransaction;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;

/**
 * DAO Interface: Loyalty Points System (UC-LOYALTY)
 *
 * <h3>Business Rules</h3>
 * <ul>
 *   <li>Earn rate: 1 pt per 10,000 VND (rounded down). Multiplied by tier bonus.</li>
 *   <li>Tier multiplier — BRONZE ×1.0 | SILVER ×1.25 | GOLD ×1.5 | PLATINUM ×2.0</li>
 *   <li>Redeem rate: 1 pt = 100 VND discount.</li>
 *   <li>Min to redeem: 100 pts (= 10,000 VND discount).</li>
 *   <li>Max per booking: 20% of subtotal (before loyalty discount).</li>
 *   <li>Tier thresholds (lifetime earned): BRONZE 0–999 | SILVER 1,000–4,999 | GOLD 5,000–14,999 | PLATINUM 15,000+</li>
 * </ul>
 *
 * Package: com.project.dao
 */
public interface LoyaltyDAO {

    /**
     * Award points when booking becomes CONFIRMED (payment success).
     * Automatically calculates points from finalTotal + current tier.
     *
     * @param userId     customer user ID
     * @param bookingId  confirmed booking ID
     * @param finalTotal paid amount in VND (BigDecimal)
     * @param tier       current tier of the user (BRONZE, SILVER, GOLD, PLATINUM)
     * @return true if points were awarded successfully
     */
    boolean earnPoints(int userId, int bookingId, BigDecimal finalTotal, String tier);

    /**
     * Redeem points at checkout to get a discount.
     * Deducts from balance immediately (booking still PENDING).
     *
     * @param userId    customer user ID
     * @param bookingId booking ID (may be null if called before booking creation)
     * @param points    number of points to redeem (must be >= 100)
     * @param description human-readable reason
     * @return true if redeemed successfully
     */
    boolean redeemPoints(int userId, Integer bookingId, int points, String description);

    /**
     * Refund redeemed points when a booking is cancelled (by customer or auto-expiry).
     * Looks up REDEEM transactions for this booking and creates matching REFUND transactions.
     *
     * @param bookingId the cancelled booking's ID
     * @return number of points refunded (0 if none were redeemed for this booking)
     */
    int refundRedeemedPoints(int bookingId);

    /**
     * Get user's current spendable points balance.
     */
    int getBalance(int userId);

    /**
     * Get user's total lifetime earned points (used for tier calculation).
     */
    int getTotalEarned(int userId);

    /**
     * Get user's current tier string.
     */
    String getTier(int userId);

    /**
     * Get paginated transaction history for a user.
     */
    List<LoyaltyTransaction> getHistory(int userId, int offset, int limit);

    /**
     * Count total transactions for a user.
     */
    int countHistory(int userId);

    // ── Static Utility Methods ────────────────────────────────────────────────

    /**
     * Calculate points earned for a given payment amount and tier.
     * Base: 1 pt per 10,000 VND, with tier multiplier applied.
     */
    static int calculateEarnPoints(BigDecimal amount, String tier) {
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) return 0;
        double multiplier;
        switch (tier != null ? tier.toUpperCase() : "BRONZE") {
            case "SILVER":   multiplier = 1.25; break;
            case "GOLD":     multiplier = 1.50; break;
            case "PLATINUM": multiplier = 2.00; break;
            default:         multiplier = 1.00; break;
        }
        int base = amount.divide(BigDecimal.valueOf(10_000), 0, RoundingMode.DOWN).intValue();
        return (int) Math.floor(base * multiplier);
    }

    /** Convert points to VND discount (1 pt = 100 VND). */
    static BigDecimal pointsToDiscount(int points) {
        return BigDecimal.valueOf((long) points * 100);
    }

    /**
     * Maximum points a customer can redeem for a given order total (20% cap).
     * Also capped by user's current balance.
     */
    static int maxRedeemablePoints(BigDecimal subtotal, int balance) {
        if (subtotal == null || subtotal.compareTo(BigDecimal.ZERO) <= 0) return 0;
        // 20% of subtotal, expressed in points (1 pt = 100 VND)
        int capFromOrder = subtotal.multiply(BigDecimal.valueOf(0.20))
                                   .divide(BigDecimal.valueOf(100), 0, RoundingMode.DOWN)
                                   .intValue();
        return Math.min(balance, capFromOrder);
    }

    /** Determine the tier string from total lifetime earned points. */
    static String computeTier(int totalEarned) {
        if (totalEarned >= 15_000) return "PLATINUM";
        if (totalEarned >= 5_000)  return "GOLD";
        if (totalEarned >= 1_000)  return "SILVER";
        return "BRONZE";
    }

    /** Points threshold for the NEXT tier (or -1 if already PLATINUM). */
    static int nextTierThreshold(String tier) {
        switch (tier != null ? tier.toUpperCase() : "BRONZE") {
            case "BRONZE":  return 1_000;
            case "SILVER":  return 5_000;
            case "GOLD":    return 15_000;
            default:        return -1;    // already PLATINUM
        }
    }
}
