<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle"      value="Lịch &amp; Giá phòng"   scope="request"/>
<c:set var="pageBreadcrumb" value="Quản lý Tài sản"          scope="request"/>
<jsp:include page="../common/header.jsp"/>

<div class="owner-shell">
    <jsp:include page="../common/sidebar-owner.jsp"/>

    <div class="owner-main">
        <jsp:include page="../common/owner-topbar.jsp"/>

        <div class="owner-content">

            <!-- Page Header -->
            <div class="owner-page-header">
                <div class="owner-page-header__info">
                    <h2><i class="fa-regular fa-calendar-days text-primary me-2"></i>Lịch bán phòng &amp; Giá linh hoạt</h2>
                    <p>Thiết lập điều chỉnh tăng/giảm giá theo ngày, đóng/mở bán phòng theo khoảng thời gian</p>
                </div>
                <div class="d-flex gap-2">
                    <select class="form-select form-select-sm" style="width:auto;">
                        <option>Ocean Breeze Luxury Homestay</option>
                        <option>Dalat Pine Forest Villa</option>
                    </select>
                    <button class="btn btn-primary-custom btn-sm px-4">
                        <i class="fa-solid fa-sliders me-1"></i>Áp dụng quy tắc giá
                    </button>
                </div>
            </div>

            <!-- Tip -->
            <div class="alert alert-info rounded-3 mb-4 d-flex align-items-center gap-2">
                <i class="fa-solid fa-lightbulb fs-5 text-info flex-shrink-0"></i>
                <span>Mẹo: Chọn khoảng ngày trên lịch để áp dụng công thức điều chỉnh giá linh hoạt (ví dụ: +25% vào thứ 7 &amp; Chủ nhật).</span>
            </div>

            <!-- Calendar Card -->
            <div class="owner-card p-0 overflow-hidden">
                <!-- Month nav -->
                <div class="d-flex align-items-center justify-content-between px-4 py-3 border-bottom">
                    <button class="btn btn-sm btn-outline-secondary rounded-3">
                        <i class="fa-solid fa-chevron-left"></i>
                    </button>
                    <h6 class="fw-bold mb-0">Tháng 09 / 2026</h6>
                    <button class="btn btn-sm btn-outline-secondary rounded-3">
                        <i class="fa-solid fa-chevron-right"></i>
                    </button>
                </div>

                <div class="table-responsive">
                    <table class="table table-bordered text-center align-middle mb-0" style="min-width:560px;">
                        <thead class="table-light">
                            <tr>
                                <th style="width:14.28%">T2</th>
                                <th style="width:14.28%">T3</th>
                                <th style="width:14.28%">T4</th>
                                <th style="width:14.28%">T5</th>
                                <th style="width:14.28%">T6</th>
                                <th class="text-danger" style="width:14.28%">T7</th>
                                <th class="text-danger" style="width:14.28%">CN</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr style="height:72px;">
                                <td><span class="d-block fw-bold">1</span><small class="text-muted">800k</small></td>
                                <td><span class="d-block fw-bold">2</span><small class="text-muted">800k</small></td>
                                <td><span class="d-block fw-bold">3</span><small class="text-muted">800k</small></td>
                                <td><span class="d-block fw-bold">4</span><small class="text-muted">800k</small></td>
                                <td><span class="d-block fw-bold">5</span><small class="text-muted">800k</small></td>
                                <td class="table-warning">
                                    <span class="d-block fw-bold text-danger">6</span>
                                    <small class="text-danger fw-bold">1.1M <span class="badge bg-danger-subtle text-danger" style="font-size:.65rem;">+25%</span></small>
                                </td>
                                <td class="table-warning">
                                    <span class="d-block fw-bold text-danger">7</span>
                                    <small class="text-danger fw-bold">1.1M <span class="badge bg-danger-subtle text-danger" style="font-size:.65rem;">+25%</span></small>
                                </td>
                            </tr>
                            <tr style="height:72px;">
                                <td><span class="d-block fw-bold">8</span><small class="text-muted">800k</small></td>
                                <td><span class="d-block fw-bold">9</span><small class="text-muted">800k</small></td>
                                <td><span class="d-block fw-bold">10</span><small class="text-muted">800k</small></td>
                                <td class="table-secondary">
                                    <span class="d-block fw-bold text-muted">11</span>
                                    <span class="badge bg-secondary" style="font-size:.65rem;">Khóa phòng</span>
                                </td>
                                <td><span class="d-block fw-bold">12</span><small class="text-muted">800k</small></td>
                                <td class="table-warning">
                                    <span class="d-block fw-bold text-danger">13</span>
                                    <small class="text-danger fw-bold">1.1M</small>
                                </td>
                                <td class="table-warning">
                                    <span class="d-block fw-bold text-danger">14</span>
                                    <small class="text-danger fw-bold">1.1M</small>
                                </td>
                            </tr>
                            <tr style="height:72px;">
                                <td><span class="d-block fw-bold">15</span><small class="text-muted">800k</small></td>
                                <td><span class="d-block fw-bold">16</span><small class="text-muted">800k</small></td>
                                <td><span class="d-block fw-bold">17</span><small class="text-muted">800k</small></td>
                                <td><span class="d-block fw-bold">18</span><small class="text-muted">800k</small></td>
                                <td><span class="d-block fw-bold">19</span><small class="text-muted">800k</small></td>
                                <td class="table-warning">
                                    <span class="d-block fw-bold text-danger">20</span>
                                    <small class="text-danger fw-bold">1.1M</small>
                                </td>
                                <td class="table-warning">
                                    <span class="d-block fw-bold text-danger">21</span>
                                    <small class="text-danger fw-bold">1.1M</small>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Legend -->
                <div class="d-flex align-items-center gap-4 px-4 py-3 border-top flex-wrap">
                    <span class="d-flex align-items-center gap-2" style="font-size:.82rem;">
                        <span style="width:14px;height:14px;border-radius:3px;background:#fef3c7;border:1px solid #fcd34d;display:inline-block;"></span>Giá cuối tuần
                    </span>
                    <span class="d-flex align-items-center gap-2" style="font-size:.82rem;">
                        <span style="width:14px;height:14px;border-radius:3px;background:#f1f5f9;border:1px solid #cbd5e1;display:inline-block;"></span>Khóa phòng
                    </span>
                    <span class="d-flex align-items-center gap-2" style="font-size:.82rem;">
                        <span style="width:14px;height:14px;border-radius:3px;background:#fff;border:1px solid #e2e8f0;display:inline-block;"></span>Giá thông thường
                    </span>
                </div>
            </div>

        </div><!-- /.owner-content -->
    </div><!-- /.owner-main -->
</div><!-- /.owner-shell -->

<jsp:include page="../common/footer.jsp"/>
