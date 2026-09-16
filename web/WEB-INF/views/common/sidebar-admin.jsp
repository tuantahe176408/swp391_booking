<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<div class="card border-0 shadow-sm rounded-4 p-3 mb-4">
    <div class="d-flex align-items-center gap-3 pb-3 border-bottom mb-3">
        <div class="rounded-circle bg-danger-subtle text-danger p-3 d-flex align-items-center justify-content-center" style="width: 48px; height: 48px;">
            <i class="fa-solid fa-user-shield fs-4"></i>
        </div>
        <div>
            <h6 class="fw-bold mb-0 text-dark">Hệ thống Admin</h6>
            <small class="text-muted">Quản trị toàn hệ thống</small>
        </div>
    </div>
    <div class="nav flex-column nav-pills gap-1">
        <a class="nav-link ${activeTab == 'users' ? 'active bg-danger text-white' : 'text-dark'}" href="${pageContext.request.contextPath}/admin/users">
            <i class="fa-solid fa-users-gear me-2"></i> UC22: Quản lý Người dùng
        </a>
        <a class="nav-link ${activeTab == 'approvals' ? 'active bg-danger text-white' : 'text-dark'}" href="${pageContext.request.contextPath}/admin/approvals">
            <i class="fa-solid fa-square-check me-2"></i> UC23: Duyệt Đăng ký Homestay
        </a>
        <a class="nav-link ${activeTab == 'config' ? 'active bg-danger text-white' : 'text-dark'}" href="${pageContext.request.contextPath}/admin/config">
            <i class="fa-solid fa-sliders me-2"></i> UC24: Cấu hình System & AI
        </a>
        <a class="nav-link ${activeTab == 'analytics' ? 'active bg-danger text-white' : 'text-dark'}" href="${pageContext.request.contextPath}/admin/analytics">
            <i class="fa-solid fa-chart-line me-2"></i> UC25: Phân tích Tài chính
        </a>
        <a class="nav-link ${activeTab == 'vouchers' ? 'active bg-danger text-white' : 'text-dark'}" href="${pageContext.request.contextPath}/admin/vouchers">
            <i class="fa-solid fa-ticket me-2"></i> UC26: Chiến dịch Vouchers
        </a>
    </div>
</div>
