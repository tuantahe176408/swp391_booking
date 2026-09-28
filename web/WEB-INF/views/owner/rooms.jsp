<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:include page="../common/header.jsp"/>

<style>
.room-badge {
    display: inline-flex; align-items: center; gap: .3rem;
    font-size: .72rem; font-weight: 600; border-radius: 6px;
    padding: 2px 7px; border: 1px solid;
}
.room-badge-available  { background:#f0fdf4; color:#16a34a; border-color:#86efac; }
.room-badge-occupied   { background:#eff6ff; color:#2563eb; border-color:#93c5fd; }
.room-badge-maintenance{ background:#fef9c3; color:#b45309; border-color:#fde68a; }
.room-badge-dirty      { background:#fdf4ff; color:#9333ea; border-color:#e9d5ff; }

.rt-card { border:1px solid #e2e8f0; border-radius:12px; overflow:hidden; margin-bottom:1rem; }
.rt-card-header {
    display:flex; align-items:center; justify-content:space-between;
    padding:.9rem 1.25rem; background:#f8fafc; cursor:pointer;
    transition:background .15s ease; gap:.75rem;
    user-select: none;
}
.rt-card-header:hover { background:#eef2ff; }
.rt-card-header.is-open { background:#eef2ff; border-bottom:1px solid #e2e8f0; }
.rt-card-body { padding:1.25rem; background:#fff; display:none; }
.rt-card-body.show { display:block; }

/* Modal overlay */
.owner-modal-overlay {
    display: none;
    position: fixed; inset: 0;
    background: rgba(15,23,42,.5);
    z-index: 900;
    align-items: center;
    justify-content: center;
    padding: 1rem;
}
.owner-modal-overlay.show { display: flex; }
.owner-modal-box {
    background: #fff;
    border-radius: 16px;
    padding: 1.75rem;
    width: 100%;
    max-width: 520px;
    max-height: 90vh;
    overflow-y: auto;
    box-shadow: 0 20px 60px rgba(15,23,42,.2);
}
</style>

<div class="owner-shell">
    <jsp:include page="../common/sidebar-owner.jsp"/>
    <div class="owner-main">
        <jsp:include page="../common/owner-topbar.jsp"/>
        <div class="owner-content">

            <!-- Flash -->
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
                        <a href="${pageContext.request.contextPath}/owner/homestays" class="text-muted text-decoration-none">
                            <i class="fa-solid fa-building-user me-1"></i>${homestay.name}
                        </a>
                        <span class="text-muted"> · ${homestay.city}</span>
                    </p>
                </div>
                <button class="btn btn-primary-custom btn-sm px-4"
                        onclick="openAddRoomTypeModal()">
                    <i class="fa-solid fa-plus me-1"></i>Thêm Loại phòng
                </button>
            </div>

            <!-- Stats -->
            <div class="row g-3 mb-4">
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
                            <div class="fw-bold fs-5 lh-1">
                                <c:set var="cntAvail" value="0"/>
                                <c:forEach var="r" items="${rooms}"><c:if test="${r.status == 'AVAILABLE'}"><c:set var="cntAvail" value="${cntAvail + 1}"/></c:if></c:forEach>
                                ${cntAvail}
                            </div>
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
                            <div class="fw-bold fs-5 lh-1">
                                <c:set var="cntOccup" value="0"/>
                                <c:forEach var="r" items="${rooms}"><c:if test="${r.status == 'OCCUPIED'}"><c:set var="cntOccup" value="${cntOccup + 1}"/></c:if></c:forEach>
                                ${cntOccup}
                            </div>
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

            <!-- Room Types Accordion -->
            <c:choose>
                <c:when test="${empty roomTypes}">
                    <div class="owner-card text-center py-5 text-muted">
                        <i class="fa-solid fa-layer-group fa-2x mb-3 d-block opacity-25"></i>
                        Chưa có loại phòng nào.
                        <button class="btn btn-sm btn-primary-custom ms-2" onclick="openAddRoomTypeModal()">Thêm ngay</button>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="rt" items="${roomTypes}" varStatus="rtSt">
                        <div class="rt-card">
                            <!-- Room type header (clickable) -->
                            <div class="rt-card-header ${rtSt.first ? 'is-open' : ''}"
                                 id="rtHeader${rt.roomTypeId}"
                                 onclick="toggleRoomType(${rt.roomTypeId})">
                                <div class="d-flex align-items-center gap-3 min-width-0">
                                    <div style="width:36px;height:36px;border-radius:9px;background:rgba(99,102,241,.1);display:flex;align-items:center;justify-content:center;color:#6366f1;font-size:.9rem;flex-shrink:0;">
                                        <i class="fa-solid fa-bed"></i>
                                    </div>
                                    <div class="min-width-0">
                                        <div class="fw-bold" style="font-size:.95rem;">${rt.name}</div>
                                        <div class="text-muted" style="font-size:.78rem;">
                                            <fmt:formatNumber value="${rt.basePrice}" type="number" groupingUsed="true"/>₫/đêm
                                            · <i class="fa-solid fa-user me-1"></i>${rt.maxOccupancy} người
                                            · <i class="fa-solid fa-moon me-1"></i>${rt.bedCount} giường
                                            <c:if test="${rt.roomSizeSqm != null && rt.roomSizeSqm > 0}">
                                                · ${rt.roomSizeSqm}m²
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                                <div class="d-flex align-items-center gap-2 flex-shrink-0">
                                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-2">
                                        ${rt.roomCount} phòng
                                    </span>
                                    <button class="btn btn-xs btn-outline-secondary rounded-2 py-1 px-2"
                                            style="font-size:.75rem;"
                                            onclick="event.stopPropagation();openEditRoomTypeModal(${rt.roomTypeId},'${rt.name}',${rt.basePrice},${rt.maxOccupancy},${rt.bedCount},'${rt.description}',${rt.roomSizeSqm != null ? rt.roomSizeSqm : 0})"
                                            title="Sửa loại phòng">
                                        <i class="fa-solid fa-pen"></i>
                                    </button>
                                    <form method="post"
                                          action="${pageContext.request.contextPath}/owner/rooms"
                                          style="display:none;"
                                          id="delRtForm${rt.roomTypeId}">
                                        <input type="hidden" name="action"      value="deleteRoomType">
                                        <input type="hidden" name="homestayId"  value="${homestay.homestayId}">
                                        <input type="hidden" name="roomTypeId"  value="${rt.roomTypeId}">
                                    </form>
                                    <button type="button"
                                            class="btn btn-xs btn-outline-danger rounded-2 py-1 px-2"
                                            style="font-size:.75rem;"
                                            data-rt-id="${rt.roomTypeId}"
                                            data-rt-name="${rt.name}"
                                            onclick="event.stopPropagation();deleteRoomType(this)"
                                            title="Xóa loại phòng">
                                        <i class="fa-solid fa-trash"></i>
                                    </button>
                                    <i class="fa-solid fa-chevron-down text-muted" id="rtChevron${rt.roomTypeId}"
                                       style="font-size:.75rem;transition:transform .2s ease;${rtSt.first ? 'transform:rotate(180deg)' : ''}"></i>
                                </div>
                            </div>

                            <!-- Room type body: list of physical rooms -->
                            <div class="rt-card-body ${rtSt.first ? 'show' : ''}" id="rtBody${rt.roomTypeId}">

                                <!-- Physical rooms list -->
                                <div class="mb-3">
                                    <c:set var="hasRooms" value="false"/>
                                    <div class="d-flex flex-wrap gap-3 mb-3">
                                        <c:forEach var="room" items="${rooms}">
                                            <c:if test="${room.roomTypeId == rt.roomTypeId}">
                                                <c:set var="hasRooms" value="true"/>

                                                <%-- Status config --%>
                                                <c:choose>
                                                    <c:when test="${room.status == 'AVAILABLE'}">
                                                        <c:set var="sIcon"  value="fa-circle-check"/>
                                                        <c:set var="sColor" value="#16a34a"/>
                                                        <c:set var="sBg"    value="linear-gradient(135deg,#f0fdf4,#dcfce7)"/>
                                                        <c:set var="sBorder" value="#86efac"/>
                                                        <c:set var="sLabel" value="Trống"/>
                                                        <c:set var="sCanEdit" value="true"/>
                                                    </c:when>
                                                    <c:when test="${room.status == 'OCCUPIED'}">
                                                        <c:set var="sIcon"  value="fa-user-check"/>
                                                        <c:set var="sColor" value="#2563eb"/>
                                                        <c:set var="sBg"    value="linear-gradient(135deg,#eff6ff,#dbeafe)"/>
                                                        <c:set var="sBorder" value="#93c5fd"/>
                                                        <c:set var="sLabel" value="Có khách"/>
                                                        <c:set var="sCanEdit" value="false"/>
                                                    </c:when>
                                                    <c:when test="${room.status == 'MAINTENANCE'}">
                                                        <c:set var="sIcon"  value="fa-screwdriver-wrench"/>
                                                        <c:set var="sColor" value="#d97706"/>
                                                        <c:set var="sBg"    value="linear-gradient(135deg,#fffbeb,#fef3c7)"/>
                                                        <c:set var="sBorder" value="#fcd34d"/>
                                                        <c:set var="sLabel" value="Bảo trì"/>
                                                        <c:set var="sCanEdit" value="true"/>
                                                    </c:when>
                                                    <c:when test="${room.status == 'DIRTY'}">
                                                        <c:set var="sIcon"  value="fa-broom"/>
                                                        <c:set var="sColor" value="#9333ea"/>
                                                        <c:set var="sBg"    value="linear-gradient(135deg,#fdf4ff,#f3e8ff)"/>
                                                        <c:set var="sBorder" value="#d8b4fe"/>
                                                        <c:set var="sLabel" value="Cần dọn"/>
                                                        <c:set var="sCanEdit" value="true"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:set var="sIcon"  value="fa-circle-question"/>
                                                        <c:set var="sColor" value="#64748b"/>
                                                        <c:set var="sBg"    value="#f8fafc"/>
                                                        <c:set var="sBorder" value="#e2e8f0"/>
                                                        <c:set var="sLabel" value="${room.status}"/>
                                                        <c:set var="sCanEdit" value="true"/>
                                                    </c:otherwise>
                                                </c:choose>

                                                <%-- Room card --%>
                                                <div class="room-card" onclick="event.stopPropagation()"
                                                     style="background:${sBg};border:1.5px solid ${sBorder};border-radius:14px;width:160px;overflow:hidden;box-shadow:0 2px 8px rgba(0,0,0,.06);">

                                                    <%-- Card header: status color strip + room number --%>
                                                    <div style="background:${sColor};padding:.5rem .75rem;display:flex;align-items:center;justify-content:space-between;">
                                                        <span style="color:#fff;font-weight:700;font-size:.82rem;letter-spacing:.02em;">
                                                            <i class="fa-solid fa-door-open me-1" style="opacity:.8;font-size:.7rem;"></i>
                                                            ${room.roomNumber}
                                                        </span>
                                                        <%-- Delete or lock icon --%>
                                                        <c:choose>
                                                            <c:when test="${room.status != 'OCCUPIED'}">
                                                                <button type="button"
                                                                        class="room-del-btn"
                                                                        data-room-id="${room.roomId}"
                                                                        data-room-number="${room.roomNumber}"
                                                                        data-homestay-id="${homestay.homestayId}"
                                                                        onclick="event.stopPropagation();deleteRoom(this)"
                                                                        title="Xóa phòng"
                                                                        style="background:rgba(255,255,255,.25);border:none;border-radius:6px;color:#fff;width:22px;height:22px;display:flex;align-items:center;justify-content:center;cursor:pointer;font-size:.72rem;flex-shrink:0;transition:background .15s;">
                                                                    <i class="fa-solid fa-xmark"></i>
                                                                </button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span style="color:rgba(255,255,255,.6);font-size:.7rem;" title="Đang có khách">
                                                                    <i class="fa-solid fa-lock"></i>
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>

                                                    <%-- Card body: status badge + dropdown --%>
                                                    <div style="padding:.6rem .75rem;">
                                                        <div style="display:flex;align-items:center;gap:.4rem;margin-bottom:.5rem;">
                                                            <i class="fa-solid ${sIcon}" style="color:${sColor};font-size:.78rem;"></i>
                                                            <span style="font-size:.78rem;font-weight:600;color:${sColor};">${sLabel}</span>
                                                        </div>

                                                        <c:choose>
                                                            <c:when test="${sCanEdit == 'true'}">
                                                                <form method="post"
                                                                      action="${pageContext.request.contextPath}/owner/rooms"
                                                                      class="room-status-form"
                                                                      onclick="event.stopPropagation()">
                                                                    <input type="hidden" name="action"     value="updateRoomStatus">
                                                                    <input type="hidden" name="homestayId" value="${homestay.homestayId}">
                                                                    <input type="hidden" name="roomId"     value="${room.roomId}">
                                                                    <select name="roomStatus"
                                                                            class="form-select form-select-sm"
                                                                            style="font-size:.73rem;padding:.15rem .35rem;border-color:${sBorder};"
                                                                            onchange="event.stopPropagation();this.closest('form').submit()">
                                                                        <option value="AVAILABLE"   ${room.status == 'AVAILABLE'   ? 'selected' : ''}>✅ Trống</option>
                                                                        <option value="MAINTENANCE" ${room.status == 'MAINTENANCE' ? 'selected' : ''}>🔧 Bảo trì</option>
                                                                        <option value="DIRTY"       ${room.status == 'DIRTY'       ? 'selected' : ''}>🧹 Cần dọn</option>
                                                                    </select>
                                                                </form>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div style="font-size:.72rem;color:#64748b;font-style:italic;">
                                                                    Booking system quản lý
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>

                                            </c:if>
                                        </c:forEach>
                                    </div>
                                    <c:if test="${!hasRooms}">
                                        <p class="text-muted mb-3" style="font-size:.83rem;">
                                            <i class="fa-solid fa-info-circle me-1"></i>Chưa có phòng vật lý nào. Thêm phòng bên dưới.
                                        </p>
                                    </c:if>
                                </div>

                                <!-- Add room inline form -->
                                <form method="post"
                                      action="${pageContext.request.contextPath}/owner/rooms"
                                      class="d-flex gap-2 align-items-end flex-wrap">
                                    <input type="hidden" name="action"     value="addRoom">
                                    <input type="hidden" name="homestayId" value="${homestay.homestayId}">
                                    <input type="hidden" name="roomTypeId" value="${rt.roomTypeId}">
                                    <div>
                                        <label class="form-label mb-1 fw-semibold" style="font-size:.78rem;">Số phòng mới</label>
                                        <input type="text" name="roomNumber"
                                               class="form-control form-control-sm"
                                               placeholder="VD: 101, A-01, VILLA-1"
                                               style="width:160px;" maxlength="50" required
                                               oninput="this.value=this.value.toUpperCase()">
                                    </div>
                                    <button type="submit" class="btn btn-sm btn-outline-primary rounded-3 mb-0">
                                        <i class="fa-solid fa-plus me-1"></i>Thêm phòng
                                    </button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>

        </div><%-- /.owner-content --%>
    </div>
</div>

<!-- ── Add RoomType Modal ─────────────────────────────────────── -->
<div class="owner-modal-overlay" id="addRoomTypeModal" onclick="if(event.target===this)closeModal('addRoomTypeModal')">
    <div class="owner-modal-box">
        <div class="d-flex align-items-center justify-content-between mb-3">
            <h6 class="fw-bold mb-0"><i class="fa-solid fa-plus text-primary me-2"></i>Thêm Loại phòng mới</h6>
            <button type="button" class="btn-close" onclick="closeModal('addRoomTypeModal')"></button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/owner/rooms">
            <input type="hidden" name="action"     value="addRoomType">
            <input type="hidden" name="homestayId" value="${homestay.homestayId}">
            <div class="mb-3">
                <label class="form-label fw-semibold" style="font-size:.83rem;">Tên loại phòng <span class="text-danger">*</span></label>
                <input type="text" name="rtName" class="form-control form-control-sm"
                       placeholder="VD: Phòng Standard, Suite Gia Đình..." required maxlength="100">
            </div>
            <div class="mb-3">
                <label class="form-label fw-semibold" style="font-size:.83rem;">Mô tả</label>
                <textarea name="rtDescription" class="form-control form-control-sm" rows="2"
                          placeholder="Đặc điểm nổi bật của loại phòng..."></textarea>
            </div>
            <div class="row g-2 mb-3">
                <div class="col-6">
                    <label class="form-label fw-semibold" style="font-size:.83rem;">Giá cơ bản/đêm (₫) <span class="text-danger">*</span></label>
                    <input type="number" name="rtBasePrice" class="form-control form-control-sm"
                           min="0" step="50000" placeholder="VD: 800000" required>
                </div>
                <div class="col-6">
                    <label class="form-label fw-semibold" style="font-size:.83rem;">Diện tích (m²)</label>
                    <input type="number" name="rtRoomSize" class="form-control form-control-sm"
                           min="0" step="0.5" placeholder="VD: 28">
                </div>
            </div>
            <div class="row g-2 mb-3">
                <div class="col-6">
                    <label class="form-label fw-semibold" style="font-size:.83rem;">Sức chứa tối đa</label>
                    <select name="rtMaxOccupancy" class="form-select form-select-sm">
                        <option value="1">1 người</option>
                        <option value="2" selected>2 người</option>
                        <option value="3">3 người</option>
                        <option value="4">4 người</option>
                        <option value="6">6 người</option>
                        <option value="8">8 người</option>
                    </select>
                </div>
                <div class="col-6">
                    <label class="form-label fw-semibold" style="font-size:.83rem;">Số giường</label>
                    <select name="rtBedCount" class="form-select form-select-sm">
                        <option value="1" selected>1 giường</option>
                        <option value="2">2 giường</option>
                        <option value="3">3 giường</option>
                        <option value="4">4 giường</option>
                    </select>
                </div>
            </div>
            <div class="d-flex gap-2 mt-3">
                <button type="submit" class="btn btn-primary-custom btn-sm px-4">
                    <i class="fa-solid fa-check me-1"></i>Lưu
                </button>
                <button type="button" class="btn btn-outline-secondary btn-sm"
                        onclick="closeModal('addRoomTypeModal')">Hủy</button>
            </div>
        </form>
    </div>
</div>

<!-- ── Edit RoomType Modal ─────────────────────────────────────── -->
<div class="owner-modal-overlay" id="editRoomTypeModal" onclick="if(event.target===this)closeModal('editRoomTypeModal')">
    <div class="owner-modal-box">
        <div class="d-flex align-items-center justify-content-between mb-3">
            <h6 class="fw-bold mb-0"><i class="fa-solid fa-pen text-primary me-2"></i>Sửa Loại phòng</h6>
            <button type="button" class="btn-close" onclick="closeModal('editRoomTypeModal')"></button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/owner/rooms" id="editRoomTypeForm">
            <input type="hidden" name="action"     value="editRoomType">
            <input type="hidden" name="homestayId" value="${homestay.homestayId}">
            <input type="hidden" name="roomTypeId" id="editRtId">
            <div class="mb-3">
                <label class="form-label fw-semibold" style="font-size:.83rem;">Tên loại phòng <span class="text-danger">*</span></label>
                <input type="text" name="rtName" id="editRtName" class="form-control form-control-sm" required maxlength="100">
            </div>
            <div class="mb-3">
                <label class="form-label fw-semibold" style="font-size:.83rem;">Mô tả</label>
                <textarea name="rtDescription" id="editRtDescription" class="form-control form-control-sm" rows="2"></textarea>
            </div>
            <div class="row g-2 mb-3">
                <div class="col-6">
                    <label class="form-label fw-semibold" style="font-size:.83rem;">Giá cơ bản/đêm (₫) <span class="text-danger">*</span></label>
                    <input type="number" name="rtBasePrice" id="editRtBasePrice" class="form-control form-control-sm" min="0" step="50000" required>
                </div>
                <div class="col-6">
                    <label class="form-label fw-semibold" style="font-size:.83rem;">Diện tích (m²)</label>
                    <input type="number" name="rtRoomSize" id="editRtRoomSize" class="form-control form-control-sm" min="0" step="0.5">
                </div>
            </div>
            <div class="row g-2 mb-3">
                <div class="col-6">
                    <label class="form-label fw-semibold" style="font-size:.83rem;">Sức chứa tối đa</label>
                    <input type="number" name="rtMaxOccupancy" id="editRtMaxOccupancy" class="form-control form-control-sm" min="1" max="20">
                </div>
                <div class="col-6">
                    <label class="form-label fw-semibold" style="font-size:.83rem;">Số giường</label>
                    <input type="number" name="rtBedCount" id="editRtBedCount" class="form-control form-control-sm" min="1" max="10">
                </div>
            </div>
            <div class="d-flex gap-2 mt-3">
                <button type="submit" class="btn btn-primary-custom btn-sm px-4">
                    <i class="fa-solid fa-floppy-disk me-1"></i>Lưu thay đổi
                </button>
                <button type="button" class="btn btn-outline-secondary btn-sm"
                        onclick="closeModal('editRoomTypeModal')">Hủy</button>
            </div>
        </form>
    </div>
</div>

<script>
// ── Delete room type ─────────────────────────────────────────────────────────
function deleteRoomType(btn) {
    try {
        var rtId   = btn.getAttribute('data-rt-id');
        var rtName = btn.getAttribute('data-rt-name');
        if (!confirm('Xóa loại phòng "' + rtName + '"?\n\nTất cả phòng vật lý thuộc loại này cũng bị xóa.\nKhông thể hoàn tác!')) return;
        var f = document.getElementById('delRtForm' + rtId);
        if (!f) { alert('Lỗi: Không tìm thấy form xóa loại phòng.'); return; }
        f.submit();
    } catch(e) { alert('Lỗi JS: ' + e.message); }
}

// ── Delete room (single shared form, populated via data-* attrs) ──────────────
function deleteRoom(btn) {
    try {
        var roomId     = btn.getAttribute('data-room-id');
        var roomNum    = btn.getAttribute('data-room-number');
        var homestayId = btn.getAttribute('data-homestay-id');
        if (!roomId || roomId === '0') { alert('Lỗi: Không tìm được ID phòng.'); return; }
        if (!confirm('Xóa phòng ' + roomNum + '?\nThao tác này không thể hoàn tác!')) return;
        var f = document.getElementById('_sharedDeleteRoomForm');
        if (!f) { alert('Lỗi: Form không tìm thấy trong trang.'); return; }
        f.elements['roomId'].value     = roomId;
        f.elements['homestayId'].value = homestayId;
        f.submit();
    } catch(e) { alert('Lỗi JS: ' + e.message); }
}

// ── Accordion ─────────────────────────────────────────────────────────────────
function toggleRoomType(rtId) {
    var body    = document.getElementById('rtBody'    + rtId);
    var header  = document.getElementById('rtHeader'  + rtId);
    var chevron = document.getElementById('rtChevron' + rtId);
    var open = body.classList.toggle('show');
    header.classList.toggle('is-open', open);
    chevron.style.transform = open ? 'rotate(180deg)' : 'rotate(0deg)';
}

// ── Modals ────────────────────────────────────────────────────────────────────
function openAddRoomTypeModal() {
    document.getElementById('addRoomTypeModal').classList.add('show');
}
function openEditRoomTypeModal(id, name, price, occ, beds, desc, size) {
    document.getElementById('editRtId').value          = id;
    document.getElementById('editRtName').value        = name;
    document.getElementById('editRtBasePrice').value   = price;
    document.getElementById('editRtMaxOccupancy').value= occ;
    document.getElementById('editRtBedCount').value    = beds;
    document.getElementById('editRtDescription').value = desc;
    document.getElementById('editRtRoomSize').value    = size > 0 ? size : '';
    document.getElementById('editRoomTypeModal').classList.add('show');
}
function closeModal(id) {
    document.getElementById(id).classList.remove('show');
}
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        closeModal('addRoomTypeModal');
        closeModal('editRoomTypeModal');
    }
});
</script>

<%-- Shared delete room form (populated by JS deleteRoom()) --%>
<form method="post" action="${pageContext.request.contextPath}/owner/rooms"
      id="_sharedDeleteRoomForm" style="display:none;">
    <input type="hidden" name="action"     value="deleteRoom">
    <input type="hidden" name="homestayId" value="">
    <input type="hidden" name="roomId"     value="">
</form>

<jsp:include page="../common/footer.jsp"/>
