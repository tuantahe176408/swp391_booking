package com.project.controller.owner;

import com.project.dao.HomestayDAO;
import com.project.dao.HomestayDAOImpl;
import com.project.dao.RoomDAO;
import com.project.dao.RoomDAOImpl;
import com.project.model.Homestay;
import com.project.model.Room;
import com.project.model.RoomType;
import com.project.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

/**
 * Controller: Manage Room Types & Physical Rooms (UC17)
 * GET  /owner/rooms?homestayId=X              — list room types + rooms
 * POST /owner/rooms?action=addRoomType        — create room type
 * POST /owner/rooms?action=editRoomType       — update room type
 * POST /owner/rooms?action=deleteRoomType     — delete room type
 * POST /owner/rooms?action=addRoom            — add physical room
 * POST /owner/rooms?action=deleteRoom         — delete physical room
 * Package: com.project.controller.owner
 */
@WebServlet(name = "OwnerRoomController", urlPatterns = {"/owner/rooms"})
public class OwnerRoomController extends HttpServlet {

    private final HomestayDAO homestayDAO = new HomestayDAOImpl();
    private final RoomDAO     roomDAO     = new RoomDAOImpl();

    // ── GET ───────────────────────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = auth(request, response);
        if (currentUser == null) return;

        int homestayId = parseIntParam(request, "homestayId", 0);
        if (homestayId == 0) {
            response.sendRedirect(request.getContextPath() + "/owner/homestays");
            return;
        }

        // Verify ownership
        Optional<Homestay> hsOpt = homestayDAO.getHomestayById(homestayId);
        if (hsOpt.isEmpty() || hsOpt.get().getOwnerId() != currentUser.getUserId()) {
            response.sendRedirect(request.getContextPath() + "/owner/homestays");
            return;
        }

        Homestay homestay = hsOpt.get();
        List<RoomType> roomTypes = homestayDAO.getRoomTypesWithCountByHomestayId(
                homestayId, currentUser.getUserId());
        List<Room> rooms = roomDAO.getRoomsByHomestayId(homestayId);

        request.setAttribute("homestay",  homestay);
        request.setAttribute("roomTypes", roomTypes);
        request.setAttribute("rooms",     rooms);
        request.setAttribute("activeTab", "homestays");
        request.setAttribute("pageTitle", "Quản lý Phòng — " + homestay.getName());
        request.setAttribute("pageBreadcrumb", "Quản lý Tài sản");

        // Flash from redirect
        HttpSession session = request.getSession(false);
        if (session != null) {
            request.setAttribute("flash_success", session.getAttribute("flash_success"));
            request.setAttribute("flash_error",   session.getAttribute("flash_error"));
            session.removeAttribute("flash_success");
            session.removeAttribute("flash_error");
        }

        request.getRequestDispatcher("/WEB-INF/views/owner/rooms.jsp")
               .forward(request, response);
    }

    // ── POST ──────────────────────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        User currentUser = auth(request, response);
        if (currentUser == null) return;

        String action     = request.getParameter("action");
        int    homestayId = parseIntParam(request, "homestayId", 0);

        // Verify ownership upfront
        if (homestayId == 0) {
            response.sendRedirect(request.getContextPath() + "/owner/homestays");
            return;
        }
        Optional<Homestay> hsOpt = homestayDAO.getHomestayById(homestayId);
        if (hsOpt.isEmpty() || hsOpt.get().getOwnerId() != currentUser.getUserId()) {
            response.sendRedirect(request.getContextPath() + "/owner/homestays");
            return;
        }

        String redirectBase = request.getContextPath() + "/owner/rooms?homestayId=" + homestayId;

        switch (action == null ? "" : action) {

            // ── Add RoomType ─────────────────────────────────────────────────
            case "addRoomType": {
                RoomType rt = buildRoomType(request, homestayId);
                int newId = homestayDAO.insertRoomType(rt);
                if (newId > 0) flash(request, "success", "Thêm loại phòng \"" + rt.getName() + "\" thành công.");
                else           flash(request, "error",   "Thêm loại phòng thất bại. Vui lòng thử lại.");
                break;
            }

            // ── Edit RoomType ────────────────────────────────────────────────
            case "editRoomType": {
                int rtId = parseIntParam(request, "roomTypeId", 0);
                if (rtId > 0) {
                    RoomType rt = buildRoomType(request, homestayId);
                    rt.setRoomTypeId(rtId);
                    boolean ok = homestayDAO.updateRoomType(rt, currentUser.getUserId());
                    if (ok) flash(request, "success", "Cập nhật loại phòng thành công.");
                    else    flash(request, "error",   "Cập nhật thất bại. Vui lòng thử lại.");
                }
                break;
            }

            // ── Delete RoomType ──────────────────────────────────────────────
            case "deleteRoomType": {
                int rtId = parseIntParam(request, "roomTypeId", 0);
                if (rtId > 0) {
                    boolean ok = homestayDAO.deleteRoomType(rtId, currentUser.getUserId());
                    if (ok) flash(request, "success", "Đã xóa loại phòng.");
                    else    flash(request, "error",   "Không thể xóa: loại phòng đang có đặt phòng chưa hoàn tất.");
                }
                break;
            }

            // ── Add physical Room ────────────────────────────────────────────
            case "addRoom": {
                int    rtId       = parseIntParam(request, "roomTypeId", 0);
                String roomNumber = request.getParameter("roomNumber");
                if (rtId > 0 && roomNumber != null && !roomNumber.trim().isEmpty()) {
                    Room room = new Room();
                    room.setRoomTypeId(rtId);
                    room.setRoomNumber(roomNumber.trim().toUpperCase());
                    room.setStatus(Room.Status.AVAILABLE);
                    int newId = roomDAO.insertRoom(room);
                    if (newId > 0) flash(request, "success", "Thêm phòng " + room.getRoomNumber() + " thành công.");
                    else           flash(request, "error",   "Thêm phòng thất bại. Số phòng có thể đã tồn tại.");
                }
                break;
            }

            // ── Delete physical Room ─────────────────────────────────────────
            case "deleteRoom": {
                int roomId = parseIntParam(request, "roomId", 0);
                if (roomId > 0) {
                    boolean ok = roomDAO.deleteRoom(roomId);
                    if (ok) flash(request, "success", "Đã xóa phòng.");
                    else    flash(request, "error",   "Xóa phòng thất bại.");
                }
                break;
            }

            // ── Update room status ───────────────────────────────────────────
            case "updateRoomStatus": {
                int    roomId    = parseIntParam(request, "roomId", 0);
                String statusStr = request.getParameter("roomStatus");
                if (roomId > 0 && statusStr != null) {
                    // Owner can only toggle AVAILABLE ↔ MAINTENANCE
                    try {
                        Room.Status newStatus = Room.Status.valueOf(statusStr.trim().toUpperCase());
                        if (newStatus == Room.Status.AVAILABLE
                                || newStatus == Room.Status.MAINTENANCE
                                || newStatus == Room.Status.DIRTY) {
                            boolean ok = roomDAO.updateRoomStatus(roomId, newStatus);
                            if (ok) flash(request, "success",
                                    "Cập nhật trạng thái phòng thành công.");
                            else flash(request, "error", "Cập nhật trạng thái thất bại.");
                        }
                    } catch (IllegalArgumentException ignored) {}
                }
                break;
            }

            default:
                break;
        }

        response.sendRedirect(redirectBase);
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    private RoomType buildRoomType(HttpServletRequest req, int homestayId) {
        RoomType rt = new RoomType();
        rt.setHomestayId(homestayId);
        rt.setName(trim(req.getParameter("rtName")));
        rt.setDescription(trim(req.getParameter("rtDescription")));
        String priceStr = req.getParameter("rtBasePrice");
        try { rt.setBasePrice(new BigDecimal(priceStr.trim())); } catch (Exception e) { rt.setBasePrice(BigDecimal.ZERO); }
        rt.setMaxOccupancy(parseIntParam(req, "rtMaxOccupancy", 2));
        rt.setBedCount(parseIntParam(req, "rtBedCount", 1));
        String sizeStr = req.getParameter("rtRoomSize");
        try { if (sizeStr != null && !sizeStr.trim().isEmpty()) rt.setRoomSizeSqm(new BigDecimal(sizeStr.trim())); }
        catch (Exception ignored) {}
        return rt;
    }

    private User auth(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        User u = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (u == null) { res.sendRedirect(req.getContextPath() + "/login"); return null; }
        return u;
    }

    private int parseIntParam(HttpServletRequest req, String name, int def) {
        String s = req.getParameter(name);
        try { return (s != null) ? Integer.parseInt(s.trim()) : def; }
        catch (NumberFormatException e) { return def; }
    }

    private String trim(String s) { return (s == null) ? "" : s.trim(); }

    private void flash(HttpServletRequest req, String type, String msg) {
        req.getSession(true).setAttribute("flash_" + type, msg);
    }
}
