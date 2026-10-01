package com.project.controller.reception;

import com.project.dao.ReceptionDAO;
import com.project.dao.ReceptionDAOImpl;
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
    private ReceptionDAO receptionDAO;

    @Override
    public void init() throws ServletException {
        this.roomDAO = new RoomDAOImpl();
        this.receptionDAO = new ReceptionDAOImpl();
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

        // Resolve & cache homestay assignment
        Integer homestayId = resolveHomestayId(session, currentUser.getUserId());
        String homestayName = (homestayId != null)
                ? receptionDAO.getAssignedHomestayName(currentUser.getUserId())
                : null;

        String statusFilter = request.getParameter("status");
        // Default filter: ALL (Tổng quan)
        if (statusFilter == null || statusFilter.isEmpty()) {
            statusFilter = "ALL";
        }

        if (homestayId != null) {
            List<Room> rooms = roomDAO.getRoomsByHomestayId(homestayId);
            if (!"ALL".equals(statusFilter)) {
                try {
                    Room.Status filterStatus = Room.Status.valueOf(statusFilter);
                    rooms.removeIf(r -> r.getStatus() != filterStatus);
                } catch (IllegalArgumentException ignored) {}
            }
            request.setAttribute("rooms", rooms);
        }

        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("assignedHomestayId", homestayId);
        request.setAttribute("homestayName", homestayName);
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
        String statusParam = request.getParameter("status");
        if (roomIdParam != null && action != null) {
            int roomId = Integer.parseInt(roomIdParam);
            // markReady: DIRTY → AVAILABLE (dọn xong)
            // markDirty:  AVAILABLE → DIRTY (cần dọn lại)
            Room.Status newStatus = "markReady".equals(action) ? Room.Status.AVAILABLE : Room.Status.DIRTY;
            roomDAO.updateRoomStatus(roomId, newStatus);
        }
        String redirectUrl = request.getContextPath() + "/reception/housekeeping?success=1";
        if (statusParam != null && !statusParam.isEmpty()) {
            redirectUrl += "&status=" + statusParam;
        }
        response.sendRedirect(redirectUrl);
    }

    /**
     * Lấy homestay_id từ session (cache), nếu chưa có thì query DB và lưu vào session.
     */
    private Integer resolveHomestayId(HttpSession session, int userId) {
        Integer homestayId = (Integer) session.getAttribute("assignedHomestayId");
        if (homestayId == null) {
            homestayId = receptionDAO.getAssignedHomestayId(userId);
            if (homestayId != null) {
                session.setAttribute("assignedHomestayId", homestayId);
            }
        }
        return homestayId;
    }
}
