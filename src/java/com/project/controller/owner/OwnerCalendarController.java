package com.project.controller.owner;

import com.project.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Controller: Manage Room Calendar & Dynamic Pricing Rules (UC18)
 * Package: com.project.controller.owner
 */
@WebServlet(name = "OwnerCalendarController", urlPatterns = {"/owner/calendar"})
public class OwnerCalendarController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setAttribute("activeTab", "calendar");
        request.setAttribute("pageTitle", "Chủ nhà - Lịch & Giá linh hoạt");
        request.getRequestDispatcher("/WEB-INF/views/owner/calendar.jsp").forward(request, response);
    }
}
