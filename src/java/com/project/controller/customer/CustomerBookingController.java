package com.project.controller.customer;

import com.project.dao.BookingDAO;
import com.project.dao.BookingDAOImpl;
import com.project.dao.PaymentDAO;
import com.project.dao.PaymentDAOImpl;
import com.project.dao.ReviewDAO;
import com.project.dao.ReviewDAOImpl;
import com.project.model.Booking;
import com.project.model.Payment;
import com.project.model.Review;
import com.project.model.User;
import com.project.util.EmailUtil;
import com.project.util.JSoupUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Optional;
import java.util.Set;

/**
 * Controller: Manage Customer Bookings & E-Tickets (UC09)
 * Package: com.project.controller.customer
 */
@WebServlet(name = "CustomerBookingController", urlPatterns = {"/customer/bookings", "/customer/booking-detail", "/customer/cancel-booking"})
public class CustomerBookingController extends HttpServlet {

    private BookingDAO bookingDAO;
    private PaymentDAO paymentDAO;
    private ReviewDAO reviewDAO;

    @Override
    public void init() throws ServletException {
        this.bookingDAO = new BookingDAOImpl();
        this.paymentDAO = new PaymentDAOImpl();
        this.reviewDAO  = new ReviewDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=" +
                    java.net.URLEncoder.encode("Vui lòng đăng nhập để xem đơn đặt phòng", "UTF-8"));
            return;
        }

        String path = request.getServletPath();

        if ("/customer/booking-detail".equals(path)) {
            handleBookingDetail(request, response, currentUser);
        } else {
            handleBookingList(request, response, currentUser);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();
        if ("/customer/cancel-booking".equals(path)) {
            handleCancelBooking(request, response, currentUser);
        } else {
            response.sendRedirect(request.getContextPath() + "/customer/bookings");
        }
    }

    private void handleBookingList(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {

        List<Booking> bookingList = bookingDAO.getBookingsByCustomerId(currentUser.getUserId());

        // UC10: Pass set of already-reviewed booking IDs so the JSP can
        // conditionally show the "Viết đánh giá" button only for un-reviewed
        // CHECKED_OUT bookings.
        Set<Integer> reviewedBookingIds = reviewDAO.getReviewedBookingIdsByCustomer(currentUser.getUserId());

        request.setAttribute("bookingList", bookingList);
        request.setAttribute("reviewedBookingIds", reviewedBookingIds);
        request.setAttribute("activeTab", "bookings");
        request.setAttribute("pageTitle", "Đơn đặt phòng của tôi - Smart Booking Platform");
        request.getRequestDispatcher("/WEB-INF/views/customer/booking-list.jsp").forward(request, response);
    }

    private void handleBookingDetail(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/customer/bookings");
            return;
        }

        try {
            int bookingId = Integer.parseInt(idStr);
            Optional<Booking> bookingOpt = bookingDAO.getBookingById(bookingId);

            if (!bookingOpt.isPresent()) {
                response.sendRedirect(request.getContextPath() + "/customer/bookings");
                return;
            }

            Booking booking = bookingOpt.get();
            // Ownership validation: only allow customer who made booking or admin
            if (booking.getCustomerId() == null ||
               (booking.getCustomerId() != currentUser.getUserId() && currentUser.getRole() != User.Role.ADMIN)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập đơn đặt phòng này.");
                return;
            }

            List<Payment> payments = paymentDAO.getPaymentsByBookingId(bookingId);

            // UC10: Load existing review for this booking (if any) for display
            Optional<Review> reviewOpt = reviewDAO.getReviewByBookingId(bookingId);
            reviewOpt.ifPresent(r -> request.setAttribute("review", r));

            request.setAttribute("booking", booking);
            request.setAttribute("payments", payments);
            request.setAttribute("pageTitle", "Chi tiết đơn đặt #" + booking.getBookingCode());

            request.getRequestDispatcher("/WEB-INF/views/customer/booking-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/customer/bookings");
        }
    }

    private void handleCancelBooking(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws IOException {

        String bookingIdStr = request.getParameter("bookingId");
        String reason = JSoupUtil.sanitizeText(request.getParameter("reason"));

        if (bookingIdStr != null && !bookingIdStr.trim().isEmpty()) {
            try {
                int bookingId = Integer.parseInt(bookingIdStr);
                Optional<Booking> bookingOpt = bookingDAO.getBookingById(bookingId);

                if (bookingOpt.isPresent()) {
                    Booking booking = bookingOpt.get();
                    if (booking.getCustomerId() != null && booking.getCustomerId() == currentUser.getUserId()) {
                        if (bookingDAO.isEligibleForCancellation(bookingId)) {
                            bookingDAO.cancelBooking(bookingId, reason.isEmpty() ? "Khách hàng hủy trên hệ thống" : reason);
                            EmailUtil.sendCancellationEmail(booking);
                            request.getSession().setAttribute("sessionSuccessMessage", "Đã hủy đơn đặt phòng #" + booking.getBookingCode() + " thành công!");
                        } else {
                            request.getSession().setAttribute("sessionErrorMessage", "Không thể hủy đơn đặt phòng này do đã quá hạn hoặc trạng thái không cho phép.");
                        }
                    }
                }
            } catch (NumberFormatException ignored) {}
        }

        response.sendRedirect(request.getContextPath() + "/customer/bookings");
    }
}
