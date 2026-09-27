<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle"      value="Doanh thu &amp; Thống kê" scope="request"/>
<c:set var="pageBreadcrumb" value="Vận hành &amp; Báo cáo"   scope="request"/>
<jsp:include page="../common/header.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

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
                    <!-- Homestay filter -->
                    <select id="homestayFilter" class="form-select form-select-sm" style="width:auto;">
                        <option value="all">Tất cả cơ sở</option>
                        <option value="1">Ocean Breeze Luxury</option>
                        <option value="2">Dalat Pine Forest Villa</option>
                    </select>
                    <!-- Month filter -->
                    <select id="monthFilter" class="form-select form-select-sm" style="width:auto;">
                        <option value="9">Tháng 9 / 2026</option>
                        <option value="8">Tháng 8 / 2026</option>
                        <option value="7">Tháng 7 / 2026</option>
                        <option value="6">Tháng 6 / 2026</option>
                    </select>
                    <!-- Export -->
                    <form method="get" action="${pageContext.request.contextPath}/owner/analytics" style="display:inline;">
                        <input type="hidden" name="export" value="excel">
                        <input type="hidden" id="exportMonth" name="month" value="9">
                        <button type="submit" class="btn btn-outline-success btn-sm rounded-3 fw-semibold">
                            <i class="fa-solid fa-file-excel me-1 text-success"></i>Xuất Excel
                        </button>
                    </form>
                </div>
            </div>

            <!-- KPI Cards — 4 metrics -->
            <div class="row g-3 mb-4">
                <div class="col-sm-6 col-xl-3">
                    <div class="owner-card" style="border-left:4px solid #6366f1;">
                        <div class="kpi-label">Tổng Doanh thu tháng</div>
                        <div class="kpi-value text-primary" id="kpiRevenue">128.500.000 ₫</div>
                        <div class="kpi-trend text-success">
                            <i class="fa-solid fa-arrow-trend-up"></i> +18.4% so với tháng trước
                        </div>
                    </div>
                </div>
                <div class="col-sm-6 col-xl-3">
                    <div class="owner-card" style="border-left:4px solid #10b981;">
                        <div class="kpi-label">Tỷ lệ Lấp đầy (Occupancy)</div>
                        <div class="kpi-value text-success" id="kpiOccupancy">84.2%</div>
                        <div class="kpi-trend text-success">
                            <i class="fa-solid fa-arrow-trend-up"></i> +5.2% so với trung bình khu vực
                        </div>
                    </div>
                </div>
                <div class="col-sm-6 col-xl-3">
                    <div class="owner-card" style="border-left:4px solid #06b6d4;">
                        <div class="kpi-label">Giá trung bình / đêm (ADR)</div>
                        <div class="kpi-value text-info" id="kpiAdr">1.120.000 ₫</div>
                        <div class="kpi-trend text-muted">
                            <i class="fa-solid fa-moon"></i> 115 lượt lưu trú
                        </div>
                    </div>
                </div>
                <div class="col-sm-6 col-xl-3">
                    <div class="owner-card" style="border-left:4px solid #f59e0b;">
                        <div class="kpi-label">RevPAR (Doanh thu / Phòng)</div>
                        <div class="kpi-value text-warning" id="kpiRevpar">943.000 ₫</div>
                        <div class="kpi-trend text-muted">
                            <i class="fa-solid fa-calculator"></i> ADR × Occupancy
                        </div>
                    </div>
                </div>
            </div>

            <!-- Revenue Chart -->
            <div class="owner-card mb-4">
                <div class="d-flex align-items-center justify-content-between mb-3 flex-wrap gap-2">
                    <h6 class="fw-bold mb-0">
                        <i class="fa-solid fa-chart-line text-primary me-2"></i>Tăng trưởng doanh thu 6 tháng gần nhất
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
                <div style="height:300px; position:relative;">
                    <canvas id="revenueChart"></canvas>
                </div>
            </div>

            <!-- Bottom row -->
            <div class="row g-3 mb-4">
                <!-- Top Homestays -->
                <div class="col-lg-5">
                    <div class="owner-card h-100">
                        <h6 class="fw-bold mb-3">
                            <i class="fa-solid fa-trophy text-warning me-2"></i>Top Cơ sở theo Doanh thu
                        </h6>
                        <div class="d-flex align-items-center justify-content-between py-2 border-bottom gap-2">
                            <div class="d-flex align-items-center gap-2 min-width-0">
                                <span class="badge bg-primary rounded-circle flex-shrink-0"
                                      style="width:24px;height:24px;display:flex;align-items:center;justify-content:center;font-size:.75rem;">1</span>
                                <span class="fw-semibold text-truncate" style="font-size:.88rem;">Ocean Breeze Luxury</span>
                            </div>
                            <span class="fw-bold text-primary flex-shrink-0" style="font-size:.88rem;">98.200.000 ₫</span>
                        </div>
                        <div class="mb-1 mt-1" style="height:6px;background:#eef2ff;border-radius:4px;">
                            <div style="height:100%;width:76%;background:#6366f1;border-radius:4px;"></div>
                        </div>
                        <div class="d-flex align-items-center justify-content-between py-2 gap-2">
                            <div class="d-flex align-items-center gap-2 min-width-0">
                                <span class="badge bg-secondary rounded-circle flex-shrink-0"
                                      style="width:24px;height:24px;display:flex;align-items:center;justify-content:center;font-size:.75rem;">2</span>
                                <span class="fw-semibold text-truncate" style="font-size:.88rem;">Dalat Pine Forest Villa</span>
                            </div>
                            <span class="fw-bold text-secondary flex-shrink-0" style="font-size:.88rem;">30.300.000 ₫</span>
                        </div>
                        <div style="height:6px;background:#f1f5f9;border-radius:4px;">
                            <div style="height:100%;width:24%;background:#94a3b8;border-radius:4px;"></div>
                        </div>
                    </div>
                </div>

                <!-- Channel donut -->
                <div class="col-lg-4">
                    <div class="owner-card h-100">
                        <h6 class="fw-bold mb-3">
                            <i class="fa-solid fa-chart-donut text-info me-2"></i>Tỷ lệ đặt phòng theo kênh
                        </h6>
                        <div style="height:160px; position:relative;">
                            <canvas id="channelChart"></canvas>
                        </div>
                    </div>
                </div>

                <!-- Quick stats -->
                <div class="col-lg-3">
                    <div class="owner-card h-100 d-flex flex-column gap-3">
                        <h6 class="fw-bold mb-0">
                            <i class="fa-solid fa-bolt text-warning me-2"></i>Tháng này
                        </h6>
                        <div class="d-flex justify-content-between align-items-center py-2 border-bottom">
                            <span class="text-muted" style="font-size:.82rem;">Đặt phòng mới</span>
                            <span class="fw-bold text-primary">47</span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center py-2 border-bottom">
                            <span class="text-muted" style="font-size:.82rem;">Đã check-in</span>
                            <span class="fw-bold text-success">38</span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center py-2 border-bottom">
                            <span class="text-muted" style="font-size:.82rem;">Đã check-out</span>
                            <span class="fw-bold">31</span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center py-2 border-bottom">
                            <span class="text-muted" style="font-size:.82rem;">Hủy phòng</span>
                            <span class="fw-bold text-danger">3</span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center py-2">
                            <span class="text-muted" style="font-size:.82rem;">Đánh giá mới</span>
                            <span class="fw-bold text-warning">
                                <i class="fa-solid fa-star me-1" style="font-size:.75rem;"></i>12
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
                            <tr>
                                <td class="ps-4">
                                    <div class="d-flex align-items-center gap-2">
                                        <div style="width:32px;height:32px;border-radius:50%;background:linear-gradient(135deg,#6366f1,#8b5cf6);display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:.8rem;flex-shrink:0;">N</div>
                                        <span class="fw-semibold" style="font-size:.85rem;">Nguyễn Văn A</span>
                                    </div>
                                </td>
                                <td style="font-size:.85rem;">Ocean Breeze Luxury</td>
                                <td style="font-size:.85rem;">20/09/2026</td>
                                <td style="font-size:.85rem;">23/09/2026</td>
                                <td class="fw-semibold" style="font-size:.85rem;">3.360.000 ₫</td>
                                <td><span class="badge bg-success-subtle text-success border border-success px-2">Hoàn thành</span></td>
                                <td class="pe-4">
                                    <span class="text-warning" style="font-size:.82rem;">
                                        <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i>
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <td class="ps-4">
                                    <div class="d-flex align-items-center gap-2">
                                        <div style="width:32px;height:32px;border-radius:50%;background:linear-gradient(135deg,#10b981,#059669);display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:.8rem;flex-shrink:0;">T</div>
                                        <span class="fw-semibold" style="font-size:.85rem;">Trần Thị B</span>
                                    </div>
                                </td>
                                <td style="font-size:.85rem;">Ocean Breeze Luxury</td>
                                <td style="font-size:.85rem;">22/09/2026</td>
                                <td style="font-size:.85rem;">25/09/2026</td>
                                <td class="fw-semibold" style="font-size:.85rem;">2.400.000 ₫</td>
                                <td><span class="badge bg-primary-subtle text-primary border border-primary px-2">Đang ở</span></td>
                                <td class="pe-4 text-muted" style="font-size:.82rem;">—</td>
                            </tr>
                            <tr>
                                <td class="ps-4">
                                    <div class="d-flex align-items-center gap-2">
                                        <div style="width:32px;height:32px;border-radius:50%;background:linear-gradient(135deg,#f59e0b,#d97706);display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:.8rem;flex-shrink:0;">L</div>
                                        <span class="fw-semibold" style="font-size:.85rem;">Lê Minh C</span>
                                    </div>
                                </td>
                                <td style="font-size:.85rem;">Dalat Pine Forest Villa</td>
                                <td style="font-size:.85rem;">25/09/2026</td>
                                <td style="font-size:.85rem;">27/09/2026</td>
                                <td class="fw-semibold" style="font-size:.85rem;">1.600.000 ₫</td>
                                <td><span class="badge bg-warning-subtle text-warning border border-warning px-2">Sắp đến</span></td>
                                <td class="pe-4 text-muted" style="font-size:.82rem;">—</td>
                            </tr>
                            <tr>
                                <td class="ps-4">
                                    <div class="d-flex align-items-center gap-2">
                                        <div style="width:32px;height:32px;border-radius:50%;background:linear-gradient(135deg,#ef4444,#dc2626);display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:.8rem;flex-shrink:0;">P</div>
                                        <span class="fw-semibold" style="font-size:.85rem;">Phạm Thị D</span>
                                    </div>
                                </td>
                                <td style="font-size:.85rem;">Ocean Breeze Luxury</td>
                                <td style="font-size:.85rem;">18/09/2026</td>
                                <td style="font-size:.85rem;">20/09/2026</td>
                                <td class="fw-semibold" style="font-size:.85rem;">1.600.000 ₫</td>
                                <td><span class="badge bg-danger-subtle text-danger border border-danger px-2">Đã hủy</span></td>
                                <td class="pe-4 text-muted" style="font-size:.82rem;">—</td>
                            </tr>
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
    font-size: 1.65rem;
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
var revenueChart;

// Dataset per month (mock data) — keys: month OR "month_homestayId"
var monthData = {
    // Tất cả cơ sở
    9: [85000000, 92000000, 110000000, 105000000, 128500000, 140000000],
    8: [75000000, 82000000,  98000000, 102000000, 115000000, 120000000],
    7: [68000000, 74000000,  88000000,  95000000, 102000000, 110000000],
    6: [60000000, 65000000,  79000000,  85000000,  94000000,  98000000],
    // Ocean Breeze Luxury (id=1) ~76% doanh thu
    '9_1': [64000000, 70000000,  84000000,  80000000,  98000000, 107000000],
    '8_1': [57000000, 62000000,  74000000,  78000000,  87000000,  91000000],
    '7_1': [52000000, 56000000,  67000000,  72000000,  78000000,  84000000],
    '6_1': [46000000, 50000000,  60000000,  65000000,  72000000,  75000000],
    // Dalat Pine Forest Villa (id=2) ~24% doanh thu
    '9_2': [21000000, 22000000, 26000000, 25000000, 30500000, 33000000],
    '8_2': [18000000, 20000000, 24000000, 24000000, 28000000, 29000000],
    '7_2': [16000000, 18000000, 21000000, 23000000, 24000000, 26000000],
    '6_2': [14000000, 15000000, 19000000, 20000000, 22000000, 23000000]
};

var kpiData = {
    // Tất cả cơ sở
    9:     { revenue: '128.500.000 ₫', occ: '84.2%', adr: '1.120.000 ₫', revpar:   '943.000 ₫' },
    8:     { revenue: '115.000.000 ₫', occ: '79.5%', adr: '1.050.000 ₫', revpar:   '835.000 ₫' },
    7:     { revenue: '102.000.000 ₫', occ: '74.1%', adr:   '980.000 ₫', revpar:   '726.000 ₫' },
    6:     { revenue:  '94.000.000 ₫', occ: '69.8%', adr:   '920.000 ₫', revpar:   '642.000 ₫' },
    // Ocean Breeze Luxury
    '9_1': { revenue:  '98.200.000 ₫', occ: '88.0%', adr: '1.200.000 ₫', revpar: '1.056.000 ₫' },
    '8_1': { revenue:  '87.000.000 ₫', occ: '83.3%', adr: '1.130.000 ₫', revpar:   '941.000 ₫' },
    '7_1': { revenue:  '78.000.000 ₫', occ: '78.7%', adr: '1.070.000 ₫', revpar:   '842.000 ₫' },
    '6_1': { revenue:  '72.000.000 ₫', occ: '73.3%', adr: '1.010.000 ₫', revpar:   '740.000 ₫' },
    // Dalat Pine Forest Villa
    '9_2': { revenue:  '30.300.000 ₫', occ: '75.0%', adr:   '900.000 ₫', revpar:   '675.000 ₫' },
    '8_2': { revenue:  '28.000.000 ₫', occ: '70.8%', adr:   '860.000 ₫', revpar:   '609.000 ₫' },
    '7_2': { revenue:  '24.000.000 ₫', occ: '62.5%', adr:   '800.000 ₫', revpar:   '500.000 ₫' },
    '6_2': { revenue:  '22.000.000 ₫', occ: '58.3%', adr:   '750.000 ₫', revpar:   '437.000 ₫' }
};

document.addEventListener('DOMContentLoaded', function () {

    // ── Revenue chart ────────────────────────────────────────────
    var ctxRevenue = document.getElementById('revenueChart').getContext('2d');
    revenueChart = new Chart(ctxRevenue, {
        type: 'line',
        data: buildRevenueData(monthData[9]),
        options: revenueOptions()
    });

    // ── Channel donut ────────────────────────────────────────────
    new Chart(document.getElementById('channelChart').getContext('2d'), {
        type: 'doughnut',
        data: {
            labels: ['Smart Booking', 'Trực tiếp', 'Giới thiệu'],
            datasets: [{
                data: [68, 22, 10],
                backgroundColor: ['#6366f1', '#10b981', '#f59e0b'],
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

    // ── Month & Homestay filter ───────────────────────────────────
    function applyFilters() {
        var m  = parseInt(document.getElementById('monthFilter').value);
        var hs = document.getElementById('homestayFilter').value;

        // Pick dataset key = "month_homestay" or fall back to month only
        var key  = m + '_' + hs;
        var data = monthData[key] || monthData[m] || monthData[9];

        var kpiKey = m + '_' + hs;
        var kpi    = kpiData[kpiKey] || kpiData[m] || kpiData[9];

        document.getElementById('kpiRevenue').textContent   = kpi.revenue;
        document.getElementById('kpiOccupancy').textContent = kpi.occ;
        document.getElementById('kpiAdr').textContent       = kpi.adr;
        document.getElementById('kpiRevpar').textContent    = kpi.revpar;
        document.getElementById('exportMonth').value        = m;

        revenueChart.data.datasets[0].data = data;
        revenueChart.update();
    }

    document.getElementById('monthFilter').addEventListener('change', applyFilters);
    document.getElementById('homestayFilter').addEventListener('change', applyFilters);
});

// ── Chart type switcher ───────────────────────────────────────────
function switchChart(type) {
    if (!revenueChart) return;
    var currentData = revenueChart.data.datasets[0].data;
    revenueChart.destroy();
    var ctx = document.getElementById('revenueChart').getContext('2d');
    revenueChart = new Chart(ctx, {
        type: type,
        data: buildRevenueData(currentData, type),
        options: revenueOptions(type)
    });
    // Update button states
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
        labels: ['Tháng 4', 'Tháng 5', 'Tháng 6', 'Tháng 7', 'Tháng 8', 'Tháng 9'],
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
                    callback: function (v) { return (v / 1000000).toFixed(0) + 'M'; },
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
