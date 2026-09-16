<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

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
                        <h4 class="fw-bold mb-1 text-dark"><i class="fa-regular fa-calendar-days text-primary me-2"></i>UC18: Lịch bán phòng & Giá linh hoạt (Dynamic Pricing)</h4>
                        <p class="text-muted mb-0">Thiết lập điều chỉnh tăng/giảm giá theo ngày cuối tuần hoặc đóng/mở bán phòng</p>
                    </div>
                </div>

                <div class="alert alert-info rounded-3 mb-4">
                    <i class="fa-solid fa-lightbulb me-2"></i> Mẹo: Chọn khoảng ngày trên lịch để áp dụng công thức điều chỉnh giá linh hoạt (ví dụ: +25% giá vào thứ 7 & CN).
                </div>

                <!-- Calendar View Prototype -->
                <div class="table-responsive border rounded-4">
                    <table class="table table-bordered text-center align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>T2</th><th>T3</th><th>T4</th><th>T5</th><th>T6</th><th class="text-danger">T7</th><th class="text-danger">CN</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><span class="d-block fw-bold">1</span><small class="text-muted">800k</small></td>
                                <td><span class="d-block fw-bold">2</span><small class="text-muted">800k</small></td>
                                <td><span class="d-block fw-bold">3</span><small class="text-muted">800k</small></td>
                                <td><span class="d-block fw-bold">4</span><small class="text-muted">800k</small></td>
                                <td><span class="d-block fw-bold">5</span><small class="text-muted">800k</small></td>
                                <td class="table-warning"><span class="d-block fw-bold text-danger">6</span><small class="text-danger fw-bold">1.1M (+25%)</small></td>
                                <td class="table-warning"><span class="d-block fw-bold text-danger">7</span><small class="text-danger fw-bold">1.1M (+25%)</small></td>
                            </tr>
                            <tr>
                                <td><span class="d-block fw-bold">8</span><small class="text-muted">800k</small></td>
                                <td><span class="d-block fw-bold">9</span><small class="text-muted">800k</small></td>
                                <td><span class="d-block fw-bold">10</span><small class="text-muted">800k</small></td>
                                <td class="table-secondary"><span class="d-block fw-bold text-muted">11</span><small class="badge bg-secondary">Khóa phòng</small></td>
                                <td><span class="d-block fw-bold">12</span><small class="text-muted">800k</small></td>
                                <td class="table-warning"><span class="d-block fw-bold text-danger">13</span><small class="text-danger fw-bold">1.1M</small></td>
                                <td class="table-warning"><span class="d-block fw-bold text-danger">14</span><small class="text-danger fw-bold">1.1M</small></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>
