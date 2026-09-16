package com.project.controller.owner;

import com.project.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Controller: Homestay & Room Property Listing Management (UC17)
 * Package: com.project.controller.owner
 */
@WebServlet(name = "OwnerHomestayController", urlPatterns = {"/owner/homestays"})
public class OwnerHomestayController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setAttribute("activeTab", "homestays");
        request.setAttribute("pageTitle", "Chủ nhà - Quản lý Homestay & Hạng phòng");
        request.getRequestDispatcher("/WEB-INF/views/owner/homestay-form.jsp").forward(request, response);
    }
}
