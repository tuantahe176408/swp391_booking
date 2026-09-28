<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../common/header.jsp"/>

<div class="owner-shell">
    <jsp:include page="../common/sidebar-owner.jsp"/>
    <div class="owner-main">
        <jsp:include page="../common/owner-topbar.jsp"/>
        <div class="owner-content">

            <!-- Flash messages -->
            <c:if test="${not empty sessionScope.flash_success}">
                <div class="alert alert-success alert-dismissible rounded-3 mb-4 d-flex gap-2 align-items-center">
                    <i class="fa-solid fa-circle-check flex-shrink-0"></i>
                    <span>${sessionScope.flash_success}</span>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="flash_success" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.flash_error}">
                <div class="alert alert-danger alert-dismissible rounded-3 mb-4 d-flex gap-2 align-items-center">
                    <i class="fa-solid fa-triangle-exclamation flex-shrink-0"></i>
                    <span>${sessionScope.flash_error}</span>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="flash_error" scope="session"/>
            </c:if>

            <!-- Page Header -->
            <div class="owner-page-header">
                <div class="owner-page-header__info">
                    <h2>
                        <i class="fa-solid fa-${isNew ? 'plus' : 'pen'} text-primary me-2"></i>
                        ${isNew ? 'Đăng ký Homestay Mới' : 'Chỉnh sửa: '.concat(homestay.name)}
                    </h2>
                    <p>${isNew ? 'Điền thông tin cơ bản, sau khi lưu Admin sẽ xét duyệt trong 1–2 ngày làm việc.' : 'Cập nhật thông tin cơ sở. Nếu cơ sở đang bị từ chối, lưu lại sẽ gửi lại Admin duyệt.'}</p>
                </div>
                <a href="${pageContext.request.contextPath}/owner/homestays"
                   class="btn btn-outline-secondary btn-sm px-3 rounded-3">
                    <i class="fa-solid fa-arrow-left me-1"></i>Quay lại
                </a>
            </div>

            <!-- Rejection reason banner -->
            <c:if test="${not isNew && homestay.status == 'REJECTED' && not empty homestay.rejectionReason}">
                <div class="alert alert-danger rounded-3 mb-4 d-flex gap-2">
                    <i class="fa-solid fa-circle-exclamation fs-5 flex-shrink-0 mt-1"></i>
                    <div>
                        <div class="fw-semibold mb-1">Lý do từ chối của Admin:</div>
                        <div>${homestay.rejectionReason}</div>
                        <div class="mt-2 text-muted" style="font-size:.82rem;">
                            Chỉnh sửa thông tin bên dưới và nhấn <strong>Lưu & Gửi lại duyệt</strong>.
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- Edit Form -->
            <div class="owner-card">
                <form method="post"
                      action="${pageContext.request.contextPath}/owner/homestays/edit"
                      novalidate id="homestayEditForm">
                    <input type="hidden" name="isNew"      value="${isNew}">
                    <input type="hidden" name="homestayId" value="${homestay.homestayId}">

                    <div class="row g-4">

                        <!-- Left column -->
                        <div class="col-lg-8">
                            <h6 class="fw-bold mb-3 pb-2 border-bottom">
                                <i class="fa-solid fa-circle-info text-primary me-2"></i>Thông tin cơ bản
                            </h6>

                            <div class="mb-3">
                                <label class="form-label fw-semibold" style="font-size:.85rem;">
                                    Tên Homestay <span class="text-danger">*</span>
                                </label>
                                <input type="text" name="name" class="form-control"
                                       value="${homestay.name}"
                                       placeholder="VD: Ocean Breeze Luxury Homestay"
                                       required maxlength="200">
                                <div class="form-text">Tối đa 200 ký tự, nên bao gồm tên thành phố để dễ tìm kiếm.</div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold" style="font-size:.85rem;">Mô tả</label>
                                <textarea name="description" class="form-control" rows="5"
                                          placeholder="Mô tả đặc điểm nổi bật, vị trí, không gian, dịch vụ...">${homestay.description}</textarea>
                                <div class="form-text">Mô tả chi tiết giúp khách hàng dễ ra quyết định hơn.</div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold" style="font-size:.85rem;">
                                    Địa chỉ <span class="text-danger">*</span>
                                </label>
                                <input type="text" name="address" class="form-control"
                                       value="${homestay.address}"
                                       placeholder="Số nhà, tên đường, phường/xã"
                                       required maxlength="255">
                            </div>

                            <div class="row g-3">
                                <div class="col-sm-6">
                                    <label class="form-label fw-semibold" style="font-size:.85rem;">
                                        Thành phố / Tỉnh <span class="text-danger">*</span>
                                    </label>
                                    <input type="text" name="city" class="form-control"
                                           value="${homestay.city}"
                                           placeholder="VD: Đà Lạt, Hội An, Đà Nẵng..."
                                           required maxlength="100">
                                </div>
                                <div class="col-sm-6">
                                    <label class="form-label fw-semibold" style="font-size:.85rem;">Quận / Huyện</label>
                                    <input type="text" name="district" class="form-control"
                                           value="${homestay.district}"
                                           placeholder="VD: Phường 10, Quận Hải Châu..."
                                           maxlength="100">
                                </div>
                            </div>
                        </div>

                        <!-- Right column -->
                        <div class="col-lg-4">
                            <h6 class="fw-bold mb-3 pb-2 border-bottom">
                                <i class="fa-regular fa-clock text-primary me-2"></i>Giờ nhận & trả phòng
                            </h6>

                            <div class="mb-3">
                                <label class="form-label fw-semibold" style="font-size:.85rem;">Giờ nhận phòng (Check-in)</label>
                                <input type="time" name="checkinTime" class="form-control"
                                       value="<c:choose><c:when test='${not empty homestay.checkinTime}'><fmt:formatDate value='${homestay.checkinTime}' pattern='HH:mm'/></c:when><c:otherwise>14:00</c:otherwise></c:choose>">
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold" style="font-size:.85rem;">Giờ trả phòng (Check-out)</label>
                                <input type="time" name="checkoutTime" class="form-control"
                                       value="<c:choose><c:when test='${not empty homestay.checkoutTime}'><fmt:formatDate value='${homestay.checkoutTime}' pattern='HH:mm'/></c:when><c:otherwise>12:00</c:otherwise></c:choose>">
                            </div>

                            <!-- Status info (read-only) -->
                            <c:if test="${not isNew}">
                                <div class="mt-4 p-3 rounded-3" style="background:#f8fafc;border:1px solid #e2e8f0;">
                                    <div class="fw-semibold mb-2" style="font-size:.83rem;">Trạng thái hiện tại</div>
                                    <c:choose>
                                        <c:when test="${homestay.status == 'ACTIVE'}">
                                            <span class="badge bg-success-subtle text-success border border-success px-2 py-1">
                                                <i class="fa-solid fa-circle-check me-1"></i>Đang hoạt động
                                            </span>
                                        </c:when>
                                        <c:when test="${homestay.status == 'PENDING_APPROVAL'}">
                                            <span class="badge bg-warning-subtle text-warning border border-warning px-2 py-1">
                                                <i class="fa-solid fa-clock me-1"></i>Chờ Admin duyệt
                                            </span>
                                        </c:when>
                                        <c:when test="${homestay.status == 'REJECTED'}">
                                            <span class="badge bg-danger-subtle text-danger border border-danger px-2 py-1">
                                                <i class="fa-solid fa-ban me-1"></i>Bị từ chối
                                            </span>
                                            <div class="text-muted mt-1" style="font-size:.75rem;">
                                                Lưu lại sẽ tự động gửi Admin xét duyệt lại.
                                            </div>
                                        </c:when>
                                        <c:when test="${homestay.status == 'INACTIVE'}">
                                            <span class="badge bg-secondary-subtle text-secondary border px-2 py-1">
                                                <i class="fa-solid fa-pause me-1"></i>Tạm ngừng
                                            </span>
                                        </c:when>
                                    </c:choose>
                                    <div class="text-muted mt-2" style="font-size:.75rem;">
                                        <i class="fa-regular fa-clock me-1"></i>
                                        Cập nhật lần cuối:
                                        <fmt:formatDate value="${homestay.updatedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </div>
                                </div>
                            </c:if>
                        </div>

                    </div><%-- /row --%>

                    <!-- Form actions -->
                    <div class="d-flex gap-3 mt-4 pt-3 border-top align-items-center flex-wrap">
                        <button type="submit" class="btn btn-primary-custom px-5">
                            <i class="fa-solid fa-${not isNew && homestay.status == 'REJECTED' ? 'paper-plane' : 'floppy-disk'} me-2"></i>
                            ${not isNew && homestay.status == 'REJECTED' ? 'Lưu & Gửi lại duyệt' : 'Lưu thay đổi'}
                        </button>
                        <a href="${pageContext.request.contextPath}/owner/homestays"
                           class="btn btn-outline-secondary px-4">Hủy</a>
                        <c:if test="${not isNew}">
                            <span class="text-muted ms-auto" style="font-size:.78rem;">
                                ID: #${homestay.homestayId}
                            </span>
                        </c:if>
                    </div>
                </form>
            </div>

        </div><%-- /.owner-content --%>
    </div><%-- /.owner-main --%>
</div><%-- /.owner-shell --%>

<script>
// Client-side validation
document.getElementById('homestayEditForm').addEventListener('submit', function(e) {
    var name = document.querySelector('[name="name"]').value.trim();
    var address = document.querySelector('[name="address"]').value.trim();
    var city = document.querySelector('[name="city"]').value.trim();
    if (!name || !address || !city) {
        e.preventDefault();
        alert('Vui lòng điền đầy đủ Tên homestay, Địa chỉ và Thành phố.');
    }
});
</script>

<jsp:include page="../common/footer.jsp"/>
