package com.project.controller.owner;

import com.project.dao.HomestayDAO;
import com.project.dao.HomestayDAOImpl;
import com.project.model.Homestay;
import com.project.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Time;
import java.util.Optional;

/**
 * Controller: Edit homestay info (UC17) + Toggle ACTIVE/INACTIVE status
 * GET  /owner/homestays/edit?id=X  — load form
 * POST /owner/homestays/edit       — save changes
 * POST /owner/homestays/toggle     — toggle ACTIVE ↔ INACTIVE
 * Package: com.project.controller.owner
 */
@WebServlet(name = "OwnerHomestayEditController",
            urlPatterns = {"/owner/homestays/edit", "/owner/homestays/toggle", "/owner/homestays/new"})
public class OwnerHomestayEditController extends HttpServlet {

    private final HomestayDAO homestayDAO = new HomestayDAOImpl();

    // ── GET: load edit form ───────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = currentUser(request, response);
        if (currentUser == null) return;

        String uri = request.getRequestURI();

        if (uri.endsWith("/new")) {
            // Empty form for new homestay
            request.setAttribute("homestay",     new Homestay());
            request.setAttribute("isNew",        true);
            request.setAttribute("activeTab",    "homestays");
            request.setAttribute("pageTitle",    "Đăng ký Homestay mới");
            request.setAttribute("pageBreadcrumb", "Quản lý Tài sản");
            request.getRequestDispatcher("/WEB-INF/views/owner/homestay-edit.jsp")
                   .forward(request, response);
            return;
        }

        // Edit existing
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/owner/homestays");
            return;
        }
        int homestayId;
        try { homestayId = Integer.parseInt(idParam); }
        catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/owner/homestays");
            return;
        }

        Optional<Homestay> opt = homestayDAO.getHomestayById(homestayId);
        if (opt.isEmpty() || opt.get().getOwnerId() != currentUser.getUserId()) {
            response.sendRedirect(request.getContextPath() + "/owner/homestays");
            return;
        }

        request.setAttribute("homestay",     opt.get());
        request.setAttribute("isNew",        false);
        request.setAttribute("activeTab",    "homestays");
        request.setAttribute("pageTitle",    "Chỉnh sửa Homestay");
        request.setAttribute("pageBreadcrumb", "Quản lý Tài sản");
        request.getRequestDispatcher("/WEB-INF/views/owner/homestay-edit.jsp")
               .forward(request, response);
    }

    // ── POST: save or toggle ──────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        User currentUser = currentUser(request, response);
        if (currentUser == null) return;

        String uri = request.getRequestURI();

        // ── Toggle ACTIVE ↔ INACTIVE ─────────────────────────────────────────
        if (uri.endsWith("/toggle")) {
            int hsId   = parseIntSafe(request.getParameter("homestayId"), 0);
            String act = request.getParameter("action"); // "activate" | "deactivate"
            if (hsId > 0 && act != null) {
                Homestay.Status newStatus = "activate".equals(act)
                        ? Homestay.Status.ACTIVE
                        : Homestay.Status.INACTIVE;
                homestayDAO.updateHomestayStatus(hsId, currentUser.getUserId(), newStatus);
            }
            response.sendRedirect(request.getContextPath() + "/owner/homestays");
            return;
        }

        // ── Save edit ────────────────────────────────────────────────────────
        int hsId = parseIntSafe(request.getParameter("homestayId"), 0);
        if (hsId == 0) {
            response.sendRedirect(request.getContextPath() + "/owner/homestays");
            return;
        }

        // Security: ensure ownership
        Optional<Homestay> opt = homestayDAO.getHomestayById(hsId);
        if (opt.isEmpty() || opt.get().getOwnerId() != currentUser.getUserId()) {
            response.sendRedirect(request.getContextPath() + "/owner/homestays");
            return;
        }

        Homestay hs = opt.get();
        hs.setName(sanitize(request.getParameter("name")));
        hs.setDescription(sanitize(request.getParameter("description")));
        hs.setAddress(sanitize(request.getParameter("address")));
        hs.setCity(sanitize(request.getParameter("city")));
        hs.setDistrict(sanitize(request.getParameter("district")));

        // checkin / checkout time
        String ci = request.getParameter("checkinTime");
        String co = request.getParameter("checkoutTime");
        try { if (ci != null && !ci.isEmpty()) hs.setCheckinTime(Time.valueOf(ci + ":00")); } catch (Exception ignored) {}
        try { if (co != null && !co.isEmpty()) hs.setCheckoutTime(Time.valueOf(co + ":00")); } catch (Exception ignored) {}

        boolean ok = homestayDAO.updateHomestay(hs);

        if (ok) {
            request.getSession().setAttribute("flash_success",
                    "Cập nhật thông tin homestay thành công!" +
                    (opt.get().getStatus() == Homestay.Status.REJECTED
                            ? " Cơ sở đã được gửi lại để Admin xét duyệt." : ""));
        } else {
            request.getSession().setAttribute("flash_error", "Cập nhật thất bại. Vui lòng thử lại.");
        }
        response.sendRedirect(request.getContextPath() + "/owner/homestays");
    }

    // ── Helpers ───────────────────────────────────────────────────────────────
    private User currentUser(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        User u = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (u == null) { res.sendRedirect(req.getContextPath() + "/login"); return null; }
        return u;
    }
    private int parseIntSafe(String s, int def) {
        try { return Integer.parseInt(s.trim()); } catch (Exception e) { return def; }
    }
    private String sanitize(String s) {
        return (s == null) ? "" : s.trim();
    }
}
