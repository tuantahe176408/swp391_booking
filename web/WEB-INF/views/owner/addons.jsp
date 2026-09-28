<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle"      value="Dịch vụ Bổ sung"    scope="request"/>
<c:set var="pageBreadcrumb" value="Quản lý Tài sản"     scope="request"/>
<jsp:include page="../common/header.jsp"/>

<div class="owner-shell">
    <jsp:include page="../common/sidebar-owner.jsp"/>

    <div class="owner-main">
        <jsp:include page="../common/owner-topbar.jsp"/>

        <div class="owner-content">

            <!-- Page Header -->
            <div class="owner-page-header">
                <div class="owner-page-header__info">
                    <h2><i class="fa-solid fa-bell-concierge text-primary me-2"></i>Danh mục Dịch vụ Bổ sung</h2>
                    <p>Thiết lập các gói dịch vụ đi kèm khi khách đặt phòng (xe đưa đón, BBQ, ăn sáng…)</p>
                </div>
                <button class="btn btn-primary-custom btn-sm px-4">
                    <i class="fa-solid fa-plus me-1"></i> Thêm Dịch vụ Mới
                </button>
            </div>

            <!-- Stats -->
            <div class="row g-3 mb-4">
                <div class="col-sm-4">
                    <div class="owner-card d-flex align-items-center gap-3 p-3">
                        <div style="width:44px;height:44px;border-radius:12px;background:rgba(16,185,129,.1);display:flex;align-items:center;justify-content:center;font-size:1.2rem;color:#10b981;flex-shrink:0;">
                            <i class="fa-solid fa-circle-check"></i>
                        </div>
                        <div>
                            <div class="fw-bold fs-4 lh-1">2</div>
                            <div class="text-muted" style="font-size:.8rem;">Đang mở bán</div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="owner-card d-flex align-items-center gap-3 p-3">
                        <div style="width:44px;height:44px;border-radius:12px;background:rgba(99,102,241,.1);display:flex;align-items:center;justify-content:center;font-size:1.2rem;color:#6366f1;flex-shrink:0;">
                            <i class="fa-solid fa-tag"></i>
                        </div>
                        <div>
                            <div class="fw-bold fs-4 lh-1">0</div>
                            <div class="text-muted" style="font-size:.8rem;">Tạm ngừng</div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="owner-card d-flex align-items-center gap-3 p-3">
                        <div style="width:44px;height:44px;border-radius:12px;background:rgba(245,158,11,.1);display:flex;align-items:center;justify-content:center;font-size:1.2rem;color:#f59e0b;flex-shrink:0;">
                            <i class="fa-solid fa-receipt"></i>
                        </div>
                        <div>
                            <div class="fw-bold fs-4 lh-1">48</div>
                            <div class="text-muted" style="font-size:.8rem;">Lượt đặt tháng này</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Add-ons Table -->
            <div class="owner-card p-0 overflow-hidden">
                <div class="d-flex align-items-center justify-content-between px-4 py-3 border-bottom">
                    <h6 class="fw-bold mb-0"><i class="fa-solid fa-list-ul me-2 text-primary"></i>Danh sách Dịch vụ</h6>
                    <input type="search" class="form-control form-control-sm" placeholder="Tìm kiếm dịch vụ..." style="width:200px;">
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-4">Tên Dịch vụ</th>
                                <th>Mô tả</th>
                                <th>Đơn giá</th>
                                <th>Đơn vị</th>
                                <th>Trạng thái</th>
                                <th class="pe-4">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="ps-4">
                                    <div class="d-flex align-items-center gap-2">
                                        <div style="width:36px;height:36px;border-radius:9px;background:rgba(16,185,129,.1);display:flex;align-items:center;justify-content:center;color:#10b981;flex-shrink:0;">
                                            <i class="fa-solid fa-mug-hot"></i>
                                        </div>
                                        <span class="fw-semibold">Bữa sáng Buffet Á-Âu</span>
                                    </div>
                                </td>
                                <td class="text-muted" style="max-width:220px;">Bữa sáng tại nhà hàng view biển từ 6h30–9h30</td>
                                <td class="fw-semibold">150.000 ₫</td>
                                <td><span class="badge bg-light text-dark border">Người / Ngày</span></td>
                                <td><span class="badge bg-success-subtle text-success border border-success px-2 py-1">Đang mở bán</span></td>
                                <td class="pe-4">
                                    <div class="d-flex gap-2">
                                        <button class="btn btn-sm btn-outline-primary rounded-3">Sửa</button>
                                        <button class="btn btn-sm btn-outline-danger rounded-3"><i class="fa-solid fa-trash"></i></button>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td class="ps-4">
                                    <div class="d-flex align-items-center gap-2">
                                        <div style="width:36px;height:36px;border-radius:9px;background:rgba(239,68,68,.1);display:flex;align-items:center;justify-content:center;color:#ef4444;flex-shrink:0;">
                                            <i class="fa-solid fa-fire-flame-curved"></i>
                                        </div>
                                        <span class="fw-semibold">Gói BBQ Ngoài trời</span>
                                    </div>
                                </td>
                                <td class="text-muted" style="max-width:220px;">Bao gồm bếp nướng, than hoa, bàn ghế và dụng cụ tiệc</td>
                                <td class="fw-semibold">350.000 ₫</td>
                                <td><span class="badge bg-light text-dark border">Lượt / Đêm</span></td>
                                <td><span class="badge bg-success-subtle text-success border border-success px-2 py-1">Đang mở bán</span></td>
                                <td class="pe-4">
                                    <div class="d-flex gap-2">
                                        <button class="btn btn-sm btn-outline-primary rounded-3">Sửa</button>
                                        <button class="btn btn-sm btn-outline-danger rounded-3"><i class="fa-solid fa-trash"></i></button>
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
