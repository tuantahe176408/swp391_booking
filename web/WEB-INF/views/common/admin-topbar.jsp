<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<header class="owner-topbar">
    <div class="owner-topbar__left">
        <nav class="owner-topbar__breadcrumb" aria-label="breadcrumb">
            <span class="owner-topbar__breadcrumb-root">
                <i class="fa-solid fa-user-shield me-1"></i>Quản trị hệ thống
            </span>
            <c:if test="${not empty pageBreadcrumb}">
                <i class="fa-solid fa-chevron-right owner-topbar__breadcrumb-sep"></i>
                <span class="owner-topbar__breadcrumb-group">${pageBreadcrumb}</span>
            </c:if>
            <c:if test="${not empty pageTitle}">
                <i class="fa-solid fa-chevron-right owner-topbar__breadcrumb-sep"></i>
                <span class="owner-topbar__breadcrumb-current" style="color:#dc2626;">${pageTitle}</span>
            </c:if>
        </nav>
        <h1 class="owner-topbar__heading">
            <c:choose>
                <c:when test="${not empty pageTitle}">${pageTitle}</c:when>
                <c:otherwise>Admin Dashboard</c:otherwise>
            </c:choose>
        </h1>
    </div>

    <div class="owner-topbar__right d-flex align-items-center gap-2">
        <!-- Quick Switch to Guest / Home View -->
        <a href="${pageContext.request.contextPath}/home" class="btn btn-sm btn-outline-danger rounded-pill px-3 py-1.5 fw-semibold d-none d-md-inline-flex align-items-center gap-1.5" title="Xem giao diện khách du lịch trên sàn">
            <i class="fa-solid fa-house"></i> Trang Khách Hàng
        </a>

        <div class="owner-topbar__user-menu dropdown">
            <button class="owner-topbar__user-btn dropdown-toggle" type="button"
                    id="adminTopbarUser" data-bs-toggle="dropdown" aria-expanded="false">
                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser.avatarUrl}">
                        <img src="${sessionScope.currentUser.avatarUrl}"
                             class="owner-topbar__user-avatar" alt="Avatar"
                             onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/images/default-avatar.svg';">
                    </c:when>
                    <c:otherwise>
                        <div class="owner-topbar__user-initial" style="background:#dc2626;">
                            ${not empty sessionScope.currentUser ? sessionScope.currentUser.fullName.substring(0,1).toUpperCase() : 'A'}
                        </div>
                    </c:otherwise>
                </c:choose>
                <span class="owner-topbar__user-name">
                    ${not empty sessionScope.currentUser ? sessionScope.currentUser.fullName : 'Admin'}
                </span>
            </button>
            <ul class="dropdown-menu dropdown-menu-end shadow-sm owner-topbar__dropdown" aria-labelledby="adminTopbarUser">
                <li class="owner-topbar__dropdown-header">
                    <span class="d-block fw-semibold">${not empty sessionScope.currentUser ? sessionScope.currentUser.fullName : ''}</span>
                    <span class="text-muted" style="font-size:.82rem;">${not empty sessionScope.currentUser ? sessionScope.currentUser.email : ''}</span>
                </li>
                <li><hr class="dropdown-divider my-1"></li>
                <li>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
                        <i class="fa-regular fa-user me-2 text-muted"></i>Hồ sơ cá nhân
                    </a>
                </li>
                <li><hr class="dropdown-divider my-1"></li>
                <li>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/home">
                        <i class="fa-solid fa-house me-2 text-danger"></i>Trang Khách Hàng
                    </a>
                </li>
                <li><hr class="dropdown-divider my-1"></li>
                <li>
                    <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
                        <i class="fa-solid fa-right-from-bracket me-2"></i>Đăng xuất
                    </a>
                </li>
            </ul>
        </div>
    </div>
</header>

<script>
(function () {
    function initDropdowns() {
        document.addEventListener('click', function (e) {
            var toggleBtn = e.target.closest('[data-bs-toggle="dropdown"]');
            if (toggleBtn) {
                e.preventDefault(); e.stopPropagation();
                var menu = toggleBtn.closest('.dropdown').querySelector('.dropdown-menu');
                if (menu) {
                    var shown = menu.classList.contains('show');
                    document.querySelectorAll('.dropdown-menu.show').forEach(function(m){ m.classList.remove('show'); });
                    if (!shown) menu.classList.add('show');
                }
            } else if (!e.target.closest('.dropdown-menu')) {
                document.querySelectorAll('.dropdown-menu.show').forEach(function(m){ m.classList.remove('show'); });
            }
        });
    }
    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', initDropdowns);
    else initDropdowns();
    document.documentElement.classList.add('owner-page');
    document.addEventListener('DOMContentLoaded', function(){ document.body.classList.add('owner-page'); });
}());
</script>
