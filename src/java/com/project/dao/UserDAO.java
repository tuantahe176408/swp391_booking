package com.project.dao;

import com.project.model.User;
import java.util.List;
import java.util.Optional;

/**
 * Data Access Object Interface: User Operations
 * Package: com.project.dao
 */
public interface UserDAO {

    Optional<User> findById(int userId);

    Optional<User> findByEmail(String email);

    Optional<User> findByGoogleId(String googleId);

    boolean insertUser(User user);

    boolean linkGoogleAccount(int userId, String googleId, String avatarUrl);

    boolean updateUser(User user);

    boolean updatePassword(int userId, String newPasswordHash);

    boolean updateLockStatus(int userId, boolean isActive);

    List<User> findAll(int offset, int limit);

    int countAll();
}
