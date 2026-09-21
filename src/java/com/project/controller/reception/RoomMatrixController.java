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
 * Controller: Room Availability Matrix & Real-time Grid (UC14)
 * Package: com.project.controller.reception
 */
@WebServlet(name = "RoomMatrixController", urlPatterns = {"/reception/matrix"})
public class RoomMatrixController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setAttribute("activeTab", "matrix");
        request.setAttribute("pageTitle", "Lễ tân - Ma trận Trạng thái Phòng");
        request.getRequestDispatcher("/WEB-INF/views/reception/room-matrix.jsp").forward(request, response);
    }
}
