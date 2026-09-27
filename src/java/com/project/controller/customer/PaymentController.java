package com.project.controller.customer;

import com.project.dao.BookingDAO;
import com.project.dao.BookingDAOImpl;
import com.project.model.Booking;
import com.project.model.Payment;
import com.project.model.User;
import com.project.util.PaymentUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Optional;

/**
 * Controller: Thanh toán Cổng VNPay (UC08, UC10)
 * Package: com.project.controller.customer
 */
@WebServlet(name = "PaymentController", urlPatterns = {"/payment/create", "/payment/return"})
public class PaymentController extends HttpServlet {

    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        this.bookingDAO = new BookingDAOImpl();
    }

    /** GET /payment/create — Tạo URL thanh toán VNPay & redirect */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/payment/create".equals(path)) {
            handleCreatePayment(request, response);
        } else if ("/payment/return".equals(path)) {
            handlePaymentReturn(request, response);
        }
    }

    private void handleCreatePayment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String bookingIdParam = request.getParameter("bookingId");
        if (bookingIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/customer/bookings");
            return;
        }

        int bookingId = Integer.parseInt(bookingIdParam);
        Optional<Booking> optBooking = bookingDAO.getBookingById(bookingId);
        if (!optBooking.isPresent() || optBooking.get().getCustomerId() != currentUser.getUserId()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        Booking booking = optBooking.get();

        // Chọn phương thức thanh toán
        String method = request.getParameter("method");
        if (method == null) method = "VNPAY";

        // Hiển thị trang chọn phương thức nếu chưa chọn
        if (request.getParameter("confirm") == null) {
            request.setAttribute("booking", booking);
            request.setAttribute("pageTitle", "Thanh toán - Smart Booking Platform");
            request.getRequestDispatcher("/WEB-INF/views/customer/payment-select.jsp").forward(request, response);
            return;
        }

        // Tạo URL VNPay
        String ipAddr = request.getRemoteAddr();
        String returnUrl = request.getScheme() + "://" + request.getServerName()
                + ":" + request.getServerPort()
                + request.getContextPath() + "/payment/return";

        String paymentUrl = PaymentUtil.createVnPayUrl(booking, ipAddr, returnUrl, method);
        response.sendRedirect(paymentUrl);
    }

    private void handlePaymentReturn(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Xác thực chữ ký HMAC-SHA512 từ VNPay callback
        boolean isValid = PaymentUtil.verifyVnPayReturn(request.getParameterMap());
        String vnpResponseCode = request.getParameter("vnp_ResponseCode");
        String vnpTxnRef = request.getParameter("vnp_TxnRef"); // booking_code

        if (isValid && "00".equals(vnpResponseCode)) {
            // Thanh toán thành công
            if (vnpTxnRef != null) {
                Optional<Booking> optB = bookingDAO.getBookingByCode(vnpTxnRef);
                if (optB.isPresent()) {
                    Booking b = optB.get();
                    bookingDAO.updateBookingStatus(b.getBookingId(), "CONFIRMED");
                    request.setAttribute("booking", b);
                    request.setAttribute("paymentSuccess", true);
                    request.setAttribute("vnpAmount", request.getParameter("vnp_Amount"));
                    request.setAttribute("vnpBankCode", request.getParameter("vnp_BankCode"));
                    request.setAttribute("vnpTransactionNo", request.getParameter("vnp_TransactionNo"));
                }
            }
            request.setAttribute("pageTitle", "Thanh toán thành công - Smart Booking Platform");
        } else {
            // Thanh toán thất bại hoặc bị giả mạo
            request.setAttribute("paymentSuccess", false);
            request.setAttribute("vnpResponseCode", vnpResponseCode);
            request.setAttribute("pageTitle", "Thanh toán thất bại - Smart Booking Platform");
        }

        request.getRequestDispatcher("/WEB-INF/views/customer/payment-result.jsp").forward(request, response);
    }
}
