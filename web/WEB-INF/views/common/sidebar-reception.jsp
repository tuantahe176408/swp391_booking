<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<aside class="owner-sidebar reception-sidebar">
    <!-- Brand -->
    <div class="owner-sidebar__brand">
        <div class="owner-sidebar__brand-icon" style="background:rgba(8,145,178,.25); color:#67e8f9;">
            <i class="fa-solid fa-concierge-bell"></i>
        </div>
        <div class="owner-sidebar__brand-text">
            <span class="owner-sidebar__brand-title">Bàn Lễ Tân</span>
            <span class="owner-sidebar__brand-sub">Smart Booking Platform</span>
        </div>
    </div>

    <!-- Profile -->
    <div class="owner-sidebar__profile">
        <c:choose>
            <c:when test="${not empty sessionScope.currentUser.avatarUrl}">
                <img src="${sessionScope.currentUser.avatarUrl}"
                     class="owner-sidebar__avatar" alt="Avatar"
                     onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/images/default-avatar.svg';">
            </c:when>
            <c:otherwise>
                <div class="owner-sidebar__avatar-fallback" style="background:#0891b2;">
                    ${not empty sessionScope.currentUser ? sessionScope.currentUser.fullName.substring(0,1).toUpperCase() : 'R'}
                </div>
            </c:otherwise>
        </c:choose>
        <div class="owner-sidebar__profile-info">
            <span class="owner-sidebar__profile-name">
                ${not empty sessionScope.currentUser ? sessionScope.currentUser.fullName : 'Lễ Tân'}
            </span>
            <span class="owner-sidebar__profile-role">
                <i class="fa-solid fa-circle-check me-1" style="color:#34d399;font-size:.65rem;"></i>Lễ tân xác minh
            </span>
        </div>
    </div>

    <!-- Nav -->
    <nav class="owner-sidebar__nav">
        <div class="owner-sidebar__group-label">Đón tiếp &amp; Quản lý Phòng</div>

        <a class="owner-sidebar__link ${activeTab == 'checkin' ? 'is-active' : ''}"
           href="${pageContext.request.contextPath}/reception/checkin">
            <span class="owner-sidebar__link-icon"><i class="fa-solid fa-passport"></i></span>
            <span class="owner-sidebar__link-text">Check-in / Out &amp; Scan OCR</span>
            <c:if test="${activeTab == 'checkin'}"><span class="owner-sidebar__link-dot"></span></c:if>
        </a>

        <a class="owner-sidebar__link ${activeTab == 'matrix' ? 'is-active' : ''}"
           href="${pageContext.request.contextPath}/reception/matrix">
            <span class="owner-sidebar__link-icon"><i class="fa-solid fa-table-cells"></i></span>
            <span class="owner-sidebar__link-text">Ma trận Trạng thái Phòng</span>
            <c:if test="${activeTab == 'matrix'}"><span class="owner-sidebar__link-dot"></span></c:if>
        </a>

        <a class="owner-sidebar__link ${activeTab == 'walkin' ? 'is-active' : ''}"
           href="${pageContext.request.contextPath}/reception/walk-in">
            <span class="owner-sidebar__link-icon"><i class="fa-solid fa-person-walking-luggage"></i></span>
            <span class="owner-sidebar__link-text">Đặt phòng Khách Vãng lai</span>
            <c:if test="${activeTab == 'walkin'}"><span class="owner-sidebar__link-dot"></span></c:if>
        </a>

        <div class="owner-sidebar__group-label">Báo cáo &amp; Vệ sinh</div>

        <a class="owner-sidebar__link ${activeTab == 'housekeeping' || activeTab == 'report' ? 'is-active' : ''}"
           href="${pageContext.request.contextPath}/reception/daily-report">
            <span class="owner-sidebar__link-icon"><i class="fa-solid fa-broom"></i></span>
            <span class="owner-sidebar__link-text">Báo cáo Tạm trú &amp; Dọn dẹp</span>
            <c:if test="${activeTab == 'housekeeping' || activeTab == 'report'}"><span class="owner-sidebar__link-dot"></span></c:if>
        </a>
    </nav>

    <!-- Footer -->
    <div class="owner-sidebar__footer">
        <a href="${pageContext.request.contextPath}/logout" class="owner-sidebar__logout-link">
            <i class="fa-solid fa-right-from-bracket me-2"></i>Đăng xuất
        </a>
    </div>
</aside>
