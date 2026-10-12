<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle"      value="Tổng quan"                       scope="request"/>
<c:set var="pageBreadcrumb" value="Vận hành &amp; Báo cáo"          scope="request"/>
<jsp:include page="../common/header.jsp"/>

<div class="owner-shell">
    <jsp:include page="../common/sidebar-owner.jsp"/>
    <div class="owner-main">
        <jsp:include page="../common/owner-topbar.jsp"/>
        <div class="owner-content">

            <%-- Page header --%>
            <div class="owner-page-header">
                <div class="owner-page-header__info">
                    <h2>
                        <i class="fa-solid fa-gauge-high text-primary me-2"></i>Tổng quan hôm nay
                        <span class="badge bg-primary-subtle text-primary border border-primary ms-2 fw-normal"
                              style="font-size:.65rem;vertical-align:middle;">
                            <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd/MM/yyyy"/>
                        </span>
                    </h2>
                    <p>Nhận phòng, trả phòng và khách đang lưu trú trên
                        <strong>${fn:length(myHomestays)}</strong> cơ sở của bạn</p>
                </div>
                <a href="${pageContext.request.contextPath}/owner/bookings"
                   class="btn btn-outline-primary btn-sm rounded-3">
                    <i class="fa-solid fa-list-check me-1"></i>Tất cả đơn đặt phòng
                </a>
            </div>

            <%-- ── KPI cards ─────────────────────────────────────────────────── --%>
            <div class="row g-3 mb-4">

                <div class="col-6 col-lg-3">
                    <div class="owner-card px-4 py-3 h-100"
                         style="border-left:4px solid #22c55e;">
                        <div class="text-muted mb-1" style="font-size:.74rem;text-transform:uppercase;letter-spacing:.05em;">Nhận phòng hôm nay</div>
                        <div class="fw-bold" style="font-size:2rem;color:#16a34a;line-height:1.1;">${fn:length(arrivals)}</div>
                        <div class="text-muted mt-1" style="font-size:.75rem;"><i class="fa-solid fa-plane-arrival me-1 text-success"></i>Đặt phòng CONFIRMED</div>
                    </div>
                </div>

                <div class="col-6 col-lg-3">
                    <div class="owner-card px-4 py-3 h-100"
                         style="border-left:4px solid #f97316;">
                        <div class="text-muted mb-1" style="font-size:.74rem;text-transform:uppercase;letter-spacing:.05em;">Trả phòng hôm nay</div>
                        <div class="fw-bold" style="font-size:2rem;color:#c2410c;line-height:1.1;">${fn:length(departures)}</div>
                        <div class="text-muted mt-1" style="font-size:.75rem;"><i class="fa-solid fa-plane-departure me-1 text-warning"></i>Đang CHECKED_IN</div>
                    </div>
                </div>

                <div class="col-6 col-lg-3">
                    <div class="owner-card px-4 py-3 h-100"
                         style="border-left:4px solid #6366f1;">
                        <div class="text-muted mb-1" style="font-size:.74rem;text-transform:uppercase;letter-spacing:.05em;">Khách đang ở</div>
                        <div class="fw-bold" style="font-size:2rem;color:#4f46e5;line-height:1.1;">${fn:length(currentGuests)}</div>
                        <div class="text-muted mt-1" style="font-size:.75rem;"><i class="fa-solid fa-person me-1 text-indigo"></i>Tổng tất cả cơ sở</div>
                    </div>
                </div>

                <div class="col-6 col-lg-3">
                    <div class="owner-card px-4 py-3 h-100"
                         style="border-left:4px solid #0ea5e9;">
                        <div class="text-muted mb-1" style="font-size:.74rem;text-transform:uppercase;letter-spacing:.05em;">Doanh thu tháng</div>
                        <div class="fw-bold" style="font-size:1.55rem;color:#0369a1;line-height:1.1;">
                            <fmt:formatNumber value="${monthRevenue}" type="number" groupingUsed="true"/>đ
                        </div>
                        <div class="text-muted mt-1" style="font-size:.75rem;">
                            <i class="fa-solid fa-receipt me-1 text-info"></i>${monthBookings} đơn thành công
                        </div>
                    </div>
                </div>
            </div>

            <%-- ── Arrivals & Departures ──────────────────────────────────────── --%>
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
                                                <th style="font-size:.74rem;">Mã đặt / Cơ sở</th>
                                                <th style="font-size:.74rem;">Thời gian ở</th>
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
                                                        <div class="text-muted" style="font-size:.72rem;">${b.homestayName}</div>
                                                    </td>
                                                    <td style="font-size:.82rem;">
                                                        <fmt:formatDate value="${b.checkinDate}"  pattern="dd/MM"/> → <fmt:formatDate value="${b.checkoutDate}" pattern="dd/MM"/>
                                                        <div class="text-muted" style="font-size:.72rem;">${b.totalNights} đêm</div>
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
                                <div class="fw-bold" style="font-size:.92rem;color:#c2410c;">Khách trả phòng hôm nay</div>
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
                                                <th style="font-size:.74rem;">Mã đặt / Cơ sở</th>
                                                <th style="font-size:.74rem;">Tổng tiền</th>
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
                                                        <div class="text-muted" style="font-size:.72rem;">${b.homestayName}</div>
                                                    </td>
                                                    <td>
                                                        <span class="fw-semibold text-dark" style="font-size:.82rem;">
                                                            <fmt:formatNumber value="${b.finalTotal}" type="number" groupingUsed="true"/>đ
                                                        </span>
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

            <%-- ── Khách đang lưu trú ─────────────────────────────────────────── --%>
            <div class="owner-card p-0 overflow-hidden mb-4">
                <div class="d-flex align-items-center gap-2 px-4 py-3 border-bottom"
                     style="background:linear-gradient(135deg,#f5f3ff,#ede9fe);">
                    <div style="width:36px;height:36px;border-radius:10px;background:#6366f1;display:flex;align-items:center;justify-content:center;color:#fff;font-size:.9rem;flex-shrink:0;">
                        <i class="fa-solid fa-people-roof"></i>
                    </div>
                    <div>
                        <div class="fw-bold" style="font-size:.92rem;color:#4338ca;">Khách đang lưu trú</div>
                        <div class="text-muted" style="font-size:.75rem;">Tất cả cơ sở</div>
                    </div>
                    <span class="badge ms-auto px-2 py-1" style="font-size:.8rem;background:#6366f1;">${totalGuests}</span>
                </div>

                <%-- Search form --%>
                <div class="px-4 py-2 border-bottom bg-light d-flex align-items-center gap-2">
                    <form method="get" action="${pageContext.request.contextPath}/owner/dashboard"
                          class="d-flex gap-2 align-items-center flex-grow-1">
                        <div class="input-group input-group-sm" style="max-width:320px;">
                            <span class="input-group-text bg-white border-end-0">
                                <i class="fa-solid fa-magnifying-glass text-muted" style="font-size:.75rem;"></i>
                            </span>
                            <input type="search" name="q" class="form-control border-start-0 ps-0"
                                   placeholder="Tên khách, SĐT, mã đặt phòng..."
                                   value="${not empty searchKeyword ? searchKeyword : ''}">
                            <button type="submit" class="btn btn-primary btn-sm px-3">Tìm</button>
                        </div>
                        <c:if test="${not empty searchKeyword}">
                            <a href="${pageContext.request.contextPath}/owner/dashboard"
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
                        <span class="text-muted">— ${totalGuests} khách</span>
                    </div>
                </c:if>

                <c:choose>
                    <c:when test="${empty currentGuests}">
                        <div class="text-center py-5 text-muted">
                            <i class="fa-solid fa-moon fa-2x mb-2 d-block opacity-25"></i>
                            <c:choose>
                                <c:when test="${not empty searchKeyword}">
                                    Không tìm thấy khách với từ khóa "<strong>${searchKeyword}</strong>".
                                </c:when>
                                <c:otherwise>
                                    <div style="font-size:.85rem;">Hiện không có khách đang lưu trú</div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th class="ps-4" style="font-size:.74rem;">#</th>
                                        <th style="font-size:.74rem;">Khách</th>
                                        <th style="font-size:.74rem;">Mã đặt phòng</th>
                                        <th style="font-size:.74rem;">Cơ sở</th>
                                        <th style="font-size:.74rem;">Check-in</th>
                                        <th style="font-size:.74rem;">Check-out</th>
                                        <th style="font-size:.74rem;">Tổng tiền</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="g" items="${currentGuests}" varStatus="st">
                                        <tr>
                                            <td class="ps-4 text-muted" style="font-size:.8rem;">${(currentPage - 1) * 10 + st.index + 1}</td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div style="width:30px;height:30px;border-radius:50%;background:linear-gradient(135deg,#6366f1,#4f46e5);display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:.78rem;flex-shrink:0;">
                                                        ${fn:substring(g.guestName,0,1).toUpperCase()}
                                                    </div>
                                                    <div>
                                                        <div class="fw-semibold" style="font-size:.83rem;">${g.guestName}</div>
                                                        <div class="text-muted" style="font-size:.72rem;">${g.guestPhone}</div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="fw-semibold text-primary" style="font-size:.78rem;font-family:monospace;">${g.bookingCode}</span>
                                                <div class="text-muted" style="font-size:.72rem;">${g.roomTypeName}</div>
                                            </td>
                                            <td style="font-size:.8rem;">${g.homestayName}</td>
                                            <td style="font-size:.8rem;"><fmt:formatDate value="${g.checkinDate}"  pattern="dd/MM/yyyy"/></td>
                                            <td style="font-size:.8rem;">
                                                <fmt:formatDate value="${g.checkoutDate}" pattern="dd/MM/yyyy"/>
                                                <c:set var="todayDate" value="<%= new java.sql.Date(System.currentTimeMillis()) %>"/>
                                                <c:if test="${g.checkoutDate == todayDate}">
                                                    <span class="badge bg-warning-subtle text-warning border border-warning ms-1" style="font-size:.65rem;">Hôm nay</span>
                                                </c:if>
                                            </td>
                                            <td>
                                                <span class="fw-semibold" style="font-size:.82rem;">
                                                    <fmt:formatNumber value="${g.finalTotal}" type="number" groupingUsed="true"/>đ
                                                </span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <%-- Pagination footer --%>
                        <div class="px-4 py-3 border-top d-flex align-items-center justify-content-between flex-wrap gap-2">
                            <small class="text-muted">
                                Hiển thị <strong>${(currentPage - 1) * 10 + 1}</strong>–<strong>${(currentPage - 1) * 10 + fn:length(currentGuests)}</strong>
                                trong tổng <strong>${totalGuests}</strong> khách đang lưu trú
                            </small>
                            <c:if test="${totalPages > 1}">
                                <nav>
                                    <ul class="pagination pagination-sm mb-0">
                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/owner/dashboard?page=${currentPage - 1}<c:if test='${not empty searchKeyword}'>&amp;q=${searchKeyword}</c:if>">
                                                <i class="fa-solid fa-chevron-left"></i>
                                            </a>
                                        </li>
                                        <c:forEach begin="1" end="${totalPages}" var="p">
                                            <li class="page-item ${p == currentPage ? 'active' : ''}">
                                                <a class="page-link" href="${pageContext.request.contextPath}/owner/dashboard?page=${p}<c:if test='${not empty searchKeyword}'>&amp;q=${searchKeyword}</c:if>">${p}</a>
                                            </li>
                                        </c:forEach>
                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/owner/dashboard?page=${currentPage + 1}<c:if test='${not empty searchKeyword}'>&amp;q=${searchKeyword}</c:if>">
                                                <i class="fa-solid fa-chevron-right"></i>
                                            </a>
                                        </li>
                                    </ul>
                                </nav>
                            </c:if>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <%-- ── Đơn gần đây ────────────────────────────────────────────────── --%>
            <div class="owner-card p-0 overflow-hidden">
                <div class="d-flex align-items-center gap-2 px-4 py-3 border-bottom">
                    <div style="width:36px;height:36px;border-radius:10px;background:#0ea5e9;display:flex;align-items:center;justify-content:center;color:#fff;font-size:.9rem;flex-shrink:0;">
                        <i class="fa-solid fa-clock-rotate-left"></i>
                    </div>
                    <div>
                        <div class="fw-bold" style="font-size:.92rem;">Đơn đặt phòng gần đây</div>
                        <div class="text-muted" style="font-size:.75rem;">8 đơn mới nhất</div>
                    </div>
                    <a href="${pageContext.request.contextPath}/owner/bookings"
                       class="btn btn-sm btn-outline-secondary rounded-3 ms-auto" style="font-size:.76rem;">
                        Xem tất cả <i class="fa-solid fa-arrow-right ms-1"></i>
                    </a>
                </div>

                <c:choose>
                    <c:when test="${empty recentBookings}">
                        <div class="text-center py-4 text-muted" style="font-size:.85rem;">
                            Chưa có đơn đặt phòng nào
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th class="ps-4" style="font-size:.74rem;">Khách</th>
                                        <th style="font-size:.74rem;">Cơ sở</th>
                                        <th style="font-size:.74rem;">Check-in</th>
                                        <th style="font-size:.74rem;">Check-out</th>
                                        <th style="font-size:.74rem;">Tổng tiền</th>
                                        <th style="font-size:.74rem;">Trạng thái</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="row" items="${recentBookings}">
                                        <%-- row: {guestName, homestayName, checkinDate, checkoutDate, finalTotal, bookingStatus, ratingOverall, bookingCode} --%>
                                        <tr>
                                            <td class="ps-4">
                                                <div class="fw-semibold" style="font-size:.83rem;">${row[0]}</div>
                                                <div class="text-muted" style="font-size:.72rem;font-family:monospace;">${row[7]}</div>
                                            </td>
                                            <td style="font-size:.8rem;">${row[1]}</td>
                                            <td style="font-size:.8rem;">${row[2]}</td>
                                            <td style="font-size:.8rem;">${row[3]}</td>
                                            <td>
                                                <span class="fw-semibold" style="font-size:.82rem;">
                                                    <fmt:formatNumber value="${row[4]}" type="number" groupingUsed="true"/>đ
                                                </span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${row[5] == 'CONFIRMED'}">
                                                        <span class="badge bg-success-subtle text-success border border-success" style="font-size:.72rem;">Xác nhận</span>
                                                    </c:when>
                                                    <c:when test="${row[5] == 'CHECKED_IN'}">
                                                        <span class="badge bg-primary-subtle text-primary border border-primary" style="font-size:.72rem;">Đang ở</span>
                                                    </c:when>
                                                    <c:when test="${row[5] == 'CHECKED_OUT'}">
                                                        <span class="badge bg-secondary-subtle text-secondary border border-secondary" style="font-size:.72rem;">Đã trả</span>
                                                    </c:when>
                                                    <c:when test="${row[5] == 'CANCELLED'}">
                                                        <span class="badge bg-danger-subtle text-danger border border-danger" style="font-size:.72rem;">Đã huỷ</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-light text-muted border" style="font-size:.72rem;">${row[5]}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

        </div><%-- /.owner-content --%>
    </div><%-- /.owner-main --%>
</div><%-- /.owner-shell --%>

<jsp:include page="../common/footer.jsp"/>
