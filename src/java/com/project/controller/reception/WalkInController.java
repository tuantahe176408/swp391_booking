package com.project.controller.reception;

import com.project.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Controller: Walk-in & On-site Desk Booking (UC13)
 * Package: com.project.controller.reception
 */
@WebServlet(name = "WalkInController", urlPatterns = {"/reception/walk-in"})
public class WalkInController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setAttribute("activeTab", "walkin");
        request.setAttribute("pageTitle", "Lễ tân - Đặt phòng Khách vãng lai");
        request.getRequestDispatcher("/WEB-INF/views/reception/walk-in.jsp").forward(request, response);
    }
}
