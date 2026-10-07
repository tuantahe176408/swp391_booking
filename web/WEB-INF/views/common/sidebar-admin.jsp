<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<aside class="owner-sidebar admin-sidebar">
    <!-- Brand -->
    <div class="owner-sidebar__brand">
        <div class="owner-sidebar__brand-icon" style="background:rgba(220,38,38,.25); color:#fca5a5;">
            <i class="fa-solid fa-user-shield"></i>
        </div>
        <div class="owner-sidebar__brand-text">
            <span class="owner-sidebar__brand-title">Portal Quản Trị</span>
            <span class="owner-sidebar__brand-sub">Smart Booking Platform</span>
        </div>
    </div>

    <!-- Profile -->
    <a href="${pageContext.request.contextPath}/profile" class="owner-sidebar__profile text-decoration-none" title="Xem hồ sơ cá nhân">
        <c:choose>
            <c:when test="${not empty sessionScope.currentUser.avatarUrl}">
                <img src="${sessionScope.currentUser.avatarUrl}"
                     class="owner-sidebar__avatar" alt="Avatar"
                     onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/images/default-avatar.svg';">
            </c:when>
            <c:otherwise>
                <div class="owner-sidebar__avatar-fallback" style="background:#dc2626;">
                    ${not empty sessionScope.currentUser ? sessionScope.currentUser.fullName.substring(0,1).toUpperCase() : 'A'}
                </div>
            </c:otherwise>
        </c:choose>
        <div class="owner-sidebar__profile-info">
            <span class="owner-sidebar__profile-name">
                ${not empty sessionScope.currentUser ? sessionScope.currentUser.fullName : 'Admin'}
            </span>
            <span class="owner-sidebar__profile-role">
                <i class="fa-solid fa-circle-check me-1" style="color:#34d399;font-size:.65rem;"></i>Quản trị viên
            </span>
        </div>
    </a>

    <!-- Nav -->
    <nav class="owner-sidebar__nav">
        <div class="owner-sidebar__group-label">Quản lý Người dùng &amp; Nội dung</div>

        <a class="owner-sidebar__link ${activeTab == 'users' ? 'is-active' : ''}"
           href="${pageContext.request.contextPath}/admin/users">
            <span class="owner-sidebar__link-icon"><i class="fa-solid fa-users-gear"></i></span>
            <span class="owner-sidebar__link-text">Quản lý Người dùng</span>
            <c:if test="${activeTab == 'users'}"><span class="owner-sidebar__link-dot"></span></c:if>
        </a>

        <a class="owner-sidebar__link ${activeTab == 'approvals' ? 'is-active' : ''}"
           href="${pageContext.request.contextPath}/admin/approvals">
            <span class="owner-sidebar__link-icon"><i class="fa-solid fa-house-circle-check"></i></span>
            <span class="owner-sidebar__link-text">Duyệt Homestay</span>
            <c:if test="${activeTab == 'approvals'}"><span class="owner-sidebar__link-dot"></span></c:if>
        </a>

        <a class="owner-sidebar__link ${activeTab == 'vouchers' ? 'is-active' : ''}"
           href="${pageContext.request.contextPath}/admin/vouchers">
            <span class="owner-sidebar__link-icon"><i class="fa-solid fa-ticket"></i></span>
            <span class="owner-sidebar__link-text">Chiến dịch Vouchers</span>
            <c:if test="${activeTab == 'vouchers'}"><span class="owner-sidebar__link-dot"></span></c:if>
        </a>

        <a class="owner-sidebar__link ${activeTab == 'contacts' ? 'is-active' : ''}"
           href="${pageContext.request.contextPath}/admin/contacts">
            <span class="owner-sidebar__link-icon"><i class="fa-solid fa-inbox"></i></span>
            <span class="owner-sidebar__link-text">Tin nhắn Liên hệ</span>
            <c:if test="${activeTab == 'contacts'}"><span class="owner-sidebar__link-dot"></span></c:if>
        </a>

        <div class="owner-sidebar__group-label">Hệ thống &amp; Phân tích</div>

        <a class="owner-sidebar__link ${activeTab == 'analytics' ? 'is-active' : ''}"
           href="${pageContext.request.contextPath}/admin/analytics">
            <span class="owner-sidebar__link-icon"><i class="fa-solid fa-chart-line"></i></span>
            <span class="owner-sidebar__link-text">Phân tích Tài chính</span>
            <c:if test="${activeTab == 'analytics'}"><span class="owner-sidebar__link-dot"></span></c:if>
        </a>

        <%-- DEFERRED UC24: Cấu hình Hệ thống tạm ẩn
        <a class="owner-sidebar__link ${activeTab == 'config' ? 'is-active' : ''}"
           href="${pageContext.request.contextPath}/admin/config">
            <span class="owner-sidebar__link-icon"><i class="fa-solid fa-sliders"></i></span>
            <span class="owner-sidebar__link-text">Cấu hình Hệ thống</span>
            <c:if test="${activeTab == 'config'}"><span class="owner-sidebar__link-dot"></span></c:if>
        </a>
        --%>

        <%-- REMOVED: Kiểm thử Tích hợp đã bị xóa khỏi scope
        <a class="owner-sidebar__link ${activeTab == 'tests' ? 'is-active' : ''}"
           href="${pageContext.request.contextPath}/admin/tests">
            <span class="owner-sidebar__link-icon"><i class="fa-solid fa-vial-circle-check"></i></span>
            <span class="owner-sidebar__link-text">Kiểm thử Tích hợp</span>
            <c:if test="${activeTab == 'tests'}"><span class="owner-sidebar__link-dot"></span></c:if>
        </a>
        --%>
    </nav>

    <!-- Footer -->
    <div class="owner-sidebar__footer d-flex flex-column gap-2">
        <a href="${pageContext.request.contextPath}/home" class="owner-sidebar__back-link" title="Xem giao diện khách du lịch">
            <i class="fa-solid fa-house me-2"></i>Trang Khách Hàng
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="owner-sidebar__logout-link">
            <i class="fa-solid fa-right-from-bracket me-2"></i>Đăng xuất
        </a>
    </div>
</aside>
