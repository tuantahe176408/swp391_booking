package com.project.dao;

import com.project.model.StaffInfo;
import java.util.List;

/**
 * Data Access Object Interface: Receptionist Staff Management for Owners (UC21)
 * Package: com.project.dao
 *
 * Operates on the receptionist_staff table joined with users and homestays.
 * Every mutating operation is scoped to the owner's homestays for security.
 */
public interface StaffDAO {

    /**
     * Return all receptionists assigned to any homestay owned by the given owner.
     * Joins receptionist_staff → users → homestays (WHERE homestays.owner_id = ownerId).
     */
    List<StaffInfo> getStaffByOwnerId(int ownerId);

    /**
     * Security guard: return true if the given userId is a receptionist
     * assigned to a homestay that belongs to ownerId.
     */
    boolean isStaffAssignedToOwner(int userId, int ownerId);

    /**
     * Insert a row into receptionist_staff linking userId ↔ homestayId.
     * Uses INSERT … ON DUPLICATE KEY UPDATE so it also handles reassignment.
     * Caller must verify that homestayId belongs to the owner before calling.
     */
    boolean assignToHomestay(int userId, int homestayId);

    // ── Aggregate stats ───────────────────────────────────────────────────

    /** Count receptionists under this owner whose account is active and fully set up. */
    int countActiveByOwnerId(int ownerId);

    /**
     * Count receptionists under this owner whose account is waiting for first login
     * (must_change_password = TRUE — password was auto-generated and not yet changed).
     */
    int countPendingByOwnerId(int ownerId);

    /**
     * Count distinct homestays under this owner that have at least one
     * receptionist assigned.
     */
    int countManagedHomestaysByOwnerId(int ownerId);
}
