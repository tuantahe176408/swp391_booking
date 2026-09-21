package com.project.controller.customer;

import com.project.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Controller: Manage Customer Bookings & E-Tickets (UC09)
 * Package: com.project.controller.customer
 */
@WebServlet(name = "CustomerBookingController", urlPatterns = {"/customer/bookings"})
public class CustomerBookingController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setAttribute("activeTab", "bookings");
        request.setAttribute("pageTitle", "Đơn đặt phòng của tôi - Smart Booking Platform");
        request.getRequestDispatcher("/WEB-INF/views/customer/booking-list.jsp").forward(request, response);
    }
}
