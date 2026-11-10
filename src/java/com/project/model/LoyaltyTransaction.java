package com.project.model;

import java.sql.Timestamp;

/**
 * Domain Entity: Loyalty Points Transaction (UC-LOYALTY)
 * Package: com.project.model
 */
public class LoyaltyTransaction {

    public enum TransactionType {
        EARN, REDEEM, REFUND, ADJUSTMENT
    }

    private int transactionId;
    private int userId;
    private Integer bookingId;
    /** Positive = earned, Negative = redeemed */
    private int points;
    private TransactionType transactionType;
    private String description;
    private Timestamp createdAt;

    /** Joined field from bookings table (not stored in loyalty_transactions) */
    private String bookingCode;

    public LoyaltyTransaction() {}

    // ── Getters & Setters ─────────────────────────────────────────────────────

    public int getTransactionId() { return transactionId; }
    public void setTransactionId(int transactionId) { this.transactionId = transactionId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public Integer getBookingId() { return bookingId; }
    public void setBookingId(Integer bookingId) { this.bookingId = bookingId; }

    public int getPoints() { return points; }
    public void setPoints(int points) { this.points = points; }

    public TransactionType getTransactionType() { return transactionType; }
    public void setTransactionType(TransactionType transactionType) { this.transactionType = transactionType; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getBookingCode() { return bookingCode; }
    public void setBookingCode(String bookingCode) { this.bookingCode = bookingCode; }
}
