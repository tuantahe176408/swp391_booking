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
                        <h4 class="fw-bold mb-1 text-dark"><i class="fa-solid fa-square-check text-danger me-2"></i>UC23: Duyệt Đăng ký Cơ sở Homestay</h4>
                        <p class="text-muted mb-0">Thẩm định giấy phép pháp lý, ảnh HD và thông tin homestay trước khi xuất bản lên sàn</p>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>Homestay</th>
                                <th>Chủ nhà (Owner)</th>
                                <th>Địa chỉ</th>
                                <th>Ngày đăng ký</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=120&q=80" class="rounded-3" width="50" height="35" style="object-fit: cover;">
                                        <strong>Dalat Pine Forest Villa</strong>
                                    </div>
                                </td>
                                <td>Trần Văn Owner</td>
                                <td>Phường 10, Đà Lạt</td>
                                <td>16/09/2026</td>
                                <td><span class="badge bg-warning text-dark">PENDING_APPROVAL</span></td>
                                <td>
                                    <button class="btn btn-sm btn-success me-1"><i class="fa-solid fa-check me-1"></i> Phê duyệt</button>
                                    <button class="btn btn-sm btn-outline-danger"><i class="fa-solid fa-xmark me-1"></i> Từ chối</button>
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
