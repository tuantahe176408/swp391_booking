<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle"      value="Quản lý Người dùng"                      scope="request"/>
<c:set var="pageBreadcrumb" value="Quản lý Người dùng &amp; Nội dung"        scope="request"/>
<jsp:include page="../common/header.jsp"/>

<div class="owner-shell">
    <jsp:include page="../common/sidebar-admin.jsp"/>
    <div class="owner-main">
        <jsp:include page="../common/admin-topbar.jsp"/>
        <div class="owner-content">
            <%-- Flash messages --%>
            <c:if test="${not empty sessionScope.adminSuccessMessage}">
                <div class="alert alert-success alert-dismissible fade show rounded-4 mb-3" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i>${sessionScope.adminSuccessMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="adminSuccessMessage" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.adminErrorMessage}">
                <div class="alert alert-danger alert-dismissible fade show rounded-4 mb-3" role="alert">
                    <i class="fa-solid fa-circle-xmark me-2"></i>${sessionScope.adminErrorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="adminErrorMessage" scope="session"/>
            </c:if>

            <div class="card border-0 shadow-sm rounded-4 p-4 mb-4">
                <div class="d-flex align-items-center justify-content-between mb-4 border-bottom pb-3">
                    <div>
                        <h4 class="fw-bold mb-1 text-dark"><i class="fa-solid fa-users-gear text-danger me-2"></i>Quản lý Người dùng & Phân quyền</h4>
                        <p class="text-muted mb-0">Quản lý toàn bộ tài khoản (Customer, Receptionist, Owner, Admin) và thực hiện Khóa / Mở khóa</p>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <span class="badge bg-danger-subtle text-danger border border-danger px-3 py-2 fs-6">
                            Tổng số: ${totalUsers != null ? totalUsers : 0} người dùng
                        </span>
                        <button type="button" class="btn btn-danger rounded-3 fw-semibold"
                                data-bs-toggle="modal" data-bs-target="#createUserModal">
                            <i class="fa-solid fa-user-plus me-1"></i>Thêm người dùng
                        </button>
                    </div>
                </div>

                <%-- Search & Filter Toolbar --%>
                <form method="get" action="${pageContext.request.contextPath}/admin/users" class="row g-2 mb-4 align-items-center">
                    <div class="col-md-5">
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0 text-muted"><i class="fa-solid fa-magnifying-glass"></i></span>
                            <input type="text" name="keyword" class="form-control bg-light border-start-0 ps-0" 
                                   placeholder="Tìm kiếm theo tên, email, SĐT..." value="<c:out value='${filterKeyword}'/>">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <select name="role" class="form-select bg-light" onchange="this.form.submit()">
                            <option value="">-- Tất cả vai trò --</option>
                            <option value="CUSTOMER" ${filterRole == 'CUSTOMER' ? 'selected' : ''}>Khách hàng (Customer)</option>
                            <option value="OWNER" ${filterRole == 'OWNER' ? 'selected' : ''}>Chủ nhà (Owner)</option>
                            <option value="RECEPTIONIST" ${filterRole == 'RECEPTIONIST' ? 'selected' : ''}>Lễ tân (Receptionist)</option>
                            <option value="ADMIN" ${filterRole == 'ADMIN' ? 'selected' : ''}>Quản trị viên (Admin)</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <select name="status" class="form-select bg-light" onchange="this.form.submit()">
                            <option value="">-- Trạng thái --</option>
                            <option value="ACTIVE" ${filterStatus == 'ACTIVE' ? 'selected' : ''}>Hoạt động</option>
                            <option value="BANNED" ${filterStatus == 'BANNED' ? 'selected' : ''}>Bị khóa</option>
                        </select>
                    </div>
                    <div class="col-md-2 d-flex gap-2">
                        <button type="submit" class="btn btn-dark w-100 rounded-3">
                            <i class="fa-solid fa-filter me-1"></i>Lọc
                        </button>
                        <c:if test="${not empty filterKeyword or not empty filterRole or not empty filterStatus}">
                            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary rounded-3" title="Đặt lại bộ lọc">
                                <i class="fa-solid fa-rotate-right"></i>
                            </a>
                        </c:if>
                    </div>
                </form>

                <c:choose>
                    <c:when test="${empty userList}">
                        <div class="text-center py-5 text-muted">
                            <i class="fa-solid fa-user-slash fa-3x mb-3 opacity-25"></i>
                            <p class="fw-semibold mb-1">Không tìm thấy người dùng phù hợp.</p>
                            <p class="small">Thử thay đổi từ khóa hoặc bộ lọc tìm kiếm.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
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
                                                            <img src="${u.avatarUrl}" class="rounded-circle" width="32" height="32" alt="Avatar" onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/images/default-avatar.svg';">
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
                                                            <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill px-3" ${u.role == 'ADMIN' ? 'disabled' : ''}
                                                                    onclick="return confirm('Khóa tài khoản ${u.fullName} (${u.email})?');">
                                                                <i class="fa-solid fa-lock me-1"></i> Khóa
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <input type="hidden" name="action" value="unban">
                                                            <button type="submit" class="btn btn-sm btn-outline-success rounded-pill px-3"
                                                                    onclick="return confirm('Mở khóa tài khoản ${u.fullName} (${u.email})?');">
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

                        <%-- Pagination Bar --%>
                        <div class="d-flex flex-column flex-md-row align-items-center justify-content-between gap-3 pt-3 border-top mt-3">
                            <div class="text-muted small">
                                Hiển thị <strong>${totalRows > 0 ? (currentPage - 1) * pageSize + 1 : 0}</strong> - 
                                <strong>${currentPage * pageSize > totalRows ? totalRows : currentPage * pageSize}</strong> 
                                trong tổng số <strong>${totalRows}</strong> người dùng
                            </div>
                            <c:if test="${totalPages > 1}">
                                <nav aria-label="Page navigation">
                                    <ul class="pagination pagination-sm mb-0">
                                        <%-- Prev --%>
                                        <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                            <a class="page-link rounded-start-3" 
                                               href="${pageContext.request.contextPath}/admin/users?page=${currentPage - 1}&keyword=${filterKeyword != null ? filterKeyword : ''}&role=${filterRole != null ? filterRole : ''}&status=${filterStatus != null ? filterStatus : ''}">
                                                <i class="fa-solid fa-chevron-left"></i>
                                            </a>
                                        </li>
                                        <%-- Page numbers --%>
                                        <c:forEach begin="1" end="${totalPages}" var="p">
                                            <li class="page-item ${currentPage == p ? 'active' : ''}">
                                                <a class="page-link" 
                                                   href="${pageContext.request.contextPath}/admin/users?page=${p}&keyword=${filterKeyword != null ? filterKeyword : ''}&role=${filterRole != null ? filterRole : ''}&status=${filterStatus != null ? filterStatus : ''}">
                                                    ${p}
                                                </a>
                                            </li>
                                        </c:forEach>
                                        <%-- Next --%>
                                        <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                            <a class="page-link rounded-end-3" 
                                               href="${pageContext.request.contextPath}/admin/users?page=${currentPage + 1}&keyword=${filterKeyword != null ? filterKeyword : ''}&role=${filterRole != null ? filterRole : ''}&status=${filterStatus != null ? filterStatus : ''}">
                                                <i class="fa-solid fa-chevron-right"></i>
                                            </a>
                                        </li>
                                    </ul>
                                </nav>
                            </c:if>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<%-- Modal: Thêm người dùng mới --%>
<div class="modal fade" id="createUserModal" tabindex="-1" aria-labelledby="createUserModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content rounded-4 border-0 shadow">
            <div class="modal-header border-bottom-0">
                <h5 class="modal-title fw-bold" id="createUserModalLabel">
                    <i class="fa-solid fa-user-plus text-danger me-2"></i>Thêm người dùng mới
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/admin/users" id="createUserForm" novalidate>
                <input type="hidden" name="action" value="create">
                <div class="modal-body pt-0">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Họ và tên <span class="text-danger">*</span></label>
                        <input type="text" name="fullName" class="form-control rounded-3"
                               placeholder="VD: Nguyễn Văn A" required maxlength="150">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Email <span class="text-danger">*</span></label>
                        <input type="email" name="email" class="form-control rounded-3"
                               placeholder="example@gmail.com" required maxlength="150">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Số điện thoại</label>
                        <input type="tel" name="phone" class="form-control rounded-3"
                               placeholder="0901234567" maxlength="20">
                    </div>
                    <div class="row g-3 mb-3">
                        <div class="col-6">
                            <label class="form-label fw-semibold">Vai trò <span class="text-danger">*</span></label>
                            <select name="role" class="form-select rounded-3" required>
                                <option value="">-- Chọn vai trò --</option>
                                <option value="CUSTOMER">Khách hàng</option>
                                <option value="OWNER">Chủ nhà</option>
                                <option value="RECEPTIONIST">Lễ tân</option>
                                <option value="ADMIN">Quản trị viên</option>
                            </select>
                        </div>
                        <div class="col-6">
                            <label class="form-label fw-semibold">Mật khẩu <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <input type="password" name="password" id="newUserPassword"
                                       class="form-control rounded-start-3"
                                       placeholder="Tối thiểu 6 ký tự" required minlength="6">
                                <button type="button" class="btn btn-outline-secondary rounded-end-3"
                                        onclick="togglePwd()"
                                        title="Hiện/Ẩn mật khẩu">
                                    <i class="fa-regular fa-eye" id="eyeIcon"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="alert alert-info rounded-3 py-2 mb-0" style="font-size:.83rem;">
                        <i class="fa-solid fa-circle-info me-1"></i>
                        Tài khoản được tạo bởi Admin sẽ được kích hoạt ngay, không cần xác thực email.
                    </div>
                </div>
                <div class="modal-footer border-top-0">
                    <button type="button" class="btn btn-outline-secondary rounded-3"
                            data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-danger rounded-3 fw-semibold px-4">
                        <i class="fa-solid fa-user-plus me-1"></i>Tạo tài khoản
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function togglePwd() {
    var input = document.getElementById('newUserPassword');
    var icon  = document.getElementById('eyeIcon');
    if (input.type === 'password') {
        input.type = 'text';
        icon.className = 'fa-regular fa-eye-slash';
    } else {
        input.type = 'password';
        icon.className = 'fa-regular fa-eye';
    }
}

// Client-side validation
document.getElementById('createUserForm').addEventListener('submit', function(e) {
    var pwd = document.getElementById('newUserPassword').value;
    if (pwd.length < 6) {
        e.preventDefault();
        alert('Mật khẩu phải có ít nhất 6 ký tự.');
    }
});
</script>

<jsp:include page="../common/footer.jsp"/>
