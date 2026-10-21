package com.project.controller.reception;

import com.project.dao.BookingDAO;
import com.project.dao.BookingDAOImpl;
import com.project.dao.ReceptionDAO;
import com.project.dao.ReceptionDAOImpl;
import com.project.model.Booking;
import com.project.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Controller: Reception — Today's Arrivals, Departures & Current Guests (UC12)
 * GET  /reception/dashboard              — hiển thị màn hình tổng quan ngày hôm nay
 * GET  /reception/dashboard?q=keyword   — filter danh sách khách đang ở
 * POST /reception/dashboard?action=checkout — checkout nhanh từ màn này
 * Package: com.project.controller.reception
 */
@WebServlet(name = "ReceptionDashboardController", urlPatterns = {"/reception/dashboard"})
public class ReceptionDashboardController extends HttpServlet {

    private BookingDAO   bookingDAO;
    private ReceptionDAO receptionDAO;

    @Override
    public void init() throws ServletException {
        this.bookingDAO   = new BookingDAOImpl();
        this.receptionDAO = new ReceptionDAOImpl();
    }

    // ── GET ──────────────────────────────────────────────────────────────────

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = requireReceptionist(request, response);
        if (currentUser == null) return;

        Integer homestayId = receptionDAO.getAssignedHomestayId(currentUser.getUserId());
        String  homestayName = homestayId != null
                ? receptionDAO.getAssignedHomestayName(currentUser.getUserId()) : null;

        // ── Flash messages từ POST checkout ─────────────────────────────────
        HttpSession session = request.getSession(false);
        if (session != null) {
            request.setAttribute("flashSuccess", session.getAttribute("today_flash_success"));
            request.setAttribute("flashError",   session.getAttribute("today_flash_error"));
            session.removeAttribute("today_flash_success");
            session.removeAttribute("today_flash_error");
        }

        // ── Keyword search cho Current Guests ────────────────────────────────
        String keyword = request.getParameter("q");
        if (keyword != null && keyword.trim().isEmpty()) keyword = null;

        List<Booking> arrivals    = null;
        List<Booking> departures  = null;
        List<Booking> currentGuests = null;

        if (homestayId != null) {
            arrivals      = bookingDAO.getTodayArrivals(homestayId);
            departures    = bookingDAO.getTodayDepartures(homestayId);
            currentGuests = bookingDAO.getCurrentGuests(homestayId, keyword);
        }

        request.setAttribute("homestayId",    homestayId);
        request.setAttribute("homestayName",  homestayName);
        request.setAttribute("arrivals",      arrivals);
        request.setAttribute("departures",    departures);
        request.setAttribute("currentGuests", currentGuests);
        request.setAttribute("searchKeyword", keyword);

        request.setAttribute("activeTab",  "today");
        request.setAttribute("pageTitle",  "Tổng quan — Check-in / Check-out");
        request.setAttribute("activeTab",  "dashboard");

        request.getRequestDispatcher("/WEB-INF/views/reception/dashboard.jsp")
               .forward(request, response);
    }

    // ── POST: quick checkout ──────────────────────────────────────────────────

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = requireReceptionist(request, response);
        if (currentUser == null) return;

        String action = trim(request.getParameter("action"));
        String keyword = trim(request.getParameter("q"));
        String qs = keyword.isEmpty() ? "" : "?q=" + java.net.URLEncoder.encode(keyword, "UTF-8");

        if ("checkout".equals(action)) {
            String bookingIdStr = trim(request.getParameter("bookingId"));
            HttpSession session = request.getSession(true);
            try {
                int bookingId = Integer.parseInt(bookingIdStr);
                boolean ok = bookingDAO.checkoutBooking(bookingId, currentUser.getUserId());
                if (ok) {
                    // Lấy booking code để hiện flash
                    bookingDAO.getBookingById(bookingId).ifPresent(b ->
                        session.setAttribute("today_flash_success",
                            "Check-out thành công đơn <strong>" + b.getBookingCode()
                            + "</strong> — phòng chuyển sang trạng thái Cần dọn dẹp."));
                } else {
                    session.setAttribute("today_flash_error",
                        "Check-out thất bại. Đơn phòng có thể không còn ở trạng thái CHECKED_IN.");
                }
            } catch (NumberFormatException e) {
                request.getSession(true).setAttribute("today_flash_error", "Thông tin không hợp lệ.");
            }
            response.sendRedirect(request.getContextPath() + "/reception/dashboard" + qs);
            return;
        }

        if ("checkin".equals(action)) {
            // Quick check-in: bookingId + selectedRoomId
            String bookingIdStr = trim(request.getParameter("bookingId"));
            String roomIdStr    = trim(request.getParameter("selectedRoomId"));
            HttpSession session = request.getSession(true);
            try {
                int bookingId = Integer.parseInt(bookingIdStr);
                int roomId    = Integer.parseInt(roomIdStr);
                boolean ok = bookingDAO.checkinBooking(bookingId, roomId,
                        currentUser.getUserId(), "", "{}");
                if (ok) {
                    bookingDAO.getBookingById(bookingId).ifPresent(b ->
                        session.setAttribute("today_flash_success",
                            "Check-in thành công đơn <strong>" + b.getBookingCode()
                            + "</strong>. Phòng đã được gán và chuyển sang OCCUPIED."));
                } else {
                    session.setAttribute("today_flash_error",
                        "Check-in thất bại. Vui lòng thử lại từ màn Check-in đầy đủ để chọn phòng và scan CCCD.");
                }
            } catch (NumberFormatException e) {
                request.getSession(true).setAttribute("today_flash_error", "Thông tin không hợp lệ.");
            }
            response.sendRedirect(request.getContextPath() + "/reception/dashboard" + qs);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/reception/dashboard");
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    private User requireReceptionist(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }
        if (user.getRole() != User.Role.RECEPTIONIST) {
            response.sendRedirect(request.getContextPath() + "/home");
            return null;
        }
        return user;
    }

    private static String trim(String s) { return s != null ? s.trim() : ""; }
}
