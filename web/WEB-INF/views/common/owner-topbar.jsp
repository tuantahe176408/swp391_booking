<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  owner-topbar.jsp — Top header bar for Owner Dashboard
  Usage: set request attribute "pageTitle" and "pageBreadcrumb" before including.
  Example:
    request.setAttribute("pageTitle", "Cơ sở Homestay");
    request.setAttribute("pageBreadcrumb", "Quản lý Tài sản");
--%>
<header class="owner-topbar">
    <div class="owner-topbar__left">
        <!-- Breadcrumb -->
        <nav class="owner-topbar__breadcrumb" aria-label="breadcrumb">
            <span class="owner-topbar__breadcrumb-root">
                <i class="fa-solid fa-gauge-high me-1"></i>Dashboard
            </span>
            <c:if test="${not empty pageBreadcrumb}">
                <i class="fa-solid fa-chevron-right owner-topbar__breadcrumb-sep"></i>
                <span class="owner-topbar__breadcrumb-group">${pageBreadcrumb}</span>
            </c:if>
            <c:if test="${not empty pageTitle}">
                <i class="fa-solid fa-chevron-right owner-topbar__breadcrumb-sep"></i>
                <span class="owner-topbar__breadcrumb-current">${pageTitle}</span>
            </c:if>
        </nav>
        <!-- Page heading -->
        <h1 class="owner-topbar__heading">
            <c:choose>
                <c:when test="${not empty pageTitle}">${pageTitle}</c:when>
                <c:otherwise>Dashboard</c:otherwise>
            </c:choose>
        </h1>
    </div>

    <div class="owner-topbar__right d-flex align-items-center gap-2">
        <!-- Quick Switch to Guest / Home View -->
        <a href="${pageContext.request.contextPath}/home" class="btn btn-sm btn-outline-primary rounded-pill px-3 py-1.5 fw-semibold d-none d-md-inline-flex align-items-center gap-1.5" title="Xem giao diện khách du lịch trên sàn">
            <i class="fa-solid fa-house"></i> Trang Khách Hàng
        </a>

        <!-- User dropdown -->
        <div class="owner-topbar__user-menu dropdown">
            <button class="owner-topbar__user-btn dropdown-toggle" type="button"
                    id="ownerTopbarUser" data-bs-toggle="dropdown" aria-expanded="false">
                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser.avatarUrl}">
                        <img src="${sessionScope.currentUser.avatarUrl}"
                             class="owner-topbar__user-avatar"
                             alt="Avatar"
                             onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/images/default-avatar.svg';">
                    </c:when>
                    <c:otherwise>
                        <div class="owner-topbar__user-initial">
                            ${not empty sessionScope.currentUser ? sessionScope.currentUser.fullName.substring(0,1).toUpperCase() : 'O'}
                        </div>
                    </c:otherwise>
                </c:choose>
                <span class="owner-topbar__user-name">
                    ${not empty sessionScope.currentUser ? sessionScope.currentUser.fullName : 'Chủ Nhà'}
                </span>
            </button>
            <ul class="dropdown-menu dropdown-menu-end shadow-sm owner-topbar__dropdown" aria-labelledby="ownerTopbarUser">
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
                <li>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/owner/homestays">
                        <i class="fa-solid fa-house-user me-2 text-primary"></i>Cơ sở của tôi
                    </a>
                </li>
                <li><hr class="dropdown-divider my-1"></li>
                <%-- Chuyển sang giao diện khách hàng (browse/book như customer bình thường) --%>
                <li>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/home">
                        <i class="fa-solid fa-house me-2 text-primary"></i>Trang Khách Hàng
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
    function initOwnerTopbarDropdowns() {
        document.addEventListener('click', function (e) {
            var toggleBtn = e.target.closest('[data-bs-toggle="dropdown"]');
            if (toggleBtn) {
                e.preventDefault();
                e.stopPropagation();
                var container = toggleBtn.closest('.dropdown');
                if (container) {
                    var menu = container.querySelector('.dropdown-menu');
                    if (menu) {
                        var isShown = menu.classList.contains('show');
                        // close all open dropdowns first
                        document.querySelectorAll('.dropdown-menu.show').forEach(function (m) {
                            m.classList.remove('show');
                        });
                        if (!isShown) {
                            menu.classList.add('show');
                        }
                    }
                }
            } else if (!e.target.closest('.dropdown-menu')) {
                document.querySelectorAll('.dropdown-menu.show').forEach(function (m) {
                    m.classList.remove('show');
                });
            }
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initOwnerTopbarDropdowns);
    } else {
        initOwnerTopbarDropdowns();
    }

    // Mark body so CSS can hide customer footer/navbar on owner pages
    document.documentElement.classList.add('owner-page');
    document.addEventListener('DOMContentLoaded', function () {
        document.body.classList.add('owner-page');
    });
})();
</script>
