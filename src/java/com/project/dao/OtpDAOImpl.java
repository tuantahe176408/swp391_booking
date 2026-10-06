package com.project.dao;

import com.project.config.DBContext;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * DAO: user_otps table operations
 * Package: com.project.dao
 */
public class OtpDAOImpl {

    private static final Logger LOGGER = Logger.getLogger(OtpDAOImpl.class.getName());
    private static final int OTP_VALID_MINUTES = 10;

    /** Tạo OTP mới (6 số), xóa OTP cũ chưa dùng cùng purpose. */
    public String createOtp(int userId, String purpose) {
        String code = String.format("%06d", (int)(Math.random() * 1_000_000));
        String deleteOld = "DELETE FROM user_otps WHERE user_id=? AND purpose=? AND is_used=FALSE";
        String insert    = "INSERT INTO user_otps (user_id, otp_code, purpose, expires_at) VALUES (?,?,?,?)";
        try (Connection conn = DBContext.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(deleteOld)) {
                ps.setInt(1, userId); ps.setString(2, purpose); ps.executeUpdate();
            }
            try (PreparedStatement ps = conn.prepareStatement(insert)) {
                ps.setInt(1, userId);
                ps.setString(2, code);
                ps.setString(3, purpose);
                ps.setTimestamp(4, Timestamp.valueOf(
                        LocalDateTime.now().plusMinutes(OTP_VALID_MINUTES)));
                ps.executeUpdate();
            }
            return code;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating OTP for userId=" + userId, e);
            return null;
        }
    }

    /**
     * Xác thực OTP — trả về true nếu hợp lệ và chưa hết hạn.
     * Tự đánh dấu is_used=TRUE khi hợp lệ.
     */
    public boolean verifyOtp(int userId, String code, String purpose) {
        String sql = "SELECT otp_id FROM user_otps " +
                     "WHERE user_id=? AND otp_code=? AND purpose=? " +
                     "AND is_used=FALSE AND expires_at > NOW() LIMIT 1";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId); ps.setString(2, code); ps.setString(3, purpose);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int otpId = rs.getInt("otp_id");
                    markUsed(conn, otpId);
                    return true;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error verifying OTP userId=" + userId, e);
        }
        return false;
    }

    private void markUsed(Connection conn, int otpId) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(
                "UPDATE user_otps SET is_used=TRUE WHERE otp_id=?")) {
            ps.setInt(1, otpId); ps.executeUpdate();
        }
    }
}
