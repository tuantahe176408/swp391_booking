<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
            <i class="fa-solid fa-users-gear me-2"></i> Quản lý Người dùng
        </a>
        <a class="nav-link ${activeTab == 'approvals' ? 'active bg-danger text-white' : 'text-dark'}" href="${pageContext.request.contextPath}/admin/approvals">
            <i class="fa-solid fa-square-check me-2"></i> Duyệt Homestay
        </a>
        <a class="nav-link ${activeTab == 'config' ? 'active bg-danger text-white' : 'text-dark'}" href="${pageContext.request.contextPath}/admin/config">
            <i class="fa-solid fa-sliders me-2"></i> Cấu hình Hệ thống
        </a>
        <a class="nav-link ${activeTab == 'analytics' ? 'active bg-danger text-white' : 'text-dark'}" href="${pageContext.request.contextPath}/admin/analytics">
            <i class="fa-solid fa-chart-line me-2"></i> Phân tích Tài chính
        </a>
        <a class="nav-link ${activeTab == 'vouchers' ? 'active bg-danger text-white' : 'text-dark'}" href="${pageContext.request.contextPath}/admin/vouchers">
            <i class="fa-solid fa-ticket me-2"></i> Chiến dịch Vouchers
        </a>
        <a class="nav-link ${activeTab == 'tests' ? 'active bg-danger text-white' : 'text-dark'}" href="${pageContext.request.contextPath}/admin/tests">
            <i class="fa-solid fa-vial-circle-check me-2"></i> Kiểm thử Tích hợp (Tests)
        </a>
    </div>
</div>
