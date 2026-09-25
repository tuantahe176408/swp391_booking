package com.project.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Domain Entity: RoomType
 * Package: com.project.model
 */
public class RoomType implements Serializable {

    private static final long serialVersionUID = 1L;

    private int roomTypeId;
    private int homestayId;
    private String name;
    private String description;
    private BigDecimal basePrice;
    private int maxOccupancy;
    private int bedCount;
    private BigDecimal roomSizeSqm;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public RoomType() {
        this.basePrice = BigDecimal.ZERO;
        this.maxOccupancy = 2;
        this.bedCount = 1;
    }

    public RoomType(int roomTypeId, int homestayId, String name, String description, BigDecimal basePrice, int maxOccupancy, int bedCount, BigDecimal roomSizeSqm) {
        this.roomTypeId = roomTypeId;
        this.homestayId = homestayId;
        this.name = name;
        this.description = description;
        this.basePrice = basePrice;
        this.maxOccupancy = maxOccupancy;
        this.bedCount = bedCount;
        this.roomSizeSqm = roomSizeSqm;
    }

    public int getRoomTypeId() {
        return roomTypeId;
    }

    public void setRoomTypeId(int roomTypeId) {
        this.roomTypeId = roomTypeId;
    }

    public int getHomestayId() {
        return homestayId;
    }

    public void setHomestayId(int homestayId) {
        this.homestayId = homestayId;
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

    public BigDecimal getBasePrice() {
        return basePrice;
    }

    public void setBasePrice(BigDecimal basePrice) {
        this.basePrice = basePrice;
    }

    public int getMaxOccupancy() {
        return maxOccupancy;
    }

    public void setMaxOccupancy(int maxOccupancy) {
        this.maxOccupancy = maxOccupancy;
    }

    public int getBedCount() {
        return bedCount;
    }

    public void setBedCount(int bedCount) {
        this.bedCount = bedCount;
    }

    public BigDecimal getRoomSizeSqm() {
        return roomSizeSqm;
    }

    public void setRoomSizeSqm(BigDecimal roomSizeSqm) {
        this.roomSizeSqm = roomSizeSqm;
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
