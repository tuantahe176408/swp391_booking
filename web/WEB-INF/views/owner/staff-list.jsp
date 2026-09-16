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
                        <h4 class="fw-bold mb-1 text-dark"><i class="fa-solid fa-user-gear text-primary me-2"></i>UC21: Quản lý Nhân viên Lễ tân</h4>
                        <p class="text-muted mb-0">Cấp tài khoản RECEPTIONIST, mã hóa mật khẩu BCrypt và gửi Email kích hoạt (`EmailUtil`)</p>
                    </div>
                    <button class="btn btn-primary-custom btn-sm"><i class="fa-solid fa-user-plus me-1"></i> Tạo Tài khoản Lễ tân Mới</button>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>Họ và tên</th>
                                <th>Email tài khoản</th>
                                <th>Cơ sở phân công</th>
                                <th>Mật khẩu</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><strong>Lê Văn Lễ Tân</strong></td>
                                <td>letan1@oceanbreeze.com</td>
                                <td>Ocean Breeze Luxury Homestay</td>
                                <td><code>BCrypt (Secured)</code></td>
                                <td><span class="badge bg-success">Hoạt động</span></td>
                                <td>
                                    <button class="btn btn-sm btn-outline-warning me-1"><i class="fa-solid fa-key me-1"></i> Reset Pass</button>
                                    <button class="btn btn-sm btn-outline-danger">Khóa</button>
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
