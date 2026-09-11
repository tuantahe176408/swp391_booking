package com.project.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Time;
import java.sql.Timestamp;

/**
 * Domain Entity: Homestay
 * Package: com.project.model
 */
public class Homestay implements Serializable {

    private static final long serialVersionUID = 1L;

    public enum Status {
        PENDING_APPROVAL, ACTIVE, REJECTED, INACTIVE
    }

    private int homestayId;
    private int ownerId;
    private String name;
    private String description;
    private String address;
    private String city;
    private String district;
    private BigDecimal latitude;
    private BigDecimal longitude;
    private Status status;
    private String rejectionReason;
    private Time checkinTime;
    private Time checkoutTime;
    private BigDecimal ratingAvg;
    private int reviewCount;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Homestay() {
        this.status = Status.PENDING_APPROVAL;
        this.ratingAvg = BigDecimal.ZERO;
        this.reviewCount = 0;
    }

    public int getHomestayId() {
        return homestayId;
    }

    public void setHomestayId(int homestayId) {
        this.homestayId = homestayId;
    }

    public int getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(int ownerId) {
        this.ownerId = ownerId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getDistrict() {
        return district;
    }

    public void setDistrict(String district) {
        this.district = district;
    }

    public BigDecimal getLatitude() {
        return latitude;
    }

    public void setLatitude(BigDecimal latitude) {
        this.latitude = latitude;
    }

    public BigDecimal getLongitude() {
        return longitude;
    }

    public void setLongitude(BigDecimal longitude) {
        this.longitude = longitude;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    public String getRejectionReason() {
        return rejectionReason;
    }

    public void setRejectionReason(String rejectionReason) {
        this.rejectionReason = rejectionReason;
    }

    public Time getCheckinTime() {
        return checkinTime;
    }

    public void setCheckinTime(Time checkinTime) {
        this.checkinTime = checkinTime;
    }

    public Time getCheckoutTime() {
        return checkoutTime;
    }

    public void setCheckoutTime(Time checkoutTime) {
        this.checkoutTime = checkoutTime;
    }

    public BigDecimal getRatingAvg() {
        return ratingAvg;
    }

    public void setRatingAvg(BigDecimal ratingAvg) {
        this.ratingAvg = ratingAvg;
    }

    public int getReviewCount() {
        return reviewCount;
    }

    public void setReviewCount(int reviewCount) {
        this.reviewCount = reviewCount;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
}
