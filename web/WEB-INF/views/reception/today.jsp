<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle"      value="Hôm nay"                          scope="request"/>
<c:set var="pageBreadcrumb" value="Đón tiếp &amp; Quản lý Phòng"     scope="request"/>
<jsp:include page="../common/header.jsp"/>

<div class="owner-shell">
    <jsp:include page="../common/sidebar-reception.jsp"/>
    <div class="owner-main">
        <jsp:include page="../common/reception-topbar.jsp"/>
        <div class="owner-content">

            <%-- Flash messages --%>
            <c:if test="${not empty flashSuccess}">
                <div class="alert alert-success alert-dismissible fade show rounded-3 mb-3 d-flex align-items-center gap-2">
                    <i class="fa-solid fa-circle-check flex-shrink-0"></i>
                    <span>${flashSuccess}</span>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty flashError}">
                <div class="alert alert-danger alert-dismissible fade show rounded-3 mb-3 d-flex align-items-center gap-2">
                    <i class="fa-solid fa-triangle-exclamation flex-shrink-0"></i>
                    <span>${flashError}</span>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <%-- Page header --%>
            <div class="owner-page-header">
                <div class="owner-page-header__info">
                    <h2>
                        <i class="fa-solid fa-calendar-day text-primary me-2"></i>Lịch hôm nay
                        <span class="badge bg-primary-subtle text-primary border border-primary ms-2 fw-normal" style="font-size:.65rem;vertical-align:middle;">
                            <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd/MM/yyyy"/>
                        </span>
                    </h2>
                    <p>Check-in / Check-out hôm nay và danh sách khách đang lưu trú tại
                        <strong>${not empty homestayName ? homestayName : 'Cơ sở của bạn'}</strong>
                    </p>
                </div>
                <a href="${pageContext.request.contextPath}/reception/checkin"
                   class="btn btn-outline-primary btn-sm rounded-3">
                    <i class="fa-solid fa-passport me-1"></i>Check-in đầy đủ &amp; OCR
                </a>
            </div>

            <%-- Chưa được gán homestay --%>
            <c:if test="${empty homestayId}">
                <div class="alert alert-warning rounded-3">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i>
                    <strong>Chưa được phân công:</strong> Tài khoản của bạn chưa được gán cho cơ sở nào.
                    Liên hệ Owner để được phân công.
                </div>
            </c:if>

            <c:if test="${not empty homestayId}">

            <%-- ══════════════════════════════════════════════════════════
                 SECTION 1: Arrivals & Departures
                 ══════════════════════════════════════════════════════════ --%>
            <div class="row g-3 mb-4">

                <%-- Arrivals --%>
                <div class="col-lg-6">
                    <div class="owner-card p-0 overflow-hidden h-100">
                        <div class="d-flex align-items-center gap-2 px-4 py-3 border-bottom"
                             style="background:linear-gradient(135deg,#f0fdf4,#dcfce7);">
                            <div style="width:36px;height:36px;border-radius:10px;background:#22c55e;display:flex;align-items:center;justify-content:center;color:#fff;font-size:.9rem;flex-shrink:0;">
                                <i class="fa-solid fa-plane-arrival"></i>
                            </div>
                            <div>
                                <div class="fw-bold text-success" style="font-size:.92rem;">Khách nhận phòng hôm nay</div>
                                <div class="text-muted" style="font-size:.74rem;">Check-in date = Hôm nay · Trạng thái CONFIRMED</div>
                            </div>
                            <span class="badge bg-success ms-auto px-2 py-1" style="font-size:.8rem;">${fn:length(arrivals)}</span>
                        </div>

                        <c:choose>
                            <c:when test="${empty arrivals}">
                                <div class="text-center py-5 text-muted">
                                    <i class="fa-solid fa-check-circle fa-2x mb-2 d-block text-success opacity-50"></i>
                                    <div style="font-size:.85rem;">Không có khách nhận phòng hôm nay</div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th class="ps-4" style="font-size:.74rem;">Khách</th>
                                                <th style="font-size:.74rem;">Mã đặt</th>
                                                <th style="font-size:.74rem;">Phòng</th>
                                                <th class="pe-3 text-center" style="font-size:.74rem;">Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="b" items="${arrivals}">
                                                <tr>
                                                    <td class="ps-4">
                                                        <div class="d-flex align-items-center gap-2">
                                                            <div style="width:32px;height:32px;border-radius:50%;background:linear-gradient(135deg,#22c55e,#16a34a);display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:.8rem;flex-shrink:0;">
                                                                ${fn:substring(b.guestName,0,1).toUpperCase()}
                                                            </div>
                                                            <div>
                                                                <div class="fw-semibold" style="font-size:.84rem;">${b.guestName}</div>
                                                                <div class="text-muted" style="font-size:.73rem;">${b.guestPhone}</div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <span class="fw-semibold text-primary" style="font-size:.78rem;font-family:monospace;">${b.bookingCode}</span>
                                                        <div class="text-muted" style="font-size:.72rem;">${b.roomTypeName}</div>
                                                    </td>
                                                    <td style="font-size:.8rem;">
                                                        <fmt:formatNumber value="${b.totalNights}"/> đêm
                                                        <div class="text-muted" style="font-size:.72rem;">→ <fmt:formatDate value="${b.checkoutDate}" pattern="dd/MM"/></div>
                                                    </td>
                                                    <td class="pe-3 text-center">
                                                        <a href="${pageContext.request.contextPath}/reception/checkin?q=${b.bookingCode}"
                                                           class="btn btn-sm btn-success rounded-3 px-2 py-1"
                                                           title="Mở màn check-in đầy đủ cho đơn này"
                                                           style="font-size:.75rem;">
                                                            <i class="fa-solid fa-passport me-1"></i>Check-in
                                                        </a>
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

                <%-- Departures --%>
                <div class="col-lg-6">
                    <div class="owner-card p-0 overflow-hidden h-100">
                        <div class="d-flex align-items-center gap-2 px-4 py-3 border-bottom"
                             style="background:linear-gradient(135deg,#fff7ed,#fed7aa);">
                            <div style="width:36px;height:36px;border-radius:10px;background:#f97316;display:flex;align-items:center;justify-content:center;color:#fff;font-size:.9rem;flex-shrink:0;">
                                <i class="fa-solid fa-plane-departure"></i>
                            </div>
                            <div>
                                <div class="fw-bold text-warning" style="font-size:.92rem;color:#c2410c!important;">Khách trả phòng hôm nay</div>
                                <div class="text-muted" style="font-size:.74rem;">Checkout date = Hôm nay · Trạng thái CHECKED_IN</div>
                            </div>
                            <span class="badge ms-auto px-2 py-1" style="font-size:.8rem;background:#f97316;">${fn:length(departures)}</span>
                        </div>

                        <c:choose>
                            <c:when test="${empty departures}">
                                <div class="text-center py-5 text-muted">
                                    <i class="fa-solid fa-door-open fa-2x mb-2 d-block opacity-25"></i>
                                    <div style="font-size:.85rem;">Không có khách trả phòng hôm nay</div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th class="ps-4" style="font-size:.74rem;">Khách</th>
                                                <th style="font-size:.74rem;">Mã đặt</th>
                                                <th style="font-size:.74rem;">Tổng tiền</th>
                                                <th class="pe-3 text-center" style="font-size:.74rem;">Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="b" items="${departures}">
                                                <tr>
                                                    <td class="ps-4">
                                                        <div class="d-flex align-items-center gap-2">
                                                            <div style="width:32px;height:32px;border-radius:50%;background:linear-gradient(135deg,#f97316,#ea580c);display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:.8rem;flex-shrink:0;">
                                                                ${fn:substring(b.guestName,0,1).toUpperCase()}
                                                            </div>
                                                            <div>
                                                                <div class="fw-semibold" style="font-size:.84rem;">${b.guestName}</div>
                                                                <div class="text-muted" style="font-size:.73rem;">${b.guestPhone}</div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <span class="fw-semibold text-primary" style="font-size:.78rem;font-family:monospace;">${b.bookingCode}</span>
                                                        <div class="text-muted" style="font-size:.72rem;">${b.roomTypeName}</div>
                                                    </td>
                                                    <td class="fw-semibold" style="font-size:.82rem;">
                                                        <fmt:formatNumber value="${b.finalTotal}" type="number" groupingUsed="true"/>₫
                                                    </td>
                                                    <td class="pe-3 text-center">
                                                        <form method="post" action="${pageContext.request.contextPath}/reception/today"
                                                              onsubmit="return confirm('Xác nhận check-out cho ${b.guestName}?')">
                                                            <input type="hidden" name="action"    value="checkout">
                                                            <input type="hidden" name="bookingId" value="${b.bookingId}">
                                                            <button type="submit"
                                                                    class="btn btn-sm btn-warning rounded-3 px-2 py-1"
                                                                    style="font-size:.75rem;">
                                                                <i class="fa-solid fa-right-from-bracket me-1"></i>Check-out
                                                            </button>
                                                        </form>
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

            <%-- ══════════════════════════════════════════════════════════
                 SECTION 2: Current Guests (CHECKED_IN) với search
                 ══════════════════════════════════════════════════════════ --%>
            <div class="owner-card p-0 overflow-hidden">

                <div class="d-flex align-items-center justify-content-between px-4 py-3 border-bottom flex-wrap gap-2">
                    <div class="d-flex align-items-center gap-2">
                        <i class="fa-solid fa-person-shelter text-info" style="font-size:1.1rem;"></i>
                        <div>
                            <span class="fw-bold" style="font-size:.92rem;">Khách đang lưu trú</span>
                            <span class="badge bg-info-subtle text-info border border-info ms-2" style="font-size:.75rem;">${fn:length(currentGuests)} khách</span>
                        </div>
                    </div>

                    <%-- Search form --%>
                    <form method="get" action="${pageContext.request.contextPath}/reception/today"
                          class="d-flex gap-2 align-items-center">
                        <div class="input-group input-group-sm" style="width:280px;">
                            <span class="input-group-text bg-white border-end-0">
                                <i class="fa-solid fa-magnifying-glass text-muted" style="font-size:.75rem;"></i>
                            </span>
                            <input type="search" name="q" class="form-control border-start-0 ps-0"
                                   placeholder="Tên, SĐT, mã đặt phòng..."
                                   value="${not empty searchKeyword ? searchKeyword : ''}">
                            <button type="submit" class="btn btn-primary btn-sm px-3">Tìm</button>
                        </div>
                        <c:if test="${not empty searchKeyword}">
                            <a href="${pageContext.request.contextPath}/reception/today"
                               class="btn btn-sm btn-outline-secondary" title="Xóa tìm kiếm">
                                <i class="fa-solid fa-xmark"></i>
                            </a>
                        </c:if>
                    </form>
                </div>

                <%-- Keyword badge --%>
                <c:if test="${not empty searchKeyword}">
                    <div class="px-4 py-2 bg-light border-bottom d-flex align-items-center gap-2" style="font-size:.8rem;">
                        <span class="text-muted">Kết quả cho:</span>
                        <span class="badge bg-secondary-subtle text-secondary border px-2">
                            <i class="fa-solid fa-magnifying-glass me-1"></i>${searchKeyword}
                        </span>
                        <span class="text-muted">— ${fn:length(currentGuests)} khách</span>
                    </div>
                </c:if>

                <c:choose>
                    <c:when test="${empty currentGuests}">
                        <div class="text-center py-5 text-muted">
                            <i class="fa-solid fa-person-shelter fa-2x mb-2 d-block opacity-25"></i>
                            <c:choose>
                                <c:when test="${not empty searchKeyword}">
                                    Không tìm thấy khách với từ khóa "<strong>${searchKeyword}</strong>".
                                </c:when>
                                <c:otherwise>
                                    Hiện không có khách nào đang lưu trú.
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th class="ps-4" style="width:40px;font-size:.73rem;">#</th>
                                        <th style="font-size:.73rem;">Khách</th>
                                        <th style="font-size:.73rem;">Mã đặt phòng</th>
                                        <th style="font-size:.73rem;">Loại phòng</th>
                                        <th style="font-size:.73rem;">Check-in</th>
                                        <th style="font-size:.73rem;">Check-out</th>
                                        <th style="font-size:.73rem;">Tổng tiền</th>
                                        <th class="pe-4 text-center" style="font-size:.73rem;">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="g" items="${currentGuests}" varStatus="st">
                                        <tr>
                                            <td class="ps-4 text-muted" style="font-size:.78rem;">${st.index + 1}</td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div style="width:34px;height:34px;border-radius:50%;background:linear-gradient(135deg,#6366f1,#8b5cf6);display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:.82rem;flex-shrink:0;">
                                                        ${fn:substring(g.guestName,0,1).toUpperCase()}
                                                    </div>
                                                    <div>
                                                        <div class="fw-semibold" style="font-size:.86rem;">${g.guestName}</div>
                                                        <div class="text-muted" style="font-size:.73rem;">${g.guestPhone}</div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="fw-semibold text-primary" style="font-size:.78rem;font-family:monospace;">${g.bookingCode}</span>
                                                <c:if test="${not empty g.guestIdCardNumber}">
                                                    <div class="text-muted" style="font-size:.7rem;">
                                                        <i class="fa-solid fa-id-card me-1"></i>${g.guestIdCardNumber}
                                                    </div>
                                                </c:if>
                                            </td>
                                            <td class="text-muted" style="font-size:.82rem;">${g.roomTypeName}</td>
                                            <td style="font-size:.82rem;">
                                                <fmt:formatDate value="${g.checkinDate}" pattern="dd/MM/yyyy"/>
                                            </td>
                                            <td style="font-size:.82rem;">
                                                <fmt:formatDate value="${g.checkoutDate}" pattern="dd/MM/yyyy"/>
                                                <c:set var="today" value="<%= new java.sql.Date(System.currentTimeMillis()) %>"/>
                                                <c:if test="${g.checkoutDate == today}">
                                                    <span class="badge bg-warning-subtle text-warning border border-warning ms-1" style="font-size:.65rem;">Hôm nay</span>
                                                </c:if>
                                            </td>
                                            <td class="fw-semibold" style="font-size:.82rem;">
                                                <fmt:formatNumber value="${g.finalTotal}" type="number" groupingUsed="true"/>₫
                                            </td>
                                            <td class="pe-4 text-center">
                                                <div class="d-flex gap-1 justify-content-center">
                                                    <form method="post" action="${pageContext.request.contextPath}/reception/today"
                                                          onsubmit="return confirm('Xác nhận check-out cho ${g.guestName}?')">
                                                        <input type="hidden" name="action"    value="checkout">
                                                        <input type="hidden" name="bookingId" value="${g.bookingId}">
                                                        <c:if test="${not empty searchKeyword}">
                                                            <input type="hidden" name="q" value="${searchKeyword}">
                                                        </c:if>
                                                        <button type="submit"
                                                                class="btn btn-sm btn-outline-warning rounded-3 px-2"
                                                                style="font-size:.74rem;" title="Check-out ngay">
                                                            <i class="fa-solid fa-right-from-bracket me-1"></i>Checkout
                                                        </button>
                                                    </form>
                                                    <a href="${pageContext.request.contextPath}/reception/checkin?q=${g.bookingCode}"
                                                       class="btn btn-sm btn-outline-secondary rounded-3 px-2"
                                                       style="font-size:.74rem;" title="Xem chi tiết">
                                                        <i class="fa-solid fa-eye"></i>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <div class="px-4 py-3 border-top d-flex align-items-center justify-content-between">
                            <small class="text-muted">
                                Tổng <strong>${fn:length(currentGuests)}</strong> khách đang lưu trú
                                <c:if test="${not empty searchKeyword}"> (đã lọc)</c:if>
                            </small>
                            <a href="${pageContext.request.contextPath}/reception/checkin"
                               class="btn btn-sm btn-outline-primary rounded-3" style="font-size:.78rem;">
                                <i class="fa-solid fa-passport me-1"></i>Check-in đầy đủ
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            </c:if><%-- end homestayId check --%>

        </div><%-- /.owner-content --%>
    </div><%-- /.owner-main --%>
</div><%-- /.owner-shell --%>

<script>
// Auto-dismiss flash alerts after 5 seconds
setTimeout(function() {
    document.querySelectorAll('.alert-dismissible').forEach(function(el) {
        var bsAlert = bootstrap && bootstrap.Alert ? new bootstrap.Alert(el) : null;
        if (bsAlert) bsAlert.close(); else el.style.display = 'none';
    });
}, 5000);
</script>

<jsp:include page="../common/footer.jsp"/>
