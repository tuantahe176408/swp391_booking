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
     */
    List<Homestay> getHomestaysByOwnerId(int ownerId);

    /**
     * UC17: Count homestays by owner, optionally filtered by status.
     * Pass null to count all statuses.
     */
    int countHomestaysByOwnerAndStatus(int ownerId, Homestay.Status status);

    /**
     * UC17: Update basic info of a homestay (name, description, address, city,
     * district, checkin_time, checkout_time).
     * Status is reset to PENDING_APPROVAL if currently REJECTED.
     */
    boolean updateHomestay(Homestay homestay);

    /**
     * UC17: Toggle homestay status between ACTIVE ↔ INACTIVE.
     * Returns false if homestay not owned by given ownerId (security check).
     */
    boolean updateHomestayStatus(int homestayId, int ownerId, Homestay.Status newStatus);

    // ── RoomType CRUD (UC17) ──────────────────────────────────────────────────

    /** Insert a new room type. @return generated room_type_id, or -1 on failure */
    int insertRoomType(RoomType roomType);

    /**
     * UC17: Insert a new homestay. Status defaults to PENDING_APPROVAL.
     * @return generated homestay_id, or -1 on failure
     */
    int insertHomestay(Homestay homestay);

    /** Update room type fields. Ownership verified via homestay JOIN. */
    boolean updateRoomType(RoomType roomType, int ownerId);

    /**
     * Delete a room type + all its physical rooms (CASCADE).
     * Returns false if active bookings exist for this room type.
     */
    boolean deleteRoomType(int roomTypeId, int ownerId);

    /**
     * Load room types for a homestay with physical room count per type.
     * Verifies ownership. Returns empty list if not owned by ownerId.
     */
    List<RoomType> getRoomTypesWithCountByHomestayId(int homestayId, int ownerId);

    // ── Homestay Image Management (UC17 — Cloudinary) ─────────────────────────

    /**
     * Insert a new image record for a homestay.
     * @return generated image_id, or -1 on failure
     */
    int insertHomestayImage(int homestayId, String imageUrl, boolean isPrimary, int displayOrder);

    /**
     * Delete a specific image by imageId.
     * Security: verifies the homestay belongs to ownerId before deleting.
     * @return true if a row was deleted
     */
    boolean deleteHomestayImage(int imageId, int homestayId, int ownerId);

    /**
     * Set one image as primary; clears is_primary on all others for the same homestay.
     * Security: verifies ownership via ownerId.
     * @return true if the target image was updated
     */
    boolean setPrimaryHomestayImage(int imageId, int homestayId, int ownerId);

    /**
     * Get a single HomestayImage by its ID (used for Cloudinary delete before DB delete).
     */
    Optional<HomestayImage> getHomestayImageById(int imageId);

    // ── Admin Approval Operations (UC23) ─────────────────────────────────────

    /**
     * UC23: Return all homestays with status = PENDING_APPROVAL, joined with owner's full_name.
     * Results ordered by created_at ASC (oldest requests first).
     */
    List<Homestay> findPendingApprovals();

    /**
     * UC23: Search & filter homestays for Admin approval with pagination.
     */
    List<Homestay> findAdminHomestays(String keyword, String status, String city, int offset, int limit);

    int countAdminHomestays(String keyword, String status, String city);

    /**
     * UC23: Admin-level status update — no ownerId check.
     * Sets status and optionally stores a rejection reason (pass null when approving).
     * @return true if a row was updated
     */
    boolean adminUpdateHomestayStatus(int homestayId, Homestay.Status newStatus, String rejectionReason);
}
