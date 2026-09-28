<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<aside class="owner-sidebar">
    <!-- Brand / Portal Header -->
    <div class="owner-sidebar__brand">
        <div class="owner-sidebar__brand-icon">
            <i class="fa-solid fa-house-user"></i>
        </div>
        <div class="owner-sidebar__brand-text">
            <span class="owner-sidebar__brand-title">Portal Chủ Nhà</span>
            <span class="owner-sidebar__brand-sub">Smart Booking Platform</span>
        </div>
    </div>

    <!-- Owner Profile Pill -->
    <div class="owner-sidebar__profile">
        <c:choose>
            <c:when test="${not empty sessionScope.currentUser.avatarUrl}">
                <img src="${sessionScope.currentUser.avatarUrl}"
                     class="owner-sidebar__avatar"
                     alt="Avatar"
                     onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/images/default-avatar.svg';">
            </c:when>
            <c:otherwise>
                <div class="owner-sidebar__avatar-fallback">
                    ${not empty sessionScope.currentUser ? sessionScope.currentUser.fullName.substring(0,1).toUpperCase() : 'O'}
                </div>
            </c:otherwise>
        </c:choose>
        <div class="owner-sidebar__profile-info">
            <span class="owner-sidebar__profile-name">
                ${not empty sessionScope.currentUser ? sessionScope.currentUser.fullName : 'Chủ Nhà'}
            </span>
            <span class="owner-sidebar__profile-role">
                <i class="fa-solid fa-circle-check me-1" style="color:#34d399;font-size:.65rem;"></i>Chủ nhà xác minh
            </span>
        </div>
    </div>

    <!-- Nav Groups -->
    <nav class="owner-sidebar__nav">

        <!-- Group: Quản lý Tài sản -->
        <div class="owner-sidebar__group-label">Quản lý Tài sản</div>

        <a class="owner-sidebar__link ${activeTab == 'homestays' || activeTab == 'rooms' ? 'is-active' : ''}"
           href="${pageContext.request.contextPath}/owner/homestays">
            <span class="owner-sidebar__link-icon">
                <i class="fa-solid fa-building-user"></i>
            </span>
            <span class="owner-sidebar__link-text">Cơ sở Homestay</span>
            <c:if test="${activeTab == 'homestays' || activeTab == 'rooms'}">
                <span class="owner-sidebar__link-dot"></span>
            </c:if>
        </a>
        <a class="owner-sidebar__link ${activeTab == 'calendar' ? 'is-active' : ''}"
           href="${pageContext.request.contextPath}/owner/calendar">
            <span class="owner-sidebar__link-icon">
                <i class="fa-regular fa-calendar-days"></i>
            </span>
            <span class="owner-sidebar__link-text">Lịch &amp; Giá phòng</span>
            <c:if test="${activeTab == 'calendar'}">
                <span class="owner-sidebar__link-dot"></span>
            </c:if>
        </a>

        <a class="owner-sidebar__link ${activeTab == 'addons' ? 'is-active' : ''}"
           href="${pageContext.request.contextPath}/owner/addons">
            <span class="owner-sidebar__link-icon">
                <i class="fa-solid fa-bell-concierge"></i>
            </span>
            <span class="owner-sidebar__link-text">Dịch vụ Bổ sung</span>
            <c:if test="${activeTab == 'addons'}">
                <span class="owner-sidebar__link-dot"></span>
            </c:if>
        </a>

        <!-- Group: Vận hành & Báo cáo -->
        <div class="owner-sidebar__group-label">Vận hành &amp; Báo cáo</div>

        <a class="owner-sidebar__link ${activeTab == 'bookings' ? 'is-active' : ''}"
           href="${pageContext.request.contextPath}/owner/bookings">
            <span class="owner-sidebar__link-icon">
                <i class="fa-solid fa-list-check"></i>
            </span>
            <span class="owner-sidebar__link-text">Đơn đặt phòng</span>
            <c:if test="${activeTab == 'bookings'}">
                <span class="owner-sidebar__link-dot"></span>
            </c:if>
        </a>

        <a class="owner-sidebar__link ${activeTab == 'analytics' ? 'is-active' : ''}"
           href="${pageContext.request.contextPath}/owner/analytics">
            <span class="owner-sidebar__link-icon">
                <i class="fa-solid fa-chart-pie"></i>
            </span>
            <span class="owner-sidebar__link-text">Doanh thu &amp; Thống kê</span>
            <c:if test="${activeTab == 'analytics'}">
                <span class="owner-sidebar__link-dot"></span>
            </c:if>
        </a>

        <a class="owner-sidebar__link ${activeTab == 'staffs' ? 'is-active' : ''}"
           href="${pageContext.request.contextPath}/owner/staffs">
            <span class="owner-sidebar__link-icon">
                <i class="fa-solid fa-user-gear"></i>
            </span>
            <span class="owner-sidebar__link-text">Nhân viên Lễ tân</span>
            <c:if test="${activeTab == 'staffs'}">
                <span class="owner-sidebar__link-dot"></span>
            </c:if>
        </a>

    </nav>

    <!-- Footer: Back to Site -->
    <div class="owner-sidebar__footer">
        <a href="${pageContext.request.contextPath}/home" class="owner-sidebar__back-link">
            <i class="fa-solid fa-arrow-left me-2"></i>Về trang khách hàng
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="owner-sidebar__logout-link">
            <i class="fa-solid fa-right-from-bracket me-2"></i>Đăng xuất
        </a>
    </div>
</aside>
