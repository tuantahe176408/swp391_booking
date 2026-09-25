package com.project.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Domain Entity: Review (UC10)
 * Package: com.project.model
 */
public class Review implements Serializable {

    private static final long serialVersionUID = 1L;

    private int reviewId;
    private int bookingId;
    private int customerId;
    private int homestayId;
    private int ratingCleanliness;
    private int ratingService;
    private int ratingLocation;
    private int ratingValue;
    private BigDecimal ratingOverall;
    private String comment;
    private String ownerReply;
    private Timestamp ownerRepliedAt;
    private Timestamp createdAt;

    // Transient attributes for UI presentation
    private String customerName;
    private String customerAvatarUrl;

    public Review() {
        this.ratingCleanliness = 5;
        this.ratingService = 5;
        this.ratingLocation = 5;
        this.ratingValue = 5;
        this.ratingOverall = new BigDecimal("5.0");
    }

    public int getReviewId() {
        return reviewId;
    }

    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public int getHomestayId() {
        return homestayId;
    }

    public void setHomestayId(int homestayId) {
        this.homestayId = homestayId;
    }

    public int getRatingCleanliness() {
        return ratingCleanliness;
    }

    public void setRatingCleanliness(int ratingCleanliness) {
        this.ratingCleanliness = ratingCleanliness;
    }

    public int getRatingService() {
        return ratingService;
    }

    public void setRatingService(int ratingService) {
        this.ratingService = ratingService;
    }

    public int getRatingLocation() {
        return ratingLocation;
    }

    public void setRatingLocation(int ratingLocation) {
        this.ratingLocation = ratingLocation;
    }

    public int getRatingValue() {
        return ratingValue;
    }

    public void setRatingValue(int ratingValue) {
        this.ratingValue = ratingValue;
    }

    public BigDecimal getRatingOverall() {
        return ratingOverall;
    }

    public void setRatingOverall(BigDecimal ratingOverall) {
        this.ratingOverall = ratingOverall;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public String getOwnerReply() {
        return ownerReply;
    }

    public void setOwnerReply(String ownerReply) {
        this.ownerReply = ownerReply;
    }

    public Timestamp getOwnerRepliedAt() {
        return ownerRepliedAt;
    }

    public void setOwnerRepliedAt(Timestamp ownerRepliedAt) {
        this.ownerRepliedAt = ownerRepliedAt;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerAvatarUrl() {
        return customerAvatarUrl;
    }

    public void setCustomerAvatarUrl(String customerAvatarUrl) {
        this.customerAvatarUrl = customerAvatarUrl;
    }
}
