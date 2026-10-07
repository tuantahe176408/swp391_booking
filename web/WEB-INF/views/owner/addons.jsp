<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle"      value="Dịch vụ Bổ sung"   scope="request"/>
<c:set var="pageBreadcrumb" value="Quản lý Tài sản"    scope="request"/>
<jsp:include page="../common/header.jsp"/>

<style>
/* ── Modal overlay ─────────────────────────────────────────── */
.owner-modal-overlay {
    display:none; position:fixed; inset:0;
    background:rgba(15,23,42,.55); z-index:900;
    align-items:center; justify-content:center; padding:1rem;
    backdrop-filter: blur(2px);
}
.owner-modal-overlay.show { display:flex; }
.owner-modal-box {
    background:#fff; border-radius:20px; padding:0;
    width:100%; max-width:600px; max-height:92vh;
    overflow-y:auto; box-shadow:0 24px 64px rgba(0,0,0,.18);
    display:flex; flex-direction:column;
}
.owner-modal-header {
    padding:1.4rem 1.75rem 1rem;
    border-bottom:1px solid #f1f5f9;
    display:flex; align-items:center; justify-content:space-between;
    position:sticky; top:0; background:#fff; z-index:1; border-radius:20px 20px 0 0;
}
.owner-modal-body { padding:1.4rem 1.75rem; flex:1; }
.owner-modal-footer {
    padding:.9rem 1.75rem 1.4rem;
    border-top:1px solid #f1f5f9;
    display:flex; align-items:center; justify-content:flex-end; gap:.6rem;
    position:sticky; bottom:0; background:#fff; border-radius:0 0 20px 20px;
}

/* ── Homestay checkbox list ────────────────────────────────── */
.hs-check-list {
    border:1.5px solid #e2e8f0; border-radius:12px;
    overflow:hidden; max-height:180px; overflow-y:auto;
}
.hs-check-all {
    background:#f8fafc; border-bottom:1.5px solid #e2e8f0 !important;
    padding:.6rem 1rem; display:flex; align-items:center; gap:.6rem;
    cursor:pointer; user-select:none;
}
.hs-check-all input[type=checkbox] { width:16px; height:16px; cursor:pointer; accent-color:#6366f1; }
.hs-check-item {
    padding:.55rem 1rem; display:flex; align-items:center; gap:.6rem;
    cursor:pointer; transition:background .12s; border-bottom:1px solid #f1f5f9;
    user-select:none;
}
.hs-check-item:last-child { border-bottom:none; }
.hs-check-item:hover { background:#f0f4ff; }
.hs-check-item input[type=checkbox] { width:16px; height:16px; cursor:pointer; accent-color:#6366f1; }
.hs-check-item input[type=checkbox]:disabled { cursor:default; opacity:.7; }
.hs-check-item.is-current { background:#f0f4ff; }

/* ── Stats cards ──────────────────────────────────────────── */
.stat-card {
    background:#fff; border-radius:16px; padding:1.1rem 1.25rem;
    border:1px solid #f1f5f9; display:flex; align-items:center; gap:.9rem;
    box-shadow:0 1px 4px rgba(15,23,42,.05);
}
.stat-icon {
    width:46px; height:46px; border-radius:13px;
    display:flex; align-items:center; justify-content:center;
    font-size:1.15rem; flex-shrink:0;
}

/* ── Table tweaks ─────────────────────────────────────────── */
#addonTable thead th { font-size:.78rem; font-weight:700; text-transform:uppercase; letter-spacing:.04em; color:#64748b; }
#addonTable tbody td { font-size:.86rem; vertical-align:middle; }
.action-btn { width:32px; height:32px; padding:0; display:inline-flex; align-items:center; justify-content:center; border-radius:8px; }

/* ── Homestay chips (grouped table rows) ─────────────────── */
.hs-chip {
    display:inline-flex; align-items:center; gap:4px;
    padding:3px 8px 3px 6px; border-radius:20px;
    font-size:.76rem; font-weight:500; border:1px solid;
    margin:2px; white-space:nowrap;
}
.hs-chip--on  { background:rgba(16,185,129,.1); border-color:#6ee7b7; color:#065f46; }
.hs-chip--off { background:rgba(100,116,139,.08); border-color:#cbd5e1; color:#475569; }
.hs-chip .dot { width:6px; height:6px; border-radius:50%; flex-shrink:0; }
.hs-chip--on .dot  { background:#10b981; }
.hs-chip--off .dot { background:#94a3b8; }
.hs-chip-btn { background:none; border:none; padding:0 0 0 3px; cursor:pointer; line-height:1; opacity:.7; }
.hs-chip-btn:hover { opacity:1; }
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
                    <h2><i class="fa-solid fa-bell-concierge text-primary me-2"></i>Danh mục Dịch vụ Bổ sung</h2>
                    <p>Thiết lập các gói dịch vụ đi kèm khi khách đặt phòng (xe đưa đón, BBQ, ăn sáng…)</p>
                </div>
                <c:choose>
                    <c:when test="${empty myHomestays}">
                        <button class="btn btn-primary-custom btn-sm px-4" disabled title="Chưa có homestay được duyệt">
                            <i class="fa-solid fa-plus me-1"></i>Thêm Dịch vụ Mới
                        </button>
                    </c:when>
                    <c:otherwise>
                        <button class="btn btn-primary-custom btn-sm px-4" onclick="openCreateModal()">
                            <i class="fa-solid fa-plus me-1"></i>Thêm Dịch vụ Mới
                        </button>
                    </c:otherwise>
                </c:choose>
            </div>

            <%-- Stats --%>
            <div class="row g-3 mb-4">
                <div class="col-sm-4">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:rgba(16,185,129,.1); color:#10b981;">
                            <i class="fa-solid fa-circle-check"></i>
                        </div>
                        <div>
                            <div class="fw-bold fs-4 lh-1 mb-1">${countActive}</div>
                            <div class="text-muted" style="font-size:.78rem;">Đang mở bán</div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:rgba(99,102,241,.1); color:#6366f1;">
                            <i class="fa-solid fa-pause-circle"></i>
                        </div>
                        <div>
                            <div class="fw-bold fs-4 lh-1 mb-1">${countInactive}</div>
                            <div class="text-muted" style="font-size:.78rem;">Tạm ngừng</div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:rgba(245,158,11,.1); color:#f59e0b;">
                            <i class="fa-solid fa-receipt"></i>
                        </div>
                        <div>
                            <div class="fw-bold fs-4 lh-1 mb-1">${countTotal}</div>
                            <div class="text-muted" style="font-size:.78rem;">Tổng dịch vụ</div>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Add-ons Table --%>
            <div class="owner-card p-0 overflow-hidden">

                <%-- Homestay filter tabs (only when > 1 homestay) --%>
                <c:if test="${fn:length(myHomestays) > 1}">
                    <div class="px-4 pt-3 pb-2 border-bottom d-flex gap-2 flex-wrap" id="homestayTabs">
                        <button class="btn btn-sm rounded-pill px-3 fw-semibold btn-primary"
                                onclick="filterByHomestay(0, this)">
                            Tất cả
                            <span class="badge rounded-pill ms-1 bg-white text-dark">${countTotal}</span>
                        </button>
                        <c:forEach var="hs" items="${myHomestays}">
                            <button class="btn btn-sm rounded-pill px-3 fw-semibold btn-outline-secondary"
                                    onclick="filterByHomestay(${hs.homestayId}, this)">
                                ${hs.name}
                            </button>
                        </c:forEach>
                    </div>
                </c:if>

                <div class="d-flex align-items-center justify-content-between px-4 py-3 border-bottom">
                    <h6 class="fw-bold mb-0">
                        <i class="fa-solid fa-list-ul me-2 text-primary"></i>Danh sách Dịch vụ
                    </h6>
                    <input type="search" id="addonSearch" class="form-control form-control-sm"
                           placeholder="Tìm kiếm dịch vụ..." style="width:220px;"
                           oninput="filterAddonTable(this.value)">
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0" id="addonTable">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-4">Tên Dịch vụ</th>
                                <th>Cơ sở</th>
                                <th>Đơn giá</th>
                                <th>Đơn vị</th>
                                <th class="pe-4 text-center">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty addonGroups}">
                                    <tr>
                                        <td colspan="5" class="text-center py-5 text-muted">
                                            <i class="fa-solid fa-bell-concierge fa-2x mb-3 d-block opacity-25"></i>
                                            Chưa có dịch vụ bổ sung nào. Hãy thêm dịch vụ đầu tiên!
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="group" items="${addonGroups}" varStatus="gs">
                                        <c:set var="a0" value="${group[0]}"/>
                                        <%-- Build comma-joined addonIds for this group --%>
                                        <c:set var="addonIdsJoined" value=""/>
                                        <c:set var="idSep" value=""/>
                                        <c:forEach var="ga" items="${group}">
                                            <c:set var="addonIdsJoined" value="${addonIdsJoined}${idSep}${ga.addonId}"/>
                                            <c:set var="idSep" value=","/>
                                        </c:forEach>
                                        <%-- Build comma-joined homestayIds for edit modal --%>
                                        <c:set var="hsIdsJoined" value=""/>
                                        <c:set var="hsSep" value=""/>
                                        <c:forEach var="ga" items="${group}">
                                            <c:set var="hsIdsJoined" value="${hsIdsJoined}${hsSep}${ga.homestayId}"/>
                                            <c:set var="hsSep" value=","/>
                                        </c:forEach>
                                        <%-- Build space-joined homestayIds for filter attribute --%>
                                        <c:set var="groupHsIds" value=""/>
                                        <c:forEach var="ga" items="${group}">
                                            <c:set var="groupHsIds" value="${groupHsIds} ${ga.homestayId}"/>
                                        </c:forEach>
                                        <tr class="addon-row"
                                            data-name="${fn:toLowerCase(a0.name)}"
                                            data-group-homestay-ids="${fn:trim(groupHsIds)}">
                                            <%-- Col 1: Name + description --%>
                                            <td class="ps-4">
                                                <span class="fw-semibold">${fn:escapeXml(a0.name)}</span>
                                                <div class="text-muted" style="font-size:.75rem;max-width:200px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">
                                                    <c:out value="${a0.description}" default=""/>
                                                </div>
                                            </td>
                                            <%-- Col 2: Homestay chips with toggle + delete per chip --%>
                                            <td>
                                                <c:forEach var="ga" items="${group}">
                                                    <span class="hs-chip ${ga.available ? 'hs-chip--on' : 'hs-chip--off'}">
                                                        <span class="dot"></span>
                                                        ${fn:escapeXml(ga.homestayName)}
                                                        <form method="post" action="${pageContext.request.contextPath}/owner/addons" style="display:inline;">
                                                            <input type="hidden" name="action" value="toggle">
                                                            <input type="hidden" name="addonId" value="${ga.addonId}">
                                                            <button type="submit" class="hs-chip-btn"
                                                                    title="${ga.available ? 'Tạm ngừng' : 'Mở bán'}">
                                                                <i class="fa-solid ${ga.available ? 'fa-pause' : 'fa-play'}" style="font-size:.6rem;"></i>
                                                            </button>
                                                        </form>
                                                        <form method="post" action="${pageContext.request.contextPath}/owner/addons"
                                                              style="display:inline;"
                                                              onsubmit="return confirm('Xóa dịch vụ khỏi ${fn:escapeXml(ga.homestayName)}?')">
                                                            <input type="hidden" name="action" value="delete">
                                                            <input type="hidden" name="addonId" value="${ga.addonId}">
                                                            <button type="submit" class="hs-chip-btn text-danger"
                                                                    title="Xóa khỏi cơ sở này">
                                                                <i class="fa-solid fa-xmark" style="font-size:.65rem;"></i>
                                                            </button>
                                                        </form>
                                                    </span>
                                                </c:forEach>
                                            </td>
                                            <%-- Col 3: Price (representative from first addon in group) --%>
                                            <td class="fw-semibold text-primary">
                                                <fmt:formatNumber value="${a0.price}" type="number" groupingUsed="true"/>₫
                                            </td>
                                            <%-- Col 4: Unit badge --%>
                                            <td>
                                                <span class="badge bg-light text-dark border" style="font-size:.74rem;">
                                                    <c:choose>
                                                        <c:when test="${a0.unit == 'per_night'}">/ Đêm</c:when>
                                                        <c:when test="${a0.unit == 'per_person'}">/ Người</c:when>
                                                        <c:when test="${a0.unit == 'per_day'}">/ Ngày</c:when>
                                                        <c:otherwise>/ Lượt</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </td>
                                            <%-- Col 5: Edit group button --%>
                                            <td class="pe-4 text-center">
                                                <button type="button" class="action-btn btn btn-outline-primary"
                                                        title="Chỉnh sửa nhóm"
                                                        onclick="openEditGroupModal(this)"
                                                        data-addon-ids="${fn:escapeXml(addonIdsJoined)}"
                                                        data-homestay-ids="${fn:escapeXml(hsIdsJoined)}"
                                                        data-name="${fn:escapeXml(a0.name)}"
                                                        data-description="${fn:escapeXml(a0.description)}"
                                                        data-price="${a0.price}"
                                                        data-unit="${empty a0.unit ? 'per_booking' : fn:trim(a0.unit)}">
                                                    <i class="fa-solid fa-pen fa-xs"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <tr id="addonNoResults" style="display:none;">
                                        <td colspan="5" class="text-center py-4 text-muted">
                                            <i class="fa-solid fa-magnifying-glass me-2"></i>Không tìm thấy dịch vụ phù hợp.
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <div class="px-4 py-3 border-top d-flex align-items-center justify-content-between">
                    <small class="text-muted" id="addonCountLabel">
                        Hiển thị ${fn:length(addonGroups)} nhóm dịch vụ
                    </small>
                </div>
            </div>

        </div>
    </div>
</div>

<%-- ══════════════════════════════════════════════════════════════
     CREATE MODAL
     ══════════════════════════════════════════════════════════════ --%>
<div class="owner-modal-overlay" id="createModal">
    <div class="owner-modal-box">
        <div class="owner-modal-header">
            <div>
                <h5 class="fw-bold mb-0"><i class="fa-solid fa-plus text-primary me-2"></i>Thêm Dịch vụ Bổ sung</h5>
                <small class="text-muted">Dịch vụ sẽ được tạo cho từng cơ sở đã chọn</small>
            </div>
            <button type="button" class="btn-close" onclick="closeModal('createModal')"></button>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/owner/addons"
              novalidate onsubmit="return validateCreateForm()">
            <input type="hidden" name="action" value="create">
            <div class="owner-modal-body">

                <%-- Homestay multi-select --%>
                <div class="mb-3">
                    <label class="form-label fw-semibold mb-2" style="font-size:.85rem;">
                        <i class="fa-solid fa-building text-primary me-1"></i>
                        Áp dụng cho cơ sở <span class="text-danger">*</span>
                    </label>
                    <div class="hs-check-list" id="createHsList">
                        <%-- Select all --%>
                        <label class="hs-check-all">
                            <input type="checkbox" id="createSelectAll"
                                   onchange="toggleSelectAll('create', this)">
                            <span class="fw-semibold" style="font-size:.85rem;">Chọn tất cả</span>
                            <span class="badge bg-secondary-subtle text-secondary border ms-auto" style="font-size:.74rem;">
                                ${fn:length(myHomestays)} cơ sở
                            </span>
                        </label>
                        <%-- Homestay items --%>
                        <c:forEach var="hs" items="${myHomestays}">
                            <label class="hs-check-item create-hs-check">
                                <input type="checkbox" name="homestayId" value="${hs.homestayId}"
                                       class="create-hs-input"
                                       onchange="updateSelectAllState('create')"
                                       <c:if test="${fn:length(myHomestays) == 1}">checked disabled</c:if>>
                                <span style="font-size:.88rem;"><c:out value="${hs.name}"/></span>
                            </label>
                        </c:forEach>
                    </div>
                    <div id="createHsError" class="text-danger mt-1" style="font-size:.78rem; display:none;">
                        <i class="fa-solid fa-circle-exclamation me-1"></i>Vui lòng chọn ít nhất một cơ sở.
                    </div>
                </div>

                <%-- Service name --%>
                <div class="mb-3">
                    <label class="form-label fw-semibold" style="font-size:.85rem;">
                        Tên dịch vụ <span class="text-danger">*</span>
                    </label>
                    <input type="text" name="addonName" class="form-control form-control-sm"
                           placeholder="Vd: Bữa sáng Buffet, Thuê xe đạp, BBQ..." required maxlength="100">
                </div>

                <%-- Description --%>
                <div class="mb-3">
                    <label class="form-label fw-semibold" style="font-size:.85rem;">Mô tả</label>
                    <textarea name="addonDescription" class="form-control form-control-sm" rows="2"
                              placeholder="Mô tả ngắn về dịch vụ..." maxlength="500"></textarea>
                </div>

                <%-- Price + Unit --%>
                <div class="row g-3">
                    <div class="col-7">
                        <label class="form-label fw-semibold" style="font-size:.85rem;">
                            Đơn giá (₫) <span class="text-danger">*</span>
                        </label>
                        <input type="number" name="addonPrice" class="form-control form-control-sm"
                               placeholder="150000" min="0" step="1000" required>
                    </div>
                    <div class="col-5">
                        <label class="form-label fw-semibold" style="font-size:.85rem;">
                            Đơn vị <span class="text-danger">*</span>
                        </label>
                        <select name="addonUnit" class="form-select form-select-sm" required>
                            <option value="per_booking">/ Lượt đặt</option>
                            <option value="per_night">/ Đêm</option>
                            <option value="per_person">/ Người</option>
                            <option value="per_day">/ Ngày</option>
                        </select>
                    </div>
                </div>

            </div><%-- end modal-body --%>

            <div class="owner-modal-footer">
                <button type="button" class="btn btn-outline-secondary btn-sm px-4"
                        onclick="closeModal('createModal')">Hủy</button>
                <button type="submit" class="btn btn-primary-custom btn-sm px-4">
                    <i class="fa-solid fa-plus me-1"></i>Thêm dịch vụ
                </button>
            </div>
        </form>
    </div>
</div>

<%-- ══════════════════════════════════════════════════════════════
     EDIT GROUP MODAL
     ══════════════════════════════════════════════════════════════ --%>
<div class="owner-modal-overlay" id="editModal">
    <div class="owner-modal-box">
        <div class="owner-modal-header">
            <div>
                <h5 class="fw-bold mb-0"><i class="fa-solid fa-pen text-primary me-2"></i>Chỉnh sửa Nhóm Dịch vụ</h5>
            </div>
            <button type="button" class="btn-close" onclick="closeModal('editModal')"></button>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/owner/addons" novalidate>
            <input type="hidden" name="action" value="updateGroup">
            <input type="hidden" name="addonIds" id="editAddonIds">

            <div class="owner-modal-body">

                <%-- Cơ sở áp dụng — multi-select, checked = giữ/thêm, unchecked = xóa --%>
                <div class="mb-3">
                    <label class="form-label fw-semibold mb-2" style="font-size:.85rem;">
                        <i class="fa-solid fa-building text-primary me-1"></i>
                        Áp dụng cho cơ sở
                    </label>
                    <div class="hs-check-list" id="editHsList">
                        <%-- Select all (only renders if > 1 homestay) --%>
                        <c:if test="${fn:length(myHomestays) > 1}">
                            <label class="hs-check-all">
                                <input type="checkbox" id="editSelectAll"
                                       onchange="toggleSelectAll('edit', this)">
                                <span class="fw-semibold" style="font-size:.85rem;">Chọn tất cả</span>
                                <span class="badge bg-secondary-subtle text-secondary border ms-auto" style="font-size:.74rem;">
                                    ${fn:length(myHomestays)} cơ sở
                                </span>
                            </label>
                        </c:if>
                        <%-- Homestay items — JS pre-ticks current ones --%>
                        <c:forEach var="hs" items="${myHomestays}">
                            <label class="hs-check-item edit-hs-check" id="editHsRow_${hs.homestayId}">
                                <input type="checkbox" name="homestayId" value="${hs.homestayId}"
                                       class="edit-hs-input"
                                       onchange="updateSelectAllState('edit')">
                                <span style="font-size:.88rem;"><c:out value="${hs.name}"/></span>
                            </label>
                        </c:forEach>
                    </div>
                    <small class="text-muted mt-1 d-block" style="font-size:.76rem;">
                        <i class="fa-solid fa-circle-info me-1"></i>
                        Bỏ chọn → xóa dịch vụ khỏi cơ sở đó. Thêm chọn → tạo bản sao mới.
                    </small>
                </div>

                <%-- Service name --%>
                <div class="mb-3">
                    <label class="form-label fw-semibold" style="font-size:.85rem;">
                        Tên dịch vụ <span class="text-danger">*</span>
                    </label>
                    <input type="text" name="addonName" id="editAddonName" class="form-control form-control-sm"
                           required maxlength="100">
                </div>

                <%-- Description --%>
                <div class="mb-3">
                    <label class="form-label fw-semibold" style="font-size:.85rem;">Mô tả</label>
                    <textarea name="addonDescription" id="editAddonDescription"
                              class="form-control form-control-sm" rows="2" maxlength="500"></textarea>
                </div>

                <%-- Price + Unit --%>
                <div class="row g-3">
                    <div class="col-7">
                        <label class="form-label fw-semibold" style="font-size:.85rem;">
                            Đơn giá (₫) <span class="text-danger">*</span>
                        </label>
                        <input type="number" name="addonPrice" id="editAddonPrice"
                               class="form-control form-control-sm" min="0" step="1000" required>
                    </div>
                    <div class="col-5">
                        <label class="form-label fw-semibold" style="font-size:.85rem;">
                            Đơn vị <span class="text-danger">*</span>
                        </label>
                        <select name="addonUnit" id="editAddonUnit"
                                class="form-select form-select-sm" required>
                            <option value="per_booking">/ Lượt đặt</option>
                            <option value="per_night">/ Đêm</option>
                            <option value="per_person">/ Người</option>
                            <option value="per_day">/ Ngày</option>
                        </select>
                    </div>
                </div>

            </div><%-- end modal-body --%>

            <div class="owner-modal-footer">
                <button type="button" class="btn btn-outline-secondary btn-sm px-4"
                        onclick="closeModal('editModal')">Hủy</button>
                <button type="submit" class="btn btn-primary-custom btn-sm px-4">
                    <i class="fa-solid fa-floppy-disk me-1"></i>Lưu thay đổi
                </button>
            </div>
        </form>
    </div>
</div>

<script>
var _activeHomestayId = 0;

/* ── Modal open/close ─────────────────────────────────────── */
function openCreateModal() {
    // Reset form
    document.getElementById('createModal').querySelector('form').reset();
    // If only 1 homestay, inputs are disabled:keep checked state
    updateSelectAllState('create');
    document.getElementById('createHsError').style.display = 'none';
    document.getElementById('createModal').classList.add('show');
}

function closeModal(id) {
    document.getElementById(id).classList.remove('show');
}

function openEditGroupModal(btn) {
    document.getElementById('editAddonIds').value         = btn.dataset.addonIds;
    document.getElementById('editAddonName').value        = btn.dataset.name;
    document.getElementById('editAddonDescription').value = btn.dataset.description || '';
    document.getElementById('editAddonPrice').value       = btn.dataset.price;
    // Safely set unit — fallback to per_booking if value is missing or doesn't match any option
    var _unitSel = document.getElementById('editAddonUnit');
    _unitSel.value = btn.dataset.unit || 'per_booking';
    if (!_unitSel.value) _unitSel.selectedIndex = 0;

    // Reset all checkboxes
    document.querySelectorAll('.edit-hs-input').forEach(function(cb) {
        cb.checked  = false;
        cb.disabled = false;
    });

    // Pre-tick homestays already in this group
    var currentHsIds = btn.dataset.homestayIds.split(',').map(Number);
    currentHsIds.forEach(function(hsId) {
        var cb = document.querySelector('.edit-hs-input[value="' + hsId + '"]');
        if (cb) cb.checked = true;
    });

    updateSelectAllState('edit');
    document.getElementById('editModal').classList.add('show');
}

/* ── Close on overlay click ───────────────────────────────── */
document.querySelectorAll('.owner-modal-overlay').forEach(function(el) {
    el.addEventListener('click', function(e) {
        if (e.target === el) el.classList.remove('show');
    });
});

/* ── Checkbox "select all" helpers ───────────────────────── */
function toggleSelectAll(prefix, cb) {
    document.querySelectorAll('.' + prefix + '-hs-input:not(:disabled)').forEach(function(input) {
        input.checked = cb.checked;
    });
}

function updateSelectAllState(prefix) {
    var all     = document.querySelectorAll('.' + prefix + '-hs-input:not(:disabled)');
    var checked = document.querySelectorAll('.' + prefix + '-hs-input:not(:disabled):checked');
    var selAll  = document.getElementById(prefix + 'SelectAll');
    if (!selAll) return;
    selAll.indeterminate = false;
    if (all.length === 0) {
        selAll.checked = false;
    } else if (checked.length === all.length) {
        selAll.checked = true;
    } else if (checked.length > 0) {
        selAll.indeterminate = true;
    } else {
        selAll.checked = false;
    }
}

/* ── Create form validation ───────────────────────────────── */
function validateCreateForm() {
    var checked = document.querySelectorAll('.create-hs-input:checked');
    if (checked.length === 0) {
        document.getElementById('createHsError').style.display = '';
        document.getElementById('createHsList').scrollIntoView({ behavior:'smooth', block:'nearest' });
        return false;
    }
    document.getElementById('createHsError').style.display = 'none';
    return true;
}

/* ── Filter tabs ──────────────────────────────────────────── */
function filterByHomestay(homestayId, btn) {
    _activeHomestayId = homestayId;
    document.querySelectorAll('#homestayTabs .btn').forEach(function(b) {
        b.className = b.className.replace('btn-primary', 'btn-outline-secondary');
    });
    btn.className = btn.className.replace('btn-outline-secondary', 'btn-primary');
    applyFilters();
}

function filterAddonTable(q) { applyFilters(q); }

function applyFilters(q) {
    if (q === undefined) q = (document.getElementById('addonSearch') || {}).value || '';
    q = q.trim().toLowerCase();
    var rows    = document.querySelectorAll('#addonTable .addon-row');
    var noRes   = document.getElementById('addonNoResults');
    var label   = document.getElementById('addonCountLabel');
    var visible = 0;

    rows.forEach(function(row) {
        var ids     = (row.dataset.groupHomestayIds || '').trim().split(/\s+/);
        var hsMatch = !_activeHomestayId || ids.includes(String(_activeHomestayId));
        var textMatch = !q || (row.dataset.name||'').includes(q);
        var show      = hsMatch && textMatch;
        row.style.display = show ? '' : 'none';
        if (show) visible++;
    });

    if (noRes) noRes.style.display = (rows.length > 0 && visible === 0) ? '' : 'none';
    if (label) label.textContent   = 'Hiển thị ' + visible + ' / ' + rows.length + ' dịch vụ';
}

/* ── Auto-dismiss flash alerts ────────────────────────────── */
setTimeout(function() {
    document.querySelectorAll('.alert-dismissible').forEach(function(el) {
        if (typeof bootstrap !== 'undefined' && bootstrap.Alert) {
            new bootstrap.Alert(el).close();
        } else {
            el.style.display = 'none';
        }
    });
}, 5000);
</script>

<jsp:include page="../common/footer.jsp"/>
