package com.project.dao;

/**
 * Data Access Object Interface: Reception Staff Assignment Queries
 * Package: com.project.dao
 *
 * Supports UC12–UC15 (Check-in, Room Matrix, Housekeeping, Walk-in).
 * A receptionist is assigned to exactly one homestay via the receptionist_staff table.
 */
public interface ReceptionDAO {

    /**
     * Return the homestay_id assigned to the given receptionist user.
     * Returns null if the user has no assignment in receptionist_staff.
     */
    Integer getAssignedHomestayId(int userId);

    /**
     * Return the name of the homestay assigned to the given receptionist user.
     * Returns null if the user has no assignment or the homestay no longer exists.
     */
    String getAssignedHomestayName(int userId);
}
