<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:include page="../common/header.jsp"/>

<style>
/* ═══════════════════════════════════════════════════════════════
   ROOMS PAGE — STYLES
════════════════════════════════════════════════════════════════ */

/* ── Room type card ────────────────────────────────────────── */
.rt-card {
    background: #fff;
    border: 1px solid #e2e8f0;
    border-radius: 16px;
    overflow: hidden;
    transition: box-shadow .2s ease;
    margin-bottom: 1.25rem;
}
.rt-card:hover { box-shadow: 0 4px 20px rgba(99,102,241,.1); }

.rt-card__header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 1rem 1.25rem;
    cursor: pointer;
    user-select: none;
    gap: .75rem;
    background: #fff;
    transition: background .15s;
}
.rt-card__header:hover  { background: #f8fafc; }
.rt-card__header.is-open { background: #eef2ff; border-bottom: 1px solid #e2e8f0; }

.rt-card__chevron {
    transition: transform .22s ease;
    color: #94a3b8;
    font-size: .8rem;
    flex-shrink: 0;
}
.rt-card__header.is-open .rt-card__chevron { transform: rotate(180deg); }

.rt-card__body { padding: 1.25rem; background: #fff; display: none; }
.rt-card__body.show { display: block; }

/* ── Physical room chip ────────────────────────────────────── */
.room-chip {
    display: inline-flex;
    flex-direction: column;
    border-radius: 12px;
    overflow: hidden;
    border: 1.5px solid;
    width: 130px;
    flex-shrink: 0;
    transition: box-shadow .15s, transform .15s;
}
.room-chip:hover { box-shadow: 0 4px 14px rgba(0,0,0,.1); transform: translateY(-1px); }

.room-chip__header {
    padding: .4rem .7rem;
    display: flex;
    align-items: center;
    justify-content: space-between;
    font-size: .8rem;
    font-weight: 700;
    color: #fff;
}
.room-chip__body {
    padding: .45rem .7rem;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: .35rem;
}
.room-chip__badge {
    display: inline-flex;
    align-items: center;
    gap: .25rem;
    font-size: .7rem;
    font-weight: 600;
}

/* Status color tokens */
.rs-available   { border-color:#86efac; }
.rs-available   .room-chip__header { background: #16a34a; }
.rs-available   .room-chip__body   { background: #f0fdf4; }
.rs-available   .room-chip__badge  { color: #16a34a; }

.rs-occupied    { border-color:#93c5fd; }
.rs-occupied    .room-chip__header { background: #2563eb; }
.rs-occupied    .room-chip__body   { background: #eff6ff; }
.rs-occupied    .room-chip__badge  { color: #2563eb; }

.rs-maintenance { border-color:#fcd34d; }
.rs-maintenance .room-chip__header { background: #d97706; }
.rs-maintenance .room-chip__body   { background: #fffbeb; }
.rs-maintenance .room-chip__badge  { color: #d97706; }

.rs-dirty       { border-color:#d8b4fe; }
.rs-dirty       .room-chip__header { background: #9333ea; }
.rs-dirty       .room-chip__body   { background: #fdf4ff; }
.rs-dirty       .room-chip__badge  { color: #9333ea; }

/* ── Delete button inside chip ─────────────────────────────── */
.room-chip__del {
    background: rgba(255,255,255,.25);
    border: none;
    border-radius: 5px;
    color: #fff;
    width: 20px; height: 20px;
    display: inline-flex; align-items: center; justify-content: center;
    cursor: pointer; font-size: .65rem;
    transition: background .15s;
    flex-shrink: 0;
}
.room-chip__del:hover { background: rgba(255,255,255,.45); }

/* ── Room status select ────────────────────────────────────── */
.room-status-select {
    font-size: .68rem;
    padding: .1rem .25rem;
    border-radius: 6px;
    border: 1px solid;
    background: transparent;
    width: 100%;
    cursor: pointer;
}
.rs-available   .room-status-select { border-color: #86efac; color: #16a34a; }
.rs-maintenance .room-status-select { border-color: #fcd34d; color: #d97706; }
.rs-dirty       .room-status-select { border-color: #d8b4fe; color: #9333ea; }

/* ── Filter bar ────────────────────────────────────────────── */
.rooms-filter-bar {
    background: #fff;
    border: 1px solid #e2e8f0;
    border-radius: 14px;
    padding: .85rem 1.1rem;
    margin-bottom: 1.25rem;
    display: flex;
    gap: .75rem;
    flex-wrap: wrap;
    align-items: center;
}
.rooms-search-wrap { position: relative; flex: 1; min-width: 180px; }
.rooms-search-icon {
    position: absolute; left: .75rem; top: 50%;
    transform: translateY(-50%);
    color: #94a3b8; font-size: .8rem; pointer-events: none;
}
.rooms-search-input {
    border-radius: 9px !important;
    padding-left: 2.2rem !important;
    font-size: .83rem;
    border-color: #e2e8f0;
}
.rooms-search-input:focus { border-color: #6366f1; box-shadow: 0 0 0 3px rgba(99,102,241,.1); }

/* ── Status pill filter ────────────────────────────────────── */
.room-status-pill {
    border-radius: 20px; font-size: .75rem; padding: .25rem .75rem;
    border: 1px solid #e2e8f0; background: #f8fafc;
    color: #64748b; cursor: pointer; transition: all .15s; white-space: nowrap;
}
.room-status-pill.active { background: #6366f1; border-color: #6366f1; color: #fff; }
.room-status-pill.pill-avail    { background: #f0fdf4; border-color: #86efac; color: #16a34a; }
.room-status-pill.pill-avail.active    { background: #16a34a; border-color: #16a34a; color: #fff; }
.room-status-pill.pill-occupied { background: #eff6ff; border-color: #93c5fd; color: #2563eb; }
.room-status-pill.pill-occupied.active { background: #2563eb; border-color: #2563eb; color: #fff; }
.room-status-pill.pill-maint    { background: #fffbeb; border-color: #fcd34d; color: #d97706; }
.room-status-pill.pill-maint.active    { background: #d97706; border-color: #d97706; color: #fff; }
.room-status-pill.pill-dirty    { background: #fdf4ff; border-color: #d8b4fe; color: #9333ea; }
.room-status-pill.pill-dirty.active    { background: #9333ea; border-color: #9333ea; color: #fff; }

/* ── Modal ─────────────────────────────────────────────────── */
.owner-modal-overlay {
    display: none; position: fixed; inset: 0;
    background: rgba(15,23,42,.55); z-index: 1050;
    align-items: center; justify-content: center; padding: 1rem;
}
.owner-modal-overlay.show { display: flex; }
.owner-modal-box {
    background: #fff; border-radius: 18px;
    padding: 1.75rem 2rem; width: 100%; max-width: 500px;
    max-height: 92vh; overflow-y: auto;
    box-shadow: 0 24px 64px rgba(15,23,42,.2);
    animation: modalIn .18s ease;
}
.owner-modal-box--sm { max-width: 420px; }
@keyframes modalIn {
    from { opacity:0; transform:scale(.96) translateY(-8px); }
    to   { opacity:1; transform:scale(1)   translateY(0); }
}

/* ── Empty state ───────────────────────────────────────────── */
.rooms-empty {
    text-align: center; padding: 2.5rem 1rem;
    color: #94a3b8;
}
.rooms-empty i { font-size: 2.2rem; margin-bottom: .75rem; display: block; opacity:.3; }

/* ── Room type pagination ──────────────────────────────────── */
.rt-pager {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    gap: .35rem;
    margin-top: .75rem;
    padding-top: .25rem;
}
.rt-pager:empty { display: none; }
.rt-pg-btn {
    min-width: 32px;
    height: 32px;
    padding: 0 .5rem;
    border-radius: 8px;
    border: 1px solid #e2e8f0;
    background: #fff;
    color: #475569;
    font-size: .8rem;
    font-weight: 600;
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    transition: all .15s;
}
.rt-pg-btn:hover:not(:disabled):not(.active) { background: #f1f5f9; border-color: #cbd5e1; }
.rt-pg-btn.active { background: #6366f1; border-color: #6366f1; color: #fff; cursor: default; }
.rt-pg-btn:disabled { opacity: .45; cursor: not-allowed; }
.rt-pg-btn.rt-pg-ellipsis { border: none; background: transparent; cursor: default; color: #94a3b8; }

/* ── Add room inline form ──────────────────────────────────── */
.add-room-form {
    display: flex; gap: .6rem; align-items: flex-end;
    flex-wrap: wrap;
    padding-top: 1rem;
    margin-top: .75rem;
    border-top: 1px dashed #e2e8f0;
}
</style>

<div class="owner-shell">
    <jsp:include page="../common/sidebar-owner.jsp"/>
    <div class="owner-main">
        <jsp:include page="../common/owner-topbar.jsp"/>
        <div class="owner-content">

            <!-- Flash messages -->
            <c:if test="${not empty flash_success}">
                <div class="alert alert-success alert-dismissible rounded-3 mb-4 d-flex gap-2 align-items-center">
                    <i class="fa-solid fa-circle-check flex-shrink-0"></i>
                    <span>${flash_success}</span>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty flash_error}">
                <div class="alert alert-danger alert-dismissible rounded-3 mb-4 d-flex gap-2 align-items-center">
                    <i class="fa-solid fa-triangle-exclamation flex-shrink-0"></i>
                    <span>${flash_error}</span>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Page Header -->
            <div class="owner-page-header">
                <div class="owner-page-header__info">
                    <h2><i class="fa-solid fa-bed text-primary me-2"></i>Quản lý Phòng &amp; Loại phòng</h2>
                    <p>
                        <a href="${pageContext.request.contextPath}/owner/homestays"
                           class="text-decoration-none text-muted">
                            <i class="fa-solid fa-arrow-left me-1" style="font-size:.8rem;"></i>Quay lại danh sách
                        </a>
                        <span class="text-muted mx-2">·</span>
                        <i class="fa-solid fa-building-user me-1 text-muted" style="font-size:.82rem;"></i>
                        <span class="fw-semibold text-dark">${homestay.name}</span>
                        <span class="text-muted"> · ${homestay.city}</span>
                    </p>
                </div>
                <button class="btn btn-primary-custom btn-sm px-4"
                        onclick="openModal('addRoomTypeModal')">
                    <i class="fa-solid fa-plus me-1"></i>Thêm Loại phòng
                </button>
            </div>

            <!-- Stats row -->
            <div class="row g-3 mb-4">
                <%-- Pre-compute counts using JSTL --%>
                <c:set var="cntAvail"   value="0"/>
                <c:set var="cntOccup"   value="0"/>
                <c:set var="cntMaint"   value="0"/>
                <c:set var="cntDirty"   value="0"/>
                <c:forEach var="r" items="${rooms}">
                    <c:choose>
                        <c:when test="${r.status == 'AVAILABLE'}">  <c:set var="cntAvail" value="${cntAvail + 1}"/> </c:when>
                        <c:when test="${r.status == 'OCCUPIED'}">   <c:set var="cntOccup" value="${cntOccup + 1}"/> </c:when>
                        <c:when test="${r.status == 'MAINTENANCE'}"><c:set var="cntMaint" value="${cntMaint + 1}"/> </c:when>
                        <c:when test="${r.status == 'DIRTY'}">      <c:set var="cntDirty" value="${cntDirty + 1}"/> </c:when>
                    </c:choose>
                </c:forEach>

                <div class="col-6 col-md-3">
                    <div class="owner-card d-flex align-items-center gap-3 p-3">
                        <div style="width:40px;height:40px;border-radius:10px;background:rgba(99,102,241,.1);display:flex;align-items:center;justify-content:center;color:#6366f1;font-size:1rem;flex-shrink:0;">
                            <i class="fa-solid fa-layer-group"></i>
                        </div>
                        <div>
                            <div class="fw-bold fs-5 lh-1">${fn:length(roomTypes)}</div>
                            <div class="text-muted" style="font-size:.78rem;">Loại phòng</div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="owner-card d-flex align-items-center gap-3 p-3">
                        <div style="width:40px;height:40px;border-radius:10px;background:rgba(16,185,129,.1);display:flex;align-items:center;justify-content:center;color:#10b981;font-size:1rem;flex-shrink:0;">
                            <i class="fa-solid fa-circle-check"></i>
                        </div>
                        <div>
                            <div class="fw-bold fs-5 lh-1">${cntAvail}</div>
                            <div class="text-muted" style="font-size:.78rem;">Trống / Sẵn sàng</div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="owner-card d-flex align-items-center gap-3 p-3">
                        <div style="width:40px;height:40px;border-radius:10px;background:rgba(37,99,235,.1);display:flex;align-items:center;justify-content:center;color:#2563eb;font-size:1rem;flex-shrink:0;">
                            <i class="fa-solid fa-user-check"></i>
                        </div>
                        <div>
                            <div class="fw-bold fs-5 lh-1">${cntOccup}</div>
                            <div class="text-muted" style="font-size:.78rem;">Đang có khách</div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="owner-card d-flex align-items-center gap-3 p-3">
                        <div style="width:40px;height:40px;border-radius:10px;background:rgba(245,158,11,.1);display:flex;align-items:center;justify-content:center;color:#f59e0b;font-size:1rem;flex-shrink:0;">
                            <i class="fa-solid fa-bed"></i>
                        </div>
                        <div>
                            <div class="fw-bold fs-5 lh-1">${fn:length(rooms)}</div>
                            <div class="text-muted" style="font-size:.78rem;">Tổng phòng vật lý</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ── Filter & Search bar ── -->
            <c:if test="${not empty rooms}">
                <div class="rooms-filter-bar">
                    <!-- Search -->
                    <div class="rooms-search-wrap">
                        <i class="fa-solid fa-magnifying-glass rooms-search-icon"></i>
                        <input type="text" id="roomSearch"
                               class="form-control rooms-search-input"
                               placeholder="Tìm số phòng, loại phòng..."
                               oninput="applyRoomFilters()">
                    </div>
                    <!-- Room type dropdown -->
                    <select id="roomTypeFilter"
                            class="form-select"
                            style="font-size:.83rem;border-color:#e2e8f0;border-radius:9px;min-width:160px;max-width:200px;"
                            onchange="applyRoomFilters()">
                        <option value="">Tất cả loại phòng</option>
                        <c:forEach var="rt" items="${roomTypes}">
                            <option value="${rt.roomTypeId}">${rt.name}</option>
                        </c:forEach>
                    </select>
                    <!-- Reset -->
                    <button class="btn btn-outline-secondary btn-sm rounded-3 px-3"
                            style="font-size:.8rem;" onclick="resetRoomFilters()" title="Xóa bộ lọc">
                        <i class="fa-solid fa-rotate-left me-1"></i>Xóa lọc
                    </button>
                </div>

                <!-- Status pills -->
                <div class="d-flex gap-2 flex-wrap mb-3 align-items-center">
                    <span class="text-muted" style="font-size:.78rem;">Trạng thái:</span>
                    <button class="room-status-pill active" data-status="all" onclick="setRoomStatus('all', this)">
                        Tất cả <span class="ms-1 opacity-75">(${fn:length(rooms)})</span>
                    </button>
                    <button class="room-status-pill pill-avail" data-status="AVAILABLE" onclick="setRoomStatus('AVAILABLE', this)">
                        <i class="fa-solid fa-circle-check me-1" style="font-size:.65rem;"></i>Trống
                        <span class="ms-1 opacity-75">(${cntAvail})</span>
                    </button>
                    <button class="room-status-pill pill-occupied" data-status="OCCUPIED" onclick="setRoomStatus('OCCUPIED', this)">
                        <i class="fa-solid fa-user-check me-1" style="font-size:.65rem;"></i>Có khách
                        <span class="ms-1 opacity-75">(${cntOccup})</span>
                    </button>
                    <button class="room-status-pill pill-maint" data-status="MAINTENANCE" onclick="setRoomStatus('MAINTENANCE', this)">
                        <i class="fa-solid fa-screwdriver-wrench me-1" style="font-size:.65rem;"></i>Bảo trì
                        <span class="ms-1 opacity-75">(${cntMaint})</span>
                    </button>
                    <button class="room-status-pill pill-dirty" data-status="DIRTY" onclick="setRoomStatus('DIRTY', this)">
                        <i class="fa-solid fa-broom me-1" style="font-size:.65rem;"></i>Cần dọn
                        <span class="ms-1 opacity-75">(${cntDirty})</span>
                    </button>
                    <small id="roomResultCount" class="text-muted ms-auto" style="font-size:.75rem;">
                        <span id="roomVisibleCount">${fn:length(rooms)}</span> / ${fn:length(rooms)} phòng
                    </small>
                </div>
            </c:if>

            <!-- ── Room Type Cards ── -->
            <c:choose>
                <c:when test="${empty roomTypes}">
                    <div class="owner-card">
                        <div class="rooms-empty">
                            <i class="fa-solid fa-layer-group"></i>
                            <p class="fw-semibold mb-1">Chưa có loại phòng nào</p>
                            <p class="mb-3" style="font-size:.85rem;">Tạo loại phòng đầu tiên để bắt đầu thêm phòng vật lý.</p>
                            <button class="btn btn-primary-custom btn-sm px-4"
                                    onclick="openModal('addRoomTypeModal')">
                                <i class="fa-solid fa-plus me-1"></i>Thêm Loại phòng
                            </button>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="rt" items="${roomTypes}" varStatus="rtSt">
                        <div class="rt-card" id="rtCard${rt.roomTypeId}" data-rt-id="${rt.roomTypeId}" data-rt-name="${rt.name}">

                            <!-- ── Room type header ── -->
                            <div class="rt-card__header ${rtSt.first ? 'is-open' : ''}"
                                 id="rtHdr${rt.roomTypeId}"
                                 onclick="toggleRoomType(${rt.roomTypeId})">

                                <!-- Left: icon + info -->
                                <div class="d-flex align-items-center gap-3 min-w-0 flex-1">
                                    <div style="width:42px;height:42px;border-radius:11px;background:rgba(99,102,241,.1);display:flex;align-items:center;justify-content:center;color:#6366f1;font-size:1rem;flex-shrink:0;">
                                        <i class="fa-solid fa-bed"></i>
                                    </div>
                                    <div class="min-w-0">
                                        <div class="fw-bold" style="font-size:.95rem;">${rt.name}</div>
                                        <div class="text-muted d-flex flex-wrap gap-2" style="font-size:.75rem;">
                                            <span><i class="fa-solid fa-tag me-1" style="color:#6366f1;font-size:.65rem;"></i>
                                                <fmt:formatNumber value="${rt.basePrice}" type="number" groupingUsed="true"/>₫/đêm
                                            </span>
                                            <span><i class="fa-solid fa-user me-1" style="color:#6366f1;font-size:.65rem;"></i>${rt.maxOccupancy} người</span>
                                            <span><i class="fa-solid fa-moon me-1" style="color:#6366f1;font-size:.65rem;"></i>${rt.bedCount} giường</span>
                                            <c:if test="${rt.roomSizeSqm != null && rt.roomSizeSqm > 0}">
                                                <span><i class="fa-solid fa-vector-square me-1" style="color:#6366f1;font-size:.65rem;"></i>${rt.roomSizeSqm}m²</span>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>

                                <!-- Right: room count badge + actions + chevron -->
                                <div class="d-flex align-items-center gap-2 flex-shrink-0">
                                    <span class="badge px-2 py-1"
                                          style="background:rgba(99,102,241,.12);color:#6366f1;border:1px solid rgba(99,102,241,.25);font-size:.73rem;">
                                        <i class="fa-solid fa-door-open me-1" style="font-size:.6rem;"></i>${rt.roomCount} phòng
                                    </span>

                                    <!-- Edit room type -->
                                    <button class="btn btn-sm btn-outline-secondary rounded-3 px-2 py-1"
                                            style="font-size:.75rem;"
                                            title="Sửa loại phòng"
                                            onclick="event.stopPropagation();openEditRoomType(${rt.roomTypeId},'${rt.name.replace("'","\\'")}',${rt.basePrice},${rt.maxOccupancy},${rt.bedCount},'${rt.description != null ? rt.description.replace("'","\\'") : ""}',${rt.roomSizeSqm != null ? rt.roomSizeSqm : 0})">
                                        <i class="fa-solid fa-pen me-1"></i>Sửa
                                    </button>

                                    <!-- Delete room type -->
                                    <button class="btn btn-sm btn-outline-danger rounded-3 px-2 py-1"
                                            style="font-size:.75rem;"
                                            title="Xóa loại phòng"
                                            onclick="event.stopPropagation();openDeleteRtModal(${rt.roomTypeId},'${rt.name.replace("'","\\'")}')">
                                        <i class="fa-solid fa-trash-can"></i>
                                    </button>

                                    <i class="fa-solid fa-chevron-down rt-card__chevron"></i>
                                </div>
                            </div>

                            <!-- ── Room type body: physical rooms ── -->
                            <div class="rt-card__body ${rtSt.first ? 'show' : ''}" id="rtBody${rt.roomTypeId}">

                                <!-- Physical rooms grid -->
                                <div class="d-flex flex-wrap gap-3 mb-2 rooms-grid"
                                     id="rtRooms${rt.roomTypeId}">
                                    <c:set var="hasRooms" value="false"/>
                                    <c:forEach var="room" items="${rooms}">
                                        <c:if test="${room.roomTypeId == rt.roomTypeId}">
                                            <c:set var="hasRooms" value="true"/>

                                            <%-- Status config --%>
                                            <c:choose>
                                                <c:when test="${room.status == 'AVAILABLE'}">
                                                    <c:set var="rsCss"   value="rs-available"/>
                                                    <c:set var="rsIcon"  value="fa-circle-check"/>
                                                    <c:set var="rsLabel" value="Trống"/>
                                                    <c:set var="rsEditable" value="true"/>
                                                </c:when>
                                                <c:when test="${room.status == 'OCCUPIED'}">
                                                    <c:set var="rsCss"   value="rs-occupied"/>
                                                    <c:set var="rsIcon"  value="fa-user-check"/>
                                                    <c:set var="rsLabel" value="Có khách"/>
                                                    <c:set var="rsEditable" value="false"/>
                                                </c:when>
                                                <c:when test="${room.status == 'MAINTENANCE'}">
                                                    <c:set var="rsCss"   value="rs-maintenance"/>
                                                    <c:set var="rsIcon"  value="fa-screwdriver-wrench"/>
                                                    <c:set var="rsLabel" value="Bảo trì"/>
                                                    <c:set var="rsEditable" value="true"/>
                                                </c:when>
                                                <c:when test="${room.status == 'DIRTY'}">
                                                    <c:set var="rsCss"   value="rs-dirty"/>
                                                    <c:set var="rsIcon"  value="fa-broom"/>
                                                    <c:set var="rsLabel" value="Cần dọn"/>
                                                    <c:set var="rsEditable" value="true"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:set var="rsCss"   value="rs-available"/>
                                                    <c:set var="rsIcon"  value="fa-circle-question"/>
                                                    <c:set var="rsLabel" value="${room.status}"/>
                                                    <c:set var="rsEditable" value="true"/>
                                                </c:otherwise>
                                            </c:choose>

                                            <div class="room-chip ${rsCss}"
                                                 data-room-id="${room.roomId}"
                                                 data-room-number="${room.roomNumber}"
                                                 data-room-status="${room.status}"
                                                 data-room-rtid="${room.roomTypeId}">

                                                <!-- Chip header: room number + delete/lock -->
                                                <div class="room-chip__header">
                                                    <span>
                                                        <i class="fa-solid fa-door-open me-1" style="opacity:.8;font-size:.65rem;"></i>
                                                        ${room.roomNumber}
                                                    </span>
                                                    <c:choose>
                                                        <c:when test="${rsEditable == 'true'}">
                                                            <button class="room-chip__del"
                                                                    title="Xóa phòng ${room.roomNumber}"
                                                                    onclick="event.stopPropagation();openDeleteRoomModal('${room.roomId}','${room.roomNumber}','${homestay.homestayId}')">
                                                                <i class="fa-solid fa-xmark"></i>
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span title="Đang có khách — không thể xóa" style="color:rgba(255,255,255,.55);font-size:.65rem;">
                                                                <i class="fa-solid fa-lock"></i>
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <!-- Chip body: status + dropdown -->
                                                <div class="room-chip__body">
                                                    <div class="room-chip__badge">
                                                        <i class="fa-solid ${rsIcon}" style="font-size:.65rem;"></i>
                                                        ${rsLabel}
                                                    </div>
                                                    <c:if test="${rsEditable == 'true'}">
                                                        <form method="post"
                                                              action="${pageContext.request.contextPath}/owner/rooms"
                                                              style="flex:1;min-width:0;"
                                                              onclick="event.stopPropagation()">
                                                            <input type="hidden" name="action"     value="updateRoomStatus">
                                                            <input type="hidden" name="homestayId" value="${homestay.homestayId}">
                                                            <input type="hidden" name="roomId"     value="${room.roomId}">
                                                            <select name="roomStatus"
                                                                    class="room-status-select"
                                                                    onchange="event.stopPropagation();this.closest('form').submit()">
                                                                <option value="AVAILABLE"   ${room.status == 'AVAILABLE'   ? 'selected' : ''}>✅ Trống</option>
                                                                <option value="MAINTENANCE" ${room.status == 'MAINTENANCE' ? 'selected' : ''}>🔧 Bảo trì</option>
                                                                <option value="DIRTY"       ${room.status == 'DIRTY'       ? 'selected' : ''}>🧹 Cần dọn</option>
                                                            </select>
                                                        </form>
                                                    </c:if>
                                                    <c:if test="${rsEditable != 'true'}">
                                                        <span style="font-size:.62rem;color:#64748b;font-style:italic;">Tự động</span>
                                                    </c:if>
                                                </div>
                                            </div>

                                        </c:if>
                                    </c:forEach>
                                </div>

                                <!-- Pagination bar for this room type -->
                                <div class="rt-pager" id="rtPager${rt.roomTypeId}" data-rt-id="${rt.roomTypeId}"></div>

                                <!-- Empty state for this room type -->
                                <c:if test="${!hasRooms}">
                                    <div class="rooms-empty py-3">
                                        <i class="fa-solid fa-door-open" style="font-size:1.5rem;"></i>
                                        <p class="mb-0" style="font-size:.83rem;">Chưa có phòng vật lý nào cho loại phòng này.</p>
                                    </div>
                                </c:if>

                                <!-- Add room inline form -->
                                <form method="post"
                                      action="${pageContext.request.contextPath}/owner/rooms"
                                      class="add-room-form">
                                    <input type="hidden" name="action"     value="addRoom">
                                    <input type="hidden" name="homestayId" value="${homestay.homestayId}">
                                    <input type="hidden" name="roomTypeId" value="${rt.roomTypeId}">
                                    <div>
                                        <label class="form-label mb-1 fw-semibold" style="font-size:.78rem;">
                                            <i class="fa-solid fa-plus-circle me-1 text-primary" style="font-size:.75rem;"></i>
                                            Thêm phòng vật lý
                                        </label>
                                        <input type="text" name="roomNumber"
                                               class="form-control form-control-sm"
                                               placeholder="VD: 101, A-01, VILLA-1"
                                               style="width:180px;"
                                               maxlength="50" required
                                               oninput="this.value=this.value.toUpperCase()">
                                    </div>
                                    <button type="submit"
                                            class="btn btn-sm btn-primary-custom rounded-3">
                                        <i class="fa-solid fa-plus me-1"></i>Thêm phòng
                                    </button>
                                </form>

                            </div><%-- /.rt-card__body --%>
                        </div><%-- /.rt-card --%>
                    </c:forEach>
                </c:otherwise>
            </c:choose>

            <!-- No room filter results -->
            <div id="roomsNoResults" class="owner-card mt-2" style="display:none;">
                <div class="rooms-empty py-3">
                    <i class="fa-solid fa-filter-circle-xmark" style="font-size:1.8rem;"></i>
                    <p class="fw-semibold mb-1">Không tìm thấy phòng nào</p>
                    <button class="btn btn-sm btn-outline-secondary" onclick="resetRoomFilters()">
                        <i class="fa-solid fa-rotate-left me-1"></i>Xóa bộ lọc
                    </button>
                </div>
            </div>

        </div><%-- /.owner-content --%>
    </div>
</div>

<!-- ══════════════════════════════════════════════════════════════
     MODALS
═══════════════════════════════════════════════════════════════ -->

<!-- ── Add Room Type Modal ── -->
<div class="owner-modal-overlay" id="addRoomTypeModal"
     onclick="if(event.target===this)closeModal('addRoomTypeModal')">
    <div class="owner-modal-box">
        <div class="d-flex align-items-center justify-content-between mb-4">
            <div>
                <h5 class="fw-bold mb-0"><i class="fa-solid fa-plus text-primary me-2"></i>Thêm Loại phòng mới</h5>
                <small class="text-muted">Loại phòng là khuôn mẫu; phòng vật lý là từng phòng cụ thể.</small>
            </div>
            <button type="button" class="btn-close" onclick="closeModal('addRoomTypeModal')"></button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/owner/rooms">
            <input type="hidden" name="action"     value="addRoomType">
            <input type="hidden" name="homestayId" value="${homestay.homestayId}">

            <div class="mb-3">
                <label class="form-label fw-semibold" style="font-size:.83rem;">
                    Tên loại phòng <span class="text-danger">*</span>
                </label>
                <input type="text" name="rtName" class="form-control"
                       placeholder="VD: Phòng Standard, Suite Gia Đình, Bungalow..." required maxlength="100">
            </div>
            <div class="mb-3">
                <label class="form-label fw-semibold" style="font-size:.83rem;">Mô tả ngắn</label>
                <textarea name="rtDescription" class="form-control" rows="2"
                          placeholder="Tiện nghi nổi bật, view, thiết kế..."></textarea>
            </div>
            <div class="row g-3 mb-3">
                <div class="col-6">
                    <label class="form-label fw-semibold" style="font-size:.83rem;">
                        Giá cơ bản / đêm (₫) <span class="text-danger">*</span>
                    </label>
                    <input type="number" name="rtBasePrice" class="form-control"
                           min="0" step="50000" placeholder="800000" required>
                </div>
                <div class="col-6">
                    <label class="form-label fw-semibold" style="font-size:.83rem;">Diện tích (m²)</label>
                    <input type="number" name="rtRoomSize" class="form-control"
                           min="0" step="0.5" placeholder="28">
                </div>
            </div>
            <div class="row g-3 mb-4">
                <div class="col-6">
                    <label class="form-label fw-semibold" style="font-size:.83rem;">Sức chứa tối đa</label>
                    <select name="rtMaxOccupancy" class="form-select">
                        <option value="1">1 người</option>
                        <option value="2" selected>2 người</option>
                        <option value="3">3 người</option>
                        <option value="4">4 người</option>
                        <option value="6">6 người</option>
                        <option value="8">8 người</option>
                        <option value="10">10 người</option>
                    </select>
                </div>
                <div class="col-6">
                    <label class="form-label fw-semibold" style="font-size:.83rem;">Số giường</label>
                    <select name="rtBedCount" class="form-select">
                        <option value="1" selected>1 giường</option>
                        <option value="2">2 giường</option>
                        <option value="3">3 giường</option>
                        <option value="4">4 giường</option>
                    </select>
                </div>
            </div>
            <div class="d-flex gap-2">
                <button type="submit" class="btn btn-primary-custom flex-fill">
                    <i class="fa-solid fa-check me-1"></i>Tạo loại phòng
                </button>
                <button type="button" class="btn btn-outline-secondary"
                        onclick="closeModal('addRoomTypeModal')">Hủy</button>
            </div>
        </form>
    </div>
</div>

<!-- ── Edit Room Type Modal ── -->
<div class="owner-modal-overlay" id="editRoomTypeModal"
     onclick="if(event.target===this)closeModal('editRoomTypeModal')">
    <div class="owner-modal-box">
        <div class="d-flex align-items-center justify-content-between mb-4">
            <h5 class="fw-bold mb-0"><i class="fa-solid fa-pen text-primary me-2"></i>Sửa Loại phòng</h5>
            <button type="button" class="btn-close" onclick="closeModal('editRoomTypeModal')"></button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/owner/rooms" id="editRtForm">
            <input type="hidden" name="action"     value="editRoomType">
            <input type="hidden" name="homestayId" value="${homestay.homestayId}">
            <input type="hidden" name="roomTypeId" id="editRtId">

            <div class="mb-3">
                <label class="form-label fw-semibold" style="font-size:.83rem;">
                    Tên loại phòng <span class="text-danger">*</span>
                </label>
                <input type="text" name="rtName" id="editRtName" class="form-control" required maxlength="100">
            </div>
            <div class="mb-3">
                <label class="form-label fw-semibold" style="font-size:.83rem;">Mô tả ngắn</label>
                <textarea name="rtDescription" id="editRtDesc" class="form-control" rows="2"></textarea>
            </div>
            <div class="row g-3 mb-3">
                <div class="col-6">
                    <label class="form-label fw-semibold" style="font-size:.83rem;">
                        Giá cơ bản / đêm (₫) <span class="text-danger">*</span>
                    </label>
                    <input type="number" name="rtBasePrice" id="editRtPrice"
                           class="form-control" min="0" step="50000" required>
                </div>
                <div class="col-6">
                    <label class="form-label fw-semibold" style="font-size:.83rem;">Diện tích (m²)</label>
                    <input type="number" name="rtRoomSize" id="editRtSize"
                           class="form-control" min="0" step="0.5">
                </div>
            </div>
            <div class="row g-3 mb-4">
                <div class="col-6">
                    <label class="form-label fw-semibold" style="font-size:.83rem;">Sức chứa tối đa</label>
                    <input type="number" name="rtMaxOccupancy" id="editRtOcc"
                           class="form-control" min="1" max="20">
                </div>
                <div class="col-6">
                    <label class="form-label fw-semibold" style="font-size:.83rem;">Số giường</label>
                    <input type="number" name="rtBedCount" id="editRtBeds"
                           class="form-control" min="1" max="10">
                </div>
            </div>
            <div class="d-flex gap-2">
                <button type="submit" class="btn btn-primary-custom flex-fill">
                    <i class="fa-solid fa-floppy-disk me-1"></i>Lưu thay đổi
                </button>
                <button type="button" class="btn btn-outline-secondary"
                        onclick="closeModal('editRoomTypeModal')">Hủy</button>
            </div>
        </form>
    </div>
</div>

<!-- ── Delete Room Type Confirm Modal ── -->
<div class="owner-modal-overlay" id="deleteRtModal"
     onclick="if(event.target===this)closeModal('deleteRtModal')">
    <div class="owner-modal-box owner-modal-box--sm">
        <div class="text-center mb-3">
            <div style="width:54px;height:54px;border-radius:50%;background:#fef2f2;display:flex;align-items:center;justify-content:center;margin:0 auto .75rem;font-size:1.4rem;color:#ef4444;">
                <i class="fa-solid fa-layer-group"></i>
            </div>
            <h5 class="fw-bold mb-1">Xóa loại phòng?</h5>
            <p class="text-muted mb-0" style="font-size:.85rem;">
                <strong id="deleteRtName" class="text-dark"></strong>
            </p>
        </div>
        <div class="alert alert-warning py-2 px-3 rounded-3 mb-3" style="font-size:.81rem;">
            <i class="fa-solid fa-triangle-exclamation me-1"></i>
            Tất cả phòng vật lý thuộc loại phòng này cũng sẽ bị xóa. Không thể xóa nếu có đặt phòng đang hoạt động.
        </div>
        <form method="post" action="${pageContext.request.contextPath}/owner/rooms" id="deleteRtForm">
            <input type="hidden" name="action"     value="deleteRoomType">
            <input type="hidden" name="homestayId" value="${homestay.homestayId}">
            <input type="hidden" name="roomTypeId" id="deleteRtId">
            <div class="d-flex gap-2">
                <button type="submit" class="btn btn-danger flex-fill">
                    <i class="fa-solid fa-trash-can me-1"></i>Xóa loại phòng
                </button>
                <button type="button" class="btn btn-outline-secondary flex-fill"
                        onclick="closeModal('deleteRtModal')">Hủy</button>
            </div>
        </form>
    </div>
</div>

<!-- ── Delete Room Confirm Modal ── -->
<div class="owner-modal-overlay" id="deleteRoomModal"
     onclick="if(event.target===this)closeModal('deleteRoomModal')">
    <div class="owner-modal-box owner-modal-box--sm">
        <div class="text-center mb-3">
            <div style="width:54px;height:54px;border-radius:50%;background:#fef2f2;display:flex;align-items:center;justify-content:center;margin:0 auto .75rem;font-size:1.4rem;color:#ef4444;">
                <i class="fa-solid fa-door-open"></i>
            </div>
            <h5 class="fw-bold mb-1">Xóa phòng vật lý?</h5>
            <p class="text-muted mb-0" style="font-size:.85rem;">
                Phòng: <strong id="deleteRoomNumber" class="text-dark"></strong>
            </p>
        </div>
        <div class="alert alert-danger py-2 px-3 rounded-3 mb-3" style="font-size:.81rem;">
            <i class="fa-solid fa-triangle-exclamation me-1"></i>
            Thao tác này không thể hoàn tác.
        </div>
        <form method="post" action="${pageContext.request.contextPath}/owner/rooms" id="deleteRoomForm">
            <input type="hidden" name="action"     value="deleteRoom">
            <input type="hidden" name="homestayId" id="deleteRoomHomestayId">
            <input type="hidden" name="roomId"     id="deleteRoomId">
            <div class="d-flex gap-2">
                <button type="submit" class="btn btn-danger flex-fill">
                    <i class="fa-solid fa-xmark me-1"></i>Xóa phòng
                </button>
                <button type="button" class="btn btn-outline-secondary flex-fill"
                        onclick="closeModal('deleteRoomModal')">Hủy</button>
            </div>
        </form>
    </div>
</div>

<!-- ══════════════════════════════════════════════════════════════
     SCRIPTS
═══════════════════════════════════════════════════════════════ -->
<script>
// ── Accordion ─────────────────────────────────────────────────────────────────
function toggleRoomType(rtId) {
    var body   = document.getElementById('rtBody' + rtId);
    var header = document.getElementById('rtHdr'  + rtId);
    var open   = body.classList.toggle('show');
    header.classList.toggle('is-open', open);
}

// ── Modal helpers ─────────────────────────────────────────────────────────────
function openModal(id) {
    document.getElementById(id).classList.add('show');
}
function closeModal(id) {
    document.getElementById(id).classList.remove('show');
}
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        ['addRoomTypeModal','editRoomTypeModal','deleteRtModal','deleteRoomModal'].forEach(closeModal);
    }
});

// ── Edit room type ─────────────────────────────────────────────────────────────
function openEditRoomType(id, name, price, occ, beds, desc, size) {
    document.getElementById('editRtId').value    = id;
    document.getElementById('editRtName').value  = name;
    document.getElementById('editRtPrice').value = price;
    document.getElementById('editRtOcc').value   = occ;
    document.getElementById('editRtBeds').value  = beds;
    document.getElementById('editRtDesc').value  = desc;
    document.getElementById('editRtSize').value  = size > 0 ? size : '';
    openModal('editRoomTypeModal');
}

// ── Delete room type modal ─────────────────────────────────────────────────────
function openDeleteRtModal(rtId, rtName) {
    document.getElementById('deleteRtId').value   = rtId;
    document.getElementById('deleteRtName').textContent = rtName;
    openModal('deleteRtModal');
}

// ── Delete room modal ─────────────────────────────────────────────────────────
function openDeleteRoomModal(roomId, roomNumber, homestayId) {
    document.getElementById('deleteRoomId').value        = roomId;
    document.getElementById('deleteRoomNumber').textContent = roomNumber;
    document.getElementById('deleteRoomHomestayId').value= homestayId;
    openModal('deleteRoomModal');
}

// ═══════════════════════════════════════════════════════════════════════════════
// ROOM FILTER / SEARCH
// ═══════════════════════════════════════════════════════════════════════════════
var _roomStatus = 'all';

// ── Pagination ──────────────────────────────────────────────────────────────
var RT_PAGE_SIZE = 8;
var _rtPage = {};   // keyed by roomTypeId -> current page (1-based)

// Build page-number sequence with sliding window around current page
// e.g. total=10, current=5  → [1, '…', 4, 5, 6, '…', 10]
function buildRtPageNumbers(total, current) {
    var pages = [];
    if (total <= 7) {
        for (var i = 1; i <= total; i++) pages.push(i);
        return pages;
    }
    var winStart = Math.max(2, current - 1);
    var winEnd   = Math.min(total - 1, current + 1);
    pages.push(1);
    if (winStart > 2) pages.push('…');
    for (var p = winStart; p <= winEnd; p++) pages.push(p);
    if (winEnd < total - 1) pages.push('…');
    pages.push(total);
    return pages;
}

// Render pagination + apply per-page visibility for every room type.
function renderRtPages() {
    document.querySelectorAll('.rt-pager').forEach(function(pager) {
        var rtId = pager.dataset.rtId;
        var grid = document.getElementById('rtRooms' + rtId);
        if (!grid) { pager.innerHTML = ''; return; }

        // Chips that currently pass the active filters (or all chips if no filtering yet)
        var chips = Array.prototype.filter.call(grid.querySelectorAll('.room-chip'), function(chip) {
            return chip.dataset.filterMatch !== '0';
        });

        var totalPages = Math.max(1, Math.ceil(chips.length / RT_PAGE_SIZE));
        var current = _rtPage[rtId] || 1;
        if (current > totalPages) current = totalPages;
        if (current < 1) current = 1;
        _rtPage[rtId] = current;

        // Show only the current page's slice; hide everything else
        var start = (current - 1) * RT_PAGE_SIZE;
        var end   = start + RT_PAGE_SIZE;
        chips.forEach(function(chip, idx) {
            chip.style.display = (idx >= start && idx < end) ? '' : 'none';
        });

        // Build the pager controls (hidden entirely when a single page)
        pager.innerHTML = '';
        if (totalPages <= 1) return;

        pager.appendChild(makeRtArrow(rtId, current - 1, current <= 1, '\u2039'));
        buildRtPageNumbers(totalPages, current).forEach(function(p) {
            if (p === '…') {
                var span = document.createElement('span');
                span.className = 'rt-pg-btn rt-pg-ellipsis';
                span.textContent = '…';
                pager.appendChild(span);
            } else {
                var btn = document.createElement('button');
                btn.type = 'button';
                btn.className = 'rt-pg-btn' + (p === current ? ' active' : '');
                btn.textContent = p;
                if (p !== current) {
                    btn.addEventListener('click', function() { goRtPage(rtId, p); });
                }
                pager.appendChild(btn);
            }
        });
        pager.appendChild(makeRtArrow(rtId, current + 1, current >= totalPages, '\u203A'));
    });
}

function makeRtArrow(rtId, targetPage, disabled, label) {
    var btn = document.createElement('button');
    btn.type = 'button';
    btn.className = 'rt-pg-btn';
    btn.textContent = label;
    btn.disabled = disabled;
    if (!disabled) {
        btn.addEventListener('click', function() { goRtPage(rtId, targetPage); });
    }
    return btn;
}

function goRtPage(rtId, page) {
    _rtPage[rtId] = page;
    renderRtPages();
}

function setRoomStatus(status, btn) {
    document.querySelectorAll('.room-status-pill').forEach(function(p) { p.classList.remove('active'); });
    btn.classList.add('active');
    _roomStatus = status;
    applyRoomFilters();
}

function applyRoomFilters() {
    var keyword    = (document.getElementById('roomSearch')    ? document.getElementById('roomSearch').value.toLowerCase().trim() : '');
    var rtFilterEl = document.getElementById('roomTypeFilter');
    var rtFilter   = rtFilterEl ? rtFilterEl.value : '';

    var allChips   = document.querySelectorAll('.room-chip');
    var visible    = 0;
    var rtCardsVisible = {};

    allChips.forEach(function(chip) {
        var roomNum = (chip.dataset.roomNumber || '').toLowerCase();
        var rtId    = chip.dataset.roomRtid || chip.dataset.roomrtid || '';
        var status  = chip.dataset.roomStatus || '';

        // Find rt name for search
        var rtCard  = chip.closest('.rt-card');
        var rtName  = rtCard ? (rtCard.dataset.rtName || '').toLowerCase() : '';

        var matchKw     = !keyword || roomNum.includes(keyword) || rtName.includes(keyword);
        var matchRt     = !rtFilter || rtId === rtFilter;
        var matchStatus = _roomStatus === 'all' || status === _roomStatus;

        var show = matchKw && matchRt && matchStatus;
        // Record filter-match; actual display is decided by pagination (renderRtPages)
        chip.dataset.filterMatch = show ? '1' : '0';
        if (show) {
            visible++;
            if (rtCard) rtCardsVisible[rtCard.dataset.rtId] = true;
        }
    });

    // Reset every room type to page 1 whenever filters change
    document.querySelectorAll('.rt-pager').forEach(function(pager) {
        _rtPage[pager.dataset.rtId] = 1;
    });
    // Apply pagination on top of the filter matches
    renderRtPages();

    // Show/hide entire rt-card sections if filter is active
    var isFiltering = keyword || rtFilter || _roomStatus !== 'all';
    document.querySelectorAll('.rt-card').forEach(function(card) {
        var rtId = card.dataset.rtId;
        if (isFiltering) {
            var hasVisible = rtCardsVisible[rtId];
            card.style.display = hasVisible ? '' : 'none';
            // Auto-open if filtering
            if (hasVisible) {
                var body   = document.getElementById('rtBody'  + rtId);
                var header = document.getElementById('rtHdr'   + rtId);
                if (body && !body.classList.contains('show')) {
                    body.classList.add('show');
                    if (header) header.classList.add('is-open');
                }
            }
        } else {
            card.style.display = '';
        }
    });

    // Update count
    var countEl = document.getElementById('roomVisibleCount');
    if (countEl) countEl.textContent = visible;

    // No results notice
    var noRes = document.getElementById('roomsNoResults');
    if (noRes) noRes.style.display = (isFiltering && visible === 0) ? '' : 'none';
}

function resetRoomFilters() {
    var s = document.getElementById('roomSearch');
    var r = document.getElementById('roomTypeFilter');
    if (s) s.value = '';
    if (r) r.value = '';
    document.querySelectorAll('.room-status-pill').forEach(function(p) { p.classList.remove('active'); });
    var allPill = document.querySelector('.room-status-pill[data-status="all"]');
    if (allPill) allPill.classList.add('active');
    _roomStatus = 'all';
    applyRoomFilters();
}

// ── Initial pagination render on page load ─────────────────────────────────────
document.addEventListener('DOMContentLoaded', function() {
    // No filters active yet: mark all chips as matching, then paginate each room type.
    document.querySelectorAll('.room-chip').forEach(function(chip) {
        if (chip.dataset.filterMatch === undefined) chip.dataset.filterMatch = '1';
    });
    document.querySelectorAll('.rt-pager').forEach(function(pager) {
        if (!_rtPage[pager.dataset.rtId]) _rtPage[pager.dataset.rtId] = 1;
    });
    renderRtPages();
});
</script>

<jsp:include page="../common/footer.jsp"/>
