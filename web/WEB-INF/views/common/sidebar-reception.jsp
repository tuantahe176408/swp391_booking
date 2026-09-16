<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<div class="card border-0 shadow-sm rounded-4 p-3 mb-4">
    <div class="d-flex align-items-center gap-3 pb-3 border-bottom mb-3">
        <div class="rounded-circle bg-info-subtle text-info p-3 d-flex align-items-center justify-content-center" style="width: 48px; height: 48px;">
            <i class="fa-solid fa-concierge-bell fs-4"></i>
        </div>
        <div>
            <h6 class="fw-bold mb-0 text-dark">Bàn Lễ Tân</h6>
            <small class="text-muted">Đón tiếp & Quản lý Phòng</small>
        </div>
    </div>
    <div class="nav flex-column nav-pills gap-1">
        <a class="nav-link ${activeTab == 'checkin' ? 'active bg-info text-white' : 'text-dark'}" href="${pageContext.request.contextPath}/reception/checkin">
            <i class="fa-solid fa-passport me-2"></i> UC12: Check-in / Out & Scan OCR
        </a>
        <a class="nav-link ${activeTab == 'matrix' ? 'active bg-info text-white' : 'text-dark'}" href="${pageContext.request.contextPath}/reception/matrix">
            <i class="fa-solid fa-table-cells me-2"></i> UC14: Ma trận Trạng thái Phòng
        </a>
        <a class="nav-link ${activeTab == 'walkin' ? 'active bg-info text-white' : 'text-dark'}" href="${pageContext.request.contextPath}/reception/walk-in">
            <i class="fa-solid fa-person-walking-luggage me-2"></i> UC13: Đặt phòng Khách Vãng lai
        </a>
        <a class="nav-link ${activeTab == 'housekeeping' ? 'active bg-info text-white' : 'text-dark'}" href="${pageContext.request.contextPath}/reception/daily-report">
            <i class="fa-solid fa-broom me-2"></i> UC16: Báo cáo Tạm trú & Dọn dẹp
        </a>
    </div>
</div>
