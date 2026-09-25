package com.project.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Domain Entity: Payment (UC08, UC09, UC15)
 * Package: com.project.model
 */
public class Payment implements Serializable {

    private static final long serialVersionUID = 1L;

    public enum Method {
        VNPAY, MOMO, CASH, POS_CARD
    }

    public enum Status {
        PENDING, SUCCESS, FAILED, REFUNDED
    }

    private int paymentId;
    private int bookingId;
    private String transactionCode;
    private String paymentMethod;
    private String paymentType;
    private BigDecimal amount;
    private String paymentStatus;
    private String gatewayChecksum;
    private String gatewayResponseData;
    private Timestamp paidAt;
    private Timestamp createdAt;

    public Payment() {
        this.amount = BigDecimal.ZERO;
        this.paymentMethod = "VNPAY";
        this.paymentType = "FULL_PAYMENT";
        this.paymentStatus = "PENDING";
    }

    public int getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public String getTransactionCode() {
        return transactionCode;
    }

    public void setTransactionCode(String transactionCode) {
        this.transactionCode = transactionCode;
    }

    // Alias for getTransactionCode()
    public String getTransactionRef() {
        return transactionCode;
    }

    public void setTransactionRef(String transactionRef) {
        this.transactionCode = transactionRef;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getPaymentType() {
        return paymentType;
    }

    public void setPaymentType(String paymentType) {
        this.paymentType = paymentType;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    // Alias for getPaymentStatus()
    public String getStatus() {
        return paymentStatus;
    }

    public void setStatus(String status) {
        this.paymentStatus = status;
    }

    public String getGatewayChecksum() {
        return gatewayChecksum;
    }

    public void setGatewayChecksum(String gatewayChecksum) {
        this.gatewayChecksum = gatewayChecksum;
    }

    public String getGatewayResponseData() {
        return gatewayResponseData;
    }

    public void setGatewayResponseData(String gatewayResponseData) {
        this.gatewayResponseData = gatewayResponseData;
    }

    public Timestamp getPaidAt() {
        return paidAt;
    }

    public void setPaidAt(Timestamp paidAt) {
        this.paidAt = paidAt;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
