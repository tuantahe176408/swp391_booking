package com.project.controller.reception;

import com.project.dao.*;
import com.project.model.Room;
import com.project.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.sql.Date;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Optional;
import java.util.logging.Logger;
import java.util.stream.Collectors;

/**
 * Controller: Walk-in & On-site Desk Booking (UC15)
 * GET  /reception/walk-in  — tải form + danh sách phòng trống
 * POST /reception/walk-in  — tạo booking WALK_IN + check-in ngay
 * Package: com.project.controller.reception
 */
@WebServlet(name = "WalkInController", urlPatterns = {"/reception/walk-in"})
public class WalkInController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(WalkInController.class.getName());

    private BookingDAO   bookingDAO;
    private RoomDAO      roomDAO;
    private ReceptionDAO receptionDAO;

    @Override
    public void init() throws ServletException {
        this.bookingDAO   = new BookingDAOImpl();
        this.roomDAO      = new RoomDAOImpl();
        this.receptionDAO = new ReceptionDAOImpl();
    }

    // ── GET: hiển thị form walk-in ────────────────────────────────────────────

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = session != null ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer homestayId   = resolveHomestayId(session, currentUser.getUserId());
        String  homestayName = (homestayId != null)
                ? receptionDAO.getAssignedHomestayName(currentUser.getUserId()) : null;

        // Lấy tất cả phòng AVAILABLE của cơ sở (dùng getRoomsByHomestayId + filter Java stream)
        List<Room> availableRooms = java.util.Collections.emptyList();
        if (homestayId != null) {
            availableRooms = roomDAO.getRoomsByHomestayId(homestayId)
                    .stream()
                    .filter(r -> r.getStatus() == Room.Status.AVAILABLE)
                    .collect(Collectors.toList());
        }

        request.setAttribute("availableRooms", availableRooms);
        request.setAttribute("homestayId",     homestayId);
        request.setAttribute("homestayName",   homestayName);
        request.setAttribute("today",          LocalDate.now().toString());
        request.setAttribute("tomorrow",       LocalDate.now().plusDays(1).toString());
        request.setAttribute("activeTab",      "walkin");
        request.setAttribute("pageTitle",      "Lễ tân — Đặt phòng Khách vãng lai");
        request.getRequestDispatcher("/WEB-INF/views/reception/walk-in.jsp").forward(request, response);
    }

    // ── POST: tạo walk-in booking ─────────────────────────────────────────────

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = session != null ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer homestayId = resolveHomestayId(session, currentUser.getUserId());
        if (homestayId == null) {
            response.sendRedirect(request.getContextPath() + "/reception/walk-in?error=no_homestay");
            return;
        }

        // ── Parse & validate form fields ─────────────────────────────────────
        String guestName   = trim(request.getParameter("guestName"));
        String guestPhone  = trim(request.getParameter("guestPhone"));
        String guestEmail  = trim(request.getParameter("guestEmail"));
        String roomIdStr   = trim(request.getParameter("roomId"));
        String checkoutStr = trim(request.getParameter("checkoutDate"));

        if (guestName.isEmpty() || guestPhone.isEmpty() || roomIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/reception/walk-in?error=missing_fields");
            return;
        }

        try {
            int roomId = Integer.parseInt(roomIdStr);

            // Parse checkout date — default tomorrow nếu không hợp lệ
            LocalDate checkoutLocal;
            try {
                checkoutLocal = LocalDate.parse(checkoutStr);
                if (!checkoutLocal.isAfter(LocalDate.now())) {
                    checkoutLocal = LocalDate.now().plusDays(1);
                }
            } catch (Exception e) {
                checkoutLocal = LocalDate.now().plusDays(1);
            }

            // Xác nhận phòng còn AVAILABLE
            Optional<Room> roomOpt = roomDAO.getRoomById(roomId);
            if (!roomOpt.isPresent() || roomOpt.get().getStatus() != Room.Status.AVAILABLE) {
                response.sendRedirect(request.getContextPath() + "/reception/walk-in?error=room_unavailable");
                return;
            }
            Room room = roomOpt.get();

            int        totalNights   = (int) ChronoUnit.DAYS.between(LocalDate.now(), checkoutLocal);
            if (totalNights < 1) totalNights = 1;
            BigDecimal pricePerNight = room.getBasePrice() != null ? room.getBasePrice() : BigDecimal.ZERO;
            BigDecimal finalTotal    = pricePerNight.multiply(BigDecimal.valueOf(totalNights));

            // ── Tạo walk-in booking (atomic) ─────────────────────────────────
            String bookingCode = bookingDAO.createWalkInBooking(
                    guestName, guestEmail, guestPhone,
                    homestayId, room.getRoomTypeId(), roomId,
                    Date.valueOf(LocalDate.now()),
                    Date.valueOf(checkoutLocal),
                    totalNights, finalTotal,
                    currentUser.getUserId()
            );

            if (bookingCode != null) {
                response.sendRedirect(request.getContextPath()
                        + "/reception/walk-in?success=" + URLEncoder.encode(bookingCode, "UTF-8")
                        + "&room="  + URLEncoder.encode("P." + room.getRoomNumber(), "UTF-8")
                        + "&guest=" + URLEncoder.encode(guestName, "UTF-8"));
            } else {
                response.sendRedirect(request.getContextPath() + "/reception/walk-in?error=booking_failed");
            }

        } catch (NumberFormatException e) {
            LOGGER.warning("WalkInController: invalid roomId param: " + roomIdStr);
            response.sendRedirect(request.getContextPath() + "/reception/walk-in?error=invalid_room");
        }
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    private Integer resolveHomestayId(HttpSession session, int userId) {
        session.removeAttribute("assignedHomestayId");
        return receptionDAO.getAssignedHomestayId(userId);
    }

    private static String trim(String s) {
        return s != null ? s.trim() : "";
    }
}
