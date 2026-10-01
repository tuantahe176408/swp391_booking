package com.project.controller.reception;

import com.project.dao.*;
import com.project.model.Room;
import com.project.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

/**
 * Controller: Room Availability Matrix & Real-time Grid (UC13)
 * GET  /reception/matrix — tải ma trận phòng từ DB (full-page)
 * POST /reception/matrix — AJAX polling trả JSON array rooms (không reload trang)
 * Package: com.project.controller.reception
 */
@WebServlet(name = "RoomMatrixController", urlPatterns = {"/reception/matrix"})
public class RoomMatrixController extends HttpServlet {

    private RoomDAO      roomDAO;
    private ReceptionDAO receptionDAO;

    @Override
    public void init() throws ServletException {
        this.roomDAO      = new RoomDAOImpl();
        this.receptionDAO = new ReceptionDAOImpl();
    }

    // ── GET: Full-page render ─────────────────────────────────────────────────

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = session != null ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer homestayId   = resolveHomestayId(session, currentUser.getUserId());
        String  homestayName = (homestayId != null)
                ? receptionDAO.getAssignedHomestayName(currentUser.getUserId())
                : null;

        long countAvailable  = 0;
        long countOccupied   = 0;
        long countDirty      = 0;
        long countMaintenance = 0;

        List<Room>                    rooms       = new ArrayList<>();
        Map<String, List<Room>>       roomsByType = new LinkedHashMap<>();

        if (homestayId != null) {
            rooms = roomDAO.getRoomsForMatrix(homestayId);

            for (Room r : rooms) {
                if (r.getStatus() != null) {
                    switch (r.getStatus()) {
                        case AVAILABLE:   countAvailable++;    break;
                        case OCCUPIED:    countOccupied++;     break;
                        case DIRTY:       countDirty++;        break;
                        case MAINTENANCE: countMaintenance++;  break;
                        default:                               break;
                    }
                }
                // Gom nhóm theo loại phòng (giữ thứ tự)
                String typeName = r.getRoomTypeName() != null ? r.getRoomTypeName() : "Khác";
                roomsByType.computeIfAbsent(typeName, k -> new ArrayList<>()).add(r);
            }
        }

        request.setAttribute("rooms",            rooms);
        request.setAttribute("roomsByType",       roomsByType);
        request.setAttribute("countAvailable",    countAvailable);
        request.setAttribute("countOccupied",     countOccupied);
        request.setAttribute("countDirty",        countDirty);
        request.setAttribute("countMaintenance",  countMaintenance);
        request.setAttribute("homestayId",        homestayId);
        request.setAttribute("homestayName",      homestayName);
        request.setAttribute("activeTab",         "matrix");
        request.setAttribute("pageTitle",         "Lễ tân — Ma trận Trạng thái Phòng");
        request.getRequestDispatcher("/WEB-INF/views/reception/room-matrix.jsp").forward(request, response);
    }

    // ── POST: AJAX polling — trả JSON ────────────────────────────────────────

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = session != null ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        Integer homestayId = resolveHomestayId(session, currentUser.getUserId());
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        if (homestayId == null) {
            out.write("{\"error\":\"Lễ tân chưa được gán cơ sở homestay\"}");
            return;
        }

        List<Room> rooms = roomDAO.getRoomsForMatrix(homestayId);

        // Serialize thành JSON array
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < rooms.size(); i++) {
            Room r = rooms.get(i);
            if (i > 0) json.append(",");
            json.append("{");
            json.append("\"roomId\":")            .append(r.getRoomId()).append(",");
            json.append("\"roomNumber\":")         .append(jsonStr(r.getRoomNumber())).append(",");
            json.append("\"status\":")             .append(jsonStr(r.getStatus() != null
                                                            ? r.getStatus().name() : "AVAILABLE")).append(",");
            json.append("\"roomTypeName\":")       .append(jsonStr(r.getRoomTypeName())).append(",");
            json.append("\"currentGuestName\":")   .append(jsonStr(r.getCurrentGuestName())).append(",");
            json.append("\"currentBookingCode\":") .append(jsonStr(r.getCurrentBookingCode())).append(",");
            json.append("\"currentBookingId\":")   .append(r.getCurrentBookingId() != null ? r.getCurrentBookingId() : "null");
            json.append("}");
        }
        json.append("]");

        out.write(json.toString());
    }

    // ── Helpers ──────────────────────────────────────────────────────────────

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

    private static String jsonStr(String s) {
        if (s == null) return "null";
        return "\"" + s
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                + "\"";
    }
}
