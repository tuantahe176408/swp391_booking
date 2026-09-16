<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
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
                    <a class="nav-link font-weight-bold" href="${pageContext.request.contextPath}/home">
                        <i class="fa-solid fa-compass me-1"></i> Khám phá
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/customer/recommendations">
                        <i class="fa-solid fa-wand-magic-sparkles me-1 text-warning"></i> Gợi ý AI <span class="badge bg-danger ms-1">New</span>
                    </a>
                </li>
            </ul>
            <div class="d-flex align-items-center gap-3">
                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser}">
                        <!-- Role Badge Indicator -->
                        <c:choose>
                            <c:when test="${sessionScope.currentUser.role == 'ADMIN'}">
                                <span class="badge bg-danger-subtle text-danger border border-danger px-2 py-1"><i class="fa-solid fa-user-shield me-1"></i> Admin</span>
                            </c:when>
                            <c:when test="${sessionScope.currentUser.role == 'OWNER'}">
                                <span class="badge bg-primary-subtle text-primary border border-primary px-2 py-1"><i class="fa-solid fa-house-user me-1"></i> Owner</span>
                            </c:when>
                            <c:when test="${sessionScope.currentUser.role == 'RECEPTIONIST'}">
                                <span class="badge bg-info-subtle text-info border border-info px-2 py-1"><i class="fa-solid fa-concierge-bell me-1"></i> Receptionist</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-success-subtle text-success border border-success px-2 py-1"><i class="fa-solid fa-user me-1"></i> Customer</span>
                            </c:otherwise>
                        </c:choose>

                        <!-- User Profile Dropdown -->
                        <div class="dropdown">
                            <button class="btn btn-light border dropdown-toggle d-flex align-items-center gap-2" type="button" id="userMenu" data-bs-toggle="dropdown" aria-expanded="false">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.currentUser.avatarUrl}">
                                        <img src="${sessionScope.currentUser.avatarUrl}" class="rounded-circle" width="28" height="28" alt="Avatar">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center fw-bold" style="width: 28px; height: 28px; font-size: 13px;">
                                            ${sessionScope.currentUser.fullName.substring(0,1).toUpperCase()}
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                <span class="fw-semibold text-dark">${sessionScope.currentUser.fullName}</span>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end shadow-sm" aria-labelledby="userMenu">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/customer/profile"><i class="fa-regular fa-user me-2"></i> Hồ sơ cá nhân</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/customer/bookings"><i class="fa-solid fa-receipt me-2"></i> Đơn đặt phòng</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <c:if test="${sessionScope.currentUser.role == 'ADMIN'}">
                                    <li><a class="dropdown-item text-danger fw-semibold" href="${pageContext.request.contextPath}/admin/users"><i class="fa-solid fa-gauge-high me-2"></i> Dashboard Admin</a></li>
                                </c:if>
                                <c:if test="${sessionScope.currentUser.role == 'OWNER'}">
                                    <li><a class="dropdown-item text-primary fw-semibold" href="${pageContext.request.contextPath}/owner/homestays"><i class="fa-solid fa-gauge-high me-2"></i> Dashboard Chủ nhà</a></li>
                                </c:if>
                                <c:if test="${sessionScope.currentUser.role == 'RECEPTIONIST'}">
                                    <li><a class="dropdown-item text-info fw-semibold" href="${pageContext.request.contextPath}/reception/checkin"><i class="fa-solid fa-gauge-high me-2"></i> Bàn Lễ tân</a></li>
                                </c:if>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout"><i class="fa-solid fa-right-from-bracket me-2"></i> Đăng xuất</a></li>
                            </ul>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-secondary me-2">Đăng nhập</a>
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-primary-custom">Đăng ký</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>

