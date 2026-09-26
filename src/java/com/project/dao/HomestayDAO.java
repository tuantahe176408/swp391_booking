package com.project.dao;

import com.project.model.Amenity;
import com.project.model.Homestay;
import com.project.model.HomestayImage;
import com.project.model.Review;
import com.project.model.RoomType;

import java.util.List;
import java.util.Optional;

/**
 * Data Access Object Interface: Homestay & Search Operations
 * Package: com.project.dao
 */
public interface HomestayDAO {

    List<Homestay> searchHomestays(String location, String checkin, String checkout, Integer guests,
                                  Double minPrice, Double maxPrice, List<Integer> amenityIds, String sortBy,
                                  int offset, int limit);

    int countSearchResults(String location, String checkin, String checkout, Integer guests,
                           Double minPrice, Double maxPrice, List<Integer> amenityIds);

    List<Homestay> getFeaturedHomestays(int limit);

    Optional<Homestay> getHomestayById(int homestayId);

    List<HomestayImage> getHomestayImages(int homestayId);

    List<RoomType> getRoomTypesByHomestayId(int homestayId);

    List<Amenity> getHomestayAmenities(int homestayId);

    List<Amenity> getAllAmenities();

    List<String> getAllCities();

    List<Review> getReviewsByHomestayId(int homestayId);

    List<Homestay> getRecommendedHomestays(int userId, int limit);

    /**
     * UC17/UC20: Return all homestays owned by a given user.
     * Used by owner controllers to populate filters and dashboards.
     *
     * @param ownerId the owner's user ID
     * @return list of Homestay entities (all statuses) ordered by name ASC
     */
    List<Homestay> getHomestaysByOwnerId(int ownerId);
}
