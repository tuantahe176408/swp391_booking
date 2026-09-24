package com.project.dao;

import com.project.model.Homestay;

import java.util.List;

/**
 * Data Access Object Interface: Wishlist Operations
 * Package: com.project.dao
 */
public interface WishlistDAO {

    boolean addToWishlist(int userId, int homestayId);

    boolean removeFromWishlist(int userId, int homestayId);

    boolean isWishlisted(int userId, int homestayId);

    List<Homestay> getWishlistByUserId(int userId);
}
