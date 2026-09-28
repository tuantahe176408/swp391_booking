<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../common/header.jsp"/>

<div class="owner-shell">
    <jsp:include page="../common/sidebar-owner.jsp"/>

    <div class="owner-main">
        <jsp:include page="../common/owner-topbar.jsp"/>

        <div class="owner-content">

            <!-- Flash messages -->
            <c:if test="${not empty sessionScope.flash_success}">
                <div class="alert alert-success alert-dismissible rounded-3 mb-4 d-flex gap-2 align-items-center">
                    <i class="fa-solid fa-circle-check flex-shrink-0"></i>
                    <span>${sessionScope.flash_success}</span>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="flash_success" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.flash_error}">
                <div class="alert alert-danger alert-dismissible rounded-3 mb-4 d-flex gap-2 align-items-center">
                    <i class="fa-solid fa-triangle-exclamation flex-shrink-0"></i>
                    <span>${sessionScope.flash_error}</span>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="flash_error" scope="session"/>
            </c:if>

            <!-- Page Header -->
            <div class="owner-page-header">
                <div class="owner-page-header__info">
                    <h2><i class="fa-solid fa-building-user text-primary me-2"></i>Quản lý Cơ sở Homestay</h2>
                    <p>Quản lý tài sản, hình ảnh HD và cấu hình các loại phòng</p>
                </div>
                <a href="${pageContext.request.contextPath}/owner/homestays/new"
                   class="btn btn-primary-custom btn-sm px-4">
                    <i class="fa-solid fa-plus me-1"></i>Đăng ký Homestay Mới
                </a>
            </div>

            <!-- Stats Row (from DB) -->
            <div class="row g-3 mb-4">
                <div class="col-6 col-xl-3">
                    <div class="owner-card d-flex align-items-center gap-3 p-3">
                        <div style="width:44px;height:44px;border-radius:12px;background:rgba(99,102,241,.1);display:flex;align-items:center;justify-content:center;font-size:1.2rem;color:#6366f1;flex-shrink:0;">
                            <i class="fa-solid fa-building-user"></i>
                        </div>
                        <div>
                            <div class="fw-bold fs-4 lh-1">${countTotal}</div>
                            <div class="text-muted" style="font-size:.8rem;">Tổng cơ sở</div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-xl-3">
                    <div class="owner-card d-flex align-items-center gap-3 p-3">
                        <div style="width:44px;height:44px;border-radius:12px;background:rgba(16,185,129,.1);display:flex;align-items:center;justify-content:center;font-size:1.2rem;color:#10b981;flex-shrink:0;">
                            <i class="fa-solid fa-circle-check"></i>
                        </div>
                        <div>
                            <div class="fw-bold fs-4 lh-1">${countActive}</div>
                            <div class="text-muted" style="font-size:.8rem;">Đang hoạt động</div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-xl-3">
                    <div class="owner-card d-flex align-items-center gap-3 p-3">
                        <div style="width:44px;height:44px;border-radius:12px;background:rgba(245,158,11,.1);display:flex;align-items:center;justify-content:center;font-size:1.2rem;color:#f59e0b;flex-shrink:0;">
                            <i class="fa-solid fa-clock"></i>
                        </div>
                        <div>
                            <div class="fw-bold fs-4 lh-1">${countPending}</div>
                            <div class="text-muted" style="font-size:.8rem;">Chờ duyệt</div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-xl-3">
                    <div class="owner-card d-flex align-items-center gap-3 p-3">
                        <div style="width:44px;height:44px;border-radius:12px;background:rgba(99,102,241,.08);display:flex;align-items:center;justify-content:center;font-size:1.2rem;color:#6366f1;flex-shrink:0;">
                            <i class="fa-solid fa-bed"></i>
                        </div>
                        <div>
                            <div class="fw-bold fs-4 lh-1">${totalRooms}</div>
                            <div class="text-muted" style="font-size:.8rem;">Tổng số phòng</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Alert: rejected homestays -->
            <c:if test="${countRejected > 0}">
                <div class="alert alert-danger d-flex align-items-center gap-2 mb-4 rounded-3">
                    <i class="fa-solid fa-triangle-exclamation flex-shrink-0"></i>
                    <span>Bạn có <strong>${countRejected}</strong> cơ sở bị Admin từ chối.
                    Xem lý do và chỉnh sửa để gửi lại duyệt.</span>
                </div>
            </c:if>

            <!-- Homestay Table -->
            <div class="owner-card p-0 overflow-hidden">
                <div class="d-flex align-items-center justify-content-between px-4 py-3 border-bottom flex-wrap gap-2">
                    <h6 class="fw-bold mb-0">
                        <i class="fa-solid fa-list-ul me-2 text-primary"></i>
                        Danh sách Cơ sở
                        <span class="badge bg-light text-muted border ms-2" style="font-size:.75rem;">${countTotal}</span>
                    </h6>
                    <div class="d-flex gap-2 align-items-center flex-wrap">
                        <!-- Status filter tabs -->
                        <div class="btn-group btn-group-sm" id="statusFilterGroup">
                            <button class="btn btn-outline-secondary active" onclick="filterStatus('all', this)">Tất cả</button>
                            <button class="btn btn-outline-secondary" onclick="filterStatus('ACTIVE', this)">Hoạt động</button>
                            <button class="btn btn-outline-secondary" onclick="filterStatus('PENDING_APPROVAL', this)">Chờ duyệt</button>
                            <button class="btn btn-outline-secondary" onclick="filterStatus('REJECTED', this)">Từ chối</button>
                            <button class="btn btn-outline-secondary" onclick="filterStatus('INACTIVE', this)">Tạm ngừng</button>
                        </div>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0" id="homestayTable">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-4" style="width:80px;">Ảnh</th>
                                <th>Tên Homestay</th>
                                <th>Địa chỉ</th>
                                <th>Giá từ</th>
                                <th>Phòng</th>
                                <th>Đánh giá</th>
                                <th>Trạng thái</th>
                                <th class="pe-4">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty homestays}">
                                    <tr>
                                        <td colspan="8" class="text-center py-5 text-muted">
                                            <i class="fa-solid fa-house-circle-xmark fa-2x mb-2 d-block opacity-25"></i>
                                            Bạn chưa đăng ký cơ sở nào.
                                            <a href="${pageContext.request.contextPath}/owner/homestays/new" class="ms-1">Đăng ký ngay</a>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="hs" items="${homestays}">
                                        <tr data-status="${hs.status}">                                            <!-- Thumbnail -->
                                            <td class="ps-4">
                                                <img src="${not empty hs.primaryImageUrl ? hs.primaryImageUrl : pageContext.request.contextPath.concat('/assets/images/default-homestay.svg')}"
                                                     class="rounded-3" width="68" height="46" style="object-fit:cover;"
                                                     alt="${hs.name}"
                                                     onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/images/default-homestay.svg'">
                                            </td>

                                            <!-- Name + updated -->
                                            <td>
                                                <div class="fw-semibold" style="max-width:220px;" title="${hs.name}">${hs.name}</div>
                                                <div class="text-muted" style="font-size:.75rem;">
                                                    <i class="fa-regular fa-clock me-1"></i>
                                                    <fmt:formatDate value="${hs.updatedAt}" pattern="dd/MM/yyyy"/>
                                                </div>
                                                <!-- Rejection reason inline -->
                                                <c:if test="${hs.status == 'REJECTED' && not empty hs.rejectionReason}">
                                                    <div class="text-danger mt-1" style="font-size:.74rem;max-width:220px;">
                                                        <i class="fa-solid fa-circle-exclamation me-1"></i>${hs.rejectionReason}
                                                    </div>
                                                </c:if>
                                            </td>

                                            <!-- Address -->
                                            <td class="text-muted" style="font-size:.83rem;max-width:180px;">
                                                <div>${hs.district}</div>
                                                <div>${hs.city}</div>
                                            </td>

                                            <!-- Min price -->
                                            <td style="font-size:.85rem;">
                                                <c:choose>
                                                    <c:when test="${hs.minPrice != null && hs.minPrice > 0}">
                                                        <span class="fw-semibold text-primary">
                                                            <fmt:formatNumber value="${hs.minPrice}" type="number" groupingUsed="true"/>₫
                                                        </span>
                                                        <div class="text-muted" style="font-size:.73rem;">/đêm</div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">—</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- Room count -->
                                            <td style="font-size:.85rem;">
                                                <span class="fw-semibold">${hs.roomCount}</span>
                                                <span class="text-muted"> phòng</span>
                                            </td>

                                            <!-- Rating -->
                                            <td style="font-size:.83rem;">
                                                <c:choose>
                                                    <c:when test="${hs.reviewCount > 0}">
                                                        <span class="text-warning fw-semibold">
                                                            <i class="fa-solid fa-star" style="font-size:.75rem;"></i>
                                                            <fmt:formatNumber value="${hs.ratingAvg}" type="number" maxFractionDigits="1"/>
                                                        </span>
                                                        <div class="text-muted" style="font-size:.72rem;">${hs.reviewCount} đánh giá</div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted" style="font-size:.78rem;">Chưa có</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- Status badge -->
                                            <td>
                                                <c:choose>
                                                    <c:when test="${hs.status == 'ACTIVE'}">
                                                        <span class="badge bg-success-subtle text-success border border-success px-2 py-1">
                                                            <i class="fa-solid fa-circle-check me-1" style="font-size:.6rem;"></i>Hoạt động
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${hs.status == 'PENDING_APPROVAL'}">
                                                        <span class="badge bg-warning-subtle text-warning border border-warning px-2 py-1">
                                                            <i class="fa-solid fa-clock me-1" style="font-size:.6rem;"></i>Chờ duyệt
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${hs.status == 'REJECTED'}">
                                                        <span class="badge bg-danger-subtle text-danger border border-danger px-2 py-1">
                                                            <i class="fa-solid fa-ban me-1" style="font-size:.6rem;"></i>Từ chối
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${hs.status == 'INACTIVE'}">
                                                        <span class="badge bg-secondary-subtle text-secondary border px-2 py-1">
                                                            <i class="fa-solid fa-pause me-1" style="font-size:.6rem;"></i>Tạm ngừng
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-light text-dark border px-2">${hs.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- Actions -->
                                            <td class="pe-4">
                                                <div class="d-flex gap-2 flex-wrap">
                                                    <c:if test="${hs.status == 'ACTIVE'}">
                                                        <a href="${pageContext.request.contextPath}/owner/calendar?homestayId=${hs.homestayId}"
                                                           class="btn btn-sm btn-outline-secondary rounded-3"
                                                           title="Quản lý lịch &amp; giá">
                                                            <i class="fa-regular fa-calendar-days"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/owner/rooms?homestayId=${hs.homestayId}"
                                                           class="btn btn-sm btn-outline-secondary rounded-3"
                                                           title="Quản lý loại phòng &amp; phòng vật lý">
                                                            <i class="fa-solid fa-bed"></i>
                                                        </a>
                                                    </c:if>
                                                    <a href="${pageContext.request.contextPath}/owner/homestays/edit?id=${hs.homestayId}"
                                                       class="btn btn-sm btn-outline-primary rounded-3"
                                                       title="Chỉnh sửa thông tin cơ sở">
                                                        <i class="fa-solid fa-pen me-1"></i>Sửa
                                                    </a>
                                                    <c:choose>
                                                        <c:when test="${hs.status == 'ACTIVE'}">
                                                            <form method="post"
                                                                  action="${pageContext.request.contextPath}/owner/homestays/toggle"
                                                                  style="display:inline;"
                                                                  onsubmit="return confirm('Tạm ngừng cơ sở này?\nCác đặt phòng đã xác nhận không bị ảnh hưởng.\nCơ sở sẽ ngừng nhận đặt mới cho đến khi bạn kích hoạt lại.')">
                                                                <input type="hidden" name="homestayId" value="${hs.homestayId}">
                                                                <input type="hidden" name="action" value="deactivate">
                                                                <button type="submit"
                                                                        class="btn btn-sm btn-outline-warning rounded-3"
                                                                        title="Tạm ngừng — ngừng nhận đặt phòng mới">
                                                                    <i class="fa-solid fa-pause"></i>
                                                                </button>
                                                            </form>
                                                        </c:when>
                                                        <c:when test="${hs.status == 'INACTIVE'}">
                                                            <form method="post"
                                                                  action="${pageContext.request.contextPath}/owner/homestays/toggle"
                                                                  style="display:inline;">
                                                                <input type="hidden" name="homestayId" value="${hs.homestayId}">
                                                                <input type="hidden" name="action" value="activate">
                                                                <button type="submit"
                                                                        class="btn btn-sm btn-outline-success rounded-3"
                                                                        title="Kích hoạt lại — mở bán phòng trở lại">
                                                                    <i class="fa-solid fa-play me-1"></i>Kích hoạt
                                                                </button>
                                                            </form>
                                                        </c:when>
                                                        <c:when test="${hs.status == 'REJECTED'}">
                                                            <a href="${pageContext.request.contextPath}/owner/homestays/edit?id=${hs.homestayId}"
                                                               class="btn btn-sm btn-outline-danger rounded-3"
                                                               title="Chỉnh sửa theo yêu cầu Admin và gửi lại duyệt">
                                                                <i class="fa-solid fa-rotate-right me-1"></i>Gửi lại
                                                            </a>
                                                        </c:when>
                                                        <c:when test="${hs.status == 'PENDING_APPROVAL'}">
                                                            <span class="badge bg-warning-subtle text-warning border border-warning px-2 py-1"
                                                                  title="Admin đang xem xét cơ sở của bạn, thường trong 1–2 ngày làm việc"
                                                                  style="font-size:.75rem;cursor:help;">
                                                                <i class="fa-solid fa-hourglass-half me-1"></i>Đang xét duyệt
                                                            </span>
                                                        </c:when>
                                                    </c:choose>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <!-- Table footer -->
                <div class="px-4 py-3 border-top d-flex align-items-center justify-content-between flex-wrap gap-2">
                    <small class="text-muted">
                        ${countActive} hoạt động · ${countPending} chờ duyệt · ${countRejected} từ chối · ${countInactive} tạm ngừng
                    </small>
                    <a href="${pageContext.request.contextPath}/owner/homestays/new"
                       class="btn btn-sm btn-outline-primary rounded-3">
                        <i class="fa-solid fa-plus me-1"></i>Thêm cơ sở mới
                    </a>
                </div>
            </div>

        </div><%-- /.owner-content --%>
    </div><%-- /.owner-main --%>
</div><%-- /.owner-shell --%>

<script>
// Status filter: show/hide rows by data-status attribute
function filterStatus(status, btn) {
    // Update button active state
    document.querySelectorAll('#homestayTable').forEach(function() {}); // noop
    var btns = btn.closest('.btn-group').querySelectorAll('.btn');
    btns.forEach(function(b) { b.classList.remove('active'); });
    btn.classList.add('active');

    // Filter rows
    document.querySelectorAll('#homestayTable tbody tr[data-status]').forEach(function(row) {
        if (status === 'all' || row.dataset.status === status) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    });
}
</script>

<jsp:include page="../common/footer.jsp"/>
