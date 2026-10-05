package com.project.controller.admin;

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
import java.util.List;

/**
 * Controller: Approve Homestay Registration Listings (UC23)
 * Package: com.project.controller.admin
 */
@WebServlet(name = "AdminApprovalController", urlPatterns = {"/admin/approvals"})
public class AdminApprovalController extends HttpServlet {

    private HomestayDAO homestayDAO;

    @Override
    public void init() throws ServletException {
        this.homestayDAO = new HomestayDAOImpl();
    }

    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null || currentUser.getRole() != User.Role.ADMIN) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Admin Privilege Required");
            return;
        }

        // Parse search & filter parameters
        String keyword = request.getParameter("keyword");
        String status  = request.getParameter("status");
        String city    = request.getParameter("city");
        String pageStr = request.getParameter("page");

        if (keyword != null && keyword.trim().isEmpty()) keyword = null;
        if (city != null && city.trim().isEmpty()) city = null;

        // Default to PENDING_APPROVAL unless explicitly set
        if (status == null || status.trim().isEmpty()) {
            status = "PENDING_APPROVAL";
        }

        int page = 1;
        if (pageStr != null) {
            try {
                page = Math.max(1, Integer.parseInt(pageStr.trim()));
            } catch (NumberFormatException ignored) {}
        }
        int offset = (page - 1) * PAGE_SIZE;

        List<Homestay> homestayList = homestayDAO.findAdminHomestays(keyword, status, city, offset, PAGE_SIZE);
        int totalRows    = homestayDAO.countAdminHomestays(keyword, status, city);
        int pendingCount = homestayDAO.countAdminHomestays(null, "PENDING_APPROVAL", null);
        int totalPages   = (totalRows == 0) ? 1 : (int) Math.ceil((double) totalRows / PAGE_SIZE);
        List<String> allCities = homestayDAO.getAllCities();

        request.setAttribute("pendingList",    homestayList);
        request.setAttribute("pendingCount",   pendingCount);
        request.setAttribute("totalRows",      totalRows);
        request.setAttribute("totalPages",     totalPages);
        request.setAttribute("currentPage",    page);
        request.setAttribute("pageSize",       PAGE_SIZE);
        request.setAttribute("allCities",      allCities);

        // Retain filter state
        request.setAttribute("filterKeyword",  keyword);
        request.setAttribute("filterStatus",   status);
        request.setAttribute("filterCity",     city);

        request.setAttribute("activeTab",      "approvals");
        request.setAttribute("pageTitle",      "Admin - Duyệt Homestay Đăng ký");
        request.getRequestDispatcher("/WEB-INF/views/admin/approval-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null || currentUser.getRole() != User.Role.ADMIN) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Admin Privilege Required");
            return;
        }

        String action        = request.getParameter("action");
        String homestayIdStr = request.getParameter("homestayId");
        String reason        = request.getParameter("rejectionReason");

        if (homestayIdStr == null || homestayIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/approvals");
            return;
        }

        int homestayId = Integer.parseInt(homestayIdStr.trim());

        if ("approve".equals(action)) {
            homestayDAO.adminUpdateHomestayStatus(homestayId, Homestay.Status.ACTIVE, null);
            session.setAttribute("adminSuccessMessage", "Đã phê duyệt homestay thành công!");
        } else if ("reject".equals(action)) {
            String safeReason = (reason != null && !reason.trim().isEmpty())
                    ? reason.trim() : "Không đạt tiêu chuẩn đăng ký.";
            homestayDAO.adminUpdateHomestayStatus(homestayId, Homestay.Status.REJECTED, safeReason);
            session.setAttribute("adminSuccessMessage", "Đã từ chối và thông báo lý do cho chủ nhà.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/approvals");
    }
}
