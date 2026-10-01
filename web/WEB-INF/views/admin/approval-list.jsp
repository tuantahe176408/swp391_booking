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

                <c:choose>
                    <c:when test="${empty pendingList}">
                        <div class="text-center py-5 text-muted">
                            <i class="fa-solid fa-circle-check fa-3x text-success mb-3"></i>
                            <p class="fw-semibold mb-1">Không có homestay nào đang chờ duyệt.</p>
                            <p class="small">Tất cả đăng ký đã được xử lý.</p>
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
                                        <th>Thao tác</th>
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
                                            <td><span class="badge bg-warning text-dark">PENDING_APPROVAL</span></td>
                                            <td>
                                                <%-- Approve --%>
                                                <form method="post" action="${pageContext.request.contextPath}/admin/approvals"
                                                      class="d-inline"
                                                      onsubmit="return confirm('Phê duyệt homestay này?');">
                                                    <input type="hidden" name="action"     value="approve">
                                                    <input type="hidden" name="homestayId" value="${h.homestayId}">
                                                    <button type="submit" class="btn btn-sm btn-success me-1">
                                                        <i class="fa-solid fa-check me-1"></i>Phê duyệt
                                                    </button>
                                                </form>
                                                <%-- Reject: opens modal --%>
                                                <button type="button" class="btn btn-sm btn-outline-danger"
                                                        data-bs-toggle="modal" data-bs-target="#rejectModal"
                                                        data-id="${h.homestayId}" data-name="${h.name}">
                                                    <i class="fa-solid fa-xmark me-1"></i>Từ chối
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
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
    document.getElementById('rejectModal').addEventListener('show.bs.modal', function (event) {
        var btn = event.relatedTarget;
        document.getElementById('rejectHomestayId').value = btn.getAttribute('data-id');
        document.getElementById('rejectHomestayName').textContent = btn.getAttribute('data-name');
        document.getElementById('rejectionReason').value = '';
    });
</script>

<jsp:include page="../common/footer.jsp"/>
