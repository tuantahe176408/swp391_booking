package com.project.controller.admin;

import com.project.dao.ContactDAO;
import com.project.dao.ContactDAOImpl;
import com.project.model.ContactMessage;
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
 * Controller: Admin — Quản lý đơn liên hệ / hỗ trợ
 * GET  /admin/contacts              — danh sách, filter
 * POST /admin/contacts?action=resolve — đánh dấu đã/chưa xử lý
 */
@WebServlet(name = "AdminContactController", urlPatterns = {"/admin/contacts"})
public class AdminContactController extends HttpServlet {

    private static final int PAGE_SIZE = 15;
    private final ContactDAO contactDAO = new ContactDAOImpl();

    // ── GET ───────────────────────────────────────────────────────────────────

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User admin = requireAdmin(request, response);
        if (admin == null) return;

        // Filter: null=tất cả, true=đã xử lý, false=chưa xử lý
        String filterParam = request.getParameter("filter");
        Boolean resolved = null;
        if ("pending".equals(filterParam))  resolved = false;
        if ("resolved".equals(filterParam)) resolved = true;

        int page   = parseIntSafe(request.getParameter("page"), 1);
        int offset = (page - 1) * PAGE_SIZE;

        List<ContactMessage> messages = contactDAO.getMessages(resolved, offset, PAGE_SIZE);
        int total      = contactDAO.countMessages(resolved);
        int totalPages = (total == 0) ? 1 : (int) Math.ceil((double) total / PAGE_SIZE);

        // Counts for filter tabs
        int countAll      = contactDAO.countMessages(null);
        int countPending  = contactDAO.countMessages(false);
        int countResolved = contactDAO.countMessages(true);

        request.setAttribute("messages",      messages);
        request.setAttribute("total",         total);
        request.setAttribute("currentPage",   page);
        request.setAttribute("totalPages",    totalPages);
        request.setAttribute("filterParam",   filterParam != null ? filterParam : "all");
        request.setAttribute("countAll",      countAll);
        request.setAttribute("countPending",  countPending);
        request.setAttribute("countResolved", countResolved);
        request.setAttribute("activeTab",     "contacts");
        request.setAttribute("pageTitle",     "Quản lý Liên hệ - Admin");

        request.getRequestDispatcher("/WEB-INF/views/admin/contact-list.jsp")
               .forward(request, response);
    }

    // ── POST: toggle resolved ─────────────────────────────────────────────────

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User admin = requireAdmin(request, response);
        if (admin == null) return;

        int     messageId = parseIntSafe(request.getParameter("messageId"), 0);
        boolean resolve   = "true".equals(request.getParameter("resolve"));
        String  filter    = request.getParameter("filter");
        String  page      = request.getParameter("page");

        if (messageId > 0) {
            boolean ok = contactDAO.setResolved(messageId, resolve, admin.getUserId());
            HttpSession session = request.getSession(true);
            if (ok) {
                session.setAttribute("adminSuccessMessage",
                    resolve ? "Đã đánh dấu xử lý xong." : "Đã đánh dấu chưa xử lý.");
            } else {
                session.setAttribute("adminErrorMessage", "Cập nhật thất bại. Vui lòng thử lại.");
            }
        }

        // Redirect back giữ filter + page
        String redirect = request.getContextPath() + "/admin/contacts";
        if (filter != null && !filter.isEmpty()) redirect += "?filter=" + filter;
        if (page   != null && !page.isEmpty())   redirect += (redirect.contains("?") ? "&" : "?") + "page=" + page;
        response.sendRedirect(redirect);
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    private User requireAdmin(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        User u = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (u == null) { res.sendRedirect(req.getContextPath() + "/login"); return null; }
        if (u.getRole() != User.Role.ADMIN) { res.sendError(403); return null; }
        return u;
    }

    private int parseIntSafe(String s, int def) {
        try { return (s != null) ? Integer.parseInt(s.trim()) : def; }
        catch (NumberFormatException e) { return def; }
    }
}
