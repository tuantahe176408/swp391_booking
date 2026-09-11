package com.project.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Domain Entity: User
 * Package: com.project.model
 */
public class User implements Serializable {

    private static final long serialVersionUID = 1L;

    public enum Role {
        CUSTOMER, RECEPTIONIST, OWNER, ADMIN
    }

    public enum AuthProvider {
        LOCAL, GOOGLE
    }

    private int userId;
    private String email;
    private String passwordHash;
    private String fullName;
    private String phoneNumber;
    private String avatarUrl;
    private Role role;
    private AuthProvider authProvider;
    private String googleId;
    private boolean active;
    private boolean emailVerified;
    private int failedLoginAttempts;
    private Timestamp lockoutUntil;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public User() {
        this.role = Role.CUSTOMER;
        this.authProvider = AuthProvider.LOCAL;
        this.active = true;
        this.emailVerified = false;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public AuthProvider getAuthProvider() {
        return authProvider;
    }

    public void setAuthProvider(AuthProvider authProvider) {
        this.authProvider = authProvider;
    }

    public String getGoogleId() {
        return googleId;
    }

    public void setGoogleId(String googleId) {
        this.googleId = googleId;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public boolean isEmailVerified() {
        return emailVerified;
    }

    public void setEmailVerified(boolean emailVerified) {
        this.emailVerified = emailVerified;
    }

    public int getFailedLoginAttempts() {
        return failedLoginAttempts;
    }

    public void setFailedLoginAttempts(int failedLoginAttempts) {
        this.failedLoginAttempts = failedLoginAttempts;
    }

    public Timestamp getLockoutUntil() {
        return lockoutUntil;
    }

    public void setLockoutUntil(Timestamp lockoutUntil) {
        this.lockoutUntil = lockoutUntil;
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
