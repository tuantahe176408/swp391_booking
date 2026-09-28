package com.project.controller.owner;

import com.project.dao.BookingDAO;
import com.project.dao.BookingDAOImpl;
import com.project.dao.HomestayDAO;
import com.project.dao.HomestayDAOImpl;
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
import java.util.List;

/**
 * Controller: Owner — View all booking orders with filter & pagination (UC20)
 * URL: /owner/bookings
 * Package: com.project.controller.owner
 */
@WebServlet(name = "OwnerBookingController", urlPatterns = {"/owner/bookings"})
public class OwnerBookingController extends HttpServlet {

    private static final int PAGE_SIZE = 15;

    private final BookingDAO  bookingDAO  = new BookingDAOImpl();
    private final HomestayDAO homestayDAO = new HomestayDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (currentUser.getRole() != User.Role.OWNER) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        int ownerId = currentUser.getUserId();

        // ── Parse filter parameters ──────────────────────────────────────────
        String  homestayParam = request.getParameter("homestayId");
        String  status        = request.getParameter("status");
        String  fromDate      = request.getParameter("fromDate");
        String  toDate        = request.getParameter("toDate");
        String  pageParam     = request.getParameter("page");

        Integer homestayId = null;
        if (homestayParam != null && !homestayParam.trim().isEmpty()) {
            try { homestayId = Integer.parseInt(homestayParam.trim()); } catch (NumberFormatException ignored) {}
        }

        // Normalise empty strings to null so DAO treats them as "no filter"
        if (status   != null && status.trim().isEmpty())   status   = null;
        if (fromDate != null && fromDate.trim().isEmpty())  fromDate = null;
        if (toDate   != null && toDate.trim().isEmpty())    toDate   = null;

        int page = 1;
        if (pageParam != null) {
            try { page = Math.max(1, Integer.parseInt(pageParam.trim())); } catch (NumberFormatException ignored) {}
        }
        int offset = (page - 1) * PAGE_SIZE;

        // ── DAO calls ────────────────────────────────────────────────────────
        List<Booking>  bookings    = bookingDAO.getBookingsByOwner(
                                         ownerId, homestayId, status, fromDate, toDate, offset, PAGE_SIZE);
        int            totalRows   = bookingDAO.countBookingsByOwner(
                                         ownerId, homestayId, status, fromDate, toDate);
        List<Homestay> myHomestays = homestayDAO.getHomestaysByOwnerId(ownerId);

        int totalPages = (totalRows == 0) ? 1 : (int) Math.ceil((double) totalRows / PAGE_SIZE);

        // ── Push to request scope ────────────────────────────────────────────
        request.setAttribute("bookings",    bookings);
        request.setAttribute("myHomestays", myHomestays);
        request.setAttribute("totalRows",   totalRows);
        request.setAttribute("totalPages",  totalPages);
        request.setAttribute("currentPage", page);

        // Preserve filter values for form re-population
        request.setAttribute("filterHomestayId", homestayId);
        request.setAttribute("filterStatus",     status);
        request.setAttribute("filterFromDate",   fromDate);
        request.setAttribute("filterToDate",     toDate);

        request.setAttribute("activeTab",  "bookings");
        request.setAttribute("pageTitle",  "Đơn đặt phòng");
        request.setAttribute("pageBreadcrumb", "Vận hành & Báo cáo");

        request.getRequestDispatcher("/WEB-INF/views/owner/booking-list.jsp")
               .forward(request, response);
    }
}
