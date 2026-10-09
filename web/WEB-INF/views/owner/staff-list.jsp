<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle"      value="Nhân viên Lễ tân"       scope="request"/>
<c:set var="pageBreadcrumb" value="Vận hành &amp; Báo cáo" scope="request"/>
<jsp:include page="../common/header.jsp"/>

<style>
.owner-modal-overlay {
    display: none; position: fixed; inset: 0;
    background: rgba(15,23,42,.5); z-index: 900;
    align-items: center; justify-content: center; padding: 1rem;
}
.owner-modal-overlay.show { display: flex; }
.owner-modal-box {
    background: #fff; border-radius: 16px; padding: 1.75rem;
    width: 100%; max-width: 520px; max-height: 90vh;
    overflow-y: auto; box-shadow: 0 20px 60px rgba(0,0,0,.2);
}
/* Pagination */
#staffPagination {
    display: flex; gap: .35rem; flex-wrap: wrap;
    justify-content: center; margin-top: 1rem;
}
#staffPagination .pg-btn {
    min-width: 34px; height: 34px; border-radius: 9px;
    border: 1px solid #e2e8f0; background: #fff; color: #475569;
    font-size: .82rem; display: inline-flex; align-items: center;
    justify-content: center; cursor: pointer; padding: 0 .5rem;
    transition: all .15s ease;
}
#staffPagination .pg-btn:hover:not(.active):not(:disabled) {
    background: #eef2ff; border-color: #6366f1; color: #6366f1;
}
#staffPagination .pg-btn.active {
    background: #6366f1; border-color: #6366f1; color: #fff; font-weight: 700;
}
#staffPagination .pg-btn:disabled {
    opacity: .38; cursor: default;
}
#staffPagination .pg-ellipsis {
    min-width: 34px; height: 34px; display: inline-flex;
    align-items: center; justify-content: center;
    color: #94a3b8; font-size: .82rem;
}
</style>

<div class="owner-shell">
    <jsp:include page="../common/sidebar-owner.jsp"/>
    <div class="owner-main">
        <jsp:include page="../common/owner-topbar.jsp"/>
        <div class="owner-content">

            <%-- Flash messages --%>
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

            <%-- Page Header --%>
            <div class="owner-page-header">
                <div class="owner-page-header__info">
                    <h2><i class="fa-solid fa-user-gear text-primary me-2"></i>Quản lý Nhân viên Lễ tân</h2>
                    <p>Cấp tài khoản lễ tân, phân công cơ sở và gửi email kích hoạt tự động</p>
                </div>
                <c:choose>
                    <c:when test="${empty myHomestays}">
                        <button class="btn btn-primary-custom btn-sm px-4" disabled title="Chưa có homestay được duyệt">
                            <i class="fa-solid fa-user-plus me-1"></i>Tạo Tài khoản Lễ tân Mới
                        </button>
                    </c:when>
                    <c:otherwise>
                        <button class="btn btn-primary-custom btn-sm px-4" onclick="openCreateModal()">
                            <i class="fa-solid fa-user-plus me-1"></i>Tạo Tài khoản Lễ tân Mới
                        </button>
                    </c:otherwise>
                </c:choose>
            </div>

            <%-- Stats cards --%>
            <div class="row g-3 mb-4">
                <div class="col-sm-4">
                    <div class="owner-card d-flex align-items-center gap-3 p-3">
                        <div style="width:44px;height:44px;border-radius:12px;background:rgba(16,185,129,.1);display:flex;align-items:center;justify-content:center;font-size:1.2rem;color:#10b981;flex-shrink:0;">
                            <i class="fa-solid fa-user-check"></i>
                        </div>
                        <div>
                            <div class="fw-bold fs-4 lh-1">${countActive}</div>
                            <div class="text-muted" style="font-size:.8rem;">Đang hoạt động</div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="owner-card d-flex align-items-center gap-3 p-3">
                        <div style="width:44px;height:44px;border-radius:12px;background:rgba(99,102,241,.1);display:flex;align-items:center;justify-content:center;font-size:1.2rem;color:#6366f1;flex-shrink:0;">
                            <i class="fa-solid fa-building-user"></i>
                        </div>
                        <div>
                            <div class="fw-bold fs-4 lh-1">${countManaged}</div>
                            <div class="text-muted" style="font-size:.8rem;">Cơ sở được quản lý</div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="owner-card d-flex align-items-center gap-3 p-3">
                        <div style="width:44px;height:44px;border-radius:12px;background:rgba(245,158,11,.1);display:flex;align-items:center;justify-content:center;font-size:1.2rem;color:#f59e0b;flex-shrink:0;">
                            <i class="fa-solid fa-envelope"></i>
                        </div>
                        <div>
                            <div class="fw-bold fs-4 lh-1">${countPending}</div>
                            <div class="text-muted" style="font-size:.8rem;">Chờ kích hoạt</div>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Staff Table --%>
            <div class="owner-card p-0 overflow-hidden">
                <div class="d-flex align-items-center justify-content-between px-4 py-3 border-bottom">
                    <h6 class="fw-bold mb-0">
                        <i class="fa-solid fa-list-ul me-2 text-primary"></i>Danh sách Nhân viên
                    </h6>
                    <input type="search" id="staffSearch" class="form-control form-control-sm"
                           placeholder="Tìm theo tên, email, cơ sở..."
                           style="width:240px;" oninput="filterStaffTable(this.value)">
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0" id="staffTable">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-4">Nhân viên</th>
                                <th>Email tài khoản</th>
                                <th>Cơ sở phân công</th>
                                <th>Trạng thái</th>
                                <th>Tham gia</th>
                                <th class="pe-4">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty staffList}">
                                    <tr>
                                        <td colspan="6" class="text-center py-5 text-muted">
                                            <i class="fa-solid fa-user-slash fa-2x mb-3 d-block opacity-25"></i>
                                            Chưa có nhân viên lễ tân nào được tạo.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="staff" items="${staffList}">
                                        <tr class="staff-row"
                                            data-name="${fn:toLowerCase(staff.fullName)}"
                                            data-email="${fn:toLowerCase(staff.email)}"
                                            data-homestay="${fn:toLowerCase(staff.homestayName)}"
                                            data-staffname="${fn:escapeXml(staff.fullName)}">

                                            <%-- Avatar + Name --%>
                                            <td class="ps-4">
                                                <div class="d-flex align-items-center gap-2">
                                                    <c:choose>
                                                        <c:when test="${not empty staff.avatarUrl}">
                                                            <img src="${staff.avatarUrl}" alt="${staff.fullName}"
                                                                 style="width:38px;height:38px;border-radius:50%;object-fit:cover;flex-shrink:0;">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div style="width:38px;height:38px;border-radius:50%;background:linear-gradient(135deg,#6366f1,#8b5cf6);display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:.9rem;flex-shrink:0;">
                                                                ${fn:substring(staff.fullName,0,1)}
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <div>
                                                        <div class="fw-semibold" style="font-size:.88rem;">${staff.fullName}</div>
                                                        <div class="text-muted" style="font-size:.75rem;">Receptionist</div>
                                                    </div>
                                                </div>
                                            </td>

                                            <td class="text-muted" style="font-size:.85rem;">${staff.email}</td>

                                            <td>
                                                <span class="badge bg-primary-subtle text-primary border border-primary-subtle" style="font-size:.75rem;">${staff.homestayName}</span>
                                            </td>

                                            <td>
                                                <c:choose>
                                                    <c:when test="${!staff.active}">
                                                        <span class="badge bg-danger-subtle text-danger border border-danger px-2 py-1">
                                                            <i class="fa-solid fa-lock me-1" style="font-size:.5rem;"></i>Đã khoá
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${staff.mustChangePassword}">
                                                        <span class="badge bg-warning-subtle text-warning border border-warning px-2 py-1">
                                                            <i class="fa-solid fa-hourglass-half me-1" style="font-size:.5rem;"></i>Chờ kích hoạt
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-success-subtle text-success border border-success px-2 py-1">
                                                            <i class="fa-solid fa-circle me-1" style="font-size:.5rem;"></i>Hoạt động
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td class="text-muted" style="font-size:.82rem;">
                                                <i class="fa-regular fa-calendar me-1"></i>
                                                <fmt:formatDate value="${staff.createdAt}" pattern="dd/MM/yyyy"/>
                                            </td>

                                            <td class="pe-4">
                                                <div class="d-flex flex-wrap gap-2">
                                                    <%-- Reassign --%>
                                                    <button type="button"
                                                            class="btn btn-sm btn-outline-secondary rounded-3"
                                                            onclick="openReassignModal(${staff.userId}, this.closest('tr').dataset.staffname, ${staff.homestayId})">
                                                        <i class="fa-solid fa-right-left me-1"></i>Đổi cơ sở
                                                    </button>

                                                    <%-- Reset --%>
                                                    <form method="post" action="${pageContext.request.contextPath}/owner/staffs"
                                                          onsubmit="return confirm('Reset mật khẩu của ${staff.fullName}?\nMật khẩu mới sẽ được gửi qua email.');">
                                                        <input type="hidden" name="action" value="reset">
                                                        <input type="hidden" name="userId" value="${staff.userId}">
                                                        <button type="submit" class="btn btn-sm btn-outline-warning rounded-3"
                                                                <c:if test="${!staff.active}">disabled title="Tài khoản đã khoá"</c:if>>
                                                            <i class="fa-solid fa-key me-1"></i>Reset
                                                        </button>
                                                    </form>

                                                    <%-- Lock / Unlock --%>
                                                    <c:choose>
                                                        <c:when test="${staff.active}">
                                                            <form method="post" action="${pageContext.request.contextPath}/owner/staffs"
                                                                  onsubmit="return confirm('Khoá tài khoản của ${staff.fullName}?');">
                                                                <input type="hidden" name="action" value="lock">
                                                                <input type="hidden" name="userId" value="${staff.userId}">
                                                                <button type="submit" class="btn btn-sm btn-outline-danger rounded-3">
                                                                    <i class="fa-solid fa-lock me-1"></i>Khoá
                                                                </button>
                                                            </form>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <form method="post" action="${pageContext.request.contextPath}/owner/staffs"
                                                                  onsubmit="return confirm('Mở khoá tài khoản của ${staff.fullName}?');">
                                                                <input type="hidden" name="action" value="unlock">
                                                                <input type="hidden" name="userId" value="${staff.userId}">
                                                                <button type="submit" class="btn btn-sm btn-outline-success rounded-3">
                                                                    <i class="fa-solid fa-lock-open me-1"></i>Mở khoá
                                                                </button>
                                                            </form>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <tr id="staffNoResults" style="display:none;">
                                        <td colspan="6" class="text-center py-4 text-muted">
                                            <i class="fa-solid fa-magnifying-glass me-2"></i>Không tìm thấy nhân viên phù hợp.
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <div id="staffPagination"></div>

                <div class="px-4 py-3 border-top d-flex align-items-center justify-content-between">
                    <small class="text-muted" id="staffCountLabel">Hiển thị ${fn:length(staffList)} nhân viên</small>
                    <c:if test="${not empty myHomestays}">
                        <button class="btn btn-sm btn-outline-primary rounded-3" onclick="openCreateModal()">
                            <i class="fa-solid fa-user-plus me-1"></i>Thêm nhân viên mới
                        </button>
                    </c:if>
                </div>
            </div>

        </div>
    </div>
</div>

<%-- CREATE MODAL --%>
<div class="owner-modal-overlay" id="createModal">
    <div class="owner-modal-box">
        <div class="d-flex align-items-center justify-content-between mb-4">
            <h5 class="fw-bold mb-0"><i class="fa-solid fa-user-plus text-primary me-2"></i>Tạo Tài khoản Lễ tân Mới</h5>
            <button type="button" class="btn-close" onclick="closeModal('createModal')"></button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/owner/staffs" novalidate>
            <input type="hidden" name="action" value="create">
            <div class="mb-3">
                <label class="form-label fw-semibold" style="font-size:.85rem;">Họ và tên <span class="text-danger">*</span></label>
                <input type="text" name="fullName" id="csFullName" class="form-control form-control-sm"
                       placeholder="Vd: Nguyễn Văn Lễ Tân" required maxlength="100">
            </div>
            <div class="mb-3">
                <label class="form-label fw-semibold" style="font-size:.85rem;">Email đăng nhập <span class="text-danger">*</span></label>
                <input type="email" name="email" class="form-control form-control-sm"
                       placeholder="letan@example.com" required maxlength="150">
                <div class="form-text text-muted" style="font-size:.78rem;">Mật khẩu ngẫu nhiên sẽ được tạo và gửi đến email này.</div>
            </div>
            <div class="mb-4">
                <label class="form-label fw-semibold" style="font-size:.85rem;">Phân công cơ sở <span class="text-danger">*</span></label>
                <select name="homestayId" class="form-select form-select-sm" required>
                    <option value="">-- Chọn cơ sở homestay --</option>
                    <c:forEach var="hs" items="${myHomestays}">
                        <option value="${hs.homestayId}">${hs.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="alert alert-info d-flex gap-2 align-items-start py-2 px-3 mb-4" style="font-size:.82rem;">
                <i class="fa-solid fa-circle-info mt-1 flex-shrink-0"></i>
                <div>Hệ thống sẽ tự động tạo mật khẩu ngẫu nhiên và gửi email kích hoạt. Nhân viên được yêu cầu đổi mật khẩu ngay lần đăng nhập đầu tiên.</div>
            </div>
            <div class="d-flex gap-2 justify-content-end">
                <button type="button" class="btn btn-outline-secondary btn-sm" onclick="closeModal('createModal')">Hủy</button>
                <button type="submit" class="btn btn-primary-custom btn-sm px-4">
                    <i class="fa-solid fa-paper-plane me-1"></i>Tạo &amp; Gửi email kích hoạt
                </button>
            </div>
        </form>
    </div>
</div>

<%-- REASSIGN MODAL --%>
<div class="owner-modal-overlay" id="reassignModal">
    <div class="owner-modal-box" style="max-width:440px;">
        <div class="d-flex align-items-center justify-content-between mb-4">
            <h5 class="fw-bold mb-0"><i class="fa-solid fa-right-left text-secondary me-2"></i>Đổi cơ sở phân công</h5>
            <button type="button" class="btn-close" onclick="closeModal('reassignModal')"></button>
        </div>
        <p class="text-muted mb-3" style="font-size:.88rem;">Nhân viên: <strong id="reassignStaffName">—</strong></p>
        <form method="post" action="${pageContext.request.contextPath}/owner/staffs">
            <input type="hidden" name="action" value="reassign">
            <input type="hidden" name="userId" id="reassignUserId" value="">
            <div class="mb-4">
                <label class="form-label fw-semibold" style="font-size:.85rem;">Cơ sở mới <span class="text-danger">*</span></label>
                <select name="homestayId" id="reassignHomestayId" class="form-select form-select-sm" required>
                    <c:forEach var="hs" items="${myHomestays}">
                        <option value="${hs.homestayId}">${hs.name}</option>
                    </c:forEach>
                </select>
                <div class="form-text text-muted" style="font-size:.78rem;">Nhân viên sẽ được chuyển sang cơ sở mới ngay lập tức.</div>
            </div>
            <div class="d-flex gap-2 justify-content-end">
                <button type="button" class="btn btn-outline-secondary btn-sm" onclick="closeModal('reassignModal')">Hủy</button>
                <button type="submit" class="btn btn-primary-custom btn-sm px-4">
                    <i class="fa-solid fa-check me-1"></i>Xác nhận chuyển cơ sở
                </button>
            </div>
        </form>
    </div>
</div>

<script>
function openCreateModal() {
    document.getElementById('createModal').classList.add('show');
    document.getElementById('csFullName').focus();
}
function closeModal(id) { document.getElementById(id).classList.remove('show'); }
function openReassignModal(userId, staffName, currentHomestayId) {
    document.getElementById('reassignUserId').value          = userId;
    document.getElementById('reassignStaffName').textContent = staffName || '';
    var sel = document.getElementById('reassignHomestayId');
    if (sel) sel.value = currentHomestayId;
    document.getElementById('reassignModal').classList.add('show');
}
document.querySelectorAll('.owner-modal-overlay').forEach(function(el) {
    el.addEventListener('click', function(e) { if (e.target === el) el.classList.remove('show'); });
});
function filterStaffTable(query) {
    var q = query.trim().toLowerCase();
    var rows = document.querySelectorAll('#staffTable .staff-row');
    staffFiltered = [];
    rows.forEach(function(row) {
        var match = q === '' || (row.dataset.name||'').includes(q) || (row.dataset.email||'').includes(q) || (row.dataset.homestay||'').includes(q);
        if (match) staffFiltered.push(row);
    });
    staffCurrentPage = 1;
    renderStaffPage();
}

/* ===== Client-side pagination ===== */
var STAFF_PAGE_SIZE = 10;
var staffCurrentPage = 1;
var staffFiltered = [];

function buildPageNumbers(total, current) {
    if (total <= 7) {
        var all = [];
        for (var i = 1; i <= total; i++) all.push(i);
        return all;
    }
    var pages = [];
    var winStart = Math.max(2, current - 1);
    var winEnd   = Math.min(total - 1, current + 1);
    pages.push(1);
    if (winStart > 2) pages.push('…');
    for (var p = winStart; p <= winEnd; p++) pages.push(p);
    if (winEnd < total - 1) pages.push('…');
    pages.push(total);
    return pages;
}

function renderStaffPage() {
    var allRows = document.querySelectorAll('#staffTable .staff-row');
    var noRes   = document.getElementById('staffNoResults');
    var label   = document.getElementById('staffCountLabel');
    var pagEl   = document.getElementById('staffPagination');

    var totalRows = staffFiltered.length;
    var totalPages = Math.max(1, Math.ceil(totalRows / STAFF_PAGE_SIZE));
    if (staffCurrentPage > totalPages) staffCurrentPage = totalPages;
    if (staffCurrentPage < 1) staffCurrentPage = 1;

    var startIdx = (staffCurrentPage - 1) * STAFF_PAGE_SIZE;
    var endIdx   = startIdx + STAFF_PAGE_SIZE;

    // Hide every row first, then show only the slice for this page.
    allRows.forEach(function(row) { row.style.display = 'none'; });
    staffFiltered.forEach(function(row, idx) {
        row.style.display = (idx >= startIdx && idx < endIdx) ? '' : 'none';
    });

    if (noRes) noRes.style.display = (allRows.length > 0 && totalRows === 0) ? '' : 'none';

    if (label) {
        if (totalRows === 0) {
            label.textContent = 'Hiển thị 0 / ' + allRows.length + ' nhân viên';
        } else {
            var from = startIdx + 1;
            var to   = Math.min(endIdx, totalRows);
            label.textContent = 'Hiển thị ' + from + '-' + to + ' / ' + totalRows +
                                ' nhân viên (Trang ' + staffCurrentPage + '/' + totalPages + ')';
        }
    }

    if (!pagEl) return;
    pagEl.innerHTML = '';
    if (totalRows === 0 || totalPages <= 1) return;

    // Prev button
    pagEl.appendChild(makeIconBtn('fa-chevron-left', staffCurrentPage === 1, function() {
        gotoStaffPage(staffCurrentPage - 1);
    }));

    // Page numbers
    buildPageNumbers(totalPages, staffCurrentPage).forEach(function(p) {
        if (p === '…') {
            var span = document.createElement('span');
            span.className = 'pg-ellipsis';
            span.textContent = '…';
            pagEl.appendChild(span);
        } else {
            var btn = document.createElement('button');
            btn.type = 'button';
            btn.className = 'pg-btn' + (p === staffCurrentPage ? ' active' : '');
            btn.textContent = p;
            btn.addEventListener('click', function() { gotoStaffPage(p); });
            pagEl.appendChild(btn);
        }
    });

    // Next button
    pagEl.appendChild(makeIconBtn('fa-chevron-right', staffCurrentPage === totalPages, function() {
        gotoStaffPage(staffCurrentPage + 1);
    }));
}

function makeIconBtn(iconClass, disabled, handler) {
    var btn = document.createElement('button');
    btn.type = 'button';
    btn.className = 'pg-btn';
    btn.disabled = disabled;
    btn.innerHTML = '<i class="fa-solid ' + iconClass + '"></i>';
    if (!disabled) btn.addEventListener('click', handler);
    return btn;
}

function gotoStaffPage(p) {
    staffCurrentPage = p;
    renderStaffPage();
}

// Initialise pagination on load with all rows visible.
(function initStaffPagination() {
    staffFiltered = Array.prototype.slice.call(document.querySelectorAll('#staffTable .staff-row'));
    staffCurrentPage = 1;
    renderStaffPage();
})();
setTimeout(function() {
    document.querySelectorAll('.alert-dismissible').forEach(function(el) {
        var a = bootstrap && bootstrap.Alert ? new bootstrap.Alert(el) : null;
        if (a) a.close(); else el.style.display = 'none';
    });
}, 5000);
</script>

<jsp:include page="../common/footer.jsp"/>
