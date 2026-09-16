<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<div class="container-fluid px-4 py-4">
    <div class="row">
        <!-- Sidebar Navigation -->
        <div class="col-lg-3">
            <jsp:include page="../common/sidebar-owner.jsp"/>
        </div>

        <!-- Main Content Area -->
        <div class="col-lg-9">
            <div class="card border-0 shadow-sm rounded-4 p-4 mb-4">
                <div class="d-flex align-items-center justify-content-between mb-4 border-bottom pb-3">
                    <div>
                        <h4 class="fw-bold mb-1 text-dark"><i class="fa-solid fa-chart-pie text-primary me-2"></i>UC20: Báo cáo Doanh thu & Tỷ lệ Lấp đầy (Occupancy %)</h4>
                        <p class="text-muted mb-0">Thống kê chỉ số ADR, RevPAR và xuất báo cáo tài chính bằng Apache POI (.xlsx)</p>
                    </div>
                    <button class="btn btn-outline-success btn-sm rounded-pill fw-semibold">
                        <i class="fa-solid fa-file-excel me-1 text-success"></i> Xuất file Excel (.xlsx) POI
                    </button>
                </div>

                <!-- KPI Metric Cards -->
                <div class="row g-3 mb-4">
                    <div class="col-md-4">
                        <div class="card border-0 bg-primary-subtle rounded-4 p-3">
                            <span class="text-primary small fw-semibold">TỔNG DOANH THU THÁNG</span>
                            <h3 class="fw-bold text-primary mb-0 mt-1">128.500.000 ₫</h3>
                            <small class="text-success mt-1 d-block"><i class="fa-solid fa-arrow-trend-up me-1"></i>+18.4% so với tháng trước</small>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="card border-0 bg-success-subtle rounded-4 p-3">
                            <span class="text-success small fw-semibold">TỶ LỆ LẤP ĐẦY (OCCUPANCY RATE)</span>
                            <h3 class="fw-bold text-success mb-0 mt-1">84.2 %</h3>
                            <small class="text-success mt-1 d-block"><i class="fa-solid fa-arrow-trend-up me-1"></i>+5.2% so với trung bình khu vực</small>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="card border-0 bg-info-subtle rounded-4 p-3">
                            <span class="text-info small fw-semibold">GIÁ TRUNG BÌNH/ĐÊM (ADR)</span>
                            <h3 class="fw-bold text-info mb-0 mt-1">1.120.000 ₫</h3>
                            <small class="text-muted mt-1 d-block">115 lượt lưu trú thành công</small>
                        </div>
                    </div>
                </div>

                <!-- Chart.js Canvas -->
                <div class="card border rounded-4 p-3">
                    <h6 class="fw-bold mb-3"><i class="fa-solid fa-chart-line text-primary me-2"></i>Biểu đồ tăng trưởng doanh thu 6 tháng gần nhất</h6>
                    <div style="height: 300px;">
                        <canvas id="revenueChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function() {
    const ctx = document.getElementById('revenueChart').getContext('2d');
    new Chart(ctx, {
        type: 'line',
        data: {
            labels: ['Tháng 5', 'Tháng 6', 'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10 (Dự kiến)'],
            datasets: [{
                label: 'Doanh thu (VNĐ)',
                data: [85000000, 92000000, 110000000, 105000000, 128500000, 140000000],
                borderColor: '#4f46e5',
                backgroundColor: 'rgba(79, 70, 229, 0.1)',
                fill: true,
                tension: 0.35
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false
        }
    });
});
</script>

<jsp:include page="../common/footer.jsp"/>
