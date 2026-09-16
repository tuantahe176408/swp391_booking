<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<div class="container-fluid px-4 py-4">
    <div class="row">
        <!-- Sidebar Navigation -->
        <div class="col-lg-3">
            <jsp:include page="../common/sidebar-admin.jsp"/>
        </div>

        <!-- Main Content Area -->
        <div class="col-lg-9">
            <div class="card border-0 shadow-sm rounded-4 p-4 mb-4">
                <div class="d-flex align-items-center justify-content-between mb-4 border-bottom pb-3">
                    <div>
                        <h4 class="fw-bold mb-1 text-dark"><i class="fa-solid fa-chart-line text-danger me-2"></i>UC25: Báo cáo Tài chính & Doanh thu Hoa hồng toàn sàn (GMV)</h4>
                        <p class="text-muted mb-0">Thống kê tổng giá trị giao dịch, lợi nhuận hoa hồng sàn và xuất file Excel đối soát (`PoiReportUtil`)</p>
                    </div>
                    <button class="btn btn-outline-success btn-sm rounded-pill fw-semibold">
                        <i class="fa-solid fa-file-excel me-1 text-success"></i> Xuất Báo cáo Tài chính (.xlsx)
                    </button>
                </div>

                <!-- KPI Metric Cards -->
                <div class="row g-3 mb-4">
                    <div class="col-md-4">
                        <div class="card border-0 bg-danger-subtle rounded-4 p-3">
                            <span class="text-danger small fw-semibold">TỔNG GMV DỊCH VỤ TOÀN SÀN</span>
                            <h3 class="fw-bold text-danger mb-0 mt-1">2.450.000.000 ₫</h3>
                            <small class="text-success mt-1 d-block"><i class="fa-solid fa-arrow-trend-up me-1"></i>+24.5% tăng trưởng YoY</small>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="card border-0 bg-primary-subtle rounded-4 p-3">
                            <span class="text-primary small fw-semibold">DOANH THU HOA HỒNG SÀN (8.5%)</span>
                            <h3 class="fw-bold text-primary mb-0 mt-1">208.250.000 ₫</h3>
                            <small class="text-muted mt-1 d-block">Lợi nhuận gộp đã khấu trừ</small>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="card border-0 bg-success-subtle rounded-4 p-3">
                            <span class="text-success small fw-semibold">TỔNG BOOKINGS THÀNH CÔNG</span>
                            <h3 class="fw-bold text-success mb-0 mt-1">1.840 Đơn</h3>
                            <small class="text-success mt-1 d-block">Tỷ lệ hoàn hủy đơn &lt; 3.2%</small>
                        </div>
                    </div>
                </div>

                <!-- Chart.js Canvas -->
                <div class="card border rounded-4 p-3">
                    <h6 class="fw-bold mb-3"><i class="fa-solid fa-chart-area text-danger me-2"></i>Biểu đồ Tăng trưởng Doanh thu Sàn năm 2026</h6>
                    <div style="height: 300px;">
                        <canvas id="adminChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function() {
    const ctx = document.getElementById('adminChart').getContext('2d');
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['Q1', 'Q2', 'Q3', 'Q4 (Dự báo)'],
            datasets: [{
                label: 'Doanh thu Hoa hồng (VNĐ)',
                data: [42000000, 58000000, 68000000, 80000000],
                backgroundColor: '#ef4444',
                borderRadius: 8
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
