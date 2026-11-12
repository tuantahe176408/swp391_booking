<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle"      value="Phân tích Tài chính"       scope="request"/>
<c:set var="pageBreadcrumb" value="Hệ thống &amp; Phân tích"  scope="request"/>
<jsp:include page="../common/header.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>

<style>
/* ── KPI card styles ──────────────────────────────────────────────────── */
.kpi-label {
    font-size: .72rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: .06em;
    color: #94a3b8;
    margin-bottom: .35rem;
}
.kpi-value {
    font-size: 1.55rem;
    font-weight: 800;
    line-height: 1.1;
    margin-bottom: .35rem;
}
.kpi-trend {
    font-size: .78rem;
    display: flex;
    align-items: center;
    gap: .3rem;
    color: #64748b;
}
/* Top homestay mini list */
.an-hs-row  { display:flex; align-items:center; gap:10px; padding:8px 0; border-bottom:1px solid #f1f5f9; }
.an-hs-row:last-child { border-bottom:none; }
.an-hs-rank { width:22px; height:22px; border-radius:6px; font-size:.7rem; font-weight:700;
    display:flex; align-items:center; justify-content:center; flex-shrink:0; }
.rank-1 { background:#fef3c7; color:#d97706; }
.rank-2 { background:#f1f5f9; color:#64748b; }
.rank-3 { background:#fff1e6; color:#c2410c; }
.rank-n { background:#f9fafb; color:#9ca3af; }
.an-hs-name { font-size:.78rem; font-weight:600; color:#374151; flex:1; min-width:0;
    white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
.an-hs-rev  { font-size:.76rem; font-weight:700; color:#6366f1; flex-shrink:0; }
.an-hs-bar-wrap { flex:0 0 60px; height:5px; background:#f3f4f6; border-radius:3px; overflow:hidden; }
.an-hs-bar  { height:100%; border-radius:3px; background:linear-gradient(90deg,#6366f1,#8b5cf6); }
/* Booking table */
.bk-code { font-family: monospace; font-size:.78rem; font-weight:600; color:#6366f1; white-space:nowrap; }
.bk-guest-name { font-size:.82rem; font-weight:600; color:#1e293b; }
.bk-guest-phone { font-size:.73rem; color:#64748b; }
</style>

<div class="owner-shell">
    <jsp:include page="../common/sidebar-admin.jsp"/>

    <div class="owner-main">
        <jsp:include page="../common/admin-topbar.jsp"/>

        <div class="owner-content">

            <%-- ── Page Header ──────────────────────────────────────────── --%>
            <div class="owner-page-header">
                <div class="owner-page-header__info">
                    <h2><i class="fa-solid fa-chart-line text-primary me-2"></i>Báo cáo Tài chính &amp; Doanh thu toàn sàn</h2>
                    <p>Thống kê tổng giá trị giao dịch và hoạt động nền tảng theo kỳ</p>
                </div>

                <%-- ── Filter bar ────────────────────────────────────── --%>
                <div class="d-flex gap-2 align-items-center flex-wrap">
                    <form method="get" action="${pageContext.request.contextPath}/admin/analytics"
                          id="filterForm" class="d-flex gap-2 align-items-center flex-wrap">

                        <%-- ── Filter type toggle ──── --%>
                        <div class="btn-group btn-group-sm" role="group" aria-label="Kiểu lọc">
                            <input type="radio" class="btn-check" name="filterType"
                                   id="ftDate" value="date_range" autocomplete="off"
                                   ${filterType == 'date_range' ? 'checked' : ''}
                                   onchange="switchFilterType('date_range')">
                            <label class="btn btn-outline-primary fw-semibold" for="ftDate"
                                   style="font-size:.78rem;">
                                <i class="fa-solid fa-calendar-days me-1"></i>Theo ngày
                            </label>

                            <input type="radio" class="btn-check" name="filterType"
                                   id="ftMonth" value="month" autocomplete="off"
                                   ${filterType == 'month' || empty filterType ? 'checked' : ''}
                                   onchange="switchFilterType('month')">
                            <label class="btn btn-outline-primary fw-semibold" for="ftMonth"
                                   style="font-size:.78rem;">
                                <i class="fa-solid fa-calendar me-1"></i>Theo tháng
                            </label>

                            <input type="radio" class="btn-check" name="filterType"
                                   id="ftYear" value="year" autocomplete="off"
                                   ${filterType == 'year' ? 'checked' : ''}
                                   onchange="switchFilterType('year')">
                            <label class="btn btn-outline-primary fw-semibold" for="ftYear"
                                   style="font-size:.78rem;">
                                <i class="fa-solid fa-calendar-year me-1"></i>Theo năm
                            </label>
                        </div>

                        <%-- ── Section: Theo ngày ───────────────────────── --%>
                        <div id="sec-date_range"
                             class="align-items-center gap-2 ${filterType == 'date_range' ? 'd-flex' : 'd-none'}">
                            <div class="d-flex align-items-center gap-1">
                                <label class="mb-0 fw-semibold text-nowrap" style="font-size:.8rem;">Từ ngày:</label>
                                <input type="date" name="fromDate" id="inpFrom"
                                       class="form-control form-control-sm" style="width:148px;"
                                       value="${fromDate}"
                                       ${filterType != 'date_range' ? 'disabled' : ''}>
                            </div>
                            <div class="d-flex align-items-center gap-1">
                                <label class="mb-0 fw-semibold text-nowrap" style="font-size:.8rem;">Đến ngày:</label>
                                <input type="date" name="toDate" id="inpTo"
                                       class="form-control form-control-sm" style="width:148px;"
                                       value="${toDate}"
                                       ${filterType != 'date_range' ? 'disabled' : ''}>
                            </div>
                        </div>

                        <%-- ── Section: Theo tháng ──────────────────────── --%>
                        <div id="sec-month"
                             class="align-items-center gap-2 ${filterType == 'month' || empty filterType ? 'd-flex' : 'd-none'}">
                            <div class="d-flex align-items-center gap-1">
                                <label class="mb-0 fw-semibold text-nowrap" style="font-size:.8rem;">Tháng:</label>
                                <select name="month" id="selMonth" class="form-select form-select-sm"
                                        style="width:116px;"
                                        ${filterType != 'month' && not empty filterType ? 'disabled' : ''}>
                                    <c:forEach begin="1" end="12" var="m">
                                        <option value="${m}" ${month == m ? 'selected' : ''}>Tháng ${m}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="d-flex align-items-center gap-1">
                                <label class="mb-0 fw-semibold text-nowrap" style="font-size:.8rem;">Năm:</label>
                                <select name="year" id="selYearM"
                                        class="form-select form-select-sm" style="width:88px;"
                                        ${filterType != 'month' && not empty filterType ? 'disabled' : ''}>
                                    <c:forEach var="yr" items="${availableYears}">
                                        <option value="${yr}" ${year == yr ? 'selected' : ''}>${yr}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <%-- ── Section: Theo năm ────────────────────────── --%>
                        <div id="sec-year"
                             class="align-items-center gap-2 ${filterType == 'year' ? 'd-flex' : 'd-none'}">
                            <div class="d-flex align-items-center gap-1">
                                <label class="mb-0 fw-semibold text-nowrap" style="font-size:.8rem;">Năm:</label>
                                <select name="yearOnly" id="selYearY"
                                        class="form-select form-select-sm" style="width:88px;"
                                        ${filterType != 'year' ? 'disabled' : ''}>
                                    <c:forEach var="yr" items="${availableYears}">
                                        <option value="${yr}" ${year == yr ? 'selected' : ''}>${yr}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary btn-sm rounded-3 fw-semibold"
                                onclick="prepareSubmit()">
                            <i class="fa-solid fa-magnifying-glass me-1"></i>Lọc
                        </button>
                    </form>

                    <%-- Export button (POST with current filter params) --%>
                    <form method="post" action="${pageContext.request.contextPath}/admin/analytics"
                          id="exportForm" style="display:inline;">
                        <input type="hidden" name="action"     value="export"/>
                        <input type="hidden" name="filterType" value="${filterType}"/>
                        <input type="hidden" name="fromDate"   value="${fromDate}"/>
                        <input type="hidden" name="toDate"     value="${toDate}"/>
                        <input type="hidden" name="month"      value="${month}"/>
                        <input type="hidden" name="year"       value="${year}"/>
                        <button type="submit" class="btn btn-outline-success btn-sm rounded-3 fw-semibold">
                            <i class="fa-solid fa-file-excel me-1 text-success"></i>Xuất Báo cáo (.xlsx)
                        </button>
                    </form>
                </div>
            </div>

            <%-- Period label badge --%>
            <div class="mb-3">
                <span class="badge bg-primary-subtle text-primary border border-primary px-3 py-2">
                    <i class="fa-solid fa-calendar-range me-1"></i>${periodLabel}
                </span>
            </div>

            <%-- ── KPI Cards (3) ──────────────────────────────────────────── --%>
            <div class="row g-3 mb-4">

                <%-- GMV --%>
                <div class="col-sm-6 col-xl-4">
                    <div class="owner-card" style="border-left:4px solid #ef4444;">
                        <div class="kpi-label">Tổng GMV toàn sàn</div>
                        <div class="kpi-value text-danger">
                            <fmt:formatNumber value="${totalGmv}" type="number" groupingUsed="true"/> ₫
                        </div>
                        <div class="kpi-trend">
                            <i class="fa-solid fa-sack-dollar text-danger"></i>
                            ${periodLabel}
                        </div>
                    </div>
                </div>

                <%-- Successful bookings --%>
                <div class="col-sm-6 col-xl-4">
                    <div class="owner-card" style="border-left:4px solid #10b981;">
                        <div class="kpi-label">Đơn thành công</div>
                        <div class="kpi-value text-success">
                            <fmt:formatNumber value="${successfulBookings}" type="number"/> <small style="font-size:.78rem;font-weight:500;color:#6b7280;">đơn</small>
                        </div>
                        <div class="kpi-trend">
                            <i class="fa-solid fa-circle-check text-success"></i>
                            Đã hủy:&nbsp;
                            <span class="badge bg-danger-subtle text-danger border border-danger-subtle px-2" style="font-size:.7rem;">
                                ${cancelledBookings} đơn<c:if test="${cancelRate > 0}">&nbsp;(${cancelRate}%)</c:if>
                            </span>
                        </div>
                    </div>
                </div>

                <%-- Customers in period --%>
                <div class="col-sm-6 col-xl-4">
                    <div class="owner-card" style="border-left:4px solid #8b5cf6;">
                        <div class="kpi-label">Khách hàng trong kỳ</div>
                        <div class="kpi-value" style="color:#8b5cf6;">
                            <fmt:formatNumber value="${uniqueCustomers}" type="number"/> <small style="font-size:.78rem;font-weight:500;color:#6b7280;">khách đặt</small>
                        </div>
                        <div class="kpi-trend">
                            <i class="fa-solid fa-user-plus" style="color:#8b5cf6;"></i>
                            Mới ĐK trong kỳ:&nbsp;<strong>${newCustomers} KH</strong>
                        </div>
                    </div>
                </div>

            </div>

            <%-- ── Booking Detail Table ───────────────────────────────────── --%>
            <div class="owner-card mb-4">
                <div class="d-flex align-items-center justify-content-between mb-3 flex-wrap gap-2">
                    <div>
                        <h6 class="fw-bold mb-1">
                            <i class="fa-solid fa-list-check text-primary me-2"></i>Danh sách Đơn hàng &amp; Doanh thu trong kỳ
                        </h6>
                        <div class="text-muted" style="font-size:.75rem;">
                            ${periodLabel}
                            <c:if test="${successfulBookings > 0}">
                                &nbsp;·&nbsp;<strong>${successfulBookings} đơn thành công</strong>
                            </c:if>
                        </div>
                    </div>
                    <div class="fw-bold" style="color:#ef4444;font-size:.95rem;">
                        Tổng tiền kỳ:&nbsp;
                        <fmt:formatNumber value="${totalGmv}" type="number" groupingUsed="true"/> ₫
                    </div>
                </div>

                <c:choose>
                    <c:when test="${empty bookingList}">
                        <div class="text-center py-5 text-muted">
                            <i class="fa-solid fa-inbox fa-2x mb-2 d-block opacity-25"></i>
                            Không có đơn hàng nào trong kỳ này.
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="table table-hover table-sm align-middle mb-2">
                                <thead class="table-light">
                                    <tr>
                                        <th style="font-size:.75rem;">Mã đơn</th>
                                        <th style="font-size:.75rem;">Khách hàng</th>
                                        <th style="font-size:.75rem;">Cơ sở Homestay</th>
                                        <th style="font-size:.75rem;">Thời gian đặt</th>
                                        <th style="font-size:.75rem;">Check-in / Check-out</th>
                                        <th style="font-size:.75rem;" class="text-center">Số đêm</th>
                                        <th style="font-size:.75rem;" class="text-end">Tổng tiền</th>
                                        <th style="font-size:.75rem;" class="text-center">Trạng thái</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="row" items="${bookingList}">
                                        <%--
                                            row[0] = bookingCode  (String)
                                            row[1] = guestName    (String)
                                            row[2] = guestPhone   (String)
                                            row[3] = homestayName (String)
                                            row[4] = checkinDate  (java.sql.Date)
                                            row[5] = checkoutDate (java.sql.Date)
                                            row[6] = totalNights  (Integer)
                                            row[7] = finalTotal   (Long)
                                            row[8] = bookingStatus (String)
                                        --%>
                                        <tr>
                                            <td>
                                                <span class="bk-code">${row[0]}</span>
                                            </td>
                                            <td>
                                                <div class="bk-guest-name">${row[1]}</div>
                                                <div class="bk-guest-phone">
                                                    <i class="fa-solid fa-phone fa-xs me-1"></i>${row[2]}
                                                </div>
                                            </td>
                                            <td style="font-size:.8rem;max-width:180px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;"
                                                title="${row[3]}">${row[3]}</td>
                                            <td style="white-space:nowrap;font-size:.78rem;color:#64748b;">
                                                <i class="fa-regular fa-clock me-1"></i>
                                                <fmt:formatDate value="${row[9]}" pattern="dd/MM/yyyy HH:mm"/>
                                            </td>
                                            <td style="white-space:nowrap;font-size:.78rem;">
                                                <i class="fa-regular fa-calendar me-1 text-muted"></i>
                                                <fmt:formatDate value="${row[4]}" pattern="dd/MM/yyyy"/>
                                                <span class="text-muted mx-1">/</span>
                                                <fmt:formatDate value="${row[5]}" pattern="dd/MM/yyyy"/>
                                            </td>
                                            <td class="text-center" style="font-size:.8rem;">${row[6]}đêm</td>
                                            <td class="text-end fw-semibold" style="font-size:.82rem;white-space:nowrap;">
                                                <fmt:formatNumber value="${row[7]}" type="number" groupingUsed="true"/> ₫
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${row[8] == 'CHECKED_OUT'}">
                                                        <span class="badge bg-success-subtle text-success border border-success-subtle" style="font-size:.68rem;">Hoàn thành</span>
                                                    </c:when>
                                                    <c:when test="${row[8] == 'CONFIRMED'}">
                                                        <span class="badge bg-primary-subtle text-primary border border-primary-subtle" style="font-size:.68rem;">Đã xác nhận</span>
                                                    </c:when>
                                                    <c:when test="${row[8] == 'CHECKED_IN'}">
                                                        <span class="badge bg-info-subtle text-info border border-info-subtle" style="font-size:.68rem;">Đang ở</span>
                                                    </c:when>
                                                    <c:when test="${row[8] == 'CANCELLED'}">
                                                        <span class="badge bg-danger-subtle text-danger border border-danger-subtle" style="font-size:.68rem;">Đã hủy</span>
                                                    </c:when>
                                                    <c:when test="${row[8] == 'REFUNDED'}">
                                                        <span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle" style="font-size:.68rem;">Hoàn tiền</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-warning-subtle text-warning border border-warning-subtle" style="font-size:.68rem;">Chờ xác nhận</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <%-- ── Pagination ──────────────────────────────── --%>
                        <c:if test="${totalPages > 1}">
                            <c:set var="filterQS"
                                   value="fromDate=${fromDate}&toDate=${toDate}&month=${month}&year=${year}"/>
                            <nav aria-label="Phân trang đơn hàng">
                                <ul class="pagination pagination-sm justify-content-center mb-0">

                                    <%-- Prev --%>
                                    <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/admin/analytics?${filterQS}&page=${currentPage - 1}">
                                            <i class="fa-solid fa-chevron-left fa-xs"></i>
                                        </a>
                                    </li>

                                    <%-- Pages (show at most 5 around current) --%>
                                    <c:set var="startPage" value="${currentPage - 2 < 1 ? 1 : currentPage - 2}"/>
                                    <c:set var="endPage"   value="${startPage + 4 > totalPages ? totalPages : startPage + 4}"/>

                                    <c:if test="${startPage > 1}">
                                        <li class="page-item">
                                            <a class="page-link" href="${pageContext.request.contextPath}/admin/analytics?${filterQS}&page=1">1</a>
                                        </li>
                                        <c:if test="${startPage > 2}">
                                            <li class="page-item disabled"><span class="page-link">…</span></li>
                                        </c:if>
                                    </c:if>

                                    <c:forEach begin="${startPage}" end="${endPage}" var="p">
                                        <li class="page-item ${p == currentPage ? 'active' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/admin/analytics?${filterQS}&page=${p}">${p}</a>
                                        </li>
                                    </c:forEach>

                                    <c:if test="${endPage < totalPages}">
                                        <c:if test="${endPage < totalPages - 1}">
                                            <li class="page-item disabled"><span class="page-link">…</span></li>
                                        </c:if>
                                        <li class="page-item">
                                            <a class="page-link" href="${pageContext.request.contextPath}/admin/analytics?${filterQS}&page=${totalPages}">${totalPages}</a>
                                        </li>
                                    </c:if>

                                    <%-- Next --%>
                                    <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/admin/analytics?${filterQS}&page=${currentPage + 1}">
                                            <i class="fa-solid fa-chevron-right fa-xs"></i>
                                        </a>
                                    </li>

                                </ul>
                            </nav>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </div>

            <%-- ── Revenue Chart ───────────────────────────────────────────── --%>
            <div class="owner-card mb-4">
                <div class="d-flex align-items-center justify-content-between mb-3 flex-wrap gap-2">
                    <div>
                        <h6 class="fw-bold mb-1">
                            <i class="fa-solid fa-chart-column text-primary me-2"></i>Doanh thu &amp; Số đơn đặt phòng
                        </h6>
                        <div class="text-muted" style="font-size:.75rem;">${periodLabel}</div>
                    </div>
                    <div class="d-flex gap-2 align-items-center">
                        <div class="d-flex gap-3 me-3" style="font-size:.75rem;color:#6b7280;">
                            <span><span style="display:inline-block;width:10px;height:10px;border-radius:50%;background:#6366f1;margin-right:4px;"></span>GMV</span>
                            <span><span style="display:inline-block;width:10px;height:10px;border-radius:50%;background:#ef4444;margin-right:4px;"></span>Số đơn</span>
                        </div>
                        <button id="btnLine" class="btn btn-sm btn-primary rounded-3" onclick="switchChart('line')">
                            <i class="fa-solid fa-chart-line me-1"></i>Đường
                        </button>
                        <button id="btnBar" class="btn btn-sm btn-outline-secondary rounded-3" onclick="switchChart('bar')">
                            <i class="fa-solid fa-chart-column me-1"></i>Cột
                        </button>
                    </div>
                </div>
                <c:choose>
                    <c:when test="${empty chartLabels || chartLabels == '[]'}">
                        <div class="text-center py-5 text-muted">
                            <i class="fa-solid fa-chart-bar fa-2x mb-2 d-block opacity-25"></i>
                            Không có dữ liệu trong kỳ này.
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div style="height:300px;position:relative;">
                            <canvas id="chartRevenue"></canvas>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <%-- ── Bottom Row: Top HS + Status donut + Payment donut ─────── --%>
            <div class="row g-3 mb-4">

                <div class="col-lg-5">
                    <div class="owner-card h-100">
                        <h6 class="fw-bold mb-3">
                            <i class="fa-solid fa-trophy text-warning me-2"></i>Top Homestay doanh thu
                        </h6>
                        <div class="text-muted mb-2" style="font-size:.72rem;text-transform:uppercase;letter-spacing:.04em;">${periodLabel}</div>
                        <div id="topHomestayList">
                            <div class="text-center text-muted py-4" style="font-size:.8rem;">
                                <i class="fa-solid fa-spinner fa-spin me-1"></i>Đang tải...
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="owner-card h-100">
                        <h6 class="fw-bold mb-1">
                            <i class="fa-solid fa-chart-pie text-info me-2"></i>Trạng thái đặt phòng
                        </h6>
                        <div class="text-muted mb-3" style="font-size:.72rem;">${periodLabel}</div>
                        <c:choose>
                            <c:when test="${empty statusLabels || statusLabels == '[]'}">
                                <div class="text-center text-muted py-4" style="font-size:.85rem;">Chưa có dữ liệu</div>
                            </c:when>
                            <c:otherwise>
                                <div style="height:200px;position:relative;">
                                    <canvas id="chartStatus"></canvas>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="col-lg-3">
                    <div class="owner-card h-100 d-flex flex-column gap-2">
                        <h6 class="fw-bold mb-0">
                            <i class="fa-solid fa-bolt text-warning me-2"></i>Phương thức thanh toán
                        </h6>
                        <div class="text-muted mb-1" style="font-size:.72rem;">Giao dịch thành công</div>
                        <c:choose>
                            <c:when test="${empty paymentLabels || paymentLabels == '[]'}">
                                <div class="text-center text-muted py-4" style="font-size:.85rem;">Chưa có dữ liệu</div>
                            </c:when>
                            <c:otherwise>
                                <div style="height:165px;position:relative;">
                                    <canvas id="chartPayment"></canvas>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

            </div>

            <%-- ── New Users chart ─────────────────────────────────────── --%>
            <div class="row g-3">
                <div class="col-12">
                    <div class="owner-card">
                        <h6 class="fw-bold mb-1">
                            <i class="fa-solid fa-user-plus text-success me-2"></i>Khách hàng mới đăng ký
                        </h6>
                        <div class="text-muted mb-3" style="font-size:.72rem;">6 tháng gần nhất</div>
                        <div style="height:200px;position:relative;">
                            <canvas id="chartNewUsers"></canvas>
                        </div>
                    </div>
                </div>
            </div>

        </div><%-- /.owner-content --%>
    </div><%-- /.owner-main --%>
</div><%-- /.owner-shell --%>

<script>
(function () {
    'use strict';

    // ── Filter type toggle ───────────────────────────────────────────────────

    var SECTIONS = ['date_range', 'month', 'year'];

    /**
     * Show the section matching `type`; hide and disable the others
     * so their inputs are not included in the form submission.
     */
    window.switchFilterType = function(type) {
        SECTIONS.forEach(function(id) {
            var sec = document.getElementById('sec-' + id);
            if (!sec) return;
            var active = (id === type);
            sec.classList.toggle('d-flex', active);
            sec.classList.toggle('d-none', !active);
            sec.querySelectorAll('input, select').forEach(function(el) {
                el.disabled = !active;
            });
        });
    };

    /** Called by the submit button — no-op since switchFilterType handles everything. */
    window.prepareSubmit = function() { /* inputs already correctly enabled/disabled */ };

    // Apply current state on page load
    (function initFilter() {
        var checked = document.querySelector('input[name="filterType"]:checked');
        switchFilterType(checked ? checked.value : 'month');
    })();

    // ── Chart helpers ────────────────────────────────────────────────────────
    function safeJson(raw) {
        try { return JSON.parse(raw && raw !== 'null' ? raw : '[]'); } catch(e) { return []; }
    }
    function fmtShort(v) {
        if (v >= 1e9) return (v/1e9).toFixed(1)+' tỷ';
        if (v >= 1e6) return (v/1e6).toFixed(0)+' tr';
        if (v >= 1e3) return (v/1e3).toFixed(0)+'k';
        return v;
    }

    var PAY_COLORS  = { 'VNPAY':'#006fe6','MOMO':'#ae2070','CASH':'#22c55e','POS_CARD':'#f97316','CARD':'#f97316' };
    var STATUS_VI   = { 'PENDING':'Chờ xác nhận','CONFIRMED':'Đã xác nhận',
                        'CHECKED_IN':'Đang ở','CHECKED_OUT':'Hoàn thành',
                        'CANCELLED':'Đã hủy','REFUNDED':'Hoàn tiền' };
    var STATUS_CLR  = { 'PENDING':'#f59e0b','CONFIRMED':'#3b82f6','CHECKED_IN':'#6366f1',
                        'CHECKED_OUT':'#10b981','CANCELLED':'#ef4444','REFUNDED':'#8b5cf6' };

    var TOOLTIP_OPTS = {
        backgroundColor:'#1f2937', titleColor:'#f9fafb', bodyColor:'#d1d5db',
        padding:10, cornerRadius:8
    };

    // ── Server data ──────────────────────────────────────────────────────────
    var revLabels = safeJson('${chartLabels}');
    var revGmv    = safeJson('${chartGmv}');
    var revCnts   = safeJson('${chartCounts}');
    var stLabels  = safeJson('${statusLabels}');
    var stData    = safeJson('${statusData}');
    var payLabels = safeJson('${paymentLabels}');
    var payData   = safeJson('${paymentData}');
    var hsLabels  = safeJson('${topHsLabels}');
    var hsRevenue = safeJson('${topHsRevenue}');
    var uLabels   = safeJson('${userLabels}');
    var uData     = safeJson('${userData}');

    // ── Revenue chart ────────────────────────────────────────────────────────
    var revenueChart = null;

    function buildRevenueDatasets(type) {
        var isBar = (type === 'bar');
        return [
            { type: isBar ? 'bar' : 'line',
              label: 'GMV (₫)', data: revGmv,
              backgroundColor: isBar ? 'rgba(99,102,241,.75)' : 'rgba(99,102,241,.08)',
              borderColor: '#6366f1',
              hoverBackgroundColor: 'rgba(99,102,241,.95)',
              pointBackgroundColor: '#6366f1', pointRadius: isBar ? 0 : 5, pointHoverRadius: 7,
              tension: 0.35, fill: !isBar,
              borderRadius: isBar ? 6 : 0, borderSkipped: false,
              yAxisID: 'yGmv', order: 2 },
            { type: 'line',
              label: 'Số đơn', data: revCnts,
              borderColor: '#ef4444', backgroundColor: 'rgba(239,68,68,.08)',
              pointBackgroundColor: '#ef4444', pointRadius: 5, pointHoverRadius: 7,
              tension: 0.35, fill: true,
              yAxisID: 'yCnt', order: 1 }
        ];
    }

    function revenueOptions() {
        return {
            responsive: true, maintainAspectRatio: false,
            interaction: { mode: 'index', intersect: false },
            plugins: {
                legend: { display: false },
                tooltip: Object.assign({}, TOOLTIP_OPTS, {
                    callbacks: { label: function(c) {
                        return c.dataset.yAxisID === 'yGmv'
                            ? '  GMV: ' + Number(c.parsed.y).toLocaleString('vi-VN') + ' ₫'
                            : '  Đơn: ' + c.parsed.y;
                    }}
                })
            },
            scales: {
                yGmv: { position: 'left',  grid: { color: 'rgba(0,0,0,.05)' },
                         ticks: { callback: fmtShort, font: { size: 11 }, color: '#9ca3af' } },
                yCnt: { position: 'right', grid: { drawOnChartArea: false },
                         ticks: { stepSize: 1, font: { size: 11 }, color: '#ef4444' } },
                x:    { grid: { display: false }, ticks: { font: { size: 11 }, color: '#6b7280' } }
            }
        };
    }

    var ctxRev = document.getElementById('chartRevenue');
    if (ctxRev && revLabels.length) {
        revenueChart = new Chart(ctxRev, {
            data: { labels: revLabels, datasets: buildRevenueDatasets('bar') },
            options: revenueOptions()
        });
    }

    window.switchChart = function(type) {
        if (!revenueChart) return;
        revenueChart.destroy();
        var ctx = document.getElementById('chartRevenue');
        revenueChart = new Chart(ctx, {
            data: { labels: revLabels, datasets: buildRevenueDatasets(type) },
            options: revenueOptions()
        });
        document.getElementById('btnLine').className = (type === 'line')
            ? 'btn btn-sm btn-primary rounded-3'
            : 'btn btn-sm btn-outline-secondary rounded-3';
        document.getElementById('btnBar').className = (type === 'bar')
            ? 'btn btn-sm btn-primary rounded-3'
            : 'btn btn-sm btn-outline-secondary rounded-3';
    };

    // ── Status donut ─────────────────────────────────────────────────────────
    var ctxSt = document.getElementById('chartStatus');
    if (ctxSt && stLabels.length) {
        var stColors = stLabels.map(function(s) { return STATUS_CLR[s] || '#9ca3af'; });
        var stVi     = stLabels.map(function(s) { return STATUS_VI[s]  || s; });
        new Chart(ctxSt, {
            type: 'doughnut',
            data: { labels: stVi, datasets: [{ data: stData, backgroundColor: stColors, borderWidth: 2, borderColor: '#fff', hoverOffset: 6 }] },
            options: {
                responsive: true, maintainAspectRatio: false, cutout: '65%',
                plugins: {
                    legend: { position: 'bottom', labels: { font: { size: 10 }, padding: 8, boxWidth: 10, color: '#6b7280' } },
                    tooltip: TOOLTIP_OPTS
                }
            }
        });
    }

    // ── Payment donut ────────────────────────────────────────────────────────
    var ctxPay = document.getElementById('chartPayment');
    if (ctxPay && payLabels.length) {
        var payColors = payLabels.map(function(m) { return PAY_COLORS[m] || '#9ca3af'; });
        new Chart(ctxPay, {
            type: 'doughnut',
            data: { labels: payLabels, datasets: [{ data: payData, backgroundColor: payColors, borderWidth: 2, borderColor: '#fff', hoverOffset: 6 }] },
            options: {
                responsive: true, maintainAspectRatio: false, cutout: '65%',
                plugins: {
                    legend: { position: 'bottom', labels: { font: { size: 10 }, padding: 8, boxWidth: 10, color: '#6b7280' } },
                    tooltip: TOOLTIP_OPTS
                }
            }
        });
    }

    // ── Top Homestays list ───────────────────────────────────────────────────
    var container = document.getElementById('topHomestayList');
    if (container && hsLabels.length) {
        var maxRev  = hsRevenue[0] || 1;
        var rankCls = ['rank-1','rank-2','rank-3'];
        var html = '';
        for (var i = 0; i < hsLabels.length; i++) {
            var pct = Math.round(hsRevenue[i] / maxRev * 100);
            var cls = rankCls[i] || 'rank-n';
            html += '<div class="an-hs-row">'
                  + '<div class="an-hs-rank ' + cls + '">' + (i+1) + '</div>'
                  + '<div class="an-hs-name" title="' + hsLabels[i] + '">' + hsLabels[i] + '</div>'
                  + '<div class="an-hs-bar-wrap"><div class="an-hs-bar" style="width:' + pct + '%;"></div></div>'
                  + '<div class="an-hs-rev">' + fmtShort(hsRevenue[i]) + '</div>'
                  + '</div>';
        }
        container.innerHTML = html;
    } else if (container) {
        container.innerHTML = '<div class="text-center text-muted py-4" style="font-size:.8rem;">Chưa có dữ liệu</div>';
    }

    // ── New users line ───────────────────────────────────────────────────────
    var ctxUsr = document.getElementById('chartNewUsers');
    if (ctxUsr && uLabels.length) {
        new Chart(ctxUsr, {
            type: 'line',
            data: { labels: uLabels, datasets: [{
                label: 'Khách mới', data: uData,
                borderColor: '#22c55e', backgroundColor: 'rgba(34,197,94,.1)',
                pointBackgroundColor: '#22c55e', pointRadius: 5, pointHoverRadius: 7,
                tension: 0.35, fill: true
            }]},
            options: {
                responsive: true, maintainAspectRatio: false,
                plugins: {
                    legend: { display: false },
                    tooltip: Object.assign({}, TOOLTIP_OPTS, {
                        callbacks: { label: function(c) { return '  ' + c.parsed.y + ' khách mới'; } }
                    })
                },
                scales: {
                    y: { beginAtZero: true, grid: { color: 'rgba(0,0,0,.05)' }, ticks: { stepSize: 1, font: { size: 11 }, color: '#9ca3af' } },
                    x: { grid: { display: false }, ticks: { font: { size: 10 }, color: '#6b7280' } }
                }
            }
        });
    }

})();
</script>

<jsp:include page="../common/footer.jsp"/>
