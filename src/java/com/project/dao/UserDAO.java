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

    boolean insertUser(User user);

    boolean updateUser(User user);

    boolean updatePassword(int userId, String newPasswordHash);

    boolean updateLockStatus(int userId, boolean isActive);

    List<User> findAll(int offset, int limit);

    int countAll();
}
