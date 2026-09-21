package com.project.controller.reception;

import com.project.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Controller: Reception Check-in / Out & OCR ID Scan (UC12)
 * Package: com.project.controller.reception
 */
@WebServlet(name = "ReceptionCheckinController", urlPatterns = {"/reception/checkin"})
public class ReceptionCheckinController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setAttribute("activeTab", "checkin");
        request.setAttribute("pageTitle", "Lễ tân - Check-in & OCR Scanning");
        request.getRequestDispatcher("/WEB-INF/views/reception/checkin.jsp").forward(request, response);
    }
}
