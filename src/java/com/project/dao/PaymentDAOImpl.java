package com.project.dao;

import com.project.config.DBContext;
import com.project.model.Payment;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object Implementation: Payment Operations
 * Package: com.project.dao
 */
public class PaymentDAOImpl implements PaymentDAO {

    private static final Logger LOGGER = Logger.getLogger(PaymentDAOImpl.class.getName());

    @Override
    public List<Payment> getPaymentsByBookingId(int bookingId) {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT payment_id, booking_id, transaction_code, payment_method, " +
                     "payment_type, amount, payment_status, gateway_checksum, " +
                     "gateway_response_data, paid_at, created_at " +
                     "FROM payments WHERE booking_id = ? ORDER BY created_at DESC";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapPayment(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getPaymentsByBookingId for bookingId: " + bookingId, e);
        }
        return list;
    }

    @Override
    public Optional<Payment> getPaymentById(int paymentId) {
        String sql = "SELECT payment_id, booking_id, transaction_code, payment_method, " +
                     "payment_type, amount, payment_status, gateway_checksum, " +
                     "gateway_response_data, paid_at, created_at " +
                     "FROM payments WHERE payment_id = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, paymentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapPayment(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getPaymentById for paymentId: " + paymentId, e);
        }
        return Optional.empty();
    }

    @Override
    public boolean insertPayment(Payment payment) {
        String sql = "INSERT INTO payments (booking_id, transaction_code, payment_method, " +
                     "payment_type, amount, payment_status, gateway_checksum, gateway_response_data, paid_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, payment.getBookingId());
            ps.setString(2, payment.getTransactionCode());
            ps.setString(3, payment.getPaymentMethod());
            ps.setString(4, payment.getPaymentType());
            ps.setBigDecimal(5, payment.getAmount());
            ps.setString(6, payment.getPaymentStatus());
            ps.setString(7, payment.getGatewayChecksum());
            ps.setString(8, payment.getGatewayResponseData());
            ps.setTimestamp(9, payment.getPaidAt());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        payment.setPaymentId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error inserting payment", e);
        }
        return false;
    }

    @Override
    public boolean updatePaymentStatus(int paymentId, String status, String transactionCode) {
        String sql = "UPDATE payments SET payment_status = ?, transaction_code = ?, paid_at = CURRENT_TIMESTAMP WHERE payment_id = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setString(2, transactionCode);
            ps.setInt(3, paymentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating payment status for paymentId: " + paymentId, e);
        }
        return false;
    }

    private Payment mapPayment(ResultSet rs) throws SQLException {
        Payment p = new Payment();
        p.setPaymentId(rs.getInt("payment_id"));
        p.setBookingId(rs.getInt("booking_id"));
        p.setTransactionCode(rs.getString("transaction_code"));
        p.setPaymentMethod(rs.getString("payment_method"));
        p.setPaymentType(rs.getString("payment_type"));
        p.setAmount(rs.getBigDecimal("amount"));
        p.setPaymentStatus(rs.getString("payment_status"));
        p.setGatewayChecksum(rs.getString("gateway_checksum"));
        p.setGatewayResponseData(rs.getString("gateway_response_data"));
        p.setPaidAt(rs.getTimestamp("paid_at"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        return p;
    }
}
