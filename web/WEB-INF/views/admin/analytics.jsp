<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle"      value="Phân tích Tài chính"       scope="request"/>
<c:set var="pageBreadcrumb" value="Hệ thống &amp; Phân tích"  scope="request"/>
<jsp:include page="../common/header.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>

<style>
/* ── KPI card styles (same pattern as owner/analytics) ───────────────── */
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
                    <p>Thống kê tổng giá trị giao dịch, hoa hồng và hoạt động nền tảng theo kỳ</p>
                </div>
                <div class="d-flex gap-2 align-items-center flex-wrap">
                    <%-- Period select (same pattern as owner) --%>
                    <form method="get" action="${pageContext.request.contextPath}/admin/analytics"
                          id="periodForm" class="d-flex gap-2 align-items-center">
                        <select name="period" class="form-select form-select-sm" style="width:auto;"
                                onchange="document.getElementById('periodForm').submit()">
                            <option value="this_month" ${period=='this_month'?'selected':''}>Tháng này</option>
                            <option value="last_3m"    ${period=='last_3m'   ?'selected':''}>3 tháng qua</option>
                            <option value="this_year"  ${period=='this_year' ?'selected':''}>Năm nay</option>
                            <option value="last_year"  ${period=='last_year' ?'selected':''}>Năm ngoái</option>
                            <option value="all_time"   ${period=='all_time'  ?'selected':''}>Tất cả</option>
                        </select>
                    </form>
                    <%-- Export Excel --%>
                    <form method="post" action="${pageContext.request.contextPath}/admin/analytics" style="display:inline;">
                        <input type="hidden" name="action" value="export"/>
                        <input type="hidden" name="period" value="${period}"/>
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

            <%-- ── KPI Cards ──────────────────────────────────────────────── --%>
            <div class="row g-3 mb-4">

                <div class="col-sm-6 col-xl-3">
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

                <div class="col-sm-6 col-xl-3">
                    <div class="owner-card" style="border-left:4px solid #6366f1;">
                        <div class="kpi-label">Hoa hồng sàn (${commissionRate}%)</div>
                        <div class="kpi-value text-primary">
                            <fmt:formatNumber value="${commissionRevenue}" type="number" groupingUsed="true"/> ₫
                        </div>
                        <div class="kpi-trend">
                            <i class="fa-solid fa-percent text-primary"></i>
                            Ước tính từ GMV
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-3">
                    <div class="owner-card" style="border-left:4px solid #10b981;">
                        <div class="kpi-label">Đơn thành công</div>
                        <div class="kpi-value text-success">
                            <fmt:formatNumber value="${successfulBookings}" type="number"/> <small style="font-size:.78rem;font-weight:500;color:#6b7280;">đơn</small>
                        </div>
                        <div class="kpi-trend">
                            <i class="fa-solid fa-circle-check text-success"></i>
                            Đã hủy:&nbsp;
                            <span class="badge bg-danger-subtle text-danger border border-danger-subtle px-2" style="font-size:.7rem;">${cancelledBookings} đơn<c:if test="${cancelRate > 0}">&nbsp;(${cancelRate}%)</c:if></span>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-3">
                    <div class="owner-card" style="border-left:4px solid #8b5cf6;">
                        <div class="kpi-label">Tổng quan nền tảng</div>
                        <div class="kpi-value" style="font-size:1.1rem;">
                            <span class="text-primary">${activeHomestays}</span><small style="font-size:.68rem;font-weight:500;color:#6b7280;"> HS</small>
                            &nbsp;·&nbsp;<span class="text-warning">${totalOwners}</span><small style="font-size:.68rem;font-weight:500;color:#6b7280;"> CĐ</small>
                            &nbsp;·&nbsp;<span class="text-success">${totalCustomers}</span><small style="font-size:.68rem;font-weight:500;color:#6b7280;"> KH</small>
                        </div>
                        <div class="kpi-trend">
                            <i class="fa-solid fa-house text-primary"></i>
                            Homestay · Chủ đầu tư · Khách hàng
                        </div>
                    </div>
                </div>

            </div>

            <%-- ── Revenue Chart (với toggle Line/Bar giống owner) ─────────── --%>
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

            <%-- ── Bottom Row: Top HS + Status donut + Quick stats ──────────── --%>
            <div class="row g-3 mb-4">

                <%-- Top Homestays --%>
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

                <%-- Booking status donut --%>
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

                <%-- Quick stats --%>
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

            <%-- ── Khách hàng mới ────────────────────────────────────────── --%>
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
    var COLORS      = ['#6366f1','#22c55e','#f97316','#ef4444','#a855f7','#06b6d4','#eab308','#ec4899'];

    var TOOLTIP_OPTS = {
        backgroundColor:'#1f2937', titleColor:'#f9fafb', bodyColor:'#d1d5db',
        padding:10, cornerRadius:8
    };

    // ── Server data ─────────────────────────────────────────────────────────
    var revLabels   = safeJson('${chartLabels}');
    var revGmv      = safeJson('${chartGmv}');
    var revCnts     = safeJson('${chartCounts}');
    var stLabels    = safeJson('${statusLabels}');
    var stData      = safeJson('${statusData}');
    var payLabels   = safeJson('${paymentLabels}');
    var payData     = safeJson('${paymentData}');
    var hsLabels    = safeJson('${topHsLabels}');
    var hsRevenue   = safeJson('${topHsRevenue}');
    var uLabels     = safeJson('${userLabels}');
    var uData       = safeJson('${userData}');

    // ── Revenue chart (shared instance for switcher) ─────────────────────────
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

    // ── Chart type switcher (same as owner) ──────────────────────────────────
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

    // ── Status donut ──────────────────────────────────────────────────────────
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

    // ── Payment donut ─────────────────────────────────────────────────────────
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

    // ── Top Homestays list (same pattern as owner) ────────────────────────────
    var container = document.getElementById('topHomestayList');
    if (container && hsLabels.length) {
        var maxRev   = hsRevenue[0] || 1;
        var rankCls  = ['rank-1','rank-2','rank-3'];
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

    // ── New users line ─────────────────────────────────────────────────────────
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
