<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<div class="card border-0 shadow-sm rounded-4 p-3 mb-4">
    <div class="d-flex align-items-center gap-3 pb-3 border-bottom mb-3">
        <div class="rounded-circle bg-primary-subtle text-primary p-3 d-flex align-items-center justify-content-center" style="width: 48px; height: 48px;">
            <i class="fa-solid fa-house-user fs-4"></i>
        </div>
        <div>
            <h6 class="fw-bold mb-0 text-dark">Portal Chủ Nhà</h6>
            <small class="text-muted">Quản lý Homestay & Doanh thu</small>
        </div>
    </div>
    <div class="nav flex-column nav-pills gap-1">
        <a class="nav-link ${activeTab == 'homestays' ? 'active bg-primary text-white' : 'text-dark'}" href="${pageContext.request.contextPath}/owner/homestays">
            <i class="fa-solid fa-building-user me-2"></i> UC17: Quản lý Danh mục Homestay
        </a>
        <a class="nav-link ${activeTab == 'calendar' ? 'active bg-primary text-white' : 'text-dark'}" href="${pageContext.request.contextPath}/owner/calendar">
            <i class="fa-regular fa-calendar-days me-2"></i> UC18: Lịch & Giá Linh hoạt
        </a>
        <a class="nav-link ${activeTab == 'addons' ? 'active bg-primary text-white' : 'text-dark'}" href="${pageContext.request.contextPath}/owner/addons">
            <i class="fa-solid fa-bell-concierge me-2"></i> UC19: Dịch vụ Bổ sung
        </a>
        <a class="nav-link ${activeTab == 'analytics' ? 'active bg-primary text-white' : 'text-dark'}" href="${pageContext.request.contextPath}/owner/analytics">
            <i class="fa-solid fa-chart-pie me-2"></i> UC20: Báo cáo Doanh thu & Rate
        </a>
        <a class="nav-link ${activeTab == 'staffs' ? 'active bg-primary text-white' : 'text-dark'}" href="${pageContext.request.contextPath}/owner/staffs">
            <i class="fa-solid fa-user-gear me-2"></i> UC21: Quản lý Nhân viên Lễ tân
        </a>
    </div>
</div>
