<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
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
                <%-- enctype="multipart/form-data" enables image file uploads alongside text fields --%>
                <form method="post"
                      action="${pageContext.request.contextPath}/owner/homestays/edit"
                      enctype="multipart/form-data"
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

                    <%-- ═══════════════════════════════════════════════════════
                         IMAGE MANAGEMENT — Upload to Cloudinary
                         New images: attach files below (uploaded on Save)
                         Existing images: delete / set as primary via action buttons
                    ═══════════════════════════════════════════════════════ --%>
                    <div class="mt-4 pt-3 border-top">
                        <h6 class="fw-bold mb-3">
                            <i class="fa-regular fa-images text-primary me-2"></i>Ảnh Homestay
                            <span class="text-muted fw-normal" style="font-size:.8rem;">(Lưu trên Cloudinary · Tối đa 6 ảnh, mỗi ảnh ≤ 10 MB)</span>
                        </h6>

                        <%-- ── Upload new images ── --%>
                        <div class="mb-3">
                            <label class="form-label" style="font-size:.85rem;font-weight:600;">
                                Thêm ảnh mới
                            </label>
                            <input type="file" name="images" id="imageUploadInput"
                                   accept="image/jpeg,image/png,image/gif,image/webp"
                                   multiple
                                   class="form-control"
                                   onchange="previewNewImages(this)">
                            <div class="form-text">JPG, PNG, GIF, WebP. Chọn nhiều file cùng lúc. Ảnh đầu tiên sẽ tự động là ảnh đại diện nếu chưa có.</div>
                        </div>

                        <%-- ── New-image preview strip (populated by JS) ── --%>
                        <div id="newImagePreview" class="d-flex flex-wrap gap-2 mb-3"></div>

                        <%-- ── Existing images (edit page only) ── --%>
                        <c:if test="${not isNew}">
                            <c:choose>
                                <c:when test="${not empty images}">
                                    <p class="fw-semibold mb-2" style="font-size:.85rem;">
                                        Ảnh hiện có (${fn:length(images)} ảnh):
                                    </p>
                                    <div class="row g-2">
                                        <c:forEach var="img" items="${images}" varStatus="loop">
                                            <div class="col-6 col-sm-4 col-md-3 col-lg-2" id="imgCard_${img.imageId}">
                                                <div class="position-relative rounded-3 overflow-hidden border
                                                            ${img.primary ? 'border-2 border-primary shadow' : 'border-light'}">
                                                    <img src="${img.imageUrl}"
                                                         class="w-100 object-fit-cover"
                                                         style="height:110px;"
                                                         alt="Ảnh ${loop.index + 1}"
                                                         onerror="this.src='${pageContext.request.contextPath}/assets/images/placeholder.jpg'">

                                                    <%-- Primary badge --%>
                                                    <c:if test="${img.primary}">
                                                        <span class="position-absolute top-0 start-0 badge bg-primary m-1"
                                                              style="font-size:.65rem;">
                                                            <i class="fa-solid fa-star me-1"></i>Chính
                                                        </span>
                                                    </c:if>

                                                    <%-- Action buttons overlay --%>
                                                    <div class="position-absolute bottom-0 start-0 end-0 d-flex gap-1 p-1"
                                                         style="background:rgba(0,0,0,.45);">

                                                        <%-- Set primary (hidden if already primary) --%>
                                                        <c:if test="${not img.primary}">
                                                            <form method="post"
                                                                  action="${pageContext.request.contextPath}/owner/homestays/set-primary"
                                                                  class="d-inline">
                                                                <input type="hidden" name="imageId"    value="${img.imageId}">
                                                                <input type="hidden" name="homestayId" value="${homestay.homestayId}">
                                                                <button type="submit"
                                                                        class="btn btn-warning btn-sm p-0 px-1"
                                                                        style="font-size:.7rem;"
                                                                        title="Đặt làm ảnh đại diện">
                                                                    <i class="fa-regular fa-star"></i>
                                                                </button>
                                                            </form>
                                                        </c:if>

                                                        <%-- Delete --%>
                                                        <form method="post"
                                                              action="${pageContext.request.contextPath}/owner/homestays/delete-image"
                                                              class="d-inline ms-auto"
                                                              onsubmit="return confirm('Xóa ảnh này?\nThao tác không thể hoàn tác.');">
                                                            <input type="hidden" name="imageId"    value="${img.imageId}">
                                                            <input type="hidden" name="homestayId" value="${homestay.homestayId}">
                                                            <button type="submit"
                                                                    class="btn btn-danger btn-sm p-0 px-1"
                                                                    style="font-size:.7rem;"
                                                                    title="Xóa ảnh">
                                                                <i class="fa-solid fa-trash-can"></i>
                                                            </button>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-muted" style="font-size:.85rem;">
                                        <i class="fa-regular fa-image me-1"></i>
                                        Homestay này chưa có ảnh. Thêm ảnh bên trên và nhấn Lưu.
                                    </p>
                                </c:otherwise>
                            </c:choose>
                        </c:if>

                        <c:if test="${isNew}">
                            <p class="text-muted" style="font-size:.83rem;">
                                <i class="fa-solid fa-circle-info me-1"></i>
                                Ảnh sẽ được tải lên Cloudinary ngay khi bạn nhấn <strong>Lưu thay đổi</strong>.
                            </p>
                        </c:if>
                    </div><%-- /image management --%>

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
                            <!-- Delete button — only show on edit page, not new -->
                            <button type="button"
                                    class="btn btn-outline-danger btn-sm px-3"
                                    onclick="openDeleteModal()"
                                    title="Xóa cơ sở này vĩnh viễn">
                                <i class="fa-solid fa-trash-can me-1"></i>Xóa cơ sở
                            </button>
                        </c:if>
                    </div>
                </form>
            </div>

            <%-- ── Delete Homestay Modal (only for edit pages) ── --%>
            <c:if test="${not isNew}">
                <div class="owner-modal-overlay" id="deleteHomestayModal"
                     style="display:none;position:fixed;inset:0;background:rgba(15,23,42,.55);z-index:1050;align-items:center;justify-content:center;padding:1rem;"
                     onclick="if(event.target===this)closeDeleteModal()">
                    <div style="background:#fff;border-radius:18px;padding:2rem;width:100%;max-width:460px;box-shadow:0 24px 64px rgba(15,23,42,.2);animation:modalIn .18s ease;">
                        <style>@keyframes modalIn{from{opacity:0;transform:scale(.96) translateY(-10px)}to{opacity:1;transform:scale(1) translateY(0)}}</style>

                        <div class="text-center mb-3">
                            <div style="width:60px;height:60px;border-radius:50%;background:#fef2f2;display:flex;align-items:center;justify-content:center;margin:0 auto .75rem;font-size:1.6rem;color:#ef4444;">
                                <i class="fa-solid fa-trash-can"></i>
                            </div>
                            <h5 class="fw-bold mb-1">Xóa cơ sở Homestay?</h5>
                            <p class="text-muted mb-0" style="font-size:.88rem;">
                                Bạn đang xóa: <strong>${homestay.name}</strong>
                            </p>
                        </div>
                        <div class="alert alert-danger py-2 px-3 rounded-3 mb-3" style="font-size:.82rem;">
                            <i class="fa-solid fa-triangle-exclamation me-1"></i>
                            <strong>Không thể hoàn tác.</strong> Tất cả ảnh, loại phòng và phòng vật lý sẽ bị xóa vĩnh viễn.
                            Không thể xóa nếu còn đặt phòng đang hoạt động.
                        </div>

                        <form method="post"
                              action="${pageContext.request.contextPath}/owner/homestays/delete"
                              id="deleteHomestayForm">
                            <input type="hidden" name="homestayId" value="${homestay.homestayId}">
                            <div class="mb-3">
                                <label class="form-label" style="font-size:.83rem;">
                                    Nhập <strong>XÓA</strong> để xác nhận:
                                </label>
                                <input type="text" id="deleteConfirmInput"
                                       class="form-control form-control-sm"
                                       placeholder='Gõ "XÓA" để xác nhận'
                                       autocomplete="off"
                                       oninput="updateDeleteBtn()">
                            </div>
                            <div class="d-flex gap-2">
                                <button type="submit" id="deleteConfirmBtn"
                                        class="btn btn-danger flex-fill" disabled>
                                    <i class="fa-solid fa-trash-can me-1"></i>Xóa cơ sở
                                </button>
                                <button type="button"
                                        class="btn btn-outline-secondary flex-fill"
                                        onclick="closeDeleteModal()">Hủy bỏ</button>
                            </div>
                        </form>
                    </div>
                </div>
            </c:if>

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

/**
 * Show thumbnail previews for files chosen in the new-image input.
 */
function previewNewImages(input) {
    var container = document.getElementById('newImagePreview');
    container.innerHTML = '';
    if (!input.files) return;

    var MAX_MB = 10;
    Array.from(input.files).forEach(function(file, idx) {
        if (!file.type.startsWith('image/')) return;
        if (file.size > MAX_MB * 1024 * 1024) {
            var warn = document.createElement('div');
            warn.className = 'text-danger small';
            warn.textContent = file.name + ' vượt quá ' + MAX_MB + ' MB, sẽ bị bỏ qua.';
            container.appendChild(warn);
            return;
        }
        var wrapper = document.createElement('div');
        wrapper.className = 'position-relative';
        wrapper.style.cssText = 'width:90px;height:90px;';

        var img = document.createElement('img');
        img.className = 'w-100 h-100 object-fit-cover rounded-3 border';
        img.alt = 'Preview ' + (idx + 1);

        var badge = document.createElement('span');
        badge.className = 'position-absolute bottom-0 start-0 badge bg-dark m-1';
        badge.style.fontSize = '.6rem';
        badge.textContent = idx === 0 ? '★ Chính' : '#' + (idx + 1);

        var reader = new FileReader();
        reader.onload = function(e) { img.src = e.target.result; };
        reader.readAsDataURL(file);

        wrapper.appendChild(img);
        wrapper.appendChild(badge);
        container.appendChild(wrapper);
    });
}

// ── Delete modal helpers ──────────────────────────────────────────────────────
function openDeleteModal() {
    var modal = document.getElementById('deleteHomestayModal');
    if (!modal) return;
    document.getElementById('deleteConfirmInput').value = '';
    document.getElementById('deleteConfirmBtn').disabled = true;
    modal.style.display = 'flex';
    setTimeout(function() {
        document.getElementById('deleteConfirmInput').focus();
    }, 200);
}
function closeDeleteModal() {
    var modal = document.getElementById('deleteHomestayModal');
    if (modal) modal.style.display = 'none';
}
function updateDeleteBtn() {
    var val = document.getElementById('deleteConfirmInput').value.trim().toUpperCase();
    document.getElementById('deleteConfirmBtn').disabled = (val !== 'XÓA');
}
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') closeDeleteModal();
});
</script>

<jsp:include page="../common/footer.jsp"/>
