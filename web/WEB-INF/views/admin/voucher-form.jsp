<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

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
                        <h4 class="fw-bold mb-1 text-dark"><i class="fa-solid fa-ticket text-danger me-2"></i>UC26: Chiến dịch Marketing & Mã giảm giá (Vouchers)</h4>
                        <p class="text-muted mb-0">Tạo mã khuyến mãi áp dụng toàn sàn do hệ thống phát hành và gửi email thông báo qua `EmailUtil`</p>
                    </div>
                    <button class="btn btn-danger btn-sm rounded-pill fw-semibold"><i class="fa-solid fa-plus me-1"></i> Tạo Mã Voucher Mới</button>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>Mã Voucher</th>
                                <th>Mức giảm</th>
                                <th>Đơn tối thiểu</th>
                                <th>Lượt phát hành</th>
                                <th>Hạn sử dụng</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><span class="badge bg-danger-subtle text-danger border border-danger px-3 py-2 font-monospace fs-6">SUMMER2026</span></td>
                                <td><strong>Giảm 15%</strong> (Tối đa 200.000₫)</td>
                                <td>1.000.000 VNĐ</td>
                                <td>150 / 500 lượt</td>
                                <td>30/11/2026</td>
                                <td><span class="badge bg-success">Đang phát hành</span></td>
                                <td>
                                    <button class="btn btn-sm btn-outline-secondary me-1">Tắt</button>
                                    <button class="btn btn-sm btn-outline-danger">Xóa</button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>
