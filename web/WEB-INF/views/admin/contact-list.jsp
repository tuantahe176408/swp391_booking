<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle"      value="Tin nhắn Liên hệ"                          scope="request"/>
<c:set var="pageBreadcrumb" value="Quản lý Người dùng &amp; Nội dung"         scope="request"/>
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

                <%-- Page header --%>
                <div class="d-flex align-items-center justify-content-between mb-4 border-bottom pb-3 flex-wrap gap-2">
                    <div>
                        <h4 class="fw-bold mb-1 text-dark">
                            <i class="fa-solid fa-inbox text-danger me-2"></i>Quản lý Đơn Liên hệ &amp; Hỗ trợ
                        </h4>
                        <p class="text-muted mb-0">Xem và đánh dấu xử lý các tin nhắn từ khách hàng</p>
                    </div>
                    <span class="badge bg-warning-subtle text-warning border border-warning px-3 py-2 fs-6">
                        Chưa xử lý: ${countPending} tin nhắn
                    </span>
                </div>

                <%-- Filter toolbar --%>
                <div class="d-flex gap-2 mb-4 flex-wrap align-items-center">
                    <a href="${pageContext.request.contextPath}/admin/contacts"
                       class="btn btn-sm rounded-pill px-4 fw-semibold
                              ${filterParam == 'all' || empty filterParam ? 'btn-primary' : 'btn-outline-secondary'}">
                        Tất cả
                        <span class="badge rounded-pill ms-1 bg-white text-dark">${countAll}</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/contacts?filter=pending"
                       class="btn btn-sm rounded-pill px-4 fw-semibold
                              ${filterParam == 'pending' ? 'btn-warning text-dark' : 'btn-outline-warning text-dark'}">
                        <i class="fa-solid fa-clock me-1"></i>Chưa xử lý
                        <span class="badge rounded-pill ms-1 bg-white text-dark">${countPending}</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/contacts?filter=resolved"
                       class="btn btn-sm rounded-pill px-4 fw-semibold
                              ${filterParam == 'resolved' ? 'btn-success text-white' : 'btn-outline-success'}">
                        <i class="fa-solid fa-circle-check me-1"></i>Đã xử lý
                        <span class="badge rounded-pill ms-1 bg-white text-dark">${countResolved}</span>
                    </a>
                </div>

                <%-- Table --%>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th style="width:36px;">#</th>
                                <th>Người gửi</th>
                                <th>Chủ đề</th>
                                <th>Nội dung</th>
                                <th>Ngày gửi</th>
                                <th>Trạng thái</th>
                                <th style="width:130px;">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty messages}">
                                    <tr>
                                        <td colspan="7" class="text-center py-5 text-muted">
                                            <i class="fa-solid fa-inbox fa-2x mb-2 d-block opacity-25"></i>
                                            Không có tin nhắn nào.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="m" items="${messages}" varStatus="s">
                                        <tr>
                                            <td class="text-muted small">${(currentPage-1)*15 + s.index+1}</td>

                                            <%-- Người gửi --%>
                                            <td>
                                                <div class="fw-semibold" style="font-size:.88rem;">${m.senderName}</div>
                                                <div class="text-muted small">${m.senderEmail}</div>
                                                <c:if test="${not empty m.senderPhone}">
                                                    <div class="text-muted small">
                                                        <i class="fa-solid fa-phone me-1" style="font-size:.7rem;"></i>${m.senderPhone}
                                                    </div>
                                                </c:if>
                                            </td>

                                            <%-- Chủ đề --%>
                                            <td>
                                                <span class="fw-semibold" style="font-size:.85rem;">${m.subject}</span>
                                            </td>

                                            <%-- Nội dung + nút xem modal --%>
                                            <td style="max-width:260px;">
                                                <span id="msg-content-${m.messageId}" style="display:none;"><c:out value="${m.message}"/></span>
                                                <div class="text-muted text-truncate" style="font-size:.83rem;max-width:240px;">${m.message}</div>
                                                <button type="button"
                                                        class="btn btn-sm btn-outline-secondary rounded-3 mt-1 px-2 py-0"
                                                        style="font-size:.75rem;"
                                                        data-id="${m.messageId}"
                                                        data-sender="<c:out value='${m.senderName}'/>"
                                                        data-subject="<c:out value='${m.subject}'/>"
                                                        onclick="showMessage(this)">
                                                    <i class="fa-solid fa-eye me-1"></i>Xem
                                                </button>
                                            </td>

                                            <%-- Ngày gửi --%>
                                            <td class="text-muted small" style="white-space:nowrap;">
                                                <fmt:formatDate value="${m.createdAt}" pattern="dd/MM/yyyy"/>
                                                <div><fmt:formatDate value="${m.createdAt}" pattern="HH:mm"/></div>
                                            </td>

                                            <%-- Trạng thái --%>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${m.resolved}">
                                                        <span class="badge bg-success-subtle text-success border border-success px-2 py-1">
                                                            <i class="fa-solid fa-circle-check me-1" style="font-size:.6rem;"></i>Đã xử lý
                                                        </span>
                                                        <c:if test="${not empty m.resolvedByName}">
                                                            <div class="text-muted" style="font-size:.72rem;">bởi ${m.resolvedByName}</div>
                                                        </c:if>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-warning-subtle text-warning border border-warning px-2 py-1">
                                                            <i class="fa-solid fa-clock me-1" style="font-size:.6rem;"></i>Chưa xử lý
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <%-- Thao tác --%>
                                            <td>
                                                <form method="post"
                                                      action="${pageContext.request.contextPath}/admin/contacts"
                                                      style="display:inline;">
                                                    <input type="hidden" name="messageId" value="${m.messageId}">
                                                    <input type="hidden" name="resolve"   value="${m.resolved ? 'false' : 'true'}">
                                                    <input type="hidden" name="filter"    value="${filterParam}">
                                                    <input type="hidden" name="page"      value="${currentPage}">
                                                    <c:choose>
                                                        <c:when test="${m.resolved}">
                                                            <button type="submit" class="btn btn-sm btn-outline-secondary rounded-3"
                                                                    title="Đánh dấu chưa xử lý">
                                                                <i class="fa-solid fa-rotate-left me-1"></i>Bỏ xử lý
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button type="submit" class="btn btn-sm btn-success rounded-3"
                                                                    title="Đánh dấu đã xử lý">
                                                                <i class="fa-solid fa-circle-check me-1"></i>Xong
                                                            </button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <%-- Pagination --%>
                <c:if test="${totalPages > 1}">
                    <div class="d-flex align-items-center justify-content-between mt-3 flex-wrap gap-2 border-top pt-3">
                        <small class="text-muted">Trang ${currentPage}/${totalPages} · ${total} tin nhắn</small>
                        <nav>
                            <ul class="pagination pagination-sm mb-0">
                                <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                    <a class="page-link rounded-3 me-1"
                                       href="${pageContext.request.contextPath}/admin/contacts?filter=${filterParam}&page=${currentPage-1}">
                                        <i class="fa-solid fa-chevron-left"></i>
                                    </a>
                                </li>
                                <c:forEach begin="1" end="${totalPages}" var="p">
                                    <li class="page-item ${p == currentPage ? 'active' : ''}">
                                        <a class="page-link rounded-3 me-1"
                                           href="${pageContext.request.contextPath}/admin/contacts?filter=${filterParam}&page=${p}">${p}</a>
                                    </li>
                                </c:forEach>
                                <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                    <a class="page-link rounded-3"
                                       href="${pageContext.request.contextPath}/admin/contacts?filter=${filterParam}&page=${currentPage+1}">
                                        <i class="fa-solid fa-chevron-right"></i>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </div>
                </c:if>

            </div><%-- /card --%>
        </div><%-- /owner-content --%>
    </div><%-- /owner-main --%>
</div><%-- /owner-shell --%>

<%-- Modal xem nội dung đầy đủ --%>
<div class="modal fade" id="msgModal" tabindex="-1" aria-labelledby="msgModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content rounded-4 border-0 shadow">
            <div class="modal-header border-bottom-0 pb-1">
                <div>
                    <h6 class="modal-title fw-bold" id="msgModalTitle"></h6>
                    <div class="text-muted small" id="msgModalSender"></div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body pt-2">
                <div class="p-3 rounded-3 bg-light border" style="font-size:.88rem;line-height:1.7;white-space:pre-wrap;" id="msgModalBody"></div>
            </div>
            <div class="modal-footer border-top-0">
                <button type="button" class="btn btn-outline-secondary rounded-3" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<script>
function showMessage(btn) {
    var id      = btn.dataset.id;
    var content = document.getElementById('msg-content-' + id).textContent;
    document.getElementById('msgModalSender').textContent = btn.dataset.sender;
    document.getElementById('msgModalTitle').textContent  = btn.dataset.subject;
    document.getElementById('msgModalBody').textContent   = content;
    new bootstrap.Modal(document.getElementById('msgModal')).show();
}
</script>

<jsp:include page="../common/footer.jsp"/>
