package com.project.dao;

import com.project.model.Payment;

import java.util.List;
import java.util.Optional;

/**
 * Data Access Object Interface: Payment Operations (UC08, UC09, UC15)
 * Package: com.project.dao
 */
public interface PaymentDAO {

    List<Payment> getPaymentsByBookingId(int bookingId);

    Optional<Payment> getPaymentById(int paymentId);

    boolean insertPayment(Payment payment);

    boolean updatePaymentStatus(int paymentId, String status, String transactionCode);
}
