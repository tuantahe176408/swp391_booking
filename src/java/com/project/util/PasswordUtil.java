package com.project.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Technical Helper: BCrypt Password Hashing & Verification
 * Package: com.project.util
 */
public class PasswordUtil {

    private static final int BCRYPT_WORK_FACTOR = 12;

    public static String hashPassword(String plainPassword) {
        if (plainPassword == null || plainPassword.trim().isEmpty()) {
            throw new IllegalArgumentException("Password cannot be null or empty.");
        }
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(BCRYPT_WORK_FACTOR));
    }

    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null || hashedPassword.trim().isEmpty()) {
            return false;
        }
        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (Exception e) {
            return false;
        }
    }

    private static final String CHAR_LOWER = "abcdefghijklmnopqrstuvwxyz";
    private static final String CHAR_UPPER = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    private static final String NUMBER = "0123456789";
    private static final String SPECIAL = "@#$!%*";
    private static final String PASSWORD_ALLOW = CHAR_LOWER + CHAR_UPPER + NUMBER + SPECIAL;
    private static final java.security.SecureRandom RANDOM = new java.security.SecureRandom();

    /**
     * Generate a secure random alphanumeric password
     *
     * @param length minimum length 8
     * @return generated random password string
     */
    public static String generateRandomPassword(int length) {
        if (length < 8) {
            length = 8;
        }
        StringBuilder sb = new StringBuilder(length);
        sb.append(CHAR_LOWER.charAt(RANDOM.nextInt(CHAR_LOWER.length())));
        sb.append(CHAR_UPPER.charAt(RANDOM.nextInt(CHAR_UPPER.length())));
        sb.append(NUMBER.charAt(RANDOM.nextInt(NUMBER.length())));
        sb.append(SPECIAL.charAt(RANDOM.nextInt(SPECIAL.length())));

        for (int i = 4; i < length; i++) {
            sb.append(PASSWORD_ALLOW.charAt(RANDOM.nextInt(PASSWORD_ALLOW.length())));
        }

        char[] chars = sb.toString().toCharArray();
        for (int i = chars.length - 1; i > 0; i--) {
            int j = RANDOM.nextInt(i + 1);
            char temp = chars[i];
            chars[i] = chars[j];
            chars[j] = temp;
        }
        return new String(chars);
    }
}
