<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle"      value="Cơ sở Homestay"       scope="request"/>
<c:set var="pageBreadcrumb" value="Quản lý Tài sản"       scope="request"/>
<jsp:include page="../common/header.jsp"/>

<div class="owner-shell">
    <jsp:include page="../common/sidebar-owner.jsp"/>

    <div class="owner-main">
        <jsp:include page="../common/owner-topbar.jsp"/>

        <div class="owner-content">

            <!-- Page Header -->
            <div class="owner-page-header">
                <div class="owner-page-header__info">
                    <h2><i class="fa-solid fa-building-user text-primary me-2"></i>Quản lý Cơ sở Homestay &amp; Hạng phòng</h2>
                    <p>Đăng bán cơ sở mới, chỉnh sửa album ảnh HD và cấu hình các loại phòng</p>
                </div>
                <button class="btn btn-primary-custom btn-sm px-4">
                    <i class="fa-solid fa-plus me-1"></i> Đăng ký Homestay Mới
                </button>
            </div>

            <!-- Stats Row -->
            <div class="row g-3 mb-4">
                <div class="col-sm-6 col-xl-3">
                    <div class="owner-card d-flex align-items-center gap-3 p-3">
                        <div style="width:44px;height:44px;border-radius:12px;background:rgba(99,102,241,.1);display:flex;align-items:center;justify-content:center;font-size:1.2rem;color:#6366f1;flex-shrink:0;">
                            <i class="fa-solid fa-building-user"></i>
                        </div>
                        <div>
                            <div class="fw-bold fs-4 lh-1">2</div>
                            <div class="text-muted" style="font-size:.8rem;">Cơ sở đã đăng</div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-6 col-xl-3">
                    <div class="owner-card d-flex align-items-center gap-3 p-3">
                        <div style="width:44px;height:44px;border-radius:12px;background:rgba(16,185,129,.1);display:flex;align-items:center;justify-content:center;font-size:1.2rem;color:#10b981;flex-shrink:0;">
                            <i class="fa-solid fa-circle-check"></i>
                        </div>
                        <div>
                            <div class="fw-bold fs-4 lh-1">1</div>
                            <div class="text-muted" style="font-size:.8rem;">Đã được duyệt</div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-6 col-xl-3">
                    <div class="owner-card d-flex align-items-center gap-3 p-3">
                        <div style="width:44px;height:44px;border-radius:12px;background:rgba(245,158,11,.1);display:flex;align-items:center;justify-content:center;font-size:1.2rem;color:#f59e0b;flex-shrink:0;">
                            <i class="fa-solid fa-clock"></i>
                        </div>
                        <div>
                            <div class="fw-bold fs-4 lh-1">1</div>
                            <div class="text-muted" style="font-size:.8rem;">Chờ duyệt</div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-6 col-xl-3">
                    <div class="owner-card d-flex align-items-center gap-3 p-3">
                        <div style="width:44px;height:44px;border-radius:12px;background:rgba(99,102,241,.1);display:flex;align-items:center;justify-content:center;font-size:1.2rem;color:#6366f1;flex-shrink:0;">
                            <i class="fa-solid fa-bed"></i>
                        </div>
                        <div>
                            <div class="fw-bold fs-4 lh-1">23</div>
                            <div class="text-muted" style="font-size:.8rem;">Tổng số phòng</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Homestay Table -->
            <div class="owner-card p-0 overflow-hidden">
                <div class="d-flex align-items-center justify-content-between px-4 py-3 border-bottom">
                    <h6 class="fw-bold mb-0"><i class="fa-solid fa-list-ul me-2 text-primary"></i>Danh sách Cơ sở</h6>
                    <div class="d-flex gap-2">
                        <input type="search" class="form-control form-control-sm" placeholder="Tìm kiếm cơ sở..." style="width:200px;">
                    </div>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-4">Hình ảnh</th>
                                <th>Tên Homestay</th>
                                <th>Địa chỉ</th>
                                <th>Số phòng</th>
                                <th>Trạng thái</th>
                                <th class="pe-4">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="ps-4">
                                    <img src="${pageContext.request.contextPath}/assets/images/default-homestay.svg"
                                         class="rounded-3" width="64" height="44" style="object-fit:cover;"
                                         onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=120&q=80';">
                                </td>
                                <td>
                                    <div class="fw-semibold">Ocean Breeze Luxury Homestay</div>
                                    <div class="text-muted" style="font-size:.78rem;">Cập nhật: 15/09/2026</div>
                                </td>
                                <td class="text-muted">Mỹ Khê, Sơn Trà, Đà Nẵng</td>
                                <td><span class="fw-semibold">15</span> <span class="text-muted">phòng</span></td>
                                <td>
                                    <span class="badge bg-success-subtle text-success border border-success px-2 py-1">
                                        <i class="fa-solid fa-circle-check me-1"></i>Đã phê duyệt
                                    </span>
                                </td>
                                <td class="pe-4">
                                    <div class="d-flex gap-2">
                                        <button class="btn btn-sm btn-outline-primary rounded-3">
                                            <i class="fa-solid fa-pen me-1"></i>Sửa
                                        </button>
                                        <button class="btn btn-sm btn-outline-danger rounded-3">
                                            <i class="fa-solid fa-trash"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td class="ps-4">
                                    <img src="${pageContext.request.contextPath}/assets/images/default-homestay.svg"
                                         class="rounded-3" width="64" height="44" style="object-fit:cover;"
                                         onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=120&q=80';">
                                </td>
                                <td>
                                    <div class="fw-semibold">Dalat Pine Forest Villa</div>
                                    <div class="text-muted" style="font-size:.78rem;">Cập nhật: 20/09/2026</div>
                                </td>
                                <td class="text-muted">Phường 10, Đà Lạt</td>
                                <td><span class="fw-semibold">8</span> <span class="text-muted">phòng</span></td>
                                <td>
                                    <span class="badge bg-warning-subtle text-warning border border-warning px-2 py-1">
                                        <i class="fa-solid fa-clock me-1"></i>Chờ Admin duyệt
                                    </span>
                                </td>
                                <td class="pe-4">
                                    <div class="d-flex gap-2">
                                        <button class="btn btn-sm btn-outline-primary rounded-3">
                                            <i class="fa-solid fa-pen me-1"></i>Sửa
                                        </button>
                                        <button class="btn btn-sm btn-outline-danger rounded-3">
                                            <i class="fa-solid fa-trash"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

        </div><!-- /.owner-content -->
    </div><!-- /.owner-main -->
</div><!-- /.owner-shell -->

<jsp:include page="../common/footer.jsp"/>
