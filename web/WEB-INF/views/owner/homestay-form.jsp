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
                        <h4 class="fw-bold mb-1 text-dark"><i class="fa-solid fa-building-user text-primary me-2"></i>UC17: Quản lý Cơ sở Homestay & Hạng phòng</h4>
                        <p class="text-muted mb-0">Đăng bán cơ sở mới, chỉnh sửa album ảnh HD và cấu hình các loại phòng</p>
                    </div>
                    <button class="btn btn-primary-custom btn-sm"><i class="fa-solid fa-plus me-1"></i> Đăng ký Homestay Mới</button>
                </div>

                <!-- Existing Homestays Table -->
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>Hình ảnh</th>
                                <th>Tên Homestay</th>
                                <th>Địa chỉ</th>
                                <th>Số lượng phòng</th>
                                <th>Trạng thái Phê duyệt</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>
                                    <img src="https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=120&q=80" class="rounded-3" width="60" height="40" style="object-fit: cover;">
                                </td>
                                <td><strong>Ocean Breeze Luxury Homestay</strong></td>
                                <td>Mỹ Khê, Sơn Trà, Đà Nẵng</td>
                                <td>15 Phòng</td>
                                <td><span class="badge bg-success-subtle text-success border border-success">Đã phê duyệt (ACTIVE)</span></td>
                                <td>
                                    <button class="btn btn-sm btn-outline-primary me-1"><i class="fa-solid fa-pen"></i> Sửa</button>
                                    <button class="btn btn-sm btn-outline-danger"><i class="fa-solid fa-trash"></i></button>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=120&q=80" class="rounded-3" width="60" height="40" style="object-fit: cover;">
                                </td>
                                <td><strong>Dalat Pine Forest Villa</strong></td>
                                <td>Phường 10, Đà Lạt</td>
                                <td>8 Phòng</td>
                                <td><span class="badge bg-warning-subtle text-warning border border-warning">Chờ Admin duyệt (PENDING)</span></td>
                                <td>
                                    <button class="btn btn-sm btn-outline-primary me-1"><i class="fa-solid fa-pen"></i> Sửa</button>
                                    <button class="btn btn-sm btn-outline-danger"><i class="fa-solid fa-trash"></i></button>
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
