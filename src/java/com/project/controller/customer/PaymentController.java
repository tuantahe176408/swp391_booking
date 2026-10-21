package com.project.controller.customer;

import com.project.dao.BookingDAO;
import com.project.dao.BookingDAOImpl;
import com.project.dao.PaymentDAO;
import com.project.dao.PaymentDAOImpl;
import com.project.model.Booking;
import com.project.model.Payment;
import com.project.model.User;
import com.project.util.EmailUtil;
import com.project.util.PaymentUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Controller: Thanh toán Cổng VNPay / MoMo (UC08, UC10)
 * GET /payment/create?bookingId=X          — trang chọn phương thức
 * GET /payment/create?bookingId=X&confirm=1&method=VNPAY — redirect sang cổng VNPay
 * GET /payment/create?bookingId=X&confirm=1&method=MOMO  — redirect sang cổng MoMo
 * GET /payment/return                      — callback từ VNPay
 * GET /payment/momo-return                 — callback từ MoMo (redirect)
 * Package: com.project.controller.customer
 */
@WebServlet(name = "PaymentController", urlPatterns = {"/payment/create", "/payment/return", "/payment/momo-return"})
public class PaymentController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(PaymentController.class.getName());

    private BookingDAO bookingDAO;
    private PaymentDAO paymentDAO;

    @Override
    public void init() throws ServletException {
        this.bookingDAO = new BookingDAOImpl();
        this.paymentDAO = new PaymentDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/payment/create".equals(path)) {
            handleCreatePayment(request, response);
        } else if ("/payment/momo-return".equals(path)) {
            handleMoMoReturn(request, response);
        } else {
            handlePaymentReturn(request, response);
        }
    }

    // ── Step 1: Show payment-select page OR redirect to gateway ──────────────

    private void handleCreatePayment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String bookingIdParam = request.getParameter("bookingId");
        if (bookingIdParam == null || bookingIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/customer/bookings");
            return;
        }

        int bookingId;
        try { bookingId = Integer.parseInt(bookingIdParam.trim()); }
        catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/customer/bookings");
            return;
        }

        Optional<Booking> optBooking = bookingDAO.getBookingById(bookingId);
        if (optBooking.isEmpty() || optBooking.get().getCustomerId() != currentUser.getUserId()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        Booking booking = optBooking.get();

        // Already paid?
        if ("CONFIRMED".equals(booking.getBookingStatus())
                || "CHECKED_IN".equals(booking.getBookingStatus())
                || "CHECKED_OUT".equals(booking.getBookingStatus())) {
            response.sendRedirect(request.getContextPath() + "/customer/bookings");
            return;
        }

        // ── If confirm=1 → create payment record + redirect to gateway ────────
        if ("1".equals(request.getParameter("confirm"))) {
            String method = request.getParameter("method");
            if (method == null || method.trim().isEmpty()) method = "VNPAY";

            // Insert PENDING payment record before redirecting
            Payment payment = new Payment();
            payment.setBookingId(bookingId);
            payment.setTransactionCode("");
            payment.setPaymentMethod(method.toUpperCase());
            payment.setPaymentType("FULL_PAYMENT");
            payment.setAmount(booking.getFinalTotal());
            payment.setPaymentStatus("PENDING");
            payment.setGatewayChecksum("");
            paymentDAO.insertPayment(payment);

            // Store paymentId in session for callback lookup
            session.setAttribute("pendingPaymentId_" + booking.getBookingCode(), payment.getPaymentId());

            String baseUrl = request.getScheme() + "://" + request.getServerName()
                    + ":" + request.getServerPort()
                    + request.getContextPath();

            // ── MoMo ────────────────────────────────────────────────────────
            if ("MOMO".equalsIgnoreCase(method)) {
                String momoReturnUrl  = baseUrl + "/payment/momo-return";
                String momoNotifyUrl  = momoReturnUrl; // same endpoint for sandbox

                if (PaymentUtil.hasMoMoCredentials()) {
                    String payUrl = PaymentUtil.createMoMoUrl(booking, momoReturnUrl, momoNotifyUrl);
                    if (payUrl != null) {
                        LOGGER.info("Redirecting to MoMo: " + booking.getBookingCode());
                        response.sendRedirect(payUrl);
                    } else {
                        LOGGER.warning("MoMo payUrl null — falling back to mock page");
                        request.setAttribute("booking",   booking);
                        request.setAttribute("method",    method);
                        request.setAttribute("returnUrl", momoReturnUrl);
                        request.setAttribute("pageTitle", "Thanh toán MoMo (Demo)");
                        request.getRequestDispatcher("/WEB-INF/views/customer/payment-mock-momo.jsp")
                               .forward(request, response);
                    }
                } else {
                    // No credentials → mock page
                    request.setAttribute("booking",   booking);
                    request.setAttribute("method",    method);
                    request.setAttribute("returnUrl", momoReturnUrl);
                    request.setAttribute("pageTitle", "Thanh toán MoMo (Demo)");
                    request.getRequestDispatcher("/WEB-INF/views/customer/payment-mock-momo.jsp")
                           .forward(request, response);
                }
                return;
            }

            // ── VNPay ────────────────────────────────────────────────────────
            String returnUrl = baseUrl + "/payment/return";
            LOGGER.info("ReturnUrl being sent to VNPay: " + returnUrl);

            boolean hasRealCredentials = PaymentUtil.hasRealCredentials();

            if (hasRealCredentials) {
                String bankCode   = request.getParameter("bankCode");
                String paymentUrl = PaymentUtil.createVnPayUrl(booking, getClientIp(request), returnUrl, bankCode);
                LOGGER.info("Redirecting to VNPay: " + booking.getBookingCode());
                response.sendRedirect(paymentUrl);
            } else {
                LOGGER.info("Using mock payment (no real credentials) for: " + booking.getBookingCode());
                request.setAttribute("booking",    booking);
                request.setAttribute("method",     method);
                request.setAttribute("returnUrl",  returnUrl);
                request.setAttribute("pageTitle",  "Thanh toán (Demo) - Smart Booking Platform");
                request.getRequestDispatcher("/WEB-INF/views/customer/payment-mock.jsp")
                       .forward(request, response);
            }
            return;
        }

        // ── Show payment-select page ──────────────────────────────────────────
        request.setAttribute("booking",   booking);
        request.setAttribute("pageTitle", "Thanh toán - Smart Booking Platform");
        request.getRequestDispatcher("/WEB-INF/views/customer/payment-select.jsp")
               .forward(request, response);
    }

    // ── Step 3: Handle MoMo return callback ──────────────────────────────────

    private void handleMoMoReturn(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String resultCode = request.getParameter("resultCode");
        String orderId    = request.getParameter("orderId");    // bookingCode_ts
        String transId    = request.getParameter("transId");    // MoMo transaction ID
        String amount     = request.getParameter("amount");
        String message    = request.getParameter("message");

        // Demo bypass: resultCode=0 với signature=DEMO_BYPASS
        boolean isDemoMode = "DEMO_BYPASS".equals(request.getParameter("signature"));
        boolean isValid = isDemoMode || PaymentUtil.verifyMoMoReturn(request.getParameterMap());

        LOGGER.info("MoMo callback — orderId=" + orderId + " resultCode=" + resultCode + " isValid=" + isValid);

        String bookingCode = PaymentUtil.extractBookingCodeFromMoMoOrderId(orderId);

        if (isValid && "0".equals(resultCode) && bookingCode != null) {
            // ── Thanh toán thành công ─────────────────────────────────────
            Optional<Booking> optB = bookingDAO.getBookingByCode(bookingCode);
            if (optB.isPresent()) {
                Booking b = optB.get();

                bookingDAO.updateBookingStatus(b.getBookingId(), "CONFIRMED");
                updatePendingPaymentMoMo(request, b, transId, "SUCCESS", amount);
                EmailUtil.sendBookingConfirmation(b);

                request.setAttribute("booking",        b);
                request.setAttribute("paymentSuccess", true);
                request.setAttribute("momoTransId",    transId);
                request.setAttribute("momoMessage",    message);
            } else {
                LOGGER.warning("MoMo callback — booking not found for code: " + bookingCode);
                request.setAttribute("paymentSuccess", false);
                request.setAttribute("momoMessage", "Không tìm thấy đơn đặt phòng.");
            }
            request.setAttribute("pageTitle", "Thanh toán MoMo thành công");

        } else {
            // ── Thanh toán thất bại / hủy ────────────────────────────────
            if (bookingCode != null) {
                Optional<Booking> optB = bookingDAO.getBookingByCode(bookingCode);
                optB.ifPresent(b -> updatePendingPaymentMoMo(request, b, transId, "FAILED", amount));
            }
            request.setAttribute("paymentSuccess",   false);
            request.setAttribute("momoResultCode",   resultCode);
            request.setAttribute("momoMessage",      message);
            request.setAttribute("pageTitle", "Thanh toán MoMo thất bại");

            LOGGER.warning("MoMo payment failed — orderId=" + orderId + " code=" + resultCode + " msg=" + message);
        }

        request.getRequestDispatcher("/WEB-INF/views/customer/payment-result.jsp")
               .forward(request, response);
    }

    /** Update pending payment record after MoMo callback. */
    private void updatePendingPaymentMoMo(HttpServletRequest request, Booking booking,
                                           String transId, String newStatus, String amountStr) {
        try {
            HttpSession session = request.getSession(false);
            Integer paymentId  = (session != null)
                    ? (Integer) session.getAttribute("pendingPaymentId_" + booking.getBookingCode())
                    : null;

            if (paymentId != null && paymentId > 0) {
                paymentDAO.updatePaymentStatus(paymentId, newStatus,
                        transId != null ? transId : "");
                session.removeAttribute("pendingPaymentId_" + booking.getBookingCode());
            } else {
                BigDecimal amt = booking.getFinalTotal();
                if (amountStr != null) {
                    try { amt = new BigDecimal(amountStr); } catch (NumberFormatException ignored) {}
                }
                Payment p = new Payment();
                p.setBookingId(booking.getBookingId());
                p.setTransactionCode(transId != null ? transId : "");
                p.setPaymentMethod("MOMO");
                p.setPaymentType("FULL_PAYMENT");
                p.setAmount(amt);
                p.setPaymentStatus(newStatus);
                p.setGatewayChecksum("");
                if ("SUCCESS".equals(newStatus)) {
                    p.setPaidAt(new java.sql.Timestamp(System.currentTimeMillis()));
                }
                paymentDAO.insertPayment(p);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating MoMo payment for booking " + booking.getBookingCode(), e);
        }
    }

    // ── Step 2: Handle VNPay return callback ─────────────────────────────────

    private void handlePaymentReturn(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── Demo mode bypass (no real VNPay credentials) ─────────────────────
        boolean isDemoMode = "1".equals(request.getParameter("demo"))
                             || "DEMO_BYPASS".equals(request.getParameter("vnp_SecureHash"));
        boolean isValid = isDemoMode || PaymentUtil.verifyVnPayReturn(request.getParameterMap());
        String  vnpResponseCode = request.getParameter("vnp_ResponseCode");
        String  vnpTxnRef      = request.getParameter("vnp_TxnRef");         // booking_code
        String  vnpTransactionNo = request.getParameter("vnp_TransactionNo"); // VNPay's transaction ID
        String  vnpBankCode    = request.getParameter("vnp_BankCode");
        String  vnpAmount      = request.getParameter("vnp_Amount");          // amount × 100
        String  vnpSecureHash  = request.getParameter("vnp_SecureHash");

        LOGGER.info("VNPay callback — txnRef=" + vnpTxnRef
                + " responseCode=" + vnpResponseCode
                + " isValid=" + isValid);

        if (isValid && "00".equals(vnpResponseCode) && vnpTxnRef != null) {
            // ── Payment SUCCESS ───────────────────────────────────────────────
            Optional<Booking> optB = bookingDAO.getBookingByCode(vnpTxnRef);
            if (optB.isPresent()) {
                Booking b = optB.get();

                // 1. Update booking status → CONFIRMED
                bookingDAO.updateBookingStatus(b.getBookingId(), "CONFIRMED");

                // 2. Update payment record → SUCCESS + store transaction code
                updatePendingPayment(request, b, vnpTransactionNo, vnpSecureHash, "SUCCESS", vnpAmount);

                // 3. Gửi email xác nhận đặt phòng kèm QR code
                EmailUtil.sendBookingConfirmation(b);

                request.setAttribute("booking",          b);
                request.setAttribute("paymentSuccess",   true);
                request.setAttribute("vnpBankCode",      vnpBankCode);
                request.setAttribute("vnpTransactionNo", vnpTransactionNo);
            } else {
                LOGGER.warning("VNPay callback — booking not found for code: " + vnpTxnRef);
                request.setAttribute("paymentSuccess", false);
                request.setAttribute("vnpResponseCode", "99");
            }
            request.setAttribute("pageTitle", "Thanh toán thành công - Smart Booking Platform");

        } else {
            // ── Payment FAILED / CANCELLED / TAMPERED ────────────────────────
            if (vnpTxnRef != null) {
                Optional<Booking> optB = bookingDAO.getBookingByCode(vnpTxnRef);
                if (optB.isPresent()) {
                    updatePendingPayment(request, optB.get(), vnpTransactionNo, vnpSecureHash, "FAILED", vnpAmount);
                }
            }
            request.setAttribute("paymentSuccess",  false);
            request.setAttribute("vnpResponseCode", vnpResponseCode);
            request.setAttribute("pageTitle", "Thanh toán thất bại - Smart Booking Platform");

            LOGGER.warning("VNPay payment failed — txnRef=" + vnpTxnRef
                    + " code=" + vnpResponseCode
                    + " isValid=" + isValid);
        }

        request.getRequestDispatcher("/WEB-INF/views/customer/payment-result.jsp")
               .forward(request, response);
    }

    // ── Helper: find pending payment record and update it ────────────────────

    private void updatePendingPayment(HttpServletRequest request,
                                       Booking booking,
                                       String transactionNo,
                                       String secureHash,
                                       String newStatus,
                                       String vnpAmountStr) {
        try {
            // Retrieve paymentId stored in session before redirect
            HttpSession session = request.getSession(false);
            Integer paymentId = (session != null)
                    ? (Integer) session.getAttribute("pendingPaymentId_" + booking.getBookingCode())
                    : null;

            if (paymentId != null && paymentId > 0) {
                paymentDAO.updatePaymentStatus(paymentId,
                        newStatus,
                        transactionNo != null ? transactionNo : "");
                // Clean up session key
                session.removeAttribute("pendingPaymentId_" + booking.getBookingCode());
            } else {
                // Fallback: insert new record if session was lost (e.g., different node)
                BigDecimal amount = booking.getFinalTotal();
                if (vnpAmountStr != null) {
                    try { amount = new BigDecimal(vnpAmountStr).divide(new BigDecimal("100")); }
                    catch (NumberFormatException ignored) {}
                }
                Payment p = new Payment();
                p.setBookingId(booking.getBookingId());
                p.setTransactionCode(transactionNo != null ? transactionNo : "");
                p.setPaymentMethod("VNPAY");
                p.setPaymentType("FULL_PAYMENT");
                p.setAmount(amount);
                p.setPaymentStatus(newStatus);
                p.setGatewayChecksum(secureHash != null ? secureHash : "");
                if ("SUCCESS".equals(newStatus)) {
                    p.setPaidAt(new Timestamp(System.currentTimeMillis()));
                }
                paymentDAO.insertPayment(p);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating payment record for booking "
                    + booking.getBookingCode(), e);
        }
    }

    // ── Helper: get real client IP (behind proxy) ────────────────────────────

    private String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip != null && !ip.isEmpty() && !"unknown".equalsIgnoreCase(ip)) {
            return ip.split(",")[0].trim();
        }
        ip = request.getHeader("X-Real-IP");
        return (ip != null && !ip.isEmpty()) ? ip : request.getRemoteAddr();
    }
}
