package com.project.controller.customer;

import com.project.dao.BookingDAO;
import com.project.dao.BookingDAOImpl;
import com.project.dao.ReviewDAO;
import com.project.dao.ReviewDAOImpl;
import com.project.model.Booking;
import com.project.model.Review;
import com.project.model.User;
import com.project.util.JSoupUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Optional;

/**
 * Controller: Review Submission & Edit (UC10)
 * Package: com.project.controller.customer
 *
 * GET  /customer/review?bookingId=X
 *   → No review yet : show blank form (create mode, reviewId=0)
 *   → Review exists : pre-fill form with existing values (edit mode, reviewId>0)
 *
 * POST /customer/review
 *   → reviewId == 0 : insertReview()
 *   → reviewId  > 0 : updateReview()  (ownership re-verified server-side)
 */
@WebServlet(name = "ReviewController", urlPatterns = {"/customer/review"})
public class ReviewController extends HttpServlet {

    private BookingDAO bookingDAO;
    private ReviewDAO  reviewDAO;

    @Override
    public void init() throws ServletException {
        this.bookingDAO = new BookingDAOImpl();
        this.reviewDAO  = new ReviewDAOImpl();
    }

    // ── GET: Show create / edit form ──────────────────────────────────────

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = getSessionUser(request);
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect="
                    + java.net.URLEncoder.encode(
                            request.getRequestURI() + "?" + request.getQueryString(), "UTF-8"));
            return;
        }

        Booking booking = resolveBooking(request, response, currentUser);
        if (booking == null) return;   // error/redirect already handled

        // Try to load an existing review for this booking
        Optional<Review> existing = reviewDAO.getReviewByBookingId(booking.getBookingId());

        if (existing.isPresent()) {
            // ── Edit mode: pre-populate form with saved values ────────────
            Review rev = existing.get();
            request.setAttribute("reviewId",          rev.getReviewId());
            request.setAttribute("ratingCleanliness", rev.getRatingCleanliness());
            request.setAttribute("ratingService",     rev.getRatingService());
            request.setAttribute("ratingLocation",    rev.getRatingLocation());
            request.setAttribute("ratingValue",       rev.getRatingValue());
            request.setAttribute("comment",           rev.getComment());
            request.setAttribute("editMode",          true);
            request.setAttribute("pageTitle",         "Sửa đánh giá - " + booking.getHomestayName());
        } else {
            // ── Create mode ───────────────────────────────────────────────
            request.setAttribute("reviewId",  0);
            request.setAttribute("editMode",  false);
            request.setAttribute("pageTitle", "Viết đánh giá - " + booking.getHomestayName());
        }

        request.setAttribute("booking", booking);
        request.getRequestDispatcher("/WEB-INF/views/customer/review-form.jsp")
               .forward(request, response);
    }

    // ── POST: Insert or update ────────────────────────────────────────────

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = getSessionUser(request);
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Booking booking = resolveBooking(request, response, currentUser);
        if (booking == null) return;

        // reviewId == 0 → insert;  reviewId > 0 → update
        int reviewId = parseId(request.getParameter("reviewId"), 0);

        // Parse & validate dimension ratings (1–5)
        int ratingCleanliness = parseRating(request.getParameter("ratingCleanliness"), 5);
        int ratingService     = parseRating(request.getParameter("ratingService"),     5);
        int ratingLocation    = parseRating(request.getParameter("ratingLocation"),    5);
        int ratingValue       = parseRating(request.getParameter("ratingValue"),       5);

        // Sanitize comment — plain text only (JSoup strips all tags)
        String comment = JSoupUtil.sanitizeText(request.getParameter("comment"));

        if (comment.length() < 10) {
            // Re-show form with inline error, preserve entered values
            request.setAttribute("booking",           booking);
            request.setAttribute("reviewId",          reviewId);
            request.setAttribute("errorMessage",      "Nội dung đánh giá phải có ít nhất 10 ký tự.");
            request.setAttribute("ratingCleanliness", ratingCleanliness);
            request.setAttribute("ratingService",     ratingService);
            request.setAttribute("ratingLocation",    ratingLocation);
            request.setAttribute("ratingValue",       ratingValue);
            request.setAttribute("comment",           comment);
            request.setAttribute("editMode",          reviewId > 0);
            request.setAttribute("pageTitle",
                    (reviewId > 0 ? "Sửa" : "Viết") + " đánh giá - " + booking.getHomestayName());
            request.getRequestDispatcher("/WEB-INF/views/customer/review-form.jsp")
                   .forward(request, response);
            return;
        }

        BigDecimal ratingOverall = BigDecimal.valueOf(
                (ratingCleanliness + ratingService + ratingLocation + ratingValue) / 4.0
        ).setScale(2, RoundingMode.HALF_UP);

        Review review = new Review();
        review.setCustomerId(currentUser.getUserId());
        review.setHomestayId(booking.getHomestayId());
        review.setRatingCleanliness(ratingCleanliness);
        review.setRatingService(ratingService);
        review.setRatingLocation(ratingLocation);
        review.setRatingValue(ratingValue);
        review.setRatingOverall(ratingOverall);
        review.setComment(comment);

        boolean saved;
        if (reviewId > 0) {
            // ── Update existing review ────────────────────────────────────
            review.setReviewId(reviewId);
            saved = reviewDAO.updateReview(review);
            if (saved) {
                request.getSession().setAttribute("sessionSuccessMessage",
                        "Đánh giá của bạn cho " + booking.getHomestayName() + " đã được cập nhật! ✏️");
            } else {
                request.getSession().setAttribute("sessionErrorMessage",
                        "Không thể cập nhật đánh giá. Vui lòng thử lại.");
            }
        } else {
            // ── Insert new review ─────────────────────────────────────────
            // Guard: prevent double-submit via back-button / replay
            if (reviewDAO.hasReviewed(booking.getBookingId())) {
                request.getSession().setAttribute("sessionErrorMessage",
                        "Đơn đặt phòng #" + booking.getBookingCode() + " đã có đánh giá rồi.");
                response.sendRedirect(request.getContextPath() + "/customer/bookings");
                return;
            }
            review.setBookingId(booking.getBookingId());
            saved = reviewDAO.insertReview(review);
            if (saved) {
                request.getSession().setAttribute("sessionSuccessMessage",
                        "Cảm ơn bạn đã gửi đánh giá cho " + booking.getHomestayName() + "! 🌟");
            } else {
                request.getSession().setAttribute("sessionErrorMessage",
                        "Có lỗi xảy ra khi lưu đánh giá. Vui lòng thử lại.");
            }
        }

        // Redirect to booking-detail so the user sees their review immediately
        response.sendRedirect(request.getContextPath()
                + "/customer/booking-detail?id=" + booking.getBookingId());
    }

    // ── Shared: resolve + validate booking ───────────────────────────────

    /**
     * Parses bookingId from request, loads the Booking, and validates:
     *   - booking exists
     *   - current user is the owner
     *   - booking status is CHECKED_OUT
     *
     * Returns the Booking on success, or null if it already sent an
     * error/redirect response.
     */
    private Booking resolveBooking(HttpServletRequest request,
                                   HttpServletResponse response,
                                   User currentUser) throws IOException, ServletException {
        String idStr = request.getParameter("bookingId");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/customer/bookings");
            return null;
        }

        int bookingId;
        try {
            bookingId = Integer.parseInt(idStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/customer/bookings");
            return null;
        }

        Optional<Booking> opt = bookingDAO.getBookingById(bookingId);
        if (!opt.isPresent()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Đơn đặt phòng không tồn tại.");
            return null;
        }

        Booking booking = opt.get();

        if (booking.getCustomerId() == null || booking.getCustomerId() != currentUser.getUserId()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Bạn không có quyền thực hiện thao tác này.");
            return null;
        }

        if (!"CHECKED_OUT".equals(booking.getBookingStatus())) {
            request.getSession().setAttribute("sessionErrorMessage",
                    "Chỉ có thể đánh giá sau khi đã hoàn thành lưu trú.");
            response.sendRedirect(request.getContextPath() + "/customer/bookings");
            return null;
        }

        return booking;
    }

    // ── Helpers ───────────────────────────────────────────────────────────

    private User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (session != null) ? (User) session.getAttribute("currentUser") : null;
    }

    private int parseRating(String param, int defaultValue) {
        if (param == null || param.trim().isEmpty()) return defaultValue;
        try {
            int v = Integer.parseInt(param.trim());
            return (v >= 1 && v <= 5) ? v : defaultValue;
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private int parseId(String param, int defaultValue) {
        if (param == null || param.trim().isEmpty()) return defaultValue;
        try { return Integer.parseInt(param.trim()); }
        catch (NumberFormatException e) { return defaultValue; }
    }
}
