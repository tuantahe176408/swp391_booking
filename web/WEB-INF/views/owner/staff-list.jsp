<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle"      value="Nhân viên Lễ tân"     scope="request"/>
<c:set var="pageBreadcrumb" value="Vận hành &amp; Báo cáo" scope="request"/>
<jsp:include page="../common/header.jsp"/>

<div class="owner-shell">
    <jsp:include page="../common/sidebar-owner.jsp"/>

    <div class="owner-main">
        <jsp:include page="../common/owner-topbar.jsp"/>

        <div class="owner-content">

            <!-- Page Header -->
            <div class="owner-page-header">
                <div class="owner-page-header__info">
                    <h2><i class="fa-solid fa-user-gear text-primary me-2"></i>Quản lý Nhân viên Lễ tân</h2>
                    <p>Cấp tài khoản lễ tân, phân công cơ sở và gửi email kích hoạt tự động</p>
                </div>
                <button class="btn btn-primary-custom btn-sm px-4">
                    <i class="fa-solid fa-user-plus me-1"></i> Tạo Tài khoản Lễ tân Mới
                </button>
            </div>

            <!-- Stats -->
            <div class="row g-3 mb-4">
                <div class="col-sm-4">
                    <div class="owner-card d-flex align-items-center gap-3 p-3">
                        <div style="width:44px;height:44px;border-radius:12px;background:rgba(16,185,129,.1);display:flex;align-items:center;justify-content:center;font-size:1.2rem;color:#10b981;flex-shrink:0;">
                            <i class="fa-solid fa-user-check"></i>
                        </div>
                        <div>
                            <div class="fw-bold fs-4 lh-1">1</div>
                            <div class="text-muted" style="font-size:.8rem;">Đang hoạt động</div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="owner-card d-flex align-items-center gap-3 p-3">
                        <div style="width:44px;height:44px;border-radius:12px;background:rgba(99,102,241,.1);display:flex;align-items:center;justify-content:center;font-size:1.2rem;color:#6366f1;flex-shrink:0;">
                            <i class="fa-solid fa-building-user"></i>
                        </div>
                        <div>
                            <div class="fw-bold fs-4 lh-1">2</div>
                            <div class="text-muted" style="font-size:.8rem;">Cơ sở được quản lý</div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="owner-card d-flex align-items-center gap-3 p-3">
                        <div style="width:44px;height:44px;border-radius:12px;background:rgba(245,158,11,.1);display:flex;align-items:center;justify-content:center;font-size:1.2rem;color:#f59e0b;flex-shrink:0;">
                            <i class="fa-solid fa-envelope"></i>
                        </div>
                        <div>
                            <div class="fw-bold fs-4 lh-1">0</div>
                            <div class="text-muted" style="font-size:.8rem;">Chờ kích hoạt</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Staff Table -->
            <div class="owner-card p-0 overflow-hidden">
                <div class="d-flex align-items-center justify-content-between px-4 py-3 border-bottom">
                    <h6 class="fw-bold mb-0"><i class="fa-solid fa-list-ul me-2 text-primary"></i>Danh sách Nhân viên</h6>
                    <input type="search" class="form-control form-control-sm" placeholder="Tìm theo tên, email..." style="width:220px;">
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-4">Nhân viên</th>
                                <th>Email tài khoản</th>
                                <th>Cơ sở phân công</th>
                                <th>Trạng thái</th>
                                <th>Đăng nhập gần nhất</th>
                                <th class="pe-4">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="ps-4">
                                    <div class="d-flex align-items-center gap-2">
                                        <div style="width:38px;height:38px;border-radius:50%;background:linear-gradient(135deg,#6366f1,#8b5cf6);display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:.9rem;flex-shrink:0;">L</div>
                                        <div>
                                            <div class="fw-semibold" style="font-size:.88rem;">Lê Văn Lễ Tân</div>
                                            <div class="text-muted" style="font-size:.75rem;">Receptionist</div>
                                        </div>
                                    </div>
                                </td>
                                <td class="text-muted" style="font-size:.85rem;">letan1@oceanbreeze.com</td>
                                <td>
                                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle" style="font-size:.75rem;">
                                        Ocean Breeze Luxury
                                    </span>
                                </td>
                                <td>
                                    <span class="badge bg-success-subtle text-success border border-success px-2 py-1">
                                        <i class="fa-solid fa-circle me-1" style="font-size:.5rem;"></i>Hoạt động
                                    </span>
                                </td>
                                <td class="text-muted" style="font-size:.82rem;">
                                    <i class="fa-regular fa-clock me-1"></i>27/09/2026 08:14
                                </td>
                                <td class="pe-4">
                                    <div class="d-flex gap-2">
                                        <button class="btn btn-sm btn-outline-warning rounded-3">
                                            <i class="fa-solid fa-key me-1"></i>Reset
                                        </button>
                                        <button class="btn btn-sm btn-outline-danger rounded-3">Khóa</button>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <!-- Empty state hint -->
                <div class="px-4 py-3 border-top d-flex align-items-center justify-content-between">
                    <small class="text-muted">Hiển thị 1–1 / 1 nhân viên</small>
                    <a href="#" class="btn btn-sm btn-outline-primary rounded-3">
                        <i class="fa-solid fa-user-plus me-1"></i>Thêm nhân viên mới
                    </a>
                </div>
            </div>

        </div><!-- /.owner-content -->
    </div><!-- /.owner-main -->
</div><!-- /.owner-shell -->

<jsp:include page="../common/footer.jsp"/>
