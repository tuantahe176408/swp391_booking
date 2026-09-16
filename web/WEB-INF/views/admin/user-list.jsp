<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="container-fluid px-4 py-4">
    <div class="row">
        <!-- Sidebar Navigation -->
        <div class="col-lg-3">
            <jsp:include page="../common/sidebar-admin.jsp"/>
        </div>

        <!-- Main Content Area -->
        <div class="col-lg-9">
            <div class="card border-0 shadow-sm rounded-4 p-4 mb-4">
                <div class="d-flex align-items-center justify-content-between mb-4 border-bottom pb-3">
                    <div>
                        <h4 class="fw-bold mb-1 text-dark"><i class="fa-solid fa-users-gear text-danger me-2"></i>UC22: Quản lý Người dùng & Phân quyền RBAC</h4>
                        <p class="text-muted mb-0">Quản lý toàn bộ tài khoản (Customer, Receptionist, Owner, Admin) và thực hiện Khóa / Mở khóa</p>
                    </div>
                    <span class="badge bg-danger-subtle text-danger border border-danger px-3 py-2 fs-6">
                        Tổng số: ${totalUsers != null ? totalUsers : 0} người dùng
                    </span>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>ID</th>
                                <th>Họ và tên</th>
                                <th>Email</th>
                                <th>Số điện thoại</th>
                                <th>Vai trò (Role)</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="u" items="${userList}">
                                <tr>
                                    <td><strong>#${u.userId}</strong></td>
                                    <td>
                                        <div class="d-flex align-items-center gap-2">
                                            <c:choose>
                                                <c:when test="${not empty u.avatarUrl}">
                                                    <img src="${u.avatarUrl}" class="rounded-circle" width="32" height="32">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="rounded-circle bg-secondary text-white d-flex align-items-center justify-content-center fw-bold" style="width: 32px; height: 32px; font-size: 13px;">
                                                        ${u.fullName.substring(0,1).toUpperCase()}
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                            <span class="fw-semibold">${u.fullName}</span>
                                        </div>
                                    </td>
                                    <td>${u.email}</td>
                                    <td>${u.phoneNumber != null ? u.phoneNumber : 'N/A'}</td>
                                    <td>
                                        <span class="badge ${u.role == 'ADMIN' ? 'bg-danger' : u.role == 'OWNER' ? 'bg-primary' : u.role == 'RECEPTIONIST' ? 'bg-info' : 'bg-secondary'}">
                                            ${u.role}
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.active}">
                                                <span class="badge bg-success-subtle text-success border border-success">Active</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger-subtle text-danger border border-danger">Banned</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/admin/users" method="POST" class="d-inline">
                                            <input type="hidden" name="userId" value="${u.userId}">
                                            <c:choose>
                                                <c:when test="${u.active}">
                                                    <input type="hidden" name="action" value="ban">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger" ${u.role == 'ADMIN' ? 'disabled' : ''}>
                                                        <i class="fa-solid fa-lock me-1"></i> Khóa
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="hidden" name="action" value="unban">
                                                    <button type="submit" class="btn btn-sm btn-outline-success">
                                                        <i class="fa-solid fa-lock-open me-1"></i> Mở khóa
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>
