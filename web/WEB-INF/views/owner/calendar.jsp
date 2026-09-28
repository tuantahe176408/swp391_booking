<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:include page="../common/header.jsp"/>

<%-- Month name lookup (Vietnamese) --%>
<c:set var="monthNames" value="Tháng 1,Tháng 2,Tháng 3,Tháng 4,Tháng 5,Tháng 6,Tháng 7,Tháng 8,Tháng 9,Tháng 10,Tháng 11,Tháng 12"/>
<c:set var="monthNameArr" value="${fn:split(monthNames, ',')}"/>
<c:set var="currentMonthName" value="${monthNameArr[month-1]}"/>

<style>
/* ── Calendar Cell ──────────────────────────────────────────── */
.cal-cell {
    min-height: 80px;
    padding: .5rem .6rem;
    border: 1px solid #e2e8f0;
    border-radius: 8px;
    cursor: pointer;
    transition: box-shadow .15s ease, border-color .15s ease;
    position: relative;
    background: #fff;
}
.cal-cell:hover { border-color: #6366f1; box-shadow: 0 0 0 2px rgba(99,102,241,.12); }
.cal-cell.is-weekend     { background: #fffbeb; }
.cal-cell.is-locked      { background: #f8fafc; cursor: default; }
.cal-cell.is-locked:hover{ border-color: #e2e8f0; box-shadow: none; }
.cal-cell.is-today       { border-color: #6366f1; box-shadow: 0 0 0 2px rgba(99,102,241,.2); }
.cal-cell.is-past        { opacity: .55; cursor: default; }
.cal-cell.is-past:hover  { border-color: #e2e8f0; box-shadow: none; }
.cal-cell.is-empty       { background: #f8fafc; border-style: dashed; cursor: default; }

.cal-day-num {
    font-weight: 700;
    font-size: .9rem;
    color: #1e293b;
    display: block;
    line-height: 1;
    margin-bottom: .35rem;
}
.cal-cell.is-weekend .cal-day-num { color: #ef4444; }
.cal-cell.is-today   .cal-day-num { color: #6366f1; }

.cal-price {
    font-size: .76rem;
    font-weight: 600;
    color: #475569;
    display: block;
    white-space: nowrap;
}
.cal-price.is-modified { color: #6366f1; }
.cal-price.is-custom   { color: #f59e0b; }

.cal-badge {
    display: inline-block;
    font-size: .62rem;
    font-weight: 700;
    border-radius: 4px;
    padding: 1px 5px;
    line-height: 1.4;
    margin-top: 2px;
}
.cal-badge-pct    { background: #eef2ff; color: #6366f1; }
.cal-badge-lock   { background: #f1f5f9; color: #94a3b8; }
.cal-badge-custom { background: #fffbeb; color: #d97706; }

/* ── Calendar 7-column CSS Grid ────────────────────────────── */
.cal-grid-7 {
    display: grid !important;
    grid-template-columns: repeat(7, minmax(0, 1fr)) !important;
    gap: 4px;
    width: 100%;
}
.cal-dow-header {
    display: grid !important;
    grid-template-columns: repeat(7, minmax(0, 1fr)) !important;
    gap: 4px;
    margin-bottom: 4px;
    width: 100%;
}
.cal-dow-cell {
    text-align: center;
    font-size: .78rem;
    font-weight: 700;
    color: #94a3b8;
    padding: .25rem 0;
}
.cal-dow-cell.is-weekend { color: #ef4444; }
.rt-tab {
    padding: .45rem 1.1rem;
    border-radius: 50px;
    font-size: .82rem;
    font-weight: 600;
    cursor: pointer;
    border: 1.5px solid #e2e8f0;
    background: #fff;
    color: #475569;
    transition: all .18s ease;
    white-space: nowrap;
    box-shadow: 0 1px 3px rgba(0,0,0,.05);
    display: inline-flex;
    align-items: center;
    gap: .35rem;
    text-decoration: none !important;
}
.rt-tab:hover {
    border-color: #6366f1;
    color: #6366f1;
    background: #f5f3ff;
    box-shadow: 0 2px 8px rgba(99,102,241,.12);
}
.rt-tab.active {
    background: linear-gradient(135deg, #6366f1, #4f46e5);
    color: #fff !important;
    border-color: transparent;
    box-shadow: 0 4px 14px rgba(99,102,241,.35);
}

/* Homestay selector cards */
.hs-tab {
    padding: .5rem 1.1rem;
    border-radius: 50px;
    font-size: .83rem;
    font-weight: 600;
    cursor: pointer;
    border: 1.5px solid #e2e8f0;
    background: #fff;
    color: #475569;
    transition: all .18s ease;
    white-space: nowrap;
    box-shadow: 0 1px 3px rgba(0,0,0,.05);
    display: inline-flex;
    align-items: center;
    gap: .4rem;
    text-decoration: none !important;
}
.hs-tab:hover {
    border-color: #6366f1;
    color: #6366f1;
    background: #f5f3ff;
}
.hs-tab.active {
    background: linear-gradient(135deg, #1e1b4b, #4338ca);
    color: #fff !important;
    border-color: transparent;
    box-shadow: 0 4px 14px rgba(67,56,202,.3);
}

/* ── Bulk panel ─────────────────────────────────────────────── */
#bulkPanel {
    display: none;
    animation: slideDown .2s ease;
}
#bulkPanel.show { display: block; }
@keyframes slideDown {
    from { opacity:0; transform:translateY(-8px); }
    to   { opacity:1; transform:translateY(0); }
}

/* ── Day modal ──────────────────────────────────────────────── */
.cal-overlay {
    display: none;
    position: fixed; inset: 0;
    background: rgba(15,23,42,.45);
    z-index: 900;
    align-items: center;
    justify-content: center;
}
.cal-overlay.show { display: flex; }
.cal-modal {
    background: #fff;
    border-radius: 16px;
    padding: 1.75rem;
    width: 420px;
    max-width: 95vw;
    box-shadow: 0 20px 60px rgba(15,23,42,.2);
}
</style>

<div class="owner-shell">
    <jsp:include page="../common/sidebar-owner.jsp"/>

    <div class="owner-main">
        <jsp:include page="../common/owner-topbar.jsp"/>

        <div class="owner-content">

            <!-- Page Header -->
            <div class="owner-page-header">
                <div class="owner-page-header__info">
                    <h2><i class="fa-regular fa-calendar-days text-primary me-2"></i>Lịch bán phòng &amp; Giá linh hoạt</h2>
                    <p>Xem giá thực tế theo ngày, điều chỉnh giá và khóa phòng</p>
                </div>
                <c:if test="${not empty myHomestays and not empty roomTypes}">
                    <button class="btn btn-primary-custom btn-sm px-4" id="btnBulkToggle">
                        <i class="fa-solid fa-sliders me-1"></i>Áp dụng quy tắc giá
                    </button>
                </c:if>
            </div>

            <!-- Homestay selector -->
            <div class="d-flex gap-2 mb-4 flex-wrap align-items-center">
                <span class="fw-semibold text-muted" style="font-size:.78rem;letter-spacing:.04em;text-transform:uppercase;">
                    <i class="fa-solid fa-building-user me-1"></i>Cơ sở
                </span>
                <c:choose>
                    <c:when test="${not empty myHomestays}">
                        <c:forEach var="hs" items="${myHomestays}">
                            <a href="${pageContext.request.contextPath}/owner/calendar?homestayId=${hs.homestayId}&year=${year}&month=${month}"
                               class="hs-tab ${hs.homestayId == selectedHomestayId ? 'active' : ''}">
                                <i class="fa-solid fa-house-chimney" style="font-size:.75rem;opacity:.8;"></i>
                                ${hs.name}
                            </a>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <span class="text-muted" style="font-size:.83rem;">Chưa có cơ sở nào.</span>
                    </c:otherwise>
                </c:choose>
            </div>

            <%-- Bulk apply panel --%>
            <div id="bulkPanel" class="owner-card mb-4 border border-primary">
                <h6 class="fw-bold mb-3"><i class="fa-solid fa-wand-magic-sparkles text-primary me-2"></i>Áp dụng quy tắc giá hàng loạt</h6>
                <form method="post" action="${pageContext.request.contextPath}/owner/calendar">
                    <input type="hidden" name="action"       value="bulk">
                    <input type="hidden" name="year"         value="${year}">
                    <input type="hidden" name="month"        value="${month}">
                    <input type="hidden" name="homestayId"   value="${selectedHomestayId}">

                    <div class="row g-3">
                        <!-- Room type checkboxes -->
                        <div class="col-12">
                            <label class="form-label fw-semibold" style="font-size:.82rem;">Áp dụng cho loại phòng</label>
                            <div class="d-flex flex-wrap gap-2">
                                <c:forEach var="rt" items="${roomTypes}">
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox"
                                               name="roomTypeIds" value="${rt.roomTypeId}"
                                               id="ckrt${rt.roomTypeId}" checked>
                                        <label class="form-check-label" for="ckrt${rt.roomTypeId}" style="font-size:.82rem;">
                                            ${rt.name}
                                        </label>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>

                        <!-- Day-of-week quick select -->
                        <div class="col-12">
                            <label class="form-label fw-semibold" style="font-size:.82rem;">Chọn nhanh ngày trong tháng</label>
                            <div class="d-flex flex-wrap gap-2 mb-2">
                                <button type="button" class="btn btn-sm btn-outline-secondary rounded-3" onclick="selectDow(6,7)">Chọn T7 &amp; CN</button>
                                <button type="button" class="btn btn-sm btn-outline-secondary rounded-3" onclick="selectDow(1,2,3,4,5)">Chọn T2–T6</button>
                                <button type="button" class="btn btn-sm btn-outline-secondary rounded-3" onclick="selectAll()">Tất cả</button>
                                <button type="button" class="btn btn-sm btn-outline-danger rounded-3"    onclick="clearDates()">Xóa chọn</button>
                            </div>
                            <%-- Hidden date checkboxes built by JS --%>
                            <div id="dateCheckboxes" class="d-flex flex-wrap gap-1"></div>
                        </div>

                        <div class="col-sm-4">
                            <label class="form-label fw-semibold" style="font-size:.82rem;">Hệ số giá (multiplier)</label>
                            <div class="input-group input-group-sm">
                                <input type="number" name="priceMultiplier" id="bulkMult"
                                       class="form-control" step="0.05" min="0.5" max="5.0"
                                       placeholder="vd: 1.25">
                                <span class="input-group-text">×</span>
                            </div>
                            <div class="form-text">Để trống nếu dùng giá tuyệt đối</div>
                        </div>

                        <div class="col-sm-4">
                            <label class="form-label fw-semibold" style="font-size:.82rem;">Giá cố định (VNĐ)</label>
                            <input type="number" name="customPrice" id="bulkCustom"
                                   class="form-control form-control-sm" min="0" step="50000"
                                   placeholder="vd: 1500000">
                            <div class="form-text">Ghi đè hệ số nếu nhập</div>
                        </div>

                        <div class="col-sm-4">
                            <label class="form-label fw-semibold" style="font-size:.82rem;">Khóa phòng</label>
                            <div class="form-check mt-1">
                                <input class="form-check-input" type="checkbox"
                                       name="isLocked" value="true" id="bulkLock">
                                <label class="form-check-label" for="bulkLock" style="font-size:.82rem;">
                                    Đóng bán những ngày đã chọn
                                </label>
                            </div>
                        </div>

                        <div class="col-12 d-flex gap-2">
                            <button type="submit" class="btn btn-primary-custom btn-sm px-4">
                                <i class="fa-solid fa-check me-1"></i>Áp dụng
                            </button>
                            <button type="button" class="btn btn-outline-secondary btn-sm"
                                    onclick="document.getElementById('bulkPanel').classList.remove('show')">
                                Hủy
                            </button>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Room type tab selector -->
            <c:if test="${not empty roomTypes}">
                <div class="d-flex gap-2 mb-3 flex-wrap align-items-center">
                    <span class="fw-semibold text-muted" style="font-size:.78rem;letter-spacing:.04em;text-transform:uppercase;">
                        <i class="fa-solid fa-bed me-1"></i>Loại phòng
                    </span>
                    <div style="width:1px;height:18px;background:#e2e8f0;flex-shrink:0;"></div>
                    <c:forEach var="rt" items="${roomTypes}" varStatus="rtSt">
                        <button class="rt-tab ${rtSt.first ? 'active' : ''}"
                                onclick="switchRoomType(${rt.roomTypeId}, this)"
                                data-rtid="${rt.roomTypeId}">
                            ${rt.name}
                            <span style="font-size:.72rem;font-weight:500;opacity:.75;background:rgba(0,0,0,.07);border-radius:50px;padding:1px 7px;margin-left:2px;">
                                <fmt:formatNumber value="${rt.basePrice}" type="number" groupingUsed="true"/>đ
                            </span>
                        </button>
                    </c:forEach>
                </div>
            </c:if>

            <!-- Calendar card -->
            <div class="owner-card p-0 overflow-hidden">
                <!-- Month navigation -->
                <div class="d-flex align-items-center justify-content-between px-4 py-3 border-bottom">
                    <a href="${pageContext.request.contextPath}/owner/calendar?year=${prevYear}&month=${prevMonth}&homestayId=${selectedHomestayId}"
                       class="btn btn-sm btn-outline-secondary rounded-3">
                        <i class="fa-solid fa-chevron-left"></i>
                    </a>
                    <div class="text-center">
                        <h6 class="fw-bold mb-0">${currentMonthName} / ${year}</h6>
                        <small class="text-muted" style="font-size:.75rem;">
                            <c:choose>
                                <c:when test="${not empty roomTypes}">
                                    Hiển thị: <span id="activeRtName">${roomTypes[0].name}</span>
                                </c:when>
                                <c:otherwise>Chưa có loại phòng</c:otherwise>
                            </c:choose>
                        </small>
                    </div>
                    <a href="${pageContext.request.contextPath}/owner/calendar?year=${nextYear}&month=${nextMonth}&homestayId=${selectedHomestayId}"
                       class="btn btn-sm btn-outline-secondary rounded-3">
                        <i class="fa-solid fa-chevron-right"></i>
                    </a>
                </div>

                <c:choose>
                    <c:when test="${empty myHomestays}">
                        <div class="text-center py-5 text-muted">
                            <i class="fa-regular fa-calendar-xmark fa-2x mb-2 d-block opacity-25"></i>
                            Bạn chưa có cơ sở homestay nào ở trạng thái đang hoạt động.
                        </div>
                    </c:when>
                    <c:when test="${empty roomTypes}">
                        <div class="text-center py-5 text-muted">
                            <i class="fa-regular fa-calendar-xmark fa-2x mb-2 d-block opacity-25"></i>
                            Cơ sở này chưa có loại phòng nào.
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div style="padding:1rem;">
                            <!-- Day-of-week header -->
                            <div style="display:grid;grid-template-columns:repeat(7,minmax(0,1fr));gap:4px;margin-bottom:6px;text-align:center;">
                                <div style="font-size:.78rem;font-weight:700;color:#94a3b8;padding:.25rem 0;">T2</div>
                                <div style="font-size:.78rem;font-weight:700;color:#94a3b8;padding:.25rem 0;">T3</div>
                                <div style="font-size:.78rem;font-weight:700;color:#94a3b8;padding:.25rem 0;">T4</div>
                                <div style="font-size:.78rem;font-weight:700;color:#94a3b8;padding:.25rem 0;">T5</div>
                                <div style="font-size:.78rem;font-weight:700;color:#94a3b8;padding:.25rem 0;">T6</div>
                                <div style="font-size:.78rem;font-weight:700;color:#ef4444;padding:.25rem 0;">T7</div>
                                <div style="font-size:.78rem;font-weight:700;color:#ef4444;padding:.25rem 0;">CN</div>
                            </div>

                            <%-- Calendar grid — one div per room type --%>
                            <c:forEach var="rt" items="${roomTypes}" varStatus="rtLoop">
                                <div class="cal-grid-rt"
                                     id="calGrid_${rt.roomTypeId}"
                                     data-rtid="${rt.roomTypeId}"
                                     style="display:${rtLoop.first ? 'grid' : 'none'};grid-template-columns:repeat(7,minmax(0,1fr));gap:4px;">

                                    <%-- Leading empty cells: firstDow-1 blanks before day 1 --%>
                                    <c:forEach begin="1" end="${firstDow - 1}">
                                        <div style="min-height:76px;border:1px dashed #e2e8f0;border-radius:8px;background:#f8fafc;"></div>
                                    </c:forEach>

                                        <%-- Day cells --%>
                                        <c:set var="todayYear"  value="${pageContext.request.getAttribute('today') != null ? pageContext.request.getAttribute('today') : ''}"/>
                                        <c:forEach begin="1" end="${daysInMonth}" var="day">
                                            <%-- Compute day-of-week: (firstDow-1 + day-1) % 7 + 1 --%>
                                            <c:set var="cellDow" value="${((firstDow - 1 + day - 1) mod 7) + 1}"/>
                                            <c:set var="isWeekend" value="${cellDow == 6 || cellDow == 7}"/>

                                            <%-- Date string for key lookup --%>
                                            <c:set var="dayPad"   value="${day < 10 ? '0' : ''}${day}"/>
                                            <c:set var="monPad"   value="${month < 10 ? '0' : ''}${month}"/>
                                            <c:set var="dateKey"  value="${rt.roomTypeId}_${year}-${monPad}-${dayPad}"/>
                                            <c:set var="dp"       value="${priceMap[dateKey]}"/>

                                            <c:set var="isLocked"   value="${dp != null && dp.locked}"/>
                                            <%-- isModified: only true when there's a real price change (mult≠1 or customPrice set) --%>
                                            <c:set var="isRealRule" value="${dp != null && dp.realPriceRule}"/>
                                            <c:set var="isModified" value="${isRealRule && !isLocked}"/>
                                            <c:set var="isCustom"   value="${dp != null && dp.customPrice != null}"/>

                                            <%-- Effective price --%>
                                            <c:choose>
                                                <c:when test="${isLocked}">
                                                    <c:set var="displayPrice" value="—"/>
                                                </c:when>
                                                <c:when test="${dp != null && dp.effectivePrice != null}">
                                                    <c:set var="priceVal" value="${dp.effectivePrice}"/>
                                                    <c:choose>
                                                        <c:when test="${priceVal >= 1000000}">
                                                            <fmt:formatNumber var="pf" value="${priceVal / 1000000}" type="number" maxFractionDigits="2"/>
                                                            <c:set var="displayPrice" value="${pf}M"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <fmt:formatNumber var="pf" value="${priceVal / 1000}" type="number" maxFractionDigits="0"/>
                                                            <c:set var="displayPrice" value="${pf}k"/>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:when>
                                                <c:otherwise>
                                                    <%-- No rule: show base price --%>
                                                    <c:set var="bp" value="${rt.basePrice}"/>
                                                    <c:choose>
                                                        <c:when test="${bp >= 1000000}">
                                                            <fmt:formatNumber var="pf" value="${bp / 1000000}" type="number" maxFractionDigits="2"/>
                                                            <c:set var="displayPrice" value="${pf}M"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <fmt:formatNumber var="pf" value="${bp / 1000}" type="number" maxFractionDigits="0"/>
                                                            <c:set var="displayPrice" value="${pf}k"/>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:otherwise>
                                            </c:choose>

                                            <%-- Badge text --%>
                                            <c:set var="badgeText" value=""/>
                                            <c:if test="${isLocked}">
                                                <c:set var="badgeText" value="Khóa phòng"/>
                                            </c:if>
                                            <c:if test="${!isLocked && dp != null && dp.realPriceRule && dp.customPrice == null}">
                                                <fmt:formatNumber var="pct" value="${(dp.priceMultiplier - 1) * 100}" type="number" maxFractionDigits="0"/>
                                                <c:if test="${pct > 0}"><c:set var="badgeText" value="+${pct}%"/></c:if>
                                                <c:if test="${pct < 0}"><c:set var="badgeText" value="${pct}%"/></c:if>
                                            </c:if>
                                            <c:if test="${isCustom && !isLocked}">
                                                <c:set var="badgeText" value="Giá cố định"/>
                                            </c:if>

                                            <%-- Cell background color --%>
                                            <c:choose>
                                                <c:when test="${isLocked}">  <c:set var="cellBg" value="#f8fafc"/></c:when>
                                                <c:when test="${isCustom}">  <c:set var="cellBg" value="#fffbeb"/></c:when>
                                                <c:when test="${isModified}"><c:set var="cellBg" value="#eef2ff"/></c:when>
                                                <c:when test="${isWeekend}"> <c:set var="cellBg" value="#fffbeb"/></c:when>
                                                <c:otherwise>               <c:set var="cellBg" value="#ffffff"/></c:otherwise>
                                            </c:choose>
                                            <c:set var="cellBorder" value="${isModified && !isLocked ? '1px solid #6366f1' : '1px solid #e2e8f0'}"/>
                                            <c:set var="cellCursor" value="${isLocked ? 'default' : 'pointer'}"/>

                                            <div style="min-height:76px;padding:.5rem .6rem;border:${cellBorder};border-radius:8px;background:${cellBg};cursor:${cellCursor};box-sizing:border-box;overflow:hidden;"
                                                 <c:if test="${!isLocked}">
                                                     onclick="openDayModal('${year}-${monPad}-${dayPad}', ${rt.roomTypeId}, '${rt.name}', ${rt.basePrice},
                                                         ${dp != null && dp.priceMultiplier != null ? dp.priceMultiplier : 'null'},
                                                         ${dp != null && dp.customPrice     != null ? dp.customPrice     : 'null'},
                                                         ${dp != null && dp.locked ? 'true' : 'false'})"
                                                 </c:if>
                                                 title="${year}-${monPad}-${dayPad}">
                                                <span style="display:block;font-weight:700;font-size:.88rem;color:${isWeekend ? '#ef4444' : isModified && !isLocked ? '#6366f1' : '#1e293b'};line-height:1;margin-bottom:.3rem;">${day}</span>
                                                <span style="display:block;font-size:.74rem;font-weight:600;color:${isCustom && !isLocked ? '#d97706' : isModified && !isLocked ? '#6366f1' : '#64748b'};">
                                                    ${displayPrice}
                                                </span>
                                                <c:if test="${not empty badgeText}">
                                                    <span style="display:inline-block;font-size:.62rem;font-weight:700;border-radius:4px;padding:1px 5px;margin-top:2px;background:${isLocked ? '#f1f5f9' : isCustom ? '#fef3c7' : '#eef2ff'};color:${isLocked ? '#94a3b8' : isCustom ? '#d97706' : '#6366f1'};">
                                                        ${badgeText}
                                                    </span>
                                                </c:if>
                                            </div>
                                        </c:forEach>

                                        <%-- Trailing empty cells to complete last row --%>
                                        <c:set var="totalCells" value="${firstDow - 1 + daysInMonth}"/>
                                        <c:set var="remainder"  value="${totalCells mod 7}"/>
                                        <c:if test="${remainder != 0}">
                                            <c:forEach begin="1" end="${7 - remainder}">
                                                <div style="min-height:76px;border:1px dashed #e2e8f0;border-radius:8px;background:#f8fafc;"></div>
                                            </c:forEach>
                                        </c:if>

                                </div><%-- /cal-grid-7 cal-grid-rt --%>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>

                <!-- Legend -->
                <div class="d-flex align-items-center gap-4 px-4 py-3 border-top flex-wrap">
                    <span class="d-flex align-items-center gap-2" style="font-size:.8rem;">
                        <span style="width:14px;height:14px;border-radius:3px;background:#fffbeb;border:1px solid #fcd34d;flex-shrink:0;"></span>Giá cuối tuần
                    </span>
                    <span class="d-flex align-items-center gap-2" style="font-size:.8rem;">
                        <span style="width:14px;height:14px;border-radius:3px;background:#eef2ff;border:1px solid #6366f1;flex-shrink:0;"></span>Giá điều chỉnh (+%)
                    </span>
                    <span class="d-flex align-items-center gap-2" style="font-size:.8rem;">
                        <span style="width:14px;height:14px;border-radius:3px;background:#fffbeb;border:1px solid #f59e0b;flex-shrink:0;"></span>Giá cố định
                    </span>
                    <span class="d-flex align-items-center gap-2" style="font-size:.8rem;">
                        <span style="width:14px;height:14px;border-radius:3px;background:#f1f5f9;border:1px solid #cbd5e1;flex-shrink:0;"></span>Khóa phòng
                    </span>
                    <span class="d-flex align-items-center gap-2" style="font-size:.8rem;">
                        <span style="width:14px;height:14px;border-radius:3px;background:#fff;border:1px solid #e2e8f0;flex-shrink:0;"></span>Giá gốc
                    </span>
                </div>
            </div>

        </div><%-- /.owner-content --%>
    </div><%-- /.owner-main --%>
</div><%-- /.owner-shell --%>

<!-- ── Day Edit Modal ─────────────────────────────────────── -->
<div class="cal-overlay" id="dayModal" onclick="if(event.target===this)closeDayModal()">
    <div class="cal-modal">
        <div class="d-flex align-items-center justify-content-between mb-3">
            <h6 class="fw-bold mb-0" id="modalTitle">Điều chỉnh giá ngày</h6>
            <button type="button" class="btn-close" onclick="closeDayModal()"></button>
        </div>

        <div class="mb-3 p-3 rounded-3" style="background:#f8fafc;font-size:.85rem;">
            <div class="d-flex justify-content-between mb-1">
                <span class="text-muted">Loại phòng:</span>
                <span class="fw-semibold" id="modalRtName">—</span>
            </div>
            <div class="d-flex justify-content-between mb-1">
                <span class="text-muted">Ngày:</span>
                <span class="fw-semibold" id="modalDate">—</span>
            </div>
            <div class="d-flex justify-content-between">
                <span class="text-muted">Giá gốc:</span>
                <span class="fw-semibold" id="modalBasePrice">—</span>
            </div>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/owner/calendar" id="modalForm">
            <input type="hidden" name="year"         value="${year}">
            <input type="hidden" name="month"        value="${month}">
            <input type="hidden" name="homestayId"   value="${selectedHomestayId}">
            <input type="hidden" name="roomTypeId"   id="modalRtId">
            <input type="hidden" name="date"         id="modalDateInput">

            <div class="mb-3">
                <label class="form-label fw-semibold" style="font-size:.82rem;">Loại điều chỉnh</label>
                <div class="d-flex gap-3">
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="adjustType"
                               id="adjMult" value="mult" checked onchange="toggleAdjType()">
                        <label class="form-check-label" for="adjMult" style="font-size:.82rem;">Hệ số %</label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="adjustType"
                               id="adjCustom" value="custom" onchange="toggleAdjType()">
                        <label class="form-check-label" for="adjCustom" style="font-size:.82rem;">Giá cố định</label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="adjustType"
                               id="adjLock" value="lock" onchange="toggleAdjType()">
                        <label class="form-check-label text-danger" for="adjLock" style="font-size:.82rem;">Khóa phòng</label>
                    </div>
                </div>
            </div>

            <div id="adjMultGroup" class="mb-3">
                <label class="form-label fw-semibold" style="font-size:.82rem;">Hệ số (vd: 1.25 = +25%)</label>
                <div class="input-group input-group-sm">
                    <input type="number" name="priceMultiplier" id="modalMult"
                           class="form-control" step="0.05" min="0.5" max="5.0" placeholder="1.25">
                    <span class="input-group-text">×</span>
                </div>
            </div>

            <div id="adjCustomGroup" class="mb-3" style="display:none;">
                <label class="form-label fw-semibold" style="font-size:.82rem;">Giá cố định (VNĐ)</label>
                <input type="number" name="customPrice" id="modalCustom"
                       class="form-control form-control-sm" min="0" step="50000">
            </div>

            <div id="adjLockGroup" class="mb-3 alert alert-warning py-2" style="display:none;font-size:.82rem;">
                <i class="fa-solid fa-triangle-exclamation me-1"></i>
                Phòng sẽ bị <strong>khóa toàn bộ</strong> vào ngày này — không thể nhận đặt phòng mới.
                <input type="hidden" name="isLocked" id="modalLockInput" value="false">
            </div>

            <div class="d-flex gap-2 justify-content-between">
                <button type="button" class="btn btn-outline-danger btn-sm rounded-3"
                        id="btnDeleteRule" onclick="deleteRule()">
                    <i class="fa-solid fa-rotate-left me-1"></i>Xóa quy tắc (về mặc định)
                </button>
                <div class="d-flex gap-2">
                    <button type="button" class="btn btn-outline-secondary btn-sm rounded-3"
                            onclick="closeDayModal()">Hủy</button>
                    <button type="submit" name="action" value="single"
                            class="btn btn-primary-custom btn-sm rounded-3">
                        <i class="fa-solid fa-check me-1"></i>Lưu
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>

<!-- Delete rule form (hidden) -->
<form method="post" action="${pageContext.request.contextPath}/owner/calendar" id="deleteForm">
    <input type="hidden" name="action"      value="delete">
    <input type="hidden" name="year"        value="${year}">
    <input type="hidden" name="month"       value="${month}">
    <input type="hidden" name="homestayId"  value="${selectedHomestayId}">
    <input type="hidden" name="roomTypeId"  id="delRtId">
    <input type="hidden" name="date"        id="delDate">
</form>

<script>
// ── Room type tab switching ───────────────────────────────────────────────────
function switchRoomType(rtId, btn) {
    document.querySelectorAll('.cal-grid-rt').forEach(function(g){
        g.style.display = 'none';
    });
    var el = document.getElementById('calGrid_'+rtId);
    if (el) {
        el.style.display = 'grid';
        el.style.gridTemplateColumns = 'repeat(7,minmax(0,1fr))';
        el.style.gap = '4px';
        el.style.width = '100%';
    }

    document.querySelectorAll('.rt-tab:not(.hs-tab)').forEach(function(t){ t.classList.remove('active'); });
    btn.classList.add('active');

    var nameEl = document.getElementById('activeRtName');
    if (nameEl) nameEl.textContent = btn.textContent.trim().split('\n')[0].trim();
}

// ── Bulk panel toggle ─────────────────────────────────────────────────────────
document.getElementById('btnBulkToggle').addEventListener('click', function() {
    document.getElementById('bulkPanel').classList.toggle('show');
    buildDateCheckboxes();
});

// ── Build date checkboxes for bulk panel ──────────────────────────────────────
var DAYS_IN_MONTH = ${daysInMonth};
var FIRST_DOW     = ${firstDow};   // 1=Mon
var CAL_YEAR      = ${year};
var CAL_MONTH     = ${month};

function buildDateCheckboxes() {
    var container = document.getElementById('dateCheckboxes');
    if (container.childElementCount > 0) return; // already built

    for (var d = 1; d <= DAYS_IN_MONTH; d++) {
        var dow = ((FIRST_DOW - 1 + d - 1) % 7) + 1; // 1=Mon
        var ds  = CAL_YEAR + '-' + pad2(CAL_MONTH) + '-' + pad2(d);

        var label = document.createElement('label');
        label.className = 'badge fw-normal ' + (dow >= 6 ? 'bg-warning-subtle text-warning border border-warning' : 'bg-light text-dark border');
        label.style.cursor = 'pointer';
        label.title = ds;

        var cb = document.createElement('input');
        cb.type  = 'checkbox';
        cb.name  = 'dates';
        cb.value = ds;
        cb.style.display = 'none';
        cb.dataset.dow   = dow;

        label.appendChild(cb);
        label.appendChild(document.createTextNode(' ' + d));
        label.addEventListener('click', function(){ setTimeout(syncLabel, 0); });
        container.appendChild(label);
    }
}

function syncLabel() {
    document.querySelectorAll('#dateCheckboxes label').forEach(function(lb){
        var cb = lb.querySelector('input');
        var dow = parseInt(cb.dataset.dow);
        lb.className = cb.checked
            ? 'badge fw-semibold bg-primary text-white border border-primary'
            : ('badge fw-normal ' + (dow >= 6 ? 'bg-warning-subtle text-warning border border-warning' : 'bg-light text-dark border'));
    });
}

function selectDow() {
    buildDateCheckboxes();
    var dows = Array.from(arguments).map(Number);
    document.querySelectorAll('#dateCheckboxes input').forEach(function(cb){
        cb.checked = dows.indexOf(parseInt(cb.dataset.dow)) !== -1;
    });
    syncLabel();
}
function selectAll() {
    buildDateCheckboxes();
    document.querySelectorAll('#dateCheckboxes input').forEach(function(cb){ cb.checked = true; });
    syncLabel();
}
function clearDates() {
    document.querySelectorAll('#dateCheckboxes input').forEach(function(cb){ cb.checked = false; });
    syncLabel();
}

function pad2(n) { return n < 10 ? '0'+n : ''+n; }

// ── Day modal ─────────────────────────────────────────────────────────────────
var _currentRtId, _currentDate;

function openDayModal(date, rtId, rtName, basePrice, mult, customPrice, locked) {
    _currentRtId  = rtId;
    _currentDate  = date;

    document.getElementById('modalTitle').textContent    = 'Điều chỉnh giá: ' + date;
    document.getElementById('modalRtName').textContent   = rtName;
    document.getElementById('modalDate').textContent     = date;
    document.getElementById('modalBasePrice').textContent = formatVnd(basePrice);
    document.getElementById('modalRtId').value           = rtId;
    document.getElementById('modalDateInput').value      = date;

    // Reset form state — always clear first to avoid stale values from previous click
    document.getElementById('modalMult').value      = '';
    document.getElementById('modalCustom').value    = '';
    document.getElementById('modalLockInput').value = 'false';
    document.getElementById('adjMult').checked      = true;

    if (locked) {
        document.getElementById('adjLock').checked = true;
    } else if (customPrice !== null && customPrice !== 'null') {
        document.getElementById('adjCustom').checked = true;
        document.getElementById('modalCustom').value  = customPrice;
    } else if (mult !== null && mult !== 'null' && parseFloat(mult) !== 1.0) {
        // Only pre-fill multiplier if it's a real rule (not the default 1.0)
        document.getElementById('adjMult').checked = true;
        document.getElementById('modalMult').value  = mult;
    } else {
        // No rule or default 1.0 → show 1 as starting point for editing
        document.getElementById('adjMult').checked = true;
        document.getElementById('modalMult').value  = '1';
    }
    toggleAdjType();

    // Show delete button only when a real rule exists (mult != 1, or customPrice set, or locked)
    var hasRealRule = locked
        || (customPrice !== null && customPrice !== 'null')
        || (mult !== null && mult !== 'null' && parseFloat(mult) !== 1.0);
    document.getElementById('btnDeleteRule').style.display = hasRealRule ? '' : 'none';

    document.getElementById('dayModal').classList.add('show');
}

function closeDayModal() {
    document.getElementById('dayModal').classList.remove('show');
}

function toggleAdjType() {
    var v = document.querySelector('input[name="adjustType"]:checked').value;
    document.getElementById('adjMultGroup').style.display   = v === 'mult'   ? '' : 'none';
    document.getElementById('adjCustomGroup').style.display = v === 'custom' ? '' : 'none';
    document.getElementById('adjLockGroup').style.display   = v === 'lock'   ? '' : 'none';
    document.getElementById('modalLockInput').value         = v === 'lock' ? 'true' : 'false';
    // Clear irrelevant fields
    if (v !== 'mult')   { document.getElementById('modalMult').value   = ''; }
    if (v !== 'custom') { document.getElementById('modalCustom').value = ''; }
}

function deleteRule() {
    if (!confirm('Xóa quy tắc giá ngày ' + _currentDate + '? Phòng sẽ về giá gốc.')) return;
    document.getElementById('delRtId').value = _currentRtId;
    document.getElementById('delDate').value  = _currentDate;
    document.getElementById('deleteForm').submit();
}

function formatVnd(val) {
    if (!val) return '—';
    return Number(val).toLocaleString('vi-VN') + ' ₫';
}

// Close modal on Escape
document.addEventListener('keydown', function(e){
    if (e.key === 'Escape') closeDayModal();
});
</script>

<jsp:include page="../common/footer.jsp"/>
