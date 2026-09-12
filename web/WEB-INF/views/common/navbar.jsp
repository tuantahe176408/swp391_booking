<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<nav class="navbar navbar-expand-lg navbar-custom">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
            <i class="fa-solid fa-hotel me-2"></i>Smart Booking
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link active font-weight-bold" href="${pageContext.request.contextPath}/home">Khám phá</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/customer/recommendations">Gợi ý AI <span class="badge bg-danger">New</span></a>
                </li>
            </ul>
            <div class="d-flex align-items-center gap-3">
                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser}">
                        <span class="text-secondary fw-semibold">Xin chào, ${sessionScope.currentUser.fullName}</span>
                        <c:if test="${sessionScope.currentUser.role == 'ADMIN'}">
                            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-primary btn-sm">Trang Admin</a>
                        </c:if>
                        <c:if test="${sessionScope.currentUser.role == 'OWNER'}">
                            <a href="${pageContext.request.contextPath}/owner/homestays" class="btn btn-outline-primary btn-sm">Quản lý Chủ nhà</a>
                        </c:if>
                        <c:if test="${sessionScope.currentUser.role == 'RECEPTIONIST'}">
                            <a href="${pageContext.request.contextPath}/reception/checkin" class="btn btn-outline-primary btn-sm">Quản lý Lễ tân</a>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">Đăng xuất</a>
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
