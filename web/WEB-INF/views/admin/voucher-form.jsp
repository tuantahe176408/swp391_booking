<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle"      value="Chiến dịch Vouchers"                      scope="request"/>
<c:set var="pageBreadcrumb" value="Quản lý Người dùng &amp; Nội dung"        scope="request"/>
<jsp:include page="../common/header.jsp"/>

<div class="owner-shell">
    <jsp:include page="../common/sidebar-admin.jsp"/>
    <div class="owner-main">
        <jsp:include page="../common/admin-topbar.jsp"/>
        <div class="owner-content">

            <%-- Flash Messages --%>
            <c:if test="${not empty sessionScope.adminSuccessMessage}">
                <div class="alert alert-success alert-dismissible fade show rounded-4 mb-3" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i>${sessionScope.adminSuccessMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="adminSuccessMessage" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.adminErrorMessage}">
                <div class="alert alert-danger alert-dismissible fade show rounded-4 mb-3" role="alert">
                    <i class="fa-solid fa-circle-xmark me-2"></i>${sessionScope.adminErrorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="adminErrorMessage" scope="session"/>
            </c:if>

            <%-- Stats Row --%>
            <div class="row g-3 mb-4">
                <div class="col-sm-4">
                    <div class="card border-0 shadow-sm rounded-4 p-3 h-100">
                        <div class="d-flex align-items-center gap-3">
                            <div class="rounded-3 p-2" style="background:rgba(220,38,38,.1);">
                                <i class="fa-solid fa-ticket fa-lg text-danger"></i>
                            </div>
                            <div>
                                <div class="fw-bold fs-4 lh-1">${totalCount}</div>
                                <div class="text-muted small">Tổng voucher</div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="card border-0 shadow-sm rounded-4 p-3 h-100">
                        <div class="d-flex align-items-center gap-3">
                            <div class="rounded-3 p-2" style="background:rgba(34,197,94,.1);">
                                <i class="fa-solid fa-circle-check fa-lg text-success"></i>
                            </div>
                            <div>
                                <div class="fw-bold fs-4 lh-1">${activeCount}</div>
                                <div class="text-muted small">Đang kích hoạt</div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="card border-0 shadow-sm rounded-4 p-3 h-100">
                        <div class="d-flex align-items-center gap-3">
                            <div class="rounded-3 p-2" style="background:rgba(107,114,128,.1);">
                                <i class="fa-solid fa-clock-rotate-left fa-lg text-secondary"></i>
                            </div>
                            <div>
                                <div class="fw-bold fs-4 lh-1">${expiredCount}</div>
                                <div class="text-muted small">Đã hết hạn</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Main Card --%>
            <div class="card border-0 shadow-sm rounded-4 p-4">
                <div class="d-flex align-items-center justify-content-between mb-4 border-bottom pb-3">
                    <div>
                        <h4 class="fw-bold mb-1 text-dark">
                            <i class="fa-solid fa-ticket text-danger me-2"></i>Chiến dịch Marketing &amp; Mã giảm giá
                        </h4>
                        <p class="text-muted mb-0 small">Tạo và quản lý mã khuyến mãi áp dụng toàn sàn do hệ thống phát hành</p>
                    </div>
                    <button class="btn btn-danger btn-sm rounded-pill fw-semibold px-3"
                            data-bs-toggle="modal" data-bs-target="#createVoucherModal"
                            id="btn-create-voucher">
                        <i class="fa-solid fa-plus me-1"></i>Tạo Mã Mới
                    </button>
                </div>

                <c:choose>
                    <c:when test="${empty voucherList}">
                        <div class="text-center py-5 text-muted">
                            <i class="fa-solid fa-ticket-slash fa-3x mb-3 opacity-25"></i>
                            <p class="fw-semibold mb-1">Chưa có voucher nào.</p>
                            <p class="small">Nhấn <strong>Tạo Mã Mới</strong> để bắt đầu chiến dịch đầu tiên.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle" id="voucher-table">
                                <thead class="table-light">
                                    <tr>
                                        <th>Mã Voucher</th>
                                        <th>Mô tả</th>
                                        <th>Mức giảm</th>
                                        <th class="text-nowrap">Đơn tối thiểu</th>
                                        <th class="text-nowrap">Sử dụng</th>
                                        <th class="text-nowrap">Hiệu lực</th>
                                        <th>Trạng thái</th>
                                        <th class="text-nowrap" style="min-width:200px;">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="v" items="${voucherList}">
                                        <tr>
                                            <%-- Code --%>
                                            <td>
                                                <span class="badge border px-3 py-2 font-monospace fs-6
                                                    ${v.active ? 'bg-danger-subtle text-danger border-danger' : 'bg-secondary-subtle text-secondary border-secondary'}">
                                                    <c:out value="${v.code}"/>
                                                </span>
                                            </td>
                                            <%-- Description --%>
                                            <td class="text-muted small" style="max-width:200px;">
                                                <span title="${v.description}">
                                                    <c:out value="${v.description}"/>
                                                </span>
                                            </td>
                                            <%-- Discount --%>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${v.discountType == 'PERCENTAGE'}">
                                                        <strong>Giảm <fmt:formatNumber value="${v.discountValue}" maxFractionDigits="0"/>%</strong>
                                                        <c:if test="${v.maxDiscountAmount != null && v.maxDiscountAmount > 0}">
                                                            <br><span class="text-muted small">(Tối đa <fmt:formatNumber value="${v.maxDiscountAmount}" type="number" groupingUsed="true"/>₫)</span>
                                                        </c:if>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <strong>Giảm <fmt:formatNumber value="${v.discountValue}" type="number" groupingUsed="true"/>₫</strong>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <%-- Min booking --%>
                                            <td class="text-nowrap">
                                                <c:choose>
                                                    <c:when test="${v.minBookingAmount != null && v.minBookingAmount > 0}">
                                                        <fmt:formatNumber value="${v.minBookingAmount}" type="number" groupingUsed="true"/>₫
                                                    </c:when>
                                                    <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <%-- Usage --%>
                                            <td>
                                                <div class="d-flex flex-column gap-1" style="min-width:90px;">
                                                    <div class="d-flex justify-content-between small">
                                                        <span>${v.usedCount} / ${v.usageLimit}</span>
                                                    </div>
                                                    <div class="progress" style="height:5px;">
                                                        <div class="progress-bar bg-danger" role="progressbar"
                                                             style="width: ${v.usageLimit > 0 ? (v.usedCount * 100 / v.usageLimit) : 0}%"></div>
                                                    </div>
                                                </div>
                                            </td>
                                            <%-- Date range --%>
                                            <td class="text-nowrap small">
                                                <c:if test="${v.startDate != null}">
                                                    <fmt:formatDate value="${v.startDate}" pattern="dd/MM/yy"/>
                                                </c:if>
                                                →
                                                <c:if test="${v.endDate != null}">
                                                    <fmt:formatDate value="${v.endDate}" pattern="dd/MM/yy"/>
                                                </c:if>
                                            </td>
                                            <%-- Status --%>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${v.active}">
                                                        <span class="badge bg-success-subtle text-success border border-success">Đang phát hành</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary-subtle text-secondary border border-secondary">Đã tắt</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <%-- Actions --%>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <%-- Edit --%>
                                                    <button type="button" class="btn btn-sm btn-outline-primary rounded-pill px-3"
                                                            data-bs-toggle="modal" data-bs-target="#editVoucherModal"
                                                            data-id="${v.voucherId}"
                                                            data-code="${v.code}"
                                                            data-desc="<c:out value='${v.description}'/>"
                                                            data-end="<fmt:formatDate value='${v.endDate}' pattern='yyyy-MM-dd'/>"
                                                            data-maxdisc="${v.maxDiscountAmount}"
                                                            data-minbook="${v.minBookingAmount}"
                                                            data-limit="${v.usageLimit}"
                                                            onclick="openEditModal(this)">
                                                        <i class="fa-solid fa-pen-to-square me-1"></i>Sửa
                                                    </button>
                                                    <%-- Toggle --%>
                                                    <form method="post" action="${pageContext.request.contextPath}/admin/vouchers" class="m-0">
                                                        <input type="hidden" name="action"    value="toggle">
                                                        <input type="hidden" name="voucherId" value="${v.voucherId}">
                                                        <input type="hidden" name="active"    value="${!v.active}">
                                                        <c:choose>
                                                            <c:when test="${v.active}">
                                                                <button type="submit" class="btn btn-sm btn-outline-secondary rounded-pill px-3"
                                                                        onclick="return confirm('Tắt voucher ${v.code}?');">
                                                                    <i class="fa-solid fa-toggle-off me-1"></i>Tắt
                                                                </button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button type="submit" class="btn btn-sm btn-outline-success rounded-pill px-3"
                                                                        onclick="return confirm('Bật lại voucher ${v.code}?');">
                                                                    <i class="fa-solid fa-toggle-on me-1"></i>Bật
                                                                </button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </form>
                                                    <%-- Delete --%>
                                                    <form method="post" action="${pageContext.request.contextPath}/admin/vouchers" class="m-0">
                                                        <input type="hidden" name="action"    value="delete">
                                                        <input type="hidden" name="voucherId" value="${v.voucherId}">
                                                        <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill px-3"
                                                                onclick="return confirm('Xóa vĩnh viễn voucher ${v.code}? Thao tác không thể hoàn tác!');">
                                                            <i class="fa-solid fa-trash-can"></i>
                                                        </button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<%-- Create Voucher Modal --%>
<div class="modal fade" id="createVoucherModal" tabindex="-1" aria-labelledby="createVoucherModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content rounded-4 border-0 shadow">
            <form method="post" action="${pageContext.request.contextPath}/admin/vouchers" id="create-voucher-form">
                <input type="hidden" name="action" value="create">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold" id="createVoucherModalLabel">
                        <i class="fa-solid fa-ticket text-danger me-2"></i>Tạo Mã Voucher Mới
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body pt-3">
                    <div class="row g-3">
                        <%-- Code & Type --%>
                        <div class="col-sm-6">
                            <label for="vc-code" class="form-label fw-semibold small">
                                Mã Voucher <span class="text-danger">*</span>
                            </label>
                            <input type="text" id="vc-code" name="code" required
                                   class="form-control rounded-3 font-monospace text-uppercase"
                                   placeholder="VD: SUMMER2026" maxlength="50"
                                   oninput="this.value=this.value.toUpperCase().replace(/[^A-Z0-9]/g,'')">
                            <div class="form-text">Chỉ chữ cái HOA và số, không dấu cách</div>
                        </div>
                        <div class="col-sm-6">
                            <label for="vc-discountType" class="form-label fw-semibold small">
                                Loại giảm giá <span class="text-danger">*</span>
                            </label>
                            <select id="vc-discountType" name="discountType" class="form-select rounded-3"
                                    onchange="toggleMaxDiscount(this.value)">
                                <option value="PERCENTAGE">Phần trăm (%)</option>
                                <option value="FIXED_AMOUNT">Số tiền cố định (₫)</option>
                            </select>
                        </div>
                        <%-- Discount Value & Max --%>
                        <div class="col-sm-6">
                            <label for="vc-discountValue" class="form-label fw-semibold small">
                                Mức giảm <span class="text-danger">*</span>
                            </label>
                            <div class="input-group">
                                <input type="number" id="vc-discountValue" name="discountValue" required
                                       class="form-control rounded-start-3" min="1" step="any"
                                       placeholder="VD: 15">
                                <span class="input-group-text" id="discount-unit">%</span>
                            </div>
                        </div>
                        <div class="col-sm-6" id="max-discount-group">
                            <label for="vc-maxDiscountAmount" class="form-label fw-semibold small">
                                Giảm tối đa (₫) <span class="text-muted">(tùy chọn)</span>
                            </label>
                            <input type="number" id="vc-maxDiscountAmount" name="maxDiscountAmount"
                                   class="form-control rounded-3" min="0" step="1000"
                                   placeholder="VD: 200000">
                        </div>
                        <%-- Min booking & Usage Limit --%>
                        <div class="col-sm-6">
                            <label for="vc-minBookingAmount" class="form-label fw-semibold small">
                                Đơn tối thiểu (₫)
                            </label>
                            <input type="number" id="vc-minBookingAmount" name="minBookingAmount"
                                   class="form-control rounded-3" min="0" step="1000" value="0"
                                   placeholder="VD: 500000">
                        </div>
                        <div class="col-sm-6">
                            <label for="vc-usageLimit" class="form-label fw-semibold small">
                                Số lượt phát hành <span class="text-danger">*</span>
                            </label>
                            <input type="number" id="vc-usageLimit" name="usageLimit" required
                                   class="form-control rounded-3" min="1" value="100"
                                   placeholder="VD: 500">
                        </div>
                        <%-- Dates --%>
                        <div class="col-sm-6">
                            <label for="vc-startDate" class="form-label fw-semibold small">
                                Ngày bắt đầu <span class="text-danger">*</span>
                            </label>
                            <input type="date" id="vc-startDate" name="startDate" required
                                   class="form-control rounded-3">
                        </div>
                        <div class="col-sm-6">
                            <label for="vc-endDate" class="form-label fw-semibold small">
                                Ngày kết thúc <span class="text-danger">*</span>
                            </label>
                            <input type="date" id="vc-endDate" name="endDate" required
                                   class="form-control rounded-3">
                        </div>
                        <%-- Description --%>
                        <div class="col-12">
                            <label for="vc-description" class="form-label fw-semibold small">
                                Mô tả chiến dịch
                            </label>
                            <textarea id="vc-description" name="description"
                                      class="form-control rounded-3" rows="2"
                                      placeholder="VD: Giảm 15% mùa hè cho homestay ven biển..."></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0 pt-0">
                    <button type="button" class="btn btn-outline-secondary rounded-3" data-bs-dismiss="modal">Huỷ</button>
                    <button type="submit" class="btn btn-danger rounded-3 fw-semibold">
                        <i class="fa-solid fa-plus me-1"></i>Tạo Voucher
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<%-- Edit Voucher Modal --%>
<div class="modal fade" id="editVoucherModal" tabindex="-1" aria-labelledby="editVoucherModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content rounded-4 border-0 shadow">
            <form method="post" action="${pageContext.request.contextPath}/admin/vouchers" id="edit-voucher-form">
                <input type="hidden" name="action"    value="update">
                <input type="hidden" name="voucherId" id="ev-voucherId" value="">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold" id="editVoucherModalLabel">
                        <i class="fa-solid fa-pen-to-square text-primary me-2"></i>
                        Chỉnh sửa Voucher — <span id="ev-codeDisplay" class="font-monospace text-primary"></span>
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body pt-2">
                    <%-- Read-only info box --%>
                    <div class="alert alert-info d-flex gap-2 align-items-start py-2 mb-3 small rounded-3">
                        <i class="fa-solid fa-lock mt-1"></i>
                        <div>
                            <strong>Trường khóa:</strong> Mã voucher, loại giảm giá và mức giảm không thể thay đổi sau khi tạo —
                            để đảm bảo tính nhất quán với các booking đã sử dụng mã này.
                        </div>
                    </div>
                    <div class="row g-3">
                        <div class="col-12">
                            <label for="ev-description" class="form-label fw-semibold small">Mô tả chiến dịch</label>
                            <textarea id="ev-description" name="description"
                                      class="form-control rounded-3" rows="2"
                                      placeholder="Mô tả chiến dịch..."></textarea>
                        </div>
                        <div class="col-sm-6">
                            <label for="ev-minBookingAmount" class="form-label fw-semibold small">
                                Đơn tối thiểu (₫)
                            </label>
                            <input type="number" id="ev-minBookingAmount" name="minBookingAmount"
                                   class="form-control rounded-3" min="0" step="1000">
                        </div>
                        <div class="col-sm-6">
                            <label for="ev-maxDiscountAmount" class="form-label fw-semibold small">
                                Giảm tối đa (₫) <span class="text-muted">(chỉ dùng với %)</span>
                            </label>
                            <input type="number" id="ev-maxDiscountAmount" name="maxDiscountAmount"
                                   class="form-control rounded-3" min="0" step="1000">
                        </div>
                        <div class="col-sm-6">
                            <label for="ev-usageLimit" class="form-label fw-semibold small">
                                Số lượt phát hành <span class="text-danger">*</span>
                            </label>
                            <input type="number" id="ev-usageLimit" name="usageLimit" required
                                   class="form-control rounded-3" min="1">
                        </div>
                        <div class="col-sm-6">
                            <label for="ev-endDate" class="form-label fw-semibold small">
                                Ngày kết thúc <span class="text-danger">*</span>
                            </label>
                            <input type="date" id="ev-endDate" name="endDate" required
                                   class="form-control rounded-3">
                            <div class="form-text text-success">
                                <i class="fa-solid fa-circle-info me-1"></i>Có thể gia hạn chiến dịch bằng cách tăng ngày này.
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0 pt-0">
                    <button type="button" class="btn btn-outline-secondary rounded-3" data-bs-dismiss="modal">Huỷ</button>
                    <button type="submit" class="btn btn-primary rounded-3 fw-semibold">
                        <i class="fa-solid fa-floppy-disk me-1"></i>Lưu thay đổi
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // Set default dates for Create Modal
    document.addEventListener('DOMContentLoaded', function () {
        var today = new Date().toISOString().split('T')[0];
        var nextYear = new Date();
        nextYear.setFullYear(nextYear.getFullYear() + 1);
        var nextYearStr = nextYear.toISOString().split('T')[0];

        var startInput = document.getElementById('vc-startDate');
        var endInput   = document.getElementById('vc-endDate');
        if (startInput && !startInput.value) startInput.value = today;
        if (endInput   && !endInput.value)   endInput.value   = nextYearStr;
    });

    function toggleMaxDiscount(type) {
        var maxGroup = document.getElementById('max-discount-group');
        var unit     = document.getElementById('discount-unit');
        if (type === 'FIXED_AMOUNT') {
            maxGroup.style.display = 'none';
            if (unit) unit.textContent = '₫';
        } else {
            maxGroup.style.display = '';
            if (unit) unit.textContent = '%';
        }
    }

    // Populate Edit Modal từ data-* attributes
    function openEditModal(btn) {
        document.getElementById('ev-voucherId').value        = btn.dataset.id    || '';
        document.getElementById('ev-codeDisplay').textContent= btn.dataset.code  || '';
        document.getElementById('ev-description').value     = btn.dataset.desc  || '';
        document.getElementById('ev-endDate').value         = btn.dataset.end   || '';
        document.getElementById('ev-maxDiscountAmount').value= btn.dataset.maxdisc || '';
        document.getElementById('ev-minBookingAmount').value = btn.dataset.minbook  || '';
        document.getElementById('ev-usageLimit').value      = btn.dataset.limit || '';
    }
</script>

<jsp:include page="../common/footer.jsp"/>

