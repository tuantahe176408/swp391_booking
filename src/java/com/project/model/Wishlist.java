package com.project.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Domain Entity: Wishlist
 * Package: com.project.model
 */
public class Wishlist implements Serializable {

    private static final long serialVersionUID = 1L;

    private int wishlistId;
    private int userId;
    private int homestayId;
    private Timestamp createdAt;

    // Transient attribute for rendering
    private Homestay homestay;

    public Wishlist() {
    }

    public Wishlist(int userId, int homestayId) {
        this.userId = userId;
        this.homestayId = homestayId;
    }

    public int getWishlistId() {
        return wishlistId;
    }

    public void setWishlistId(int wishlistId) {
        this.wishlistId = wishlistId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getHomestayId() {
        return homestayId;
    }

    public void setHomestayId(int homestayId) {
        this.homestayId = homestayId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Homestay getHomestay() {
        return homestay;
    }

    public void setHomestay(Homestay homestay) {
        this.homestay = homestay;
    }
}
