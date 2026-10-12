package com.project.controller.owner;

import com.project.dao.BookingDAO;
import com.project.dao.BookingDAOImpl;
import com.project.dao.HomestayDAO;
import com.project.dao.HomestayDAOImpl;
import com.project.dao.OwnerAnalyticsDAO;
import com.project.dao.OwnerAnalyticsDAOImpl;
import com.project.model.Booking;
import com.project.model.Homestay;
import com.project.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Controller: Owner — Dashboard tổng quan hôm nay (UC17)
 * GET /owner/dashboard — Nhận/Trả phòng hôm nay, khách đang ở, KPI tháng
 * Package: com.project.controller.owner
 */
@WebServlet(name = "OwnerDashboardController", urlPatterns = {"/owner/dashboard"})
public class OwnerDashboardController extends HttpServlet {

    private BookingDAO        bookingDAO;
    private HomestayDAO       homestayDAO;
    private OwnerAnalyticsDAO analyticsDAO;

    @Override
    public void init() throws ServletException {
        this.bookingDAO   = new BookingDAOImpl();
        this.homestayDAO  = new HomestayDAOImpl();
        this.analyticsDAO = new OwnerAnalyticsDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = requireOwner(request, response);
        if (currentUser == null) return;

        int ownerId = currentUser.getUserId();

        // ── Lấy tất cả homestay của owner ───────────────────────────────────
        List<Homestay> myHomestays = homestayDAO.getHomestaysByOwnerId(ownerId);

        // Map homestayId → name để annotate booking
        Map<Integer, String> homestayNames = new HashMap<>();
        for (Homestay h : myHomestays) {
            homestayNames.put(h.getHomestayId(), h.getName());
        }

        // ── Aggregate today's arrivals, departures, current guests ──────────
        List<Booking> arrivals     = new ArrayList<>();
        List<Booking> departures   = new ArrayList<>();
        List<Booking> currentGuests = new ArrayList<>();

        for (Homestay h : myHomestays) {
            int hId = h.getHomestayId();
            String hName = h.getName();

            List<Booking> hArrivals = bookingDAO.getTodayArrivals(hId);
            for (Booking b : hArrivals) b.setHomestayName(hName);
            arrivals.addAll(hArrivals);

            List<Booking> hDepartures = bookingDAO.getTodayDepartures(hId);
            for (Booking b : hDepartures) b.setHomestayName(hName);
            departures.addAll(hDepartures);

            List<Booking> hGuests = bookingDAO.getCurrentGuests(hId, null);
            for (Booking b : hGuests) b.setHomestayName(hName);
            currentGuests.addAll(hGuests);
        }

        // ── KPI tháng này ────────────────────────────────────────────────────
        String today         = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
        String firstOfMonth  = today.substring(0, 8) + "01";

        long   monthRevenue   = analyticsDAO.getTotalRevenue(ownerId, null, firstOfMonth, today);
        int    monthBookings  = analyticsDAO.countSuccessfulBookings(ownerId, null, firstOfMonth, today);
        double occupancyRate  = analyticsDAO.getOccupancyRate(ownerId, null, firstOfMonth, today);

        // ── Recent bookings (bảng nhỏ phía dưới) ────────────────────────────
        List<Object[]> recentBookings = analyticsDAO.getRecentBookings(ownerId, null, 8);

        // ── Push attributes ─────────────────────────────────────────────────
        request.setAttribute("myHomestays",    myHomestays);
        request.setAttribute("arrivals",       arrivals);
        request.setAttribute("departures",     departures);
        request.setAttribute("currentGuests",  currentGuests);
        request.setAttribute("monthRevenue",   monthRevenue);
        request.setAttribute("monthBookings",  monthBookings);
        request.setAttribute("occupancyRate",  occupancyRate);
        request.setAttribute("recentBookings", recentBookings);

        request.setAttribute("activeTab",      "dashboard");
        request.setAttribute("pageTitle",      "Tổng quan — Hôm nay");
        request.setAttribute("pageBreadcrumb", "Vận hành &amp; Báo cáo");

        request.getRequestDispatcher("/WEB-INF/views/owner/dashboard.jsp")
               .forward(request, response);
    }

    // ── Helper ───────────────────────────────────────────────────────────────

    private User requireOwner(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }
        if (user.getRole() != User.Role.OWNER && user.getRole() != User.Role.ADMIN) {
            response.sendRedirect(request.getContextPath() + "/home");
            return null;
        }
        return user;
    }
}
