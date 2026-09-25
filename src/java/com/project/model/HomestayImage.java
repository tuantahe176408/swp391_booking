package com.project.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Domain Entity: HomestayImage
 * Package: com.project.model
 */
public class HomestayImage implements Serializable {

    private static final long serialVersionUID = 1L;

    private int imageId;
    private int homestayId;
    private String imageUrl;
    private boolean primary;
    private int displayOrder;
    private Timestamp createdAt;

    public HomestayImage() {
    }

    public HomestayImage(int imageId, int homestayId, String imageUrl, boolean primary, int displayOrder, Timestamp createdAt) {
        this.imageId = imageId;
        this.homestayId = homestayId;
        this.imageUrl = imageUrl;
        this.primary = primary;
        this.displayOrder = displayOrder;
        this.createdAt = createdAt;
    }

    public int getImageId() {
        return imageId;
    }

    public void setImageId(int imageId) {
        this.imageId = imageId;
    }

    public int getHomestayId() {
        return homestayId;
    }

    public void setHomestayId(int homestayId) {
        this.homestayId = homestayId;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public boolean isPrimary() {
        return primary;
    }

    public void setPrimary(boolean primary) {
        this.primary = primary;
    }

    public int getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(int displayOrder) {
        this.displayOrder = displayOrder;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
