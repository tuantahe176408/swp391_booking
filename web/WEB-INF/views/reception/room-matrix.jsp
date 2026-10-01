<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle"      value="Ma trận Trạng thái Phòng" scope="request"/>
<c:set var="pageBreadcrumb" value="Đón tiếp &amp; Quản lý Phòng" scope="request"/>
<jsp:include page="../common/header.jsp"/>

<style>
/* ═══════════════════════════════════════════════════
   Room Matrix — Soft & Modern Redesign
   Bảng màu dịu mắt: pastel border, light bg tint
═══════════════════════════════════════════════════ */

/* ── Color tokens — muted, professional palette ─── */
:root {
    /* Sage green */
    --avail-color:  #3d7a56;
    --avail-bg:     #ffffff;
    --avail-pill:   #f2f8f4;
    --avail-ring:   #bddece;
    --avail-accent: #7ab896;

    /* Soft rose */
    --occup-color:  #8e4a4a;
    --occup-bg:     #ffffff;
    --occup-pill:   #faf2f2;
    --occup-ring:   #ddbfbf;
    --occup-accent: #c08888;

    /* Warm amber */
    --dirty-color:  #8a6520;
    --dirty-bg:     #ffffff;
    --dirty-pill:   #faf6ec;
    --dirty-ring:   #d8c085;
    --dirty-accent: #c4a050;

    /* Neutral slate */
    --maint-color:  #5e7488;
    --maint-bg:     #ffffff;
    --maint-pill:   #f2f5f8;
    --maint-ring:   #bccfdc;
    --maint-accent: #90a8bc;
}

/* ── Page header banner ─────────────────────────── */
.rm-page-header {
    background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
    border: 1px solid #e2e8f0;
    border-radius: 18px;
    padding: 1.15rem 1.5rem;
    margin-bottom: 1.25rem;
}

/* ── Stats legend row ───────────────────────────── */
.rm-stat {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 8px 16px;
    background: #ffffff;
    border: 1px solid #e2e8f0;
    border-radius: 50px;
    box-shadow: 0 1px 3px rgba(15, 23, 42, 0.03);
    white-space: nowrap;
    transition: all 0.15s ease;
}
.rm-stat:hover {
    border-color: #cbd5e1;
    transform: translateY(-1px);
}
.rm-stat-dot {
    width: 9px; height: 9px;
    border-radius: 50%; flex-shrink: 0;
}
.rm-stat-count { font-size: 1.05rem; font-weight: 700; line-height: 1; }
.rm-stat-label { font-size: 0.76rem; color: #64748b; font-weight: 500; }

/* ── Section header (room type grouping) ────────── */
.rm-section-hdr {
    display: flex; align-items: center; gap: 12px;
    margin-top: 10px; margin-bottom: 14px;
}
.rm-section-badge {
    display: inline-flex; align-items: center; gap: 8px;
    padding: 6px 14px;
    background: #ffffff;
    border: 1px solid #e2e8f0;
    border-radius: 10px;
    font-size: 0.84rem; font-weight: 700; color: #1e293b;
    box-shadow: 0 1px 3px rgba(15, 23, 42, 0.03);
}
.rm-section-count { font-size: 0.78rem; color: #64748b; font-weight: 500; }
.rm-section-line  { flex: 1; height: 1px; background: #e2e8f0; }

/* ── Room card — Harmonious & Modern PMS Redesign ── */
.room-card {
    border-radius: 18px !important;
    overflow: hidden;
    border: 1px solid #e2e8f0;
    border-top: 3.5px solid #cbd5e1;
    background: #ffffff;
    box-shadow: 0 2px 8px rgba(15, 23, 42, 0.04);
    transition: transform 0.2s ease, box-shadow 0.2s ease, border-color 0.2s ease;
    height: 100%;
    min-height: 148px;
    display: flex;
    flex-direction: column;
}
.room-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 12px 24px rgba(15, 23, 42, 0.08) !important;
}

/* Status top accents */
.room-card.status-available {
    border-top-color: var(--avail-accent) !important;
}
.room-card.status-available:hover {
    border-color: var(--avail-ring);
    box-shadow: 0 10px 24px rgba(0,0,0,0.07) !important;
}

.room-card.status-occupied {
    border-top-color: var(--occup-accent) !important;
}
.room-card.status-occupied:hover {
    border-color: var(--occup-ring);
    box-shadow: 0 10px 24px rgba(0,0,0,0.07) !important;
}

.room-card.status-dirty {
    border-top-color: var(--dirty-accent) !important;
}
.room-card.status-dirty:hover {
    border-color: var(--dirty-ring);
    box-shadow: 0 10px 24px rgba(0,0,0,0.07) !important;
}

.room-card.status-maintenance {
    border-top-color: var(--maint-accent) !important;
}
.room-card.status-maintenance:hover {
    border-color: var(--maint-ring);
    box-shadow: 0 10px 24px rgba(0,0,0,0.07) !important;
}

/* ── Card Body Layout ───────────────────────────── */
.rm-card-body {
    padding: 14px 16px 14px;
    height: 100%;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
}

/* ── Status icon circle (top-left of card) ──────── */
.rm-icon-circle {
    width: 38px; height: 38px;
    border-radius: 12px; flex-shrink: 0;
    display: flex; align-items: center; justify-content: center;
    font-size: 0.95rem;
    transition: all 0.2s ease;
}
.rm-icon-circle.icon-available   { background: var(--avail-pill);  color: var(--avail-color); }
.rm-icon-circle.icon-occupied    { background: var(--occup-pill);  color: var(--occup-color); }
.rm-icon-circle.icon-dirty       { background: var(--dirty-pill);  color: var(--dirty-color); }
.rm-icon-circle.icon-maintenance { background: var(--maint-pill);  color: var(--maint-color); }

/* ── Room number & type ─────────────────────────── */
.rm-number {
    font-size: 1.25rem;
    font-weight: 800;
    letter-spacing: -0.4px;
    color: #0f172a;
    line-height: 1.1;
}
.rm-type-name {
    font-size: 0.75rem;
    color: #64748b;
    font-weight: 500;
    margin-top: 2px;
}

/* ── Status pill (top-right of card) ─────────────── */
.rm-pill {
    display: inline-flex; align-items: center; gap: 5px;
    padding: 3.5px 10px;
    border-radius: 50px;
    font-size: 0.72rem; font-weight: 700;
    border: 1px solid transparent;
    letter-spacing: 0.15px;
    flex-shrink: 0;
}
.rm-pill.pill-available   { background: var(--avail-pill);  color: var(--avail-color); border-color: var(--avail-ring); }
.rm-pill.pill-occupied    { background: var(--occup-pill);  color: var(--occup-color); border-color: var(--occup-ring); }
.rm-pill.pill-dirty       { background: var(--dirty-pill);  color: var(--dirty-color); border-color: var(--dirty-ring); }
.rm-pill.pill-maintenance { background: var(--maint-pill);  color: var(--maint-color); border-color: var(--maint-ring); }

/* ── Bottom Info Box — neutral bg, no colored tints ── */
.rm-info-box {
    margin-top: 12px;
    padding: 8px 12px;
    border-radius: 12px;
    background: #f8fafc;
    border: 1px solid #edf0f5;
    min-height: 48px;
    display: flex;
    flex-direction: column;
    justify-content: center;
    transition: background 0.18s ease;
}
.room-card.status-available .rm-info-box  { background: #f8fafc; border-color: #edf0f5; }
.room-card.status-occupied .rm-info-box   { background: #f8fafc; border-color: #edf0f5; }
.room-card.status-dirty .rm-info-box      { background: #f8fafc; border-color: #edf0f5; }
.room-card.status-maintenance .rm-info-box{ background: #f8fafc; border-color: #edf0f5; }

/* ── Guest line inside info box ─────────────────── */
.rm-guest {
    font-size: 0.78rem; font-weight: 600;
    display: flex; align-items: center; gap: 5px;
    line-height: 1.3;
}
.rm-guest.gst-available   { color: var(--avail-color); }
.rm-guest.gst-occupied    { color: var(--occup-color); }
.rm-guest.gst-dirty       { color: var(--dirty-color); }
.rm-guest.gst-maintenance { color: var(--maint-color); }

/* ── Booking code inside info box ───────────────── */
.rm-booking-code {
    font-size: 0.68rem;
    color: #64748b;
    font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
    font-weight: 500;
    margin-top: 2px;
    letter-spacing: 0.3px;
    display: flex;
    align-items: center;
    opacity: 0.75;
}

/* ── Checkout button (inside OCCUPIED rm-info-box) ── */
.btn-checkout-sm {
    display: flex; align-items: center; justify-content: center; gap: 5px;
    width: 100%; margin-top: 6px; padding: 5px 0;
    border-radius: 8px;
    background: transparent;
    color: var(--occup-color);
    border: 1px solid var(--occup-ring);
    font-size: 0.72rem; font-weight: 700;
    cursor: pointer; transition: all 0.15s ease;
    line-height: 1;
}
.btn-checkout-sm:hover {
    background: var(--occup-accent);
    color: #ffffff;
    border-color: var(--occup-accent);
}

/* ── Refresh button ─────────────────────────────── */
#btnRefresh {
    background: #ffffff; color: #475569;
    border: 1px solid #e2e8f0;
    border-radius: 50px !important;
    font-size: 0.8rem; padding: 6px 15px;
    font-weight: 600;
    box-shadow: 0 1px 3px rgba(15, 23, 42, 0.04);
    transition: all 0.15s ease;
}
#btnRefresh:hover { background: #f8fafc; color: #1e293b; border-color: #cbd5e1; }

/* ── Empty state ────────────────────────────────── */
.rm-empty-state {
    text-align: center; padding: 4rem 1rem;
    background: #ffffff; border: 1px dashed #e2e8f0;
    border-radius: 18px; color: #94a3b8;
}
.rm-empty-state i { font-size: 2.8rem; margin-bottom: 1rem; display: block; }

/* ── Auto-refresh bar ───────────────────────────── */
.rm-refresh-bar { font-size: 0.76rem; color: #64748b; }
.rm-refresh-bar .rm-progress {
    flex: 1; height: 4px; background: #e2e8f0; border-radius: 50px; overflow: hidden;
}
.rm-refresh-bar .rm-progress-fill {
    height: 100%; width: 100%;
    background: linear-gradient(90deg, #6366f1, #06b6d4);
    transition: width 1s linear;
    border-radius: 50px;
}
</style>

<div class="owner-shell">
    <jsp:include page="../common/sidebar-reception.jsp"/>
    <div class="owner-main">
        <jsp:include page="../common/reception-topbar.jsp"/>
        <div class="owner-content">

            <%-- ── Page header ─────────────────────────────────────────── --%>
            <div class="rm-page-header d-flex align-items-center justify-content-between flex-wrap gap-3">
                <div>
                    <h4 class="fw-bold mb-1" style="font-size:1.15rem; color:#1e293b;">
                        <i class="fa-solid fa-table-cells-large me-2" style="color:#6366f1;"></i>Ma trận Trạng thái Phòng
                    </h4>
                    <p class="mb-0" style="font-size:0.83rem; color:#64748b;">
                        Theo dõi thời gian thực tất cả phòng tại&nbsp;
                        <strong style="color:#334155;">
                            <c:choose>
                                <c:when test="${not empty homestayName}">${homestayName}</c:when>
                                <c:otherwise>homestay của bạn</c:otherwise>
                            </c:choose>
                        </strong>
                    </p>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <small id="lastRefreshed" style="font-size:0.72rem; color:#94a3b8;"></small>
                    <button id="btnRefresh" class="btn btn-sm" onclick="refreshMatrix()">
                        <i class="fa-solid fa-rotate me-1"></i>Làm mới
                    </button>
                </div>
            </div>

            <%-- ── Warning: no homestay assigned ──────────────────────── --%>
            <c:if test="${empty homestayId}">
                <div class="d-flex align-items-start gap-3 p-3 mb-3 rounded-4"
                     style="background:#fffbeb; border:1px solid #fcd34d;">
                    <i class="fa-solid fa-triangle-exclamation mt-1" style="color:#d97706;"></i>
                    <div style="font-size:0.85rem; color:#92400e;">
                        <strong>Chưa được phân công:</strong> Tài khoản lễ tân của bạn chưa được gán cho cơ sở homestay nào.
                        Vui lòng liên hệ Owner hoặc Admin để được phân công.
                    </div>
                </div>
            </c:if>

            <%-- ── Flash: checkout success / error ────────────────────── --%>
            <c:if test="${not empty param.checkoutSuccess}">
                <div class="alert alert-dismissible fade show d-flex align-items-center gap-2 mb-3 rounded-3"
                     style="background:#f2f8f4; border:1px solid #bddece; color:#3d7a56;" role="alert">
                    <i class="fa-solid fa-circle-check fs-5"></i>
                    <span>Check-out thành công! Mã đặt phòng <strong>${param.checkoutSuccess}</strong>
                          đã được trả phòng — phòng chuyển sang <strong>Cần dọn dẹp</strong>.</span>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.error eq 'checkout_failed'}">
                <div class="alert alert-dismissible fade show d-flex align-items-center gap-2 mb-3 rounded-3"
                     style="background:#faf2f2; border:1px solid #ddbfbf; color:#8e4a4a;" role="alert">
                    <i class="fa-solid fa-circle-exclamation fs-5"></i>
                    <span>Check-out thất bại. Vui lòng kiểm tra lại trạng thái đặt phòng.</span>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <%-- ── Stats legend ────────────────────────────────────────── --%>
            <c:if test="${not empty homestayId}">
                <div class="d-flex flex-wrap gap-2 mb-4 align-items-center">
                    <div class="rm-stat">
                        <span class="rm-stat-dot" style="background: var(--avail-accent);"></span>
                        <span class="rm-stat-count" style="color: var(--avail-color);" id="cntAvailable">${countAvailable}</span>
                        <span class="rm-stat-label">Phòng trống</span>
                    </div>
                    <div class="rm-stat">
                        <span class="rm-stat-dot" style="background: var(--occup-accent);"></span>
                        <span class="rm-stat-count" style="color: var(--occup-color);" id="cntOccupied">${countOccupied}</span>
                        <span class="rm-stat-label">Có khách</span>
                    </div>
                    <div class="rm-stat">
                        <span class="rm-stat-dot" style="background: var(--dirty-accent);"></span>
                        <span class="rm-stat-count" style="color: var(--dirty-color);" id="cntDirty">${countDirty}</span>
                        <span class="rm-stat-label">Cần dọn</span>
                    </div>
                    <div class="rm-stat">
                        <span class="rm-stat-dot" style="background: var(--maint-accent);"></span>
                        <span class="rm-stat-count" style="color: var(--maint-color);" id="cntMaintenance">${countMaintenance}</span>
                        <span class="rm-stat-label">Bảo trì</span>
                    </div>
                    <div class="rm-stat ms-auto" style="background:#f8fafc;">
                        <i class="fa-solid fa-building" style="color:#94a3b8; font-size:0.9rem;"></i>
                        <span class="rm-stat-count" style="color:#334155;">${fn:length(rooms)}</span>
                        <span class="rm-stat-label">tổng phòng</span>
                    </div>
                </div>
            </c:if>

            <%-- ── Empty state ─────────────────────────────────────────── --%>
            <c:if test="${not empty homestayId and empty rooms}">
                <div class="rm-empty-state">
                    <i class="fa-solid fa-door-open" style="color:#cbd5e1;"></i>
                    <h6 class="fw-bold" style="color:#334155;">Chưa có phòng nào được thiết lập</h6>
                    <p class="mb-0 small">Vui lòng liên hệ Owner để thêm phòng vào hệ thống.</p>
                </div>
            </c:if>

            <%-- ── Room grid grouped by room type ─────────────────────── --%>
            <div id="roomMatrixContainer">
                <c:forEach var="entry" items="${roomsByType}">

                    <%-- Section header --%>
                    <div class="rm-section-hdr">
                        <div class="rm-section-badge">
                            <i class="fa-solid fa-layer-group" style="color:#6366f1; font-size:0.82rem;"></i>
                            ${entry.key}
                        </div>
                        <span class="rm-section-count">${fn:length(entry.value)} phòng</span>
                        <div class="rm-section-line"></div>
                    </div>

                    <div class="row g-3 mb-4">
                        <c:forEach var="room" items="${entry.value}">

                            <%-- Resolve per-card style variables via c:set --%>
                            <c:choose>
                                <c:when test="${room.status eq 'AVAILABLE'}">
                                    <c:set var="cardClass"    value="status-available"/>
                                    <c:set var="pillClass"    value="pill-available"/>
                                    <c:set var="iconClass"    value="icon-available"/>
                                    <c:set var="pillIcon"     value="fa-circle-check"/>
                                    <c:set var="pillLabel"    value="Trống"/>
                                    <c:set var="statusIcon"   value="fa-door-open"/>
                                    <c:set var="guestClass"   value="gst-available"/>
                                    <c:set var="guestIcon"    value="fa-circle-check"/>
                                    <c:set var="guestDefault" value="Sẵn sàng đón khách"/>
                                </c:when>
                                <c:when test="${room.status eq 'OCCUPIED'}">
                                    <c:set var="cardClass"    value="status-occupied"/>
                                    <c:set var="pillClass"    value="pill-occupied"/>
                                    <c:set var="iconClass"    value="icon-occupied"/>
                                    <c:set var="pillIcon"     value="fa-user"/>
                                    <c:set var="pillLabel"    value="Có khách"/>
                                    <c:set var="statusIcon"   value="fa-bed"/>
                                    <c:set var="guestClass"   value="gst-occupied"/>
                                    <c:set var="guestIcon"    value="fa-user"/>
                                    <c:set var="guestDefault" value="Đang có khách"/>
                                </c:when>
                                <c:when test="${room.status eq 'DIRTY'}">
                                    <c:set var="cardClass"    value="status-dirty"/>
                                    <c:set var="pillClass"    value="pill-dirty"/>
                                    <c:set var="iconClass"    value="icon-dirty"/>
                                    <c:set var="pillIcon"     value="fa-broom"/>
                                    <c:set var="pillLabel"    value="Cần dọn"/>
                                    <c:set var="statusIcon"   value="fa-broom"/>
                                    <c:set var="guestClass"   value="gst-dirty"/>
                                    <c:set var="guestIcon"    value="fa-broom"/>
                                    <c:set var="guestDefault" value="Cần vệ sinh"/>
                                </c:when>
                                <c:otherwise>
                                    <c:set var="cardClass"    value="status-maintenance"/>
                                    <c:set var="pillClass"    value="pill-maintenance"/>
                                    <c:set var="iconClass"    value="icon-maintenance"/>
                                    <c:set var="pillIcon"     value="fa-screwdriver-wrench"/>
                                    <c:set var="pillLabel"    value="Bảo trì"/>
                                    <c:set var="statusIcon"   value="fa-screwdriver-wrench"/>
                                    <c:set var="guestClass"   value="gst-maintenance"/>
                                    <c:set var="guestIcon"    value="fa-wrench"/>
                                    <c:set var="guestDefault" value="Đang bảo trì"/>
                                </c:otherwise>
                            </c:choose>

                            <div class="col-6 col-md-4 col-xl-3 d-flex">
                                <div class="room-card ${cardClass} w-100" data-room-id="${room.roomId}">
                                    <div class="rm-card-body">

                                        <%-- Top row: Room identity (Icon + Number & Type) on left, Status Pill on right --%>
                                        <div class="d-flex align-items-center justify-content-between gap-2">
                                            <div class="d-flex align-items-center gap-2" style="min-width: 0;">
                                                <div class="rm-icon-circle ${iconClass}">
                                                    <i class="fa-solid ${statusIcon}"></i>
                                                </div>
                                                <div style="min-width: 0;">
                                                    <div class="rm-number">P.${room.roomNumber}</div>
                                                    <div class="rm-type-name text-truncate" title="${room.roomTypeName}">${room.roomTypeName}</div>
                                                </div>
                                            </div>
                                            <span class="rm-pill ${pillClass}">
                                                <i class="fa-solid ${pillIcon}"></i>${pillLabel}
                                            </span>
                                        </div>

                                        <%-- Bottom row: Harmonious Info Box --%>
                                        <div class="rm-info-box">
                                            <div class="rm-guest ${guestClass}">
                                                <i class="fa-solid ${guestIcon}"></i>
                                                <c:choose>
                                                    <c:when test="${room.status eq 'OCCUPIED' and not empty room.currentGuestName}">
                                                        <span class="text-truncate" title="${room.currentGuestName}">${room.currentGuestName}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span>${guestDefault}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <%-- Booking code (occupied only) --%>
                                            <c:if test="${room.status eq 'OCCUPIED' and not empty room.currentBookingCode}">
                                                <div class="rm-booking-code">
                                                    <i class="fa-solid fa-ticket me-1"></i>${room.currentBookingCode}
                                                </div>
                                            </c:if>

                                            <%-- Check-out button (OCCUPIED rooms only) --%>
                                            <c:if test="${room.status eq 'OCCUPIED' and not empty room.currentBookingId}">
                                                <form class="rm-checkout-form"
                                                      action="${pageContext.request.contextPath}/reception/checkin"
                                                      method="POST"
                                                      onsubmit="return confirmCheckout('P.${room.roomNumber}','${room.currentGuestName}');">
                                                    <input type="hidden" name="action"    value="checkout">
                                                    <input type="hidden" name="bookingId" value="${room.currentBookingId}">
                                                    <button type="submit" class="btn-checkout-sm">
                                                        <i class="fa-solid fa-right-from-bracket"></i>Check-out
                                                    </button>
                                                </form>
                                            </c:if>
                                        </div>

                                    </div><%-- /rm-card-body --%>
                                </div><%-- /room-card --%>
                            </div>
                        </c:forEach>
                    </div><%-- /row --%>

                </c:forEach>
            </div><%-- /roomMatrixContainer --%>

            <%-- ── Auto-refresh countdown bar ─────────────────────────── --%>
            <c:if test="${not empty homestayId and not empty rooms}">
                <div class="rm-refresh-bar d-flex align-items-center gap-2 mt-2">
                    <i class="fa-solid fa-rotate" style="color:#6366f1; font-size:0.76rem;"></i>
                    Tự động làm mới sau
                    <span id="countdown" class="fw-semibold" style="color:#6366f1; min-width:14px;">30</span>s
                    <div class="rm-progress">
                        <div id="progressBar" class="rm-progress-fill"></div>
                    </div>
                </div>
            </c:if>

        </div><%-- /owner-content --%>
    </div><%-- /owner-main --%>
</div><%-- /owner-shell --%>

<%-- ── AJAX auto-polling JavaScript ──────────────────────────────────────── --%>
<script>
(function () {
    var ctxPath   = '${pageContext.request.contextPath}';
    var countdown = 30, totalSecs = 30, timer = null;
    var countEl   = document.getElementById('countdown');
    var barEl     = document.getElementById('progressBar');
    var lastRefEl = document.getElementById('lastRefreshed');
    var btnRef    = document.getElementById('btnRefresh');

    /* Status display configuration — must match CSS class names above */
    var STATUS_CFG = {
        AVAILABLE:   {
            cardCls:'status-available', pillCls:'pill-available', pillIcon:'fa-circle-check', pillLabel:'Trống',
            iconCls:'icon-available',   statusIcon:'fa-door-open',
            guestCls:'gst-available',   guestIcon:'fa-circle-check', guestText:'Sẵn sàng đón khách'
        },
        OCCUPIED:    {
            cardCls:'status-occupied',  pillCls:'pill-occupied',  pillIcon:'fa-user',               pillLabel:'Có khách',
            iconCls:'icon-occupied',    statusIcon:'fa-bed',
            guestCls:'gst-occupied',    guestIcon:'fa-user',              guestText:'Đang có khách'
        },
        DIRTY:       {
            cardCls:'status-dirty',     pillCls:'pill-dirty',     pillIcon:'fa-broom',              pillLabel:'Cần dọn',
            iconCls:'icon-dirty',       statusIcon:'fa-broom',
            guestCls:'gst-dirty',       guestIcon:'fa-broom',             guestText:'Cần vệ sinh'
        },
        MAINTENANCE: {
            cardCls:'status-maintenance', pillCls:'pill-maintenance', pillIcon:'fa-screwdriver-wrench', pillLabel:'Bảo trì',
            iconCls:'icon-maintenance',   statusIcon:'fa-screwdriver-wrench',
            guestCls:'gst-maintenance',   guestIcon:'fa-wrench',            guestText:'Đang bảo trì'
        }
    };
    var ALL_CARD_CLS  = ['status-available','status-occupied','status-dirty','status-maintenance'];
    var ALL_ICON_CLS  = ['icon-available','icon-occupied','icon-dirty','icon-maintenance'];

    /* ── Countdown ─────────────────────────────────── */
    function startCountdown() {
        countdown = totalSecs;
        tick();
        clearInterval(timer);
        timer = setInterval(function () {
            countdown--;
            tick();
            if (countdown <= 0) { clearInterval(timer); refreshMatrix(); }
        }, 1000);
    }
    function tick() {
        if (countEl) countEl.textContent = countdown;
        if (barEl)   barEl.style.width = ((countdown / totalSecs) * 100) + '%';
    }

    /* ── AJAX refresh ──────────────────────────────── */
    window.refreshMatrix = function () {
        clearInterval(timer);
        if (btnRef) {
            btnRef.disabled = true;
            btnRef.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span>';
        }

        fetch(ctxPath + '/reception/matrix', { method: 'POST' })
        .then(function (r) { return r.json(); })
        .then(function (rooms) {
            rooms.forEach(function (room) {
                var card = document.querySelector('[data-room-id="' + room.roomId + '"]');
                if (!card) return;

                var cfg = STATUS_CFG[room.status] || STATUS_CFG.AVAILABLE;

                /* 1 — card class */
                ALL_CARD_CLS.forEach(function (c) { card.classList.remove(c); });
                card.classList.add(cfg.cardCls);

                /* 2 — pill */
                var pill = card.querySelector('.rm-pill');
                if (pill) {
                    pill.className = 'rm-pill ' + cfg.pillCls;
                    pill.innerHTML = '<i class="fa-solid ' + cfg.pillIcon + '"></i>' + cfg.pillLabel;
                }

                /* 3 — icon circle */
                var ico = card.querySelector('.rm-icon-circle');
                if (ico) {
                    ALL_ICON_CLS.forEach(function (c) { ico.classList.remove(c); });
                    ico.classList.add(cfg.iconCls);
                    ico.innerHTML = '<i class="fa-solid ' + cfg.statusIcon + '"></i>';
                }

                /* 4 — guest line */
                var guestEl = card.querySelector('.rm-guest');
                if (guestEl) {
                    guestEl.className = 'rm-guest ' + cfg.guestCls;
                    var name = (room.status === 'OCCUPIED' && room.currentGuestName)
                        ? room.currentGuestName : cfg.guestText;
                    guestEl.innerHTML =
                        '<i class="fa-solid ' + cfg.guestIcon + '"></i><span class="text-truncate" title="' + escHtml(name) + '">' + escHtml(name) + '</span>';
                }

                /* 5 — booking code inside info box */
                var codeEl = card.querySelector('.rm-booking-code');
                var infoBox = card.querySelector('.rm-info-box') || card.querySelector('.rm-card-body');
                if (room.status === 'OCCUPIED' && room.currentBookingCode) {
                    if (!codeEl) {
                        var d = document.createElement('div');
                        d.className = 'rm-booking-code';
                        d.innerHTML = '<i class="fa-solid fa-ticket me-1"></i>' + escHtml(room.currentBookingCode);
                        if (infoBox) infoBox.appendChild(d);
                    } else {
                        codeEl.innerHTML = '<i class="fa-solid fa-ticket me-1"></i>' + escHtml(room.currentBookingCode);
                    }
                } else if (codeEl) {
                    codeEl.remove();
                }

                /* 6 — checkout button: add when OCCUPIED+bookingId, remove otherwise */
                var coForm = card.querySelector('.rm-checkout-form');
                if (room.status === 'OCCUPIED' && room.currentBookingId) {
                    if (!coForm) {
                        var form = document.createElement('form');
                        form.className = 'rm-checkout-form';
                        form.method    = 'POST';
                        form.action    = ctxPath + '/reception/checkin';
                        form.onsubmit  = function() {
                            return confirmCheckout(
                                'P.' + escHtml(room.roomNumber),
                                room.currentGuestName || ''
                            );
                        };
                        form.innerHTML =
                            '<input type="hidden" name="action"    value="checkout">' +
                            '<input type="hidden" name="bookingId" value="' + room.currentBookingId + '">' +
                            '<button type="submit" class="btn-checkout-sm">' +
                            '<i class="fa-solid fa-right-from-bracket"></i>Check-out</button>';
                        if (infoBox) infoBox.appendChild(form);
                    } else {
                        /* Update bookingId in case same room has a new booking */
                        var bInput = coForm.querySelector('[name="bookingId"]');
                        if (bInput) bInput.value = room.currentBookingId;
                    }
                } else if (coForm) {
                    coForm.remove();
                }
            });

            /* 6 — stat counters */
            var cnt = { AVAILABLE:0, OCCUPIED:0, DIRTY:0, MAINTENANCE:0 };
            rooms.forEach(function (r) { if (cnt[r.status] !== undefined) cnt[r.status]++; });
            setTxt('cntAvailable',   cnt.AVAILABLE);
            setTxt('cntOccupied',    cnt.OCCUPIED);
            setTxt('cntDirty',       cnt.DIRTY);
            setTxt('cntMaintenance', cnt.MAINTENANCE);

            /* 7 — last refreshed timestamp */
            if (lastRefEl) {
                var n = new Date();
                lastRefEl.textContent = pad(n.getHours()) + ':' + pad(n.getMinutes()) + ':' + pad(n.getSeconds());
            }
        })
        .catch(function (e) { console.warn('[RoomMatrix] refresh failed:', e); })
        .finally(function () {
            if (btnRef) {
                btnRef.disabled = false;
                btnRef.innerHTML = '<i class="fa-solid fa-rotate me-1"></i>Làm mới';
            }
            startCountdown();
        });
    };

    /* ── Helpers ─────────────────────────────────── */
    function setTxt(id, v) { var e = document.getElementById(id); if (e) e.textContent = v; }
    function pad(n)         { return n < 10 ? '0' + n : '' + n; }
    function escHtml(s) {
        if (!s) return '';
        return s.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
    }

    /* Boot: start countdown only when the countdown element exists */
    if (countEl) startCountdown();
})();

/**
 * Confirmation dialog trước khi check-out — called by both JSP-rendered
 * and AJAX-injected checkout forms.
 */
function confirmCheckout(roomNum, guestName) {
    var msg = 'Xác nhận Check-out?\n\nPhòng: ' + roomNum;
    if (guestName) msg += '\nKhách: ' + guestName;
    msg += '\n\nPhòng sẽ chuyển sang trạng thái "Cần dọn dẹp".';
    return window.confirm(msg);
}
</script>

<jsp:include page="../common/footer.jsp"/>
