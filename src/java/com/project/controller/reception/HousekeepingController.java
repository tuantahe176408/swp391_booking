package com.project.controller.reception;

import com.project.dao.RoomDAO;
import com.project.dao.RoomDAOImpl;
import com.project.model.Room;
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
 * Controller: Reception Housekeeping & Room Cleanliness (UC14)
 * Package: com.project.controller.reception
 */
@WebServlet(name = "HousekeepingController", urlPatterns = {"/reception/housekeeping"})
public class HousekeepingController extends HttpServlet {

    private RoomDAO roomDAO;

    @Override
    public void init() throws ServletException {
        this.roomDAO = new RoomDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer homestayId = (Integer) session.getAttribute("assignedHomestayId");
        String statusFilter = request.getParameter("status");

        if (homestayId != null) {
            List<Room> rooms = roomDAO.getRoomsByHomestayId(homestayId);
            if (statusFilter != null && !"ALL".equals(statusFilter)) {
                try {
                    Room.Status filterStatus = Room.Status.valueOf(statusFilter);
                    rooms.removeIf(r -> r.getStatus() != filterStatus);
                } catch (IllegalArgumentException ignored) {}
            }
            request.setAttribute("rooms", rooms);
        }

        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("activeTab", "housekeeping");
        request.setAttribute("pageTitle", "Lễ tân - Quản lý Buồng phòng & Housekeeping");
        request.getRequestDispatcher("/WEB-INF/views/reception/housekeeping.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        String action = request.getParameter("action");
        String roomIdParam = request.getParameter("roomId");
        if (roomIdParam != null && action != null) {
            int roomId = Integer.parseInt(roomIdParam);
            Room.Status newStatus = "markReady".equals(action) ? Room.Status.AVAILABLE : Room.Status.HOUSEKEEPING;
            roomDAO.updateRoomStatus(roomId, newStatus);
        }
        response.sendRedirect(request.getContextPath() + "/reception/housekeeping");
    }
}
