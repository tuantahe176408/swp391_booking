<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<nav class="navbar navbar-expand-lg navbar-custom">
    <div class="container-fluid px-4">
        <a class="navbar-brand d-flex align-items-center me-4" href="${pageContext.request.contextPath}/home">
            <i class="fa-solid fa-hotel me-2 text-primary"></i>
            <span class="fw-bold">Smart Booking</span>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link ${pageContext.request.requestURI.endsWith('/home') || pageContext.request.requestURI.endsWith('/') ? 'active' : ''}" href="${pageContext.request.contextPath}/home">
                        <i class="fa-solid fa-compass me-1"></i> Khám phá
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${pageContext.request.requestURI.contains('/search') || pageContext.request.requestURI.contains('/detail') ? 'active' : ''}" href="${pageContext.request.contextPath}/search">
                        <i class="fa-solid fa-magnifying-glass me-1"></i> Tìm phòng
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${pageContext.request.requestURI.contains('/recommendations') ? 'active' : ''}" href="${pageContext.request.contextPath}/customer/recommendations">
                        <i class="fa-solid fa-wand-magic-sparkles me-1 text-warning"></i> Gợi ý AI <span class="badge bg-danger ms-1">New</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${pageContext.request.requestURI.contains('/about') ? 'active' : ''}" href="${pageContext.request.contextPath}/about">
                        <i class="fa-solid fa-circle-info me-1"></i> Giới thiệu
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${pageContext.request.requestURI.contains('/contact') ? 'active' : ''}" href="${pageContext.request.contextPath}/contact">
                        <i class="fa-solid fa-headset me-1"></i> Liên hệ
                    </a>
                </li>
            </ul>
            <div class="d-flex align-items-center ms-auto">
                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser}">
                        <!-- Clean Single User Profile Dropdown -->
                        <div class="dropdown">
                            <button class="btn btn-light border shadow-sm rounded-pill px-3 py-1.5 dropdown-toggle d-flex align-items-center gap-2" type="button" id="userMenu" data-bs-toggle="dropdown" aria-expanded="false">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.currentUser.avatarUrl}">
                                        <img src="${sessionScope.currentUser.avatarUrl}" class="rounded-circle object-fit-cover" width="30" height="30" alt="Avatar" onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/images/default-avatar.svg';">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center fw-bold" style="width: 30px; height: 30px; font-size: 13px;">
                                            ${sessionScope.currentUser.fullName.substring(0,1).toUpperCase()}
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                <span class="fw-semibold text-dark fs-6">${sessionScope.currentUser.fullName}</span>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end shadow rounded-4 p-2" style="min-width: 240px;" aria-labelledby="userMenu">
                                <li class="px-3 py-2 border-bottom mb-1 bg-light rounded-3">
                                    <div class="fw-bold text-dark">${sessionScope.currentUser.fullName}</div>
                                    <div class="text-muted small">${sessionScope.currentUser.email}</div>
                                    <div class="mt-1">
                                        <c:choose>
                                            <c:when test="${sessionScope.currentUser.role == 'ADMIN'}">
                                                <span class="badge bg-danger-subtle text-danger border border-danger-subtle px-2 py-0.5 rounded-pill"><i class="fa-solid fa-user-shield me-1"></i> Quản trị viên</span>
                                            </c:when>
                                            <c:when test="${sessionScope.currentUser.role == 'OWNER'}">
                                                <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-2 py-0.5 rounded-pill"><i class="fa-solid fa-house-user me-1"></i> Chủ nhà</span>
                                            </c:when>
                                            <c:when test="${sessionScope.currentUser.role == 'RECEPTIONIST'}">
                                                <span class="badge bg-info-subtle text-info border border-info-subtle px-2 py-0.5 rounded-pill"><i class="fa-solid fa-concierge-bell me-1"></i> Lễ tân</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-0.5 rounded-pill"><i class="fa-solid fa-user me-1"></i> Khách hàng</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </li>
                                <li><a class="dropdown-item rounded-2 py-2" href="${pageContext.request.contextPath}/profile"><i class="fa-regular fa-user me-2 text-primary"></i> Hồ sơ cá nhân</a></li>
                                <li><a class="dropdown-item rounded-2 py-2" href="${pageContext.request.contextPath}/customer/wishlist"><i class="fa-solid fa-heart me-2 text-danger"></i> Yêu thích đã lưu</a></li>
                                <li><a class="dropdown-item rounded-2 py-2" href="${pageContext.request.contextPath}/customer/bookings"><i class="fa-solid fa-receipt me-2 text-primary"></i> Đơn đặt phòng</a></li>
                                
                                <c:if test="${sessionScope.currentUser.role == 'ADMIN'}">
                                    <li><hr class="dropdown-divider my-1"></li>
                                    <li><a class="dropdown-item rounded-2 py-2 text-danger fw-semibold bg-danger-subtle" href="${pageContext.request.contextPath}/admin/users"><i class="fa-solid fa-user-shield me-2"></i> Portal Quản Trị</a></li>
                                </c:if>
                                <c:if test="${sessionScope.currentUser.role == 'OWNER'}">
                                    <li><hr class="dropdown-divider my-1"></li>
                                    <li><a class="dropdown-item rounded-2 py-2 text-primary fw-semibold bg-primary-subtle" href="${pageContext.request.contextPath}/owner/homestays"><i class="fa-solid fa-house-user me-2"></i> Portal Chủ Nhà</a></li>
                                </c:if>
                                <c:if test="${sessionScope.currentUser.role == 'RECEPTIONIST'}">
                                    <li><hr class="dropdown-divider my-1"></li>
                                    <li><a class="dropdown-item rounded-2 py-2 text-info fw-semibold bg-info-subtle" href="${pageContext.request.contextPath}/reception/checkin"><i class="fa-solid fa-concierge-bell me-2"></i> Portal Lễ Tân</a></li>
                                </c:if>
                                
                                <li><hr class="dropdown-divider my-1"></li>
                                <li><a class="dropdown-item rounded-2 py-2 text-danger" href="${pageContext.request.contextPath}/logout"><i class="fa-solid fa-right-from-bracket me-2"></i> Đăng xuất</a></li>
                            </ul>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-secondary rounded-pill me-2 px-3">Đăng nhập</a>
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-primary-custom rounded-pill px-3">Đăng ký</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>

<script>
(function() {
    function initNavbarInteractions() {
        document.addEventListener('click', function(e) {
            var toggleBtn = e.target.closest('[data-bs-toggle="dropdown"]');
            if (toggleBtn) {
                e.preventDefault();
                e.stopPropagation();
                var container = toggleBtn.closest('.dropdown');
                if (container) {
                    var menu = container.querySelector('.dropdown-menu');
                    if (menu) {
                        var isShown = menu.classList.contains('show');
                        document.querySelectorAll('.dropdown-menu.show').forEach(function(m) {
                            m.classList.remove('show');
                        });
                        if (!isShown) {
                            menu.classList.add('show');
                        }
                    }
                }
            } else if (!e.target.closest('.dropdown-menu')) {
                document.querySelectorAll('.dropdown-menu.show').forEach(function(m) {
                    m.classList.remove('show');
                });
            }

            var collapseBtn = e.target.closest('[data-bs-toggle="collapse"]');
            if (collapseBtn) {
                e.preventDefault();
                var targetSel = collapseBtn.getAttribute('data-bs-target');
                if (targetSel) {
                    var targetEl = document.querySelector(targetSel);
                    if (targetEl) {
                        targetEl.classList.toggle('show');
                    }
                }
            }
        });

        // Highlight active navbar link based on window location
        var currentPath = window.location.pathname;
        document.querySelectorAll('.navbar-nav .nav-link').forEach(function(link) {
            var href = link.getAttribute('href');
            if (href && (currentPath === href || (href !== '/' && currentPath.endsWith(href)) || (href.indexOf('search') !== -1 && currentPath.indexOf('detail') !== -1))) {
                document.querySelectorAll('.navbar-nav .nav-link').forEach(function(l) { l.classList.remove('active'); });
                link.classList.add('active');
            }
        });
    }
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initNavbarInteractions);
    } else {
        initNavbarInteractions();
    }
})();
</script>

