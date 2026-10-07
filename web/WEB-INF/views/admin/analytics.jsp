<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle"      value="Phân tích Tài chính"       scope="request"/>
<c:set var="pageBreadcrumb" value="Hệ thống &amp; Phân tích"  scope="request"/>
<jsp:include page="../common/header.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>

<style>
/* ── Analytics Page ──────────────────────────────────────────────────────── */
.an-kpi-card {
    background:#fff; border-radius:14px; padding:20px 22px;
    border:1px solid #f0f0f0; box-shadow:0 2px 8px rgba(0,0,0,.05);
    transition:box-shadow .2s; height:100%;
}
.an-kpi-card:hover { box-shadow:0 4px 16px rgba(0,0,0,.09); }

.an-kpi-icon {
    width:46px; height:46px; border-radius:12px;
    display:flex; align-items:center; justify-content:center;
    font-size:1.15rem; flex-shrink:0;
}
.an-kpi-icon.red    { background:#fff1f1; color:#ef4444; }
.an-kpi-icon.blue   { background:#eff6ff; color:#3b82f6; }
.an-kpi-icon.green  { background:#f0fdf4; color:#22c55e; }
.an-kpi-icon.purple { background:#f5f3ff; color:#8b5cf6; }

.an-kpi-label { font-size:.72rem; text-transform:uppercase; letter-spacing:.6px; color:#9ca3af; font-weight:600; margin-bottom:4px; }
.an-kpi-value { font-size:1.5rem; font-weight:700; line-height:1.15; color:#111827; }
.an-kpi-value small { font-size:.78rem; font-weight:500; color:#6b7280; margin-left:2px; }
.an-kpi-sub   { font-size:.75rem; color:#9ca3af; margin-top:4px; }
.badge-cancel { background:#fee2e2; color:#dc2626; padding:1px 7px; border-radius:20px; font-size:.7rem; font-weight:600; }

.an-chart-card {
    background:#fff; border-radius:14px; border:1px solid #f0f0f0;
    box-shadow:0 2px 8px rgba(0,0,0,.05); padding:22px 24px; height:100%;
}
.an-chart-title { font-size:.875rem; font-weight:700; color:#111827; margin-bottom:2px; }
.an-chart-sub   { font-size:.72rem; color:#9ca3af; margin-bottom:14px; }

.period-tabs .btn { font-size:.78rem; padding:5px 14px; border-radius:20px; font-weight:600; transition:all .15s; }
.period-tabs .btn-active   { background:#ef4444; color:#fff; border:1px solid #ef4444; }
.period-tabs .btn-inactive { background:#fff; color:#6b7280; border:1px solid #e5e7eb; }
.period-tabs .btn-inactive:hover { border-color:#ef4444; color:#ef4444; }

.an-legend-dot { width:10px; height:10px; border-radius:50%; display:inline-block; margin-right:4px; }

/* Top homestay mini list */
.an-hs-row  { display:flex; align-items:center; gap:10px; padding:8px 0; border-bottom:1px solid #f5f5f5; }
.an-hs-row:last-child { border-bottom:none; }
.an-hs-rank { width:22px; height:22px; border-radius:6px; font-size:.7rem; font-weight:700;
    display:flex; align-items:center; justify-content:center; flex-shrink:0; }
.rank-1 { background:#fef3c7; color:#d97706; }
.rank-2 { background:#f1f5f9; color:#64748b; }
.rank-3 { background:#fff1e6; color:#c2410c; }
.rank-n { background:#f9fafb; color:#9ca3af; }
.an-hs-name { font-size:.78rem; font-weight:600; color:#374151; flex:1; min-width:0;
    white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
.an-hs-rev  { font-size:.76rem; font-weight:700; color:#ef4444; flex-shrink:0; }
.an-hs-bar-wrap { flex:0 0 60px; height:5px; background:#f3f4f6; border-radius:3px; overflow:hidden; }
.an-hs-bar  { height:100%; border-radius:3px; background:linear-gradient(90deg,#ef4444,#f97316); }
</style>

<div class="owner-shell">
    <jsp:include page="../common/sidebar-admin.jsp"/>

    <div class="owner-main">
        <jsp:include page="../common/admin-topbar.jsp"/>

        <div class="owner-content">

            <%-- ── Page Header ──────────────────────────────────────────── --%>
            <div class="d-flex align-items-start justify-content-between mb-4 flex-wrap gap-3">
                <div>
                    <h2 class="mb-1 fw-bold" style="font-size:1.2rem;color:#111827;">
                        <i class="fa-solid fa-chart-line text-danger me-2"></i>Báo cáo Tài chính &amp; Doanh thu toàn sàn
                    </h2>
                    <p class="text-muted mb-0" style="font-size:.82rem;">
                        Thống kê tổng giá trị giao dịch, hoa hồng và hoạt động nền tảng theo kỳ
                    </p>
                </div>
                <%-- Export form — POST to same URL --%>
                <form method="post" action="${pageContext.request.contextPath}/admin/analytics" style="margin:0;">
                    <input type="hidden" name="action" value="export"/>
                    <input type="hidden" name="period" value="${period}"/>
                    <button type="submit" class="btn btn-sm rounded-pill fw-semibold"
                            style="background:#fff;border:1px solid #22c55e;color:#22c55e;">
                        <i class="fa-solid fa-file-excel me-1 text-success"></i>Xuất Báo cáo (.xlsx)
                    </button>
                </form>
            </div>

            <%-- ── Period Tabs ────────────────────────────────────────────── --%>
            <div class="period-tabs d-flex gap-2 mb-4 flex-wrap">
                <c:set var="base" value="${pageContext.request.contextPath}/admin/analytics"/>
                <a href="${base}?period=this_month" class="btn ${period=='this_month'?'btn-active':'btn-inactive'}">Tháng này</a>
                <a href="${base}?period=last_3m"    class="btn ${period=='last_3m'   ?'btn-active':'btn-inactive'}">3 tháng qua</a>
                <a href="${base}?period=this_year"  class="btn ${period=='this_year' ?'btn-active':'btn-inactive'}">Năm nay</a>
                <a href="${base}?period=last_year"  class="btn ${period=='last_year' ?'btn-active':'btn-inactive'}">Năm ngoái</a>
                <a href="${base}?period=all_time"   class="btn ${period=='all_time'  ?'btn-active':'btn-inactive'}">Tất cả</a>
            </div>

            <%-- ── KPI Cards ──────────────────────────────────────────────── --%>
            <div class="row g-3 mb-4">

                <div class="col-xl-3 col-md-6">
                    <div class="an-kpi-card">
                        <div class="d-flex align-items-start justify-content-between mb-3">
                            <div>
                                <div class="an-kpi-label">Tổng GMV toàn sàn</div>
                                <div class="an-kpi-value text-danger">
                                    <fmt:formatNumber value="${totalGmv}" type="number"/>
                                    <small>₫</small>
                                </div>
                            </div>
                            <div class="an-kpi-icon red"><i class="fa-solid fa-sack-dollar"></i></div>
                        </div>
                        <div class="an-kpi-sub">${periodLabel}</div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6">
                    <div class="an-kpi-card">
                        <div class="d-flex align-items-start justify-content-between mb-3">
                            <div>
                                <div class="an-kpi-label">Hoa hồng sàn (${commissionRate}%)</div>
                                <div class="an-kpi-value text-primary">
                                    <fmt:formatNumber value="${commissionRevenue}" type="number"/>
                                    <small>₫</small>
                                </div>
                            </div>
                            <div class="an-kpi-icon blue"><i class="fa-solid fa-percent"></i></div>
                        </div>
                        <div class="an-kpi-sub">Ước tính từ GMV</div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6">
                    <div class="an-kpi-card">
                        <div class="d-flex align-items-start justify-content-between mb-3">
                            <div>
                                <div class="an-kpi-label">Đơn thành công</div>
                                <div class="an-kpi-value text-success">
                                    <fmt:formatNumber value="${successfulBookings}" type="number"/>
                                    <small>đơn</small>
                                </div>
                            </div>
                            <div class="an-kpi-icon green"><i class="fa-solid fa-circle-check"></i></div>
                        </div>
                        <div class="an-kpi-sub">
                            Đã hủy:&nbsp;
                            <span class="badge-cancel">${cancelledBookings} đơn<c:if test="${cancelRate > 0}">&nbsp;(${cancelRate}%)</c:if></span>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6">
                    <div class="an-kpi-card">
                        <div class="d-flex align-items-start justify-content-between mb-3">
                            <div>
                                <div class="an-kpi-label">Tổng quan nền tảng</div>
                                <div class="an-kpi-value" style="font-size:1.05rem;">
                                    <span class="text-primary">${activeHomestays}</span><small style="font-size:.68rem;"> HS</small>
                                    &nbsp;·&nbsp;<span class="text-warning">${totalOwners}</span><small style="font-size:.68rem;"> CĐ</small>
                                    &nbsp;·&nbsp;<span class="text-success">${totalCustomers}</span><small style="font-size:.68rem;"> KH</small>
                                </div>
                            </div>
                            <div class="an-kpi-icon purple"><i class="fa-solid fa-building"></i></div>
                        </div>
                        <div class="an-kpi-sub"><i class="fa-solid fa-house me-1 text-primary"></i>Homestay · Chủ đầu tư · Khách hàng</div>
                    </div>
                </div>
            </div>

            <%-- ── Row 1: Main Revenue Chart ─────────────────────────────── --%>
            <div class="row g-3 mb-3">
                <div class="col-12">
                    <div class="an-chart-card">
                        <div class="d-flex align-items-start justify-content-between">
                            <div>
                                <div class="an-chart-title">
                                    <i class="fa-solid fa-chart-column text-danger me-2"></i>Doanh thu &amp; Số đơn đặt phòng
                                </div>
                                <div class="an-chart-sub">${periodLabel}</div>
                            </div>
                            <div class="d-flex gap-3 align-items-center" style="font-size:.75rem;color:#6b7280;">
                                <span><span class="an-legend-dot" style="background:#ef4444;"></span>GMV</span>
                                <span><span class="an-legend-dot" style="background:#6366f1;"></span>Số đơn</span>
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
                                <div style="height:280px;"><canvas id="chartRevenue"></canvas></div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <%-- ── Row 2: 4 mini charts ───────────────────────────────────── --%>
            <div class="row g-3">

                <div class="col-xl-3 col-md-6">
                    <div class="an-chart-card">
                        <div class="an-chart-title"><i class="fa-solid fa-circle-half-stroke me-2" style="color:#6366f1;"></i>Trạng thái đặt phòng</div>
                        <div class="an-chart-sub">${periodLabel}</div>
                        <div style="height:200px;"><canvas id="chartStatus"></canvas></div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6">
                    <div class="an-chart-card">
                        <div class="an-chart-title"><i class="fa-solid fa-credit-card me-2 text-warning"></i>Phương thức thanh toán</div>
                        <div class="an-chart-sub">Giao dịch thành công</div>
                        <div style="height:200px;"><canvas id="chartPayment"></canvas></div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6">
                    <div class="an-chart-card">
                        <div class="an-chart-title"><i class="fa-solid fa-trophy me-2 text-warning"></i>Top Homestay doanh thu</div>
                        <div class="an-chart-sub">${periodLabel}</div>
                        <div id="topHomestayList"></div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6">
                    <div class="an-chart-card">
                        <div class="an-chart-title"><i class="fa-solid fa-user-plus me-2 text-success"></i>Khách hàng mới</div>
                        <div class="an-chart-sub">6 tháng gần nhất</div>
                        <div style="height:200px;"><canvas id="chartNewUsers"></canvas></div>
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

    var COLORS = ['#6366f1','#22c55e','#f97316','#ef4444','#a855f7','#06b6d4','#eab308','#ec4899'];
    var PAY_COLORS = { 'VNPAY':'#006fe6', 'MOMO':'#ae2070', 'CASH':'#22c55e', 'POS_CARD':'#f97316' };
    var STATUS_VI  = { 'PENDING':'Chờ xác nhận','CONFIRMED':'Đã xác nhận',
                       'CHECKED_IN':'Đang ở','CHECKED_OUT':'Hoàn thành',
                       'CANCELLED':'Đã hủy','REFUNDED':'Hoàn tiền' };

    var TOOLTIP_OPTS = {
        backgroundColor:'#1f2937', titleColor:'#f9fafb', bodyColor:'#d1d5db',
        padding:10, cornerRadius:8
    };

    // ── Chart 1: Revenue bar + count line ──────────────────────────────────
    var ctxRev = document.getElementById('chartRevenue');
    var revLabels = safeJson('${chartLabels}');
    var revGmv    = safeJson('${chartGmv}');
    var revCnts   = safeJson('${chartCounts}');
    if (ctxRev && revLabels.length) {
        new Chart(ctxRev, {
            data: {
                labels: revLabels,
                datasets: [
                    { type:'bar',  label:'GMV (₫)', data:revGmv,
                      backgroundColor:'rgba(239,68,68,.75)', hoverBackgroundColor:'rgba(239,68,68,.95)',
                      borderRadius:6, borderSkipped:false, yAxisID:'yGmv', order:2 },
                    { type:'line', label:'Số đơn',  data:revCnts,
                      borderColor:'#6366f1', backgroundColor:'rgba(99,102,241,.08)',
                      pointBackgroundColor:'#6366f1', pointRadius:5, pointHoverRadius:7,
                      tension:0.35, fill:true, yAxisID:'yCnt', order:1 }
                ]
            },
            options: {
                responsive:true, maintainAspectRatio:false,
                interaction:{ mode:'index', intersect:false },
                plugins: {
                    legend:{ display:false },
                    tooltip:{ ...TOOLTIP_OPTS,
                        callbacks:{ label:function(c){
                            return c.dataset.yAxisID==='yGmv'
                                ? '  GMV: '+Number(c.parsed.y).toLocaleString('vi-VN')+' ₫'
                                : '  Đơn: '+c.parsed.y;
                        }}
                    }
                },
                scales: {
                    yGmv:{ position:'left',  grid:{color:'rgba(0,0,0,.05)'}, ticks:{callback:fmtShort, font:{size:11}, color:'#9ca3af'} },
                    yCnt:{ position:'right', grid:{drawOnChartArea:false},   ticks:{stepSize:1, font:{size:11}, color:'#6366f1'} },
                    x:   { grid:{display:false}, ticks:{font:{size:11}, color:'#6b7280'} }
                }
            }
        });
    }

    // ── Chart 2: Booking status donut ──────────────────────────────────────
    var ctxSt = document.getElementById('chartStatus');
    var stLabels = safeJson('${statusLabels}').map(function(s){return STATUS_VI[s]||s;});
    var stData   = safeJson('${statusData}');
    if (ctxSt && stLabels.length) {
        new Chart(ctxSt, {
            type:'doughnut',
            data:{ labels:stLabels, datasets:[{ data:stData, backgroundColor:COLORS, borderWidth:2, borderColor:'#fff', hoverOffset:6 }] },
            options:{ responsive:true, maintainAspectRatio:false, cutout:'65%',
                plugins:{ legend:{ position:'bottom', labels:{font:{size:10},padding:8,boxWidth:10,color:'#6b7280'} },
                          tooltip:{ ...TOOLTIP_OPTS } } }
        });
    }

    // ── Chart 3: Payment method donut ──────────────────────────────────────
    var ctxPay = document.getElementById('chartPayment');
    var payLabels = safeJson('${paymentLabels}');
    var payData   = safeJson('${paymentData}');
    if (ctxPay && payLabels.length) {
        var payColors = payLabels.map(function(m){return PAY_COLORS[m]||'#9ca3af';});
        new Chart(ctxPay, {
            type:'doughnut',
            data:{ labels:payLabels, datasets:[{ data:payData, backgroundColor:payColors, borderWidth:2, borderColor:'#fff', hoverOffset:6 }] },
            options:{ responsive:true, maintainAspectRatio:false, cutout:'65%',
                plugins:{ legend:{ position:'bottom', labels:{font:{size:10},padding:8,boxWidth:10,color:'#6b7280'} },
                          tooltip:{ ...TOOLTIP_OPTS } } }
        });
    }

    // ── Top Homestays list ─────────────────────────────────────────────────
    var hsLabels  = safeJson('${topHsLabels}');
    var hsRevenue = safeJson('${topHsRevenue}');
    var container = document.getElementById('topHomestayList');
    if (container && hsLabels.length) {
        var maxRev = hsRevenue[0] || 1;
        var rankCls = ['rank-1','rank-2','rank-3'];
        var html = '';
        for (var i = 0; i < hsLabels.length; i++) {
            var pct = Math.round(hsRevenue[i] / maxRev * 100);
            var cls = rankCls[i] || 'rank-n';
            html += '<div class="an-hs-row">'
                  + '<div class="an-hs-rank '+cls+'">'+(i+1)+'</div>'
                  + '<div class="an-hs-name" title="'+hsLabels[i]+'">'+hsLabels[i]+'</div>'
                  + '<div class="an-hs-bar-wrap"><div class="an-hs-bar" style="width:'+pct+'%;"></div></div>'
                  + '<div class="an-hs-rev">'+fmtShort(hsRevenue[i])+'</div>'
                  + '</div>';
        }
        container.innerHTML = html;
    } else if (container) {
        container.innerHTML = '<div class="text-center text-muted py-4" style="font-size:.8rem;">Chưa có dữ liệu</div>';
    }

    // ── Chart 4: New users line ────────────────────────────────────────────
    var ctxUsr = document.getElementById('chartNewUsers');
    var uLabels = safeJson('${userLabels}');
    var uData   = safeJson('${userData}');
    if (ctxUsr && uLabels.length) {
        new Chart(ctxUsr, {
            type:'line',
            data:{ labels:uLabels, datasets:[{
                label:'Khách mới', data:uData,
                borderColor:'#22c55e', backgroundColor:'rgba(34,197,94,.1)',
                pointBackgroundColor:'#22c55e', pointRadius:5, pointHoverRadius:7,
                tension:0.35, fill:true
            }]},
            options:{
                responsive:true, maintainAspectRatio:false,
                plugins:{ legend:{display:false},
                    tooltip:{ ...TOOLTIP_OPTS, callbacks:{label:function(c){return '  '+c.parsed.y+' khách mới';}} } },
                scales:{
                    y:{ beginAtZero:true, grid:{color:'rgba(0,0,0,.05)'}, ticks:{stepSize:1,font:{size:11},color:'#9ca3af'} },
                    x:{ grid:{display:false}, ticks:{font:{size:10},color:'#6b7280'} }
                }
            }
        });
    }

})();
</script>

<jsp:include page="../common/footer.jsp"/>
