<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle"      value="Doanh thu &amp; Thống kê" scope="request"/>
<c:set var="pageBreadcrumb" value="Vận hành &amp; Báo cáo"   scope="request"/>
<jsp:include page="../common/header.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>

<div class="owner-shell">
    <jsp:include page="../common/sidebar-owner.jsp"/>

    <div class="owner-main">
        <jsp:include page="../common/owner-topbar.jsp"/>

        <div class="owner-content">

            <!-- Page Header -->
            <div class="owner-page-header">
                <div class="owner-page-header__info">
                    <h2><i class="fa-solid fa-chart-pie text-primary me-2"></i>Doanh thu &amp; Tỷ lệ Lấp đầy</h2>
                    <p>Theo dõi chỉ số ADR, RevPAR và xuất báo cáo tài chính</p>
                </div>
                <div class="d-flex gap-2 align-items-center flex-wrap">
                    <!-- Filters form (GET) -->
                    <form method="get" action="${pageContext.request.contextPath}/owner/analytics"
                          class="d-flex gap-2 align-items-center flex-wrap" id="filterForm">

                        <!-- Homestay filter -->
                        <select name="homestayId" class="form-select form-select-sm" style="width:auto;"
                                onchange="document.getElementById('filterForm').submit()">
                            <option value="0" ${selectedHomestayId == 0 ? 'selected' : ''}>Tất cả cơ sở</option>
                            <c:forEach var="hs" items="${ownerHomestays}">
                                <option value="${hs[0]}" ${selectedHomestayId == hs[0] ? 'selected' : ''}>${hs[1]}</option>
                            </c:forEach>
                        </select>

                        <!-- Period filter -->
                        <select name="period" class="form-select form-select-sm" style="width:auto;"
                                onchange="document.getElementById('filterForm').submit()">
                            <option value="this_month" ${period == 'this_month' ? 'selected' : ''}>Tháng này</option>
                            <option value="last_3m"    ${period == 'last_3m' || empty period ? 'selected' : ''}>3 tháng qua</option>
                            <option value="this_year"  ${period == 'this_year'  ? 'selected' : ''}>Năm nay</option>
                            <option value="all_time"   ${period == 'all_time'   ? 'selected' : ''}>Tất cả</option>
                        </select>
                    </form>

                    <!-- Export Excel (POST) -->
                    <form method="post" action="${pageContext.request.contextPath}/owner/analytics" style="display:inline;">
                        <input type="hidden" name="action"      value="export">
                        <input type="hidden" name="period"      value="${period}">
                        <input type="hidden" name="homestayId"  value="${selectedHomestayId}">
                        <button type="submit" class="btn btn-outline-success btn-sm rounded-3 fw-semibold">
                            <i class="fa-solid fa-file-excel me-1 text-success"></i>Xuất Excel
                        </button>
                    </form>
                </div>
            </div>

            <!-- Period label badge -->
            <div class="mb-3">
                <span class="badge bg-primary-subtle text-primary border border-primary px-3 py-2">
                    <i class="fa-solid fa-calendar-range me-1"></i>${periodLabel}
                </span>
            </div>

            <!-- KPI Cards — 4 metrics -->
            <div class="row g-3 mb-4">
                <div class="col-sm-6 col-xl-3">
                    <div class="owner-card" style="border-left:4px solid #6366f1;">
                        <div class="kpi-label">Tổng Doanh thu kỳ</div>
                        <div class="kpi-value text-primary">
                            <fmt:formatNumber value="${totalRevenue}" type="number" groupingUsed="true"/> ₫
                        </div>
                        <div class="kpi-trend text-muted">
                            <i class="fa-solid fa-check-circle text-success"></i>
                            ${successfulBookings} đơn thành công
                        </div>
                    </div>
                </div>
                <div class="col-sm-6 col-xl-3">
                    <div class="owner-card" style="border-left:4px solid #10b981;">
                        <div class="kpi-label">Tỷ lệ Lấp đầy (Occupancy)</div>
                        <div class="kpi-value text-success">
                            <fmt:formatNumber value="${occupancyRate}" type="number" maxFractionDigits="1"/>%
                        </div>
                        <div class="kpi-trend text-muted">
                            <i class="fa-solid fa-bed me-1"></i>ADR × Occupancy = RevPAR
                        </div>
                    </div>
                </div>
                <div class="col-sm-6 col-xl-3">
                    <div class="owner-card" style="border-left:4px solid #06b6d4;">
                        <div class="kpi-label">Giá trung bình / đêm (ADR)</div>
                        <div class="kpi-value text-info">
                            <fmt:formatNumber value="${adr}" type="number" groupingUsed="true"/> ₫
                        </div>
                        <div class="kpi-trend text-muted">
                            <i class="fa-solid fa-moon me-1"></i>Tổng tiền / Số đêm
                        </div>
                    </div>
                </div>
                <div class="col-sm-6 col-xl-3">
                    <div class="owner-card" style="border-left:4px solid #f59e0b;">
                        <div class="kpi-label">RevPAR (Doanh thu / Phòng)</div>
                        <div class="kpi-value text-warning">
                            <fmt:formatNumber value="${revpar}" type="number" groupingUsed="true"/> ₫
                        </div>
                        <div class="kpi-trend text-muted">
                            <i class="fa-solid fa-calculator me-1"></i>ADR × Occupancy
                        </div>
                    </div>
                </div>
            </div>

            <!-- Revenue Chart -->
            <div class="owner-card mb-4">
                <div class="d-flex align-items-center justify-content-between mb-3 flex-wrap gap-2">
                    <h6 class="fw-bold mb-0">
                        <i class="fa-solid fa-chart-line text-primary me-2"></i>Tăng trưởng doanh thu — ${periodLabel}
                    </h6>
                    <div class="d-flex gap-2">
                        <button id="btnLine" class="btn btn-sm btn-primary rounded-3" onclick="switchChart('line')">
                            <i class="fa-solid fa-chart-line me-1"></i>Đường
                        </button>
                        <button id="btnBar" class="btn btn-sm btn-outline-secondary rounded-3" onclick="switchChart('bar')">
                            <i class="fa-solid fa-chart-column me-1"></i>Cột
                        </button>
                    </div>
                </div>
                <c:choose>
                    <c:when test="${empty chartLabels or chartLabels == '[]'}">
                        <div class="text-center text-muted py-4">
                            <i class="fa-solid fa-chart-line fa-2x mb-2 d-block opacity-25"></i>
                            Chưa có dữ liệu trong kỳ được chọn
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div style="height:300px; position:relative;">
                            <canvas id="revenueChart"></canvas>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Bottom row -->
            <div class="row g-3 mb-4">
                <!-- Top Homestays -->
                <div class="col-lg-5">
                    <div class="owner-card h-100">
                        <h6 class="fw-bold mb-3">
                            <i class="fa-solid fa-trophy text-warning me-2"></i>Top Cơ sở theo Doanh thu
                        </h6>
                        <c:choose>
                            <c:when test="${empty topHsRows}">
                                <p class="text-muted text-center py-3" style="font-size:.85rem;">Chưa có dữ liệu</p>
                            </c:when>
                            <c:otherwise>
                                <c:set var="firstRev" value="${topHsRows[0][1]}"/>
                                <c:forEach var="row" items="${topHsRows}" varStatus="st">
                                    <c:set var="barWidth" value="${firstRev > 0 ? (row[1] * 100 / firstRev) : 0}"/>
                                    <div class="d-flex align-items-center justify-content-between py-2
                                                ${not st.last ? 'border-bottom' : ''} gap-2">
                                        <div class="d-flex align-items-center gap-2 min-width-0">
                                            <span class="badge ${st.index == 0 ? 'bg-primary' : st.index == 1 ? 'bg-secondary' : 'bg-light text-dark'} rounded-circle flex-shrink-0"
                                                  style="width:24px;height:24px;display:flex;align-items:center;justify-content:center;font-size:.75rem;">${st.count}</span>
                                            <span class="fw-semibold text-truncate" style="font-size:.88rem;" title="${row[0]}">${row[0]}</span>
                                        </div>
                                        <span class="fw-bold text-primary flex-shrink-0" style="font-size:.88rem;">
                                            <fmt:formatNumber value="${row[1]}" type="number" groupingUsed="true"/> ₫
                                        </span>
                                    </div>
                                    <div class="mb-1" style="height:5px;background:#eef2ff;border-radius:4px;">
                                        <div style="height:100%;width:${barWidth}%;background:${st.index == 0 ? '#6366f1' : '#94a3b8'};border-radius:4px;"></div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Booking Status donut -->
                <div class="col-lg-4">
                    <div class="owner-card h-100">
                        <h6 class="fw-bold mb-3">
                            <i class="fa-solid fa-chart-pie text-info me-2"></i>Trạng thái đặt phòng
                        </h6>
                        <c:choose>
                            <c:when test="${empty statusLabels or statusLabels == '[]'}">
                                <p class="text-muted text-center py-3" style="font-size:.85rem;">Chưa có dữ liệu</p>
                            </c:when>
                            <c:otherwise>
                                <div style="height:165px; position:relative;">
                                    <canvas id="statusChart"></canvas>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Quick stats -->
                <div class="col-lg-3">
                    <div class="owner-card h-100 d-flex flex-column gap-2">
                        <h6 class="fw-bold mb-0">
                            <i class="fa-solid fa-bolt text-warning me-2"></i>${periodLabel}
                        </h6>
                        <div class="d-flex justify-content-between align-items-center py-2 border-bottom">
                            <span class="text-muted" style="font-size:.82rem;">Đặt phòng mới</span>
                            <span class="fw-bold text-primary">${newBookings}</span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center py-2 border-bottom">
                            <span class="text-muted" style="font-size:.82rem;">Đã check-in</span>
                            <span class="fw-bold text-success">${checkedIn}</span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center py-2 border-bottom">
                            <span class="text-muted" style="font-size:.82rem;">Đã check-out</span>
                            <span class="fw-bold">${checkedOut}</span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center py-2 border-bottom">
                            <span class="text-muted" style="font-size:.82rem;">Hủy phòng</span>
                            <span class="fw-bold text-danger">${cancelledBookings}</span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center py-2 border-bottom">
                            <span class="text-muted" style="font-size:.82rem;">Tỷ lệ hủy</span>
                            <span class="fw-bold text-warning">
                                <fmt:formatNumber value="${cancelRate}" type="number" maxFractionDigits="1"/>%
                            </span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center py-2">
                            <span class="text-muted" style="font-size:.82rem;">Đánh giá mới</span>
                            <span class="fw-bold text-warning">
                                <i class="fa-solid fa-star me-1" style="font-size:.75rem;"></i>${newReviews}
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Bookings Table -->
            <div class="owner-card p-0 overflow-hidden">
                <div class="d-flex align-items-center justify-content-between px-4 py-3 border-bottom flex-wrap gap-2">
                    <h6 class="fw-bold mb-0">
                        <i class="fa-solid fa-list-ul me-2 text-primary"></i>Đơn đặt phòng gần đây
                    </h6>
                    <a href="${pageContext.request.contextPath}/owner/bookings" class="btn btn-sm btn-outline-primary rounded-3">
                        Xem tất cả <i class="fa-solid fa-arrow-right ms-1"></i>
                    </a>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-4">Khách hàng</th>
                                <th>Cơ sở</th>
                                <th>Check-in</th>
                                <th>Check-out</th>
                                <th>Tổng tiền</th>
                                <th>Trạng thái</th>
                                <th class="pe-4">Đánh giá</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty recentBookings}">
                                    <tr>
                                        <td colspan="7" class="text-center text-muted py-4">
                                            <i class="fa-solid fa-inbox fa-2x mb-2 d-block opacity-25"></i>
                                            Chưa có đơn đặt phòng nào
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="bk" items="${recentBookings}">
                                        <%-- row[0]=guestName, row[1]=homestayName, row[2]=checkin,
                                             row[3]=checkout, row[4]=finalTotal, row[5]=status,
                                             row[6]=rating, row[7]=bookingCode --%>
                                        <c:set var="firstChar" value="${not empty bk[0] ? bk[0].substring(0,1).toUpperCase() : '?'}"/>
                                        <tr>
                                            <td class="ps-4">
                                                <div class="d-flex align-items-center gap-2">
                                                    <div style="width:32px;height:32px;border-radius:50%;
                                                                background:linear-gradient(135deg,#6366f1,#8b5cf6);
                                                                display:flex;align-items:center;justify-content:center;
                                                                color:#fff;font-weight:700;font-size:.8rem;flex-shrink:0;">
                                                        ${firstChar}
                                                    </div>
                                                    <span class="fw-semibold" style="font-size:.85rem;">${bk[0]}</span>
                                                </div>
                                            </td>
                                            <td style="font-size:.85rem;">${bk[1]}</td>
                                            <td style="font-size:.85rem;">${bk[2]}</td>
                                            <td style="font-size:.85rem;">${bk[3]}</td>
                                            <td class="fw-semibold" style="font-size:.85rem;">
                                                <fmt:formatNumber value="${bk[4]}" type="number" groupingUsed="true"/> ₫
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${bk[5] == 'CHECKED_OUT'}">
                                                        <span class="badge bg-success-subtle text-success border border-success px-2">Hoàn thành</span>
                                                    </c:when>
                                                    <c:when test="${bk[5] == 'CHECKED_IN'}">
                                                        <span class="badge bg-primary-subtle text-primary border border-primary px-2">Đang ở</span>
                                                    </c:when>
                                                    <c:when test="${bk[5] == 'CONFIRMED'}">
                                                        <span class="badge bg-info-subtle text-info border border-info px-2">Đã xác nhận</span>
                                                    </c:when>
                                                    <c:when test="${bk[5] == 'PENDING'}">
                                                        <span class="badge bg-warning-subtle text-warning border border-warning px-2">Chờ thanh toán</span>
                                                    </c:when>
                                                    <c:when test="${bk[5] == 'CANCELLED'}">
                                                        <span class="badge bg-danger-subtle text-danger border border-danger px-2">Đã hủy</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary-subtle text-secondary border px-2">${bk[5]}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="pe-4">
                                                <c:choose>
                                                    <c:when test="${bk[6] > 0}">
                                                        <span class="text-warning" style="font-size:.82rem;">
                                                            <c:forEach begin="1" end="${Math.round(bk[6])}"><i class="fa-solid fa-star"></i></c:forEach>
                                                        </span>
                                                        <span class="text-muted ms-1" style="font-size:.78rem;">
                                                            (<fmt:formatNumber value="${bk[6]}" type="number" maxFractionDigits="1"/>)
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted" style="font-size:.82rem;">—</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

        </div><!-- /.owner-content -->
    </div><!-- /.owner-main -->
</div><!-- /.owner-shell -->

<style>
.kpi-label {
    font-size: .72rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: .06em;
    color: #94a3b8;
    margin-bottom: .35rem;
}
.kpi-value {
    font-family: 'Outfit', sans-serif;
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
}
</style>

<script>
// ── Data from server ──────────────────────────────────────────────────────────
var SERVER_CHART_LABELS  = ${chartLabels};
var SERVER_CHART_REVENUE = ${chartRevenue};
var SERVER_STATUS_LABELS = ${statusLabels};
var SERVER_STATUS_DATA   = ${statusData};

// Status label -> Vietnamese
var STATUS_VI = {
    'CONFIRMED'  : 'Đã xác nhận',
    'CHECKED_IN' : 'Đang ở',
    'CHECKED_OUT': 'Hoàn thành',
    'PENDING'    : 'Chờ TT',
    'CANCELLED'  : 'Đã hủy',
    'REFUNDED'   : 'Hoàn tiền'
};

var STATUS_COLORS = {
    'CONFIRMED'  : '#3b82f6',
    'CHECKED_IN' : '#6366f1',
    'CHECKED_OUT': '#10b981',
    'PENDING'    : '#f59e0b',
    'CANCELLED'  : '#ef4444',
    'REFUNDED'   : '#8b5cf6'
};

var revenueChart;

document.addEventListener('DOMContentLoaded', function () {

    // ── Revenue chart ─────────────────────────────────────────────────────
    var ctxRevenue = document.getElementById('revenueChart');
    if (ctxRevenue && SERVER_CHART_LABELS.length > 0) {
        revenueChart = new Chart(ctxRevenue.getContext('2d'), {
            type: 'line',
            data: buildRevenueData(SERVER_CHART_REVENUE, 'line'),
            options: revenueOptions('line')
        });
    }

    // ── Status donut ──────────────────────────────────────────────────────
    var ctxStatus = document.getElementById('statusChart');
    if (ctxStatus && SERVER_STATUS_LABELS.length > 0) {
        var statusColors = SERVER_STATUS_LABELS.map(function(s) {
            return STATUS_COLORS[s] || '#94a3b8';
        });
        var statusVi = SERVER_STATUS_LABELS.map(function(s) {
            return STATUS_VI[s] || s;
        });
        new Chart(ctxStatus.getContext('2d'), {
            type: 'doughnut',
            data: {
                labels: statusVi,
                datasets: [{
                    data: SERVER_STATUS_DATA,
                    backgroundColor: statusColors,
                    borderWidth: 2,
                    borderColor: '#fff'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { position: 'right', labels: { font: { size: 11 }, boxWidth: 12 } }
                }
            }
        });
    }
});

// ── Chart type switcher ───────────────────────────────────────────────────────
function switchChart(type) {
    if (!revenueChart) return;
    revenueChart.destroy();
    var ctx = document.getElementById('revenueChart').getContext('2d');
    revenueChart = new Chart(ctx, {
        type: type,
        data: buildRevenueData(SERVER_CHART_REVENUE, type),
        options: revenueOptions(type)
    });
    document.getElementById('btnLine').className = type === 'line'
        ? 'btn btn-sm btn-primary rounded-3'
        : 'btn btn-sm btn-outline-secondary rounded-3';
    document.getElementById('btnBar').className = type === 'bar'
        ? 'btn btn-sm btn-primary rounded-3'
        : 'btn btn-sm btn-outline-secondary rounded-3';
}

function buildRevenueData(data, type) {
    var isBar = type === 'bar';
    return {
        labels: SERVER_CHART_LABELS,
        datasets: [{
            label: 'Doanh thu (VNĐ)',
            data: data,
            borderColor: '#4f46e5',
            backgroundColor: isBar ? 'rgba(99,102,241,0.7)' : 'rgba(99,102,241,0.08)',
            fill: !isBar,
            tension: 0.4,
            pointBackgroundColor: '#4f46e5',
            pointRadius: isBar ? 0 : 4,
            borderRadius: isBar ? 6 : 0
        }]
    };
}

function revenueOptions(type) {
    return {
        responsive: true,
        maintainAspectRatio: false,
        plugins: { legend: { display: false } },
        scales: {
            y: {
                ticks: {
                    callback: function(v) { return (v / 1000000).toFixed(0) + 'M'; },
                    font: { size: 11 }
                },
                grid: { color: 'rgba(0,0,0,.04)' }
            },
            x: { grid: { display: false } }
        }
    };
}
</script>

<jsp:include page="../common/footer.jsp"/>
