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
                        <h4 class="fw-bold mb-1 text-dark"><i class="fa-solid fa-bell-concierge text-primary me-2"></i>UC19: Danh mục Dịch vụ Bổ sung (Add-ons)</h4>
                        <p class="text-muted mb-0">Thiết lập các gói dịch vụ đi kèm khi khách đặt phòng (Cho thuê xe, nướng BBQ, ăn sáng...)</p>
                    </div>
                    <button class="btn btn-primary-custom btn-sm"><i class="fa-solid fa-plus me-1"></i> Thêm Dịch vụ Mới</button>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>Tên Dịch vụ</th>
                                <th>Mô tả</th>
                                <th>Đơn giá</th>
                                <th>Đơn vị tính</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><strong>Bữa sáng Buffet Á-Âu</strong></td>
                                <td>Bữa sáng tại nhà hàng view biển từ 6h30-9h30</td>
                                <td>150.000 VNĐ</td>
                                <td>Người / Ngày</td>
                                <td><span class="badge bg-success">Đang mở bán</span></td>
                                <td>
                                    <button class="btn btn-sm btn-outline-primary me-1">Sửa</button>
                                    <button class="btn btn-sm btn-outline-danger">Xóa</button>
                                </td>
                            </tr>
                            <tr>
                                <td><strong>Gói Setup Tiệc BBQ Ngoài trời</strong></td>
                                <td>Bao gồm bếp nướng, than hoa, bàn ghế và dụng cụ tiệc</td>
                                <td>350.000 VNĐ</td>
                                <td>Lượt / Đêm</td>
                                <td><span class="badge bg-success">Đang mở bán</span></td>
                                <td>
                                    <button class="btn btn-sm btn-outline-primary me-1">Sửa</button>
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
