<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle"      value="Quản lý Buồng phòng &amp; Dọn dẹp" scope="request"/>
<c:set var="pageBreadcrumb" value="Đón tiếp &amp; Quản lý Phòng"       scope="request"/>
<jsp:include page="../common/header.jsp"/>

<style>
/* ═══════════════════════════════════════════════════
   Housekeeping — reuses room-matrix card design system
   Color tokens & card CSS mirror room-matrix.jsp exactly
═══════════════════════════════════════════════════ */

/* ── Color tokens (identical to room-matrix.jsp) ─── */
:root {
    --avail-color:  #3d7a56; --avail-bg: #ffffff; --avail-pill: #f2f8f4; --avail-ring: #bddece; --avail-accent: #7ab896;
    --occup-color:  #8e4a4a; --occup-bg: #ffffff; --occup-pill: #faf2f2; --occup-ring: #ddbfbf; --occup-accent: #c08888;
    --dirty-color:  #8a6520; --dirty-bg: #ffffff; --dirty-pill: #faf6ec; --dirty-ring: #d8c085; --dirty-accent: #c4a050;
    --maint-color:  #5e7488; --maint-bg: #ffffff; --maint-pill: #f2f5f8; --maint-ring: #bccfdc; --maint-accent: #90a8bc;
}

/* ── Room card (mirror of room-matrix.jsp) ────────── */
.room-card {
    border-radius: 18px !important;
    overflow: hidden;
    border: 1px solid #e2e8f0;
    border-top: 3.5px solid #cbd5e1;
    background: #ffffff;
    box-shadow: 0 2px 8px rgba(15,23,42,0.04);
    transition: transform 0.2s ease, box-shadow 0.2s ease, border-color 0.2s ease;
    height: 100%;
    min-height: 148px;
    display: flex;
    flex-direction: column;
}
.room-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 12px 24px rgba(15,23,42,0.08) !important;
}
.room-card.status-available   { border-top-color: var(--avail-accent) !important; }
.room-card.status-occupied    { border-top-color: var(--occup-accent) !important; }
.room-card.status-dirty       { border-top-color: var(--dirty-accent) !important; }
.room-card.status-maintenance { border-top-color: var(--maint-accent) !important; }

.room-card.status-available:hover   { border-color: var(--avail-ring); box-shadow: 0 10px 24px rgba(0,0,0,0.07) !important; }
.room-card.status-occupied:hover    { border-color: var(--occup-ring); box-shadow: 0 10px 24px rgba(0,0,0,0.07) !important; }
.room-card.status-dirty:hover       { border-color: var(--dirty-ring); box-shadow: 0 10px 24px rgba(0,0,0,0.07) !important; }
.room-card.status-maintenance:hover { border-color: var(--maint-ring); box-shadow: 0 10px 24px rgba(0,0,0,0.07) !important; }

/* ── Card body (same as room-matrix) ─────────────── */
.rm-card-body {
    padding: 14px 16px;
    height: 100%;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
}

/* ── Icon circle (same as room-matrix) ───────────── */
.rm-icon-circle {
    width: 38px; height: 38px;
    border-radius: 12px; flex-shrink: 0;
    display: flex; align-items: center; justify-content: center;
    font-size: 0.95rem;
}
.rm-icon-circle.icon-available   { background: var(--avail-pill); color: var(--avail-color); }
.rm-icon-circle.icon-occupied    { background: var(--occup-pill); color: var(--occup-color); }
.rm-icon-circle.icon-dirty       { background: var(--dirty-pill); color: var(--dirty-color); }
.rm-icon-circle.icon-maintenance { background: var(--maint-pill); color: var(--maint-color); }

/* ── Room number / type (same as room-matrix) ─────── */
.rm-number    { font-size: 1.25rem; font-weight: 800; letter-spacing: -0.4px; color: #0f172a; line-height: 1.1; }
.rm-type-name { font-size: 0.75rem; color: #64748b; font-weight: 500; margin-top: 2px; }

/* ── Status pill (same as room-matrix) ───────────── */
.rm-pill {
    display: inline-flex; align-items: center; gap: 5px;
    padding: 3.5px 10px; border-radius: 50px;
    font-size: 0.72rem; font-weight: 700;
    border: 1px solid transparent;
    letter-spacing: 0.15px; flex-shrink: 0;
}
.rm-pill.pill-available   { background: var(--avail-pill); color: var(--avail-color); border-color: var(--avail-ring); }
.rm-pill.pill-occupied    { background: var(--occup-pill); color: var(--occup-color); border-color: var(--occup-ring); }
.rm-pill.pill-dirty       { background: var(--dirty-pill); color: var(--dirty-color); border-color: var(--dirty-ring); }
.rm-pill.pill-maintenance { background: var(--maint-pill); color: var(--maint-color); border-color: var(--maint-ring); }

/* ── Info box (same as room-matrix) ──────────────── */
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
}

/* ── Guest / info text (same as room-matrix) ─────── */
.rm-guest {
    font-size: 0.78rem; font-weight: 600;
    display: flex; align-items: center; gap: 5px;
    line-height: 1.3;
}
.rm-guest.gst-available   { color: var(--avail-color); }
.rm-guest.gst-occupied    { color: var(--occup-color); }
.rm-guest.gst-dirty       { color: var(--dirty-color); }
.rm-guest.gst-maintenance { color: var(--maint-color); }

/* ── Action buttons (housekeeping-only, inside rm-info-box) ── */
.btn-hk {
    display: flex; align-items: center; justify-content: center; gap: 5px;
    width: 100%;
    padding: 7px 0;
    border-radius: 9px;
    font-size: 0.76rem; font-weight: 700;
    cursor: pointer; transition: all 0.15s ease;
    border: 1px solid transparent;
    line-height: 1;
}
.btn-hk.btn-done {
    background: var(--avail-pill);
    color: var(--avail-color);
    border-color: var(--avail-ring);
}
.btn-hk.btn-done:hover {
    background: var(--avail-accent);
    color: #ffffff;
    border-color: var(--avail-accent);
}
.btn-hk.btn-mark {
    background: transparent;
    color: var(--dirty-color);
    border-color: var(--dirty-ring);
}
.btn-hk.btn-mark:hover { background: var(--dirty-pill); }

/* ── Page header ──────────────────────────────────── */
.hk-page-header {
    display: flex; align-items: center; justify-content: space-between;
    flex-wrap: wrap; gap: 12px;
    margin-bottom: 1.25rem;
    padding-bottom: 1rem;
    border-bottom: 1px solid #f0f3f7;
}
.hk-property-tag {
    display: inline-flex; align-items: center; gap: 6px;
    padding: 5px 14px;
    background: #f8fafc; border: 1px solid #e2e8f0;
    border-radius: 8px;
    font-size: 0.78rem; font-weight: 600; color: #475569;
}

/* ── Tabs (underline, workflow order) ────────────── */
.hk-tabs {
    display: flex;
    border-bottom: 1.5px solid #edf0f5;
    margin-bottom: 1.5rem;
    overflow-x: auto; -webkit-overflow-scrolling: touch;
    scrollbar-width: none;
}
.hk-tabs::-webkit-scrollbar { display: none; }
.hk-tab {
    display: inline-flex; align-items: center; gap: 6px;
    padding: 10px 14px 9px;
    font-size: 0.79rem; font-weight: 600;
    color: #94a3b8; text-decoration: none;
    border-bottom: 2px solid transparent;
    margin-bottom: -1.5px; white-space: nowrap;
    transition: color 0.15s ease; flex-shrink: 0;
}
.hk-tab:hover { color: #64748b; }
.hk-tab.is-active { color: #1e293b; border-bottom-color: #475569; font-weight: 700; }
.hk-tab.is-active.tab-all   { color: #0891b2; border-bottom-color: #0891b2; }
.hk-tab.is-active.tab-dirty { color: var(--dirty-color); border-bottom-color: var(--dirty-accent); }
.hk-tab.is-active.tab-avail { color: var(--avail-color); border-bottom-color: var(--avail-accent); }
.hk-tab.is-active.tab-occup { color: var(--occup-color); border-bottom-color: var(--occup-accent); }
.hk-tab.is-active.tab-maint { color: var(--maint-color); border-bottom-color: var(--maint-accent); }

/* ── Empty state ─────────────────────────────────── */
.hk-empty {
    text-align: center; padding: 4rem 1rem;
    background: #f8fafc; border: 1px dashed #dde2ea;
    border-radius: 18px;
}
.hk-empty i  { font-size: 2.4rem; display: block; margin-bottom: 0.8rem; color: #c8d4de; }
.hk-empty h6 { font-weight: 700; color: #334155; margin-bottom: 4px; }
.hk-empty p  { font-size: 0.82rem; color: #94a3b8; margin: 0; }
</style>

<div class="owner-shell">
    <jsp:include page="../common/sidebar-reception.jsp"/>
    <div class="owner-main">
        <jsp:include page="../common/reception-topbar.jsp"/>
        <div class="owner-content">

            <%-- Flash --%>
            <c:if test="${not empty param.success}">
                <div class="alert alert-dismissible fade show d-flex align-items-center gap-2 mb-3 rounded-3"
                     style="background:#f2f8f4; border:1px solid #bddece; color:#3d7a56;" role="alert">
                    <i class="fa-solid fa-circle-check"></i>
                    <span class="fw-semibold small">Cập nhật trạng thái phòng thành công!</span>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <%-- Page header --%>
            <div class="hk-page-header">
                <div>
                    <h4 class="fw-bold mb-1" style="font-size:1.1rem; color:#1e293b;">
                        <i class="fa-solid fa-broom me-2" style="color:#c4a050; font-size:1rem;"></i>Quản lý Buồng phòng & Dọn dẹp
                    </h4>
                    <p class="mb-0" style="font-size:0.8rem; color:#94a3b8;">
                        Cập nhật trạng thái vệ sinh và đánh dấu phòng sẵn sàng đón khách mới
                    </p>
                </div>
                <c:if test="${not empty homestayName}">
                    <div class="hk-property-tag">
                        <i class="fa-solid fa-hotel" style="color:#90a8bc;"></i>${homestayName}
                    </div>
                </c:if>
            </div>

            <%-- Warning --%>
            <c:if test="${empty assignedHomestayId}">
                <div class="d-flex gap-3 p-3 mb-3 rounded-3"
                     style="background:#faf6ec; border:1px solid #d8c085; font-size:0.84rem; color:#6b4e1a;">
                    <i class="fa-solid fa-triangle-exclamation mt-1 flex-shrink-0" style="color:#c4a050;"></i>
                    <span><strong>Chưa được phân công:</strong> Tài khoản lễ tân chưa được gán cho cơ sở nào.</span>
                </div>
            </c:if>

            <%-- Tabs — workflow order: Tổng quan → Cần dọn → Đang ở → Sẵn sàng → Bảo trì --%>
            <div class="hk-tabs">
                <a href="?status=ALL"
                   class="hk-tab tab-all ${statusFilter eq 'ALL' or empty statusFilter ? 'is-active' : ''}">
                    <i class="fa-solid fa-table-cells-large"></i>Tổng quan
                </a>
                <a href="?status=DIRTY"
                   class="hk-tab tab-dirty ${statusFilter eq 'DIRTY' ? 'is-active' : ''}">
                    <i class="fa-solid fa-broom"></i>Cần dọn dẹp
                </a>
                <a href="?status=OCCUPIED"
                   class="hk-tab tab-occup ${statusFilter eq 'OCCUPIED' ? 'is-active' : ''}">
                    <i class="fa-solid fa-user"></i>Đang có khách
                </a>
                <a href="?status=AVAILABLE"
                   class="hk-tab tab-avail ${statusFilter eq 'AVAILABLE' ? 'is-active' : ''}">
                    <i class="fa-solid fa-circle-check"></i>Sẵn sàng
                </a>
                <a href="?status=MAINTENANCE"
                   class="hk-tab tab-maint ${statusFilter eq 'MAINTENANCE' ? 'is-active' : ''}">
                    <i class="fa-solid fa-screwdriver-wrench"></i>Bảo trì
                </a>
            </div>

            <%-- Room grid --%>
            <c:choose>
                <c:when test="${not empty rooms}">
                    <div class="row g-3">
                        <c:forEach var="room" items="${rooms}">

                            <%-- Resolve per-card vars (same pattern as room-matrix) --%>
                            <c:choose>
                                <c:when test="${room.status eq 'AVAILABLE'}">
                                    <c:set var="cardClass"  value="status-available"/>
                                    <c:set var="pillClass"  value="pill-available"/>
                                    <c:set var="iconClass"  value="icon-available"/>
                                    <c:set var="pillIcon"   value="fa-circle-check"/>
                                    <c:set var="pillLabel"  value="Sẵn sàng"/>
                                    <c:set var="statusIcon" value="fa-door-open"/>
                                    <c:set var="guestClass" value="gst-available"/>
                                </c:when>
                                <c:when test="${room.status eq 'OCCUPIED'}">
                                    <c:set var="cardClass"  value="status-occupied"/>
                                    <c:set var="pillClass"  value="pill-occupied"/>
                                    <c:set var="iconClass"  value="icon-occupied"/>
                                    <c:set var="pillIcon"   value="fa-user"/>
                                    <c:set var="pillLabel"  value="Có khách"/>
                                    <c:set var="statusIcon" value="fa-bed"/>
                                    <c:set var="guestClass" value="gst-occupied"/>
                                </c:when>
                                <c:when test="${room.status eq 'DIRTY'}">
                                    <c:set var="cardClass"  value="status-dirty"/>
                                    <c:set var="pillClass"  value="pill-dirty"/>
                                    <c:set var="iconClass"  value="icon-dirty"/>
                                    <c:set var="pillIcon"   value="fa-broom"/>
                                    <c:set var="pillLabel"  value="Cần dọn"/>
                                    <c:set var="statusIcon" value="fa-broom"/>
                                    <c:set var="guestClass" value="gst-dirty"/>
                                </c:when>
                                <c:otherwise>
                                    <c:set var="cardClass"  value="status-maintenance"/>
                                    <c:set var="pillClass"  value="pill-maintenance"/>
                                    <c:set var="iconClass"  value="icon-maintenance"/>
                                    <c:set var="pillIcon"   value="fa-screwdriver-wrench"/>
                                    <c:set var="pillLabel"  value="Bảo trì"/>
                                    <c:set var="statusIcon" value="fa-screwdriver-wrench"/>
                                    <c:set var="guestClass" value="gst-maintenance"/>
                                </c:otherwise>
                            </c:choose>

                            <div class="col-6 col-md-4 col-xl-3 d-flex">
                                <div class="room-card ${cardClass} w-100">
                                    <div class="rm-card-body">

                                        <%-- Top row: identical to room-matrix --%>
                                        <div class="d-flex align-items-center justify-content-between gap-2">
                                            <div class="d-flex align-items-center gap-2" style="min-width:0;">
                                                <div class="rm-icon-circle ${iconClass}">
                                                    <i class="fa-solid ${statusIcon}"></i>
                                                </div>
                                                <div style="min-width:0;">
                                                    <div class="rm-number">P.${room.roomNumber}</div>
                                                    <div class="rm-type-name text-truncate" title="${room.roomTypeName}">${room.roomTypeName}</div>
                                                </div>
                                            </div>
                                            <span class="rm-pill ${pillClass}">
                                                <i class="fa-solid ${pillIcon}"></i>${pillLabel}
                                            </span>
                                        </div>

                                        <%-- Bottom info-box: action buttons replace guest info --%>
                                        <div class="rm-info-box">
                                            <c:choose>
                                                <c:when test="${room.status eq 'DIRTY'}">
                                                    <form action="${pageContext.request.contextPath}/reception/housekeeping"
                                                          method="POST" style="margin:0;">
                                                        <input type="hidden" name="roomId" value="${room.roomId}">
                                                        <input type="hidden" name="action" value="markReady">
                                                        <input type="hidden" name="status" value="${statusFilter}">
                                                        <button type="submit" class="btn-hk btn-done">
                                                            <i class="fa-solid fa-check"></i>Đã dọn xong
                                                        </button>
                                                    </form>
                                                </c:when>
                                                <c:when test="${room.status eq 'AVAILABLE'}">
                                                    <form action="${pageContext.request.contextPath}/reception/housekeeping"
                                                          method="POST" style="margin:0;">
                                                        <input type="hidden" name="roomId" value="${room.roomId}">
                                                        <input type="hidden" name="action" value="markDirty">
                                                        <input type="hidden" name="status" value="${statusFilter}">
                                                        <button type="submit" class="btn-hk btn-mark">
                                                            <i class="fa-solid fa-broom"></i>Đánh dấu cần dọn
                                                        </button>
                                                    </form>
                                                </c:when>
                                                <c:when test="${room.status eq 'OCCUPIED'}">
                                                    <div class="rm-guest ${guestClass}">
                                                        <i class="fa-regular fa-clock"></i>
                                                        <span>Chờ khách check-out</span>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="rm-guest ${guestClass}">
                                                        <i class="fa-solid fa-wrench"></i>
                                                        <span>Đang bảo trì</span>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                    </div>
                                </div>
                            </div>

                        </c:forEach>
                    </div>

                    <div class="mt-3" style="font-size:0.75rem; color:#94a3b8;">
                        Hiển thị <strong class="text-dark">${fn:length(rooms)}</strong> phòng
                        <c:if test="${statusFilter ne 'ALL' and not empty statusFilter}">
                            &mdash; lọc: <strong>${statusFilter}</strong>
                        </c:if>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="hk-empty">
                        <c:choose>
                            <c:when test="${statusFilter eq 'DIRTY'}">
                                <i class="fa-solid fa-check-double" style="color:#7ab896;"></i>
                                <h6>Tất cả phòng đã sạch sẽ!</h6>
                                <p>Không có phòng nào cần dọn dẹp lúc này.</p>
                            </c:when>
                            <c:when test="${statusFilter eq 'ALL' or empty statusFilter}">
                                <i class="fa-solid fa-door-open"></i>
                                <h6>Chưa có phòng nào</h6>
                                <p>Cơ sở này hiện chưa có danh sách phòng nào.</p>
                            </c:when>
                            <c:otherwise>
                                <i class="fa-solid fa-door-open"></i>
                                <h6>Không có phòng nào</h6>
                                <p>Không tìm thấy phòng với trạng thái <strong>${statusFilter}</strong>.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:otherwise>
            </c:choose>

        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>
