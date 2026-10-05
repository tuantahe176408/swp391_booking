<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle"      value="Duyệt Homestay"                           scope="request"/>
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
                        <h4 class="fw-bold mb-1 text-dark">
                            <i class="fa-solid fa-square-check text-danger me-2"></i>Duyệt Đăng ký Cơ sở Homestay
                        </h4>
                        <p class="text-muted mb-0">Thẩm định giấy phép pháp lý, ảnh HD và thông tin homestay trước khi xuất bản lên sàn</p>
                    </div>
                    <span class="badge bg-warning-subtle text-warning border border-warning px-3 py-2 fs-6">
                        Chờ duyệt: ${pendingCount} cơ sở
                    </span>
                </div>

                <%-- Search & Filter Toolbar --%>
                <form method="get" action="${pageContext.request.contextPath}/admin/approvals" class="row g-2 mb-4 align-items-center">
                    <div class="col-md-5">
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0 text-muted"><i class="fa-solid fa-magnifying-glass"></i></span>
                            <input type="text" name="keyword" class="form-control bg-light border-start-0 ps-0" 
                                   placeholder="Tìm kiếm theo tên homestay, chủ nhà, địa chỉ..." value="<c:out value='${filterKeyword}'/>">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <select name="status" class="form-select bg-light" onchange="this.form.submit()">
                            <option value="PENDING_APPROVAL" ${filterStatus == 'PENDING_APPROVAL' ? 'selected' : ''}>Chờ duyệt (Pending)</option>
                            <option value="ACTIVE" ${filterStatus == 'ACTIVE' ? 'selected' : ''}>Đã duyệt (Active)</option>
                            <option value="REJECTED" ${filterStatus == 'REJECTED' ? 'selected' : ''}>Bị từ chối (Rejected)</option>
                            <option value="ALL" ${filterStatus == 'ALL' ? 'selected' : ''}>-- Tất cả trạng thái --</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <select name="city" class="form-select bg-light" onchange="this.form.submit()">
                            <option value="">-- Tất cả thành phố --</option>
                            <c:forEach var="ct" items="${allCities}">
                                <option value="${ct}" ${filterCity == ct ? 'selected' : ''}>${ct}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2 d-flex gap-2">
                        <button type="submit" class="btn btn-dark w-100 rounded-3">
                            <i class="fa-solid fa-filter me-1"></i>Lọc
                        </button>
                        <c:if test="${not empty filterKeyword or (filterStatus != 'PENDING_APPROVAL' and not empty filterStatus) or not empty filterCity}">
                            <a href="${pageContext.request.contextPath}/admin/approvals" class="btn btn-outline-secondary rounded-3" title="Đặt lại bộ lọc">
                                <i class="fa-solid fa-rotate-right"></i>
                            </a>
                        </c:if>
                    </div>
                </form>

                <c:choose>
                    <c:when test="${empty pendingList}">
                        <div class="text-center py-5 text-muted">
                            <i class="fa-solid fa-circle-check fa-3x text-success mb-3"></i>
                            <p class="fw-semibold mb-1">Không có homestay nào phù hợp với bộ lọc.</p>
                            <p class="small">Thử thay đổi từ khóa hoặc bộ lọc trạng thái tìm kiếm.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th>Homestay</th>
                                        <th>Chủ nhà (Owner)</th>
                                        <th>Địa chỉ</th>
                                        <th>Ngày đăng ký</th>
                                        <th>Trạng thái</th>
                                        <th class="text-nowrap" style="min-width: 220px;">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="h" items="${pendingList}">
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <img src="${not empty h.primaryImageUrl ? h.primaryImageUrl : pageContext.request.contextPath.concat('/assets/images/default-homestay.svg')}"
                                                         class="rounded-3" width="50" height="35" style="object-fit: cover;"
                                                         onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=120&q=80';"
                                                         alt="${h.name}">
                                                    <strong><c:out value="${h.name}"/></strong>
                                                </div>
                                            </td>
                                            <td><c:out value="${not empty h.ownerName ? h.ownerName : 'N/A'}"/></td>
                                            <td>
                                                <c:out value="${h.district}"/><c:if test="${not empty h.district and not empty h.city}">, </c:if><c:out value="${h.city}"/>
                                            </td>
                                            <td><fmt:formatDate value="${h.createdAt}" pattern="dd/MM/yyyy"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${h.status == 'PENDING_APPROVAL'}">
                                                        <span class="badge bg-warning text-dark">Chờ duyệt</span>
                                                    </c:when>
                                                    <c:when test="${h.status == 'ACTIVE'}">
                                                        <span class="badge bg-success-subtle text-success border border-success">Đã duyệt</span>
                                                    </c:when>
                                                    <c:when test="${h.status == 'REJECTED'}">
                                                        <span class="badge bg-danger-subtle text-danger border border-danger">Bị từ chối</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary-subtle text-secondary border border-secondary">${h.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-nowrap">
                                                <c:choose>
                                                    <c:when test="${h.status == 'PENDING_APPROVAL'}">
                                                        <div class="d-flex align-items-center gap-2">
                                                            <%-- Approve --%>
                                                            <form method="post" action="${pageContext.request.contextPath}/admin/approvals"
                                                                  class="m-0 p-0"
                                                                  onsubmit="return confirm('Phê duyệt homestay này?');">
                                                                <input type="hidden" name="action"     value="approve">
                                                                <input type="hidden" name="homestayId" value="${h.homestayId}">
                                                                <button type="submit" class="btn btn-sm btn-success rounded-pill px-3 py-1.5 fw-semibold d-inline-flex align-items-center gap-1.5 shadow-sm">
                                                                    <i class="fa-solid fa-check"></i> Phê duyệt
                                                                </button>
                                                            </form>
                                                            <%-- Reject: opens modal --%>
                                                            <button type="button" class="btn btn-sm btn-outline-danger rounded-pill px-3 py-1.5 fw-semibold d-inline-flex align-items-center gap-1.5"
                                                                    data-bs-toggle="modal" data-bs-target="#rejectModal"
                                                                    data-id="${h.homestayId}" data-name="${h.name}">
                                                                <i class="fa-solid fa-xmark"></i> Từ chối
                                                            </button>
                                                        </div>
                                                    </c:when>
                                                    <c:when test="${h.status == 'ACTIVE'}">
                                                        <span class="text-success small fw-semibold"><i class="fa-solid fa-circle-check me-1"></i>Đã phê duyệt</span>
                                                    </c:when>
                                                    <c:when test="${h.status == 'REJECTED'}">
                                                        <span class="text-danger small fw-semibold" title="${h.rejectionReason}"><i class="fa-solid fa-circle-exclamation me-1"></i>Bị từ chối</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted small">${h.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
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
                                trong tổng số <strong>${totalRows}</strong> cơ sở
                            </div>
                            <c:if test="${totalPages > 1}">
                                <nav aria-label="Page navigation">
                                    <ul class="pagination pagination-sm mb-0">
                                        <%-- Prev --%>
                                        <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                            <a class="page-link rounded-start-3" 
                                               href="${pageContext.request.contextPath}/admin/approvals?page=${currentPage - 1}&keyword=${filterKeyword != null ? filterKeyword : ''}&status=${filterStatus != null ? filterStatus : ''}&city=${filterCity != null ? filterCity : ''}">
                                                <i class="fa-solid fa-chevron-left"></i>
                                            </a>
                                        </li>
                                        <%-- Page numbers --%>
                                        <c:forEach begin="1" end="${totalPages}" var="p">
                                            <li class="page-item ${currentPage == p ? 'active' : ''}">
                                                <a class="page-link" 
                                                   href="${pageContext.request.contextPath}/admin/approvals?page=${p}&keyword=${filterKeyword != null ? filterKeyword : ''}&status=${filterStatus != null ? filterStatus : ''}&city=${filterCity != null ? filterCity : ''}">
                                                    ${p}
                                                </a>
                                            </li>
                                        </c:forEach>
                                        <%-- Next --%>
                                        <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                            <a class="page-link rounded-end-3" 
                                               href="${pageContext.request.contextPath}/admin/approvals?page=${currentPage + 1}&keyword=${filterKeyword != null ? filterKeyword : ''}&status=${filterStatus != null ? filterStatus : ''}&city=${filterCity != null ? filterCity : ''}">
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

<%-- Reject Modal --%>
<div class="modal fade" id="rejectModal" tabindex="-1" aria-labelledby="rejectModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content rounded-4 border-0 shadow">
            <form method="post" action="${pageContext.request.contextPath}/admin/approvals">
                <input type="hidden" name="action"     value="reject">
                <input type="hidden" name="homestayId" id="rejectHomestayId" value="">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold" id="rejectModalLabel">
                        <i class="fa-solid fa-xmark-circle text-danger me-2"></i>Từ chối Đăng ký Homestay
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body pt-2">
                    <p class="text-muted small mb-3">Homestay: <strong id="rejectHomestayName"></strong></p>
                    <label for="rejectionReason" class="form-label fw-semibold small">
                        Lý do từ chối <span class="text-danger">*</span>
                    </label>
                    <textarea id="rejectionReason" name="rejectionReason"
                              class="form-control rounded-3" rows="4" required
                              placeholder="Ví dụ: Ảnh không đạt chất lượng HD, thiếu giấy phép kinh doanh..."></textarea>
                    <div class="form-text text-muted">Lý do sẽ được gửi tới chủ nhà để chỉnh sửa và đăng ký lại.</div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-outline-secondary rounded-3" data-bs-dismiss="modal">Huỷ</button>
                    <button type="submit" class="btn btn-danger rounded-3">
                        <i class="fa-solid fa-xmark me-1"></i>Xác nhận Từ chối
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        var modalEl = document.getElementById('rejectModal');
        if (modalEl) {
            modalEl.addEventListener('show.bs.modal', function (event) {
                var btn = event.relatedTarget;
                if (btn) {
                    var trigger = btn.closest('[data-bs-target="#rejectModal"]') || btn;
                    var hid = trigger.getAttribute('data-id') || '';
                    var hname = trigger.getAttribute('data-name') || '';
                    var idInput = document.getElementById('rejectHomestayId');
                    var nameSpan = document.getElementById('rejectHomestayName');
                    if (idInput) idInput.value = hid;
                    if (nameSpan) nameSpan.textContent = hname;
                }
                var reasonInput = document.getElementById('rejectionReason');
                if (reasonInput) reasonInput.value = '';
            });
        }
    });
</script>

<jsp:include page="../common/footer.jsp"/>
