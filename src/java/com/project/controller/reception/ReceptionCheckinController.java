package com.project.controller.reception;

import com.project.dao.*;
import com.project.model.Booking;
import com.project.model.Room;
import com.project.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

/**
 * Controller: Reception Check-in / Out & OCR ID Scan (UC12)
 * GET  /reception/checkin          — form tìm kiếm (blank hoặc kết quả)
 * GET  /reception/checkin?q=...    — tìm theo mã đặt phòng hoặc SĐT
 * POST /reception/checkin          — xác nhận check-in (action=checkin)
 * Package: com.project.controller.reception
 */
@WebServlet(name = "ReceptionCheckinController", urlPatterns = {"/reception/checkin"})
public class ReceptionCheckinController extends HttpServlet {

    private BookingDAO   bookingDAO;
    private RoomDAO      roomDAO;
    private ReceptionDAO receptionDAO;

    @Override
    public void init() throws ServletException {
        this.bookingDAO   = new BookingDAOImpl();
        this.roomDAO      = new RoomDAOImpl();
        this.receptionDAO = new ReceptionDAOImpl();
    }

    // ── GET ──────────────────────────────────────────────────────────────────

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = session != null ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Resolve & cache homestay assignment in session
        Integer homestayId = resolveHomestayId(session, currentUser.getUserId());
        String  homestayName = (homestayId != null)
                ? receptionDAO.getAssignedHomestayName(currentUser.getUserId())
                : null;

        request.setAttribute("homestayId",   homestayId);
        request.setAttribute("homestayName", homestayName);

        String query = request.getParameter("q");
        if (query != null && !query.trim().isEmpty()) {
            query = query.trim();
            request.setAttribute("searchQuery", query);

            Optional<Booking> found = Optional.empty();

            if (query.toUpperCase().startsWith("BK-")) {
                // Tìm theo mã đặt phòng
                found = bookingDAO.getBookingByCode(query.toUpperCase());
                // Kiểm tra booking có thuộc homestay của lễ tân không
                if (found.isPresent() && homestayId != null
                        && found.get().getHomestayId() != homestayId) {
                    found = Optional.empty(); // không phải cơ sở của lễ tân này
                }
            } else if (query.matches("[0-9+]{9,15}") && homestayId != null) {
                // Tìm theo SĐT
                List<Booking> byPhone = bookingDAO.searchBookingsByPhone(query, homestayId);
                if (!byPhone.isEmpty()) {
                    found = Optional.of(byPhone.get(0));
                    if (byPhone.size() > 1) {
                        request.setAttribute("multipleResults", byPhone);
                    }
                }
            } else if (homestayId == null) {
                request.setAttribute("searchError",
                        "Lễ tân chưa được gán cơ sở — không thể tìm theo SĐT.");
            }

            if (found.isPresent()) {
                Booking booking = found.get();
                request.setAttribute("booking", booking);

                // Nếu CONFIRMED, tải danh sách phòng trống để giao
                if ("CONFIRMED".equals(booking.getBookingStatus())) {
                    String checkinStr  = booking.getCheckinDate()  != null
                            ? booking.getCheckinDate().toString()  : "";
                    String checkoutStr = booking.getCheckoutDate() != null
                            ? booking.getCheckoutDate().toString() : "";
                    List<Room> availableRooms = roomDAO.getAvailableRooms(
                            booking.getHomestayId(),
                            booking.getRoomTypeId(),
                            checkinStr, checkoutStr);
                    request.setAttribute("availableRooms", availableRooms);
                }
            } else if (request.getAttribute("searchError") == null) {
                request.setAttribute("searchError",
                        "Không tìm thấy đơn phòng với mã / SĐT: \"" + query + "\". " +
                        "Kiểm tra lại trạng thái đặt phòng phải là CONFIRMED hoặc CHECKED_IN.");
            }
        }

        request.setAttribute("activeTab", "checkin");
        request.setAttribute("pageTitle", "Lễ tân — Check-in & OCR Scanning");
        request.getRequestDispatcher("/WEB-INF/views/reception/checkin.jsp").forward(request, response);
    }

    // ── POST ─────────────────────────────────────────────────────────────────

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = session != null ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if ("checkin".equals(action)) {
            String bookingIdParam  = request.getParameter("bookingId");
            String roomIdParam     = request.getParameter("selectedRoomId");
            String idCardNumber    = request.getParameter("idCardNumber");
            String rawOcrJson      = request.getParameter("rawOcrJson");

            if (bookingIdParam == null || roomIdParam == null || roomIdParam.isEmpty()) {
                response.sendRedirect(request.getContextPath()
                        + "/reception/checkin?error=missing_params");
                return;
            }

            try {
                int bookingId = Integer.parseInt(bookingIdParam);
                int roomId    = Integer.parseInt(roomIdParam);

                boolean ok = bookingDAO.checkinBooking(
                        bookingId,
                        roomId,
                        currentUser.getUserId(),
                        idCardNumber != null ? idCardNumber.trim() : "",
                        rawOcrJson   != null ? rawOcrJson           : "{}");

                if (ok) {
                    // Lấy mã đặt phòng để hiện flash message
                    Optional<Booking> b = bookingDAO.getBookingById(bookingId);
                    String code = b.isPresent() ? b.get().getBookingCode() : "";
                    response.sendRedirect(request.getContextPath()
                            + "/reception/checkin?success=" + code);
                } else {
                    response.sendRedirect(request.getContextPath()
                            + "/reception/checkin?error=checkin_failed");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath()
                        + "/reception/checkin?error=invalid_params");
            }

        } else if ("checkout".equals(action)) {
            // ── UC12: Check-out ──────────────────────────────────────────
            String bookingIdParam = request.getParameter("bookingId");
            // referer dùng để redirect về đúng trang gọi (checkin hoặc matrix)
            String referer = request.getHeader("Referer");
            String baseRedirect = (referer != null && referer.contains("/reception/checkin"))
                    ? request.getContextPath() + "/reception/checkin"
                    : request.getContextPath() + "/reception/matrix";

            if (bookingIdParam == null || bookingIdParam.trim().isEmpty()) {
                response.sendRedirect(baseRedirect + "?error=missing_booking_id");
                return;
            }
            try {
                int bookingId = Integer.parseInt(bookingIdParam.trim());
                boolean ok = bookingDAO.checkoutBooking(bookingId, currentUser.getUserId());

                if (ok) {
                    // Lấy mã booking để hiển thị flash message trên matrix
                    Optional<Booking> b = bookingDAO.getBookingById(bookingId);
                    String code = (b.isPresent() && b.get().getBookingCode() != null)
                            ? b.get().getBookingCode() : "";
                    response.sendRedirect(baseRedirect
                            + "?checkoutSuccess="
                            + java.net.URLEncoder.encode(code, "UTF-8"));
                } else {
                    response.sendRedirect(baseRedirect + "?error=checkout_failed");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(baseRedirect + "?error=invalid_booking_id");
            }

        } else {
            response.sendRedirect(request.getContextPath() + "/reception/checkin");
        }
    }

    // ── Helpers ──────────────────────────────────────────────────────────────

    /**
     * Luôn query DB để lấy homestay_id mới nhất — tránh stale cache khi Owner reassign.
     */
    private Integer resolveHomestayId(HttpSession session, int userId) {
        session.removeAttribute("assignedHomestayId");
        return receptionDAO.getAssignedHomestayId(userId);
    }
}
