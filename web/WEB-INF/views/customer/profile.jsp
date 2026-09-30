<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<style>
.profile-avatar-wrapper {
    position: relative;
    width: 110px;
    height: 110px;
    margin: 0 auto;
}
.profile-avatar-img {
    width: 110px;
    height: 110px;
    object-fit: cover;
    border-radius: 50%;
    border: 4px solid #ffffff;
    box-shadow: 0 8px 24px rgba(79, 70, 229, 0.18);
    transition: transform 0.25s ease;
}
.profile-avatar-wrapper:hover .profile-avatar-img {
    transform: scale(1.02);
}
.avatar-upload-badge {
    position: absolute;
    bottom: 2px;
    right: 2px;
    width: 34px;
    height: 34px;
    border-radius: 50%;
    background: var(--primary-color, #4f46e5);
    color: #ffffff;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    box-shadow: 0 4px 10px rgba(0,0,0,0.2);
    border: 2px solid #ffffff;
    transition: all 0.2s ease;
}
.avatar-upload-badge:hover {
    background: var(--primary-hover, #4338ca);
    transform: scale(1.1);
}
.preference-pill-checkbox {
    display: none;
}
.preference-pill-label {
    display: inline-flex;
    align-items: center;
    padding: 0.5rem 1rem;
    border-radius: 50px;
    font-size: 0.88rem;
    font-weight: 500;
    color: #475569;
    background-color: #f1f5f9;
    border: 1.5px solid transparent;
    cursor: pointer;
    transition: all 0.2s ease;
    user-select: none;
}
.preference-pill-label:hover {
    background-color: #e2e8f0;
}
.preference-pill-checkbox:checked + .preference-pill-label {
    background-color: #eef2ff;
    color: #4f46e5;
    border-color: #6366f1;
    font-weight: 600;
    box-shadow: 0 2px 8px rgba(99, 102, 241, 0.15);
}
.profile-side-link {
    display: flex;
    align-items: center;
    padding: 0.75rem 1rem;
    border-radius: 12px;
    color: #475569;
    font-weight: 600;
    text-decoration: none;
    transition: all 0.2s ease;
    margin-bottom: 0.35rem;
}
.profile-side-link:hover {
    background-color: #f8fafc;
    color: var(--primary-color, #4f46e5);
    transform: translateX(4px);
}
.profile-side-link.active {
    background: linear-gradient(135deg, #eef2ff 0%, #e0e7ff 100%);
    color: var(--primary-color, #4f46e5);
    border-left: 4px solid var(--primary-color, #4f46e5);
}
.form-icon-group {
    position: relative;
}
.form-icon-group .form-control {
    padding-left: 2.75rem;
}
.form-icon-group .input-icon {
    position: absolute;
    left: 1rem;
    top: 50%;
    transform: translateY(-50%);
    color: #94a3b8;
    font-size: 1rem;
    z-index: 4;
}
</style>

<div class="container py-4 py-lg-5">
    <!-- Breadcrumb & Header -->
    <div class="row mb-4">
        <div class="col-12">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-2">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home" class="text-decoration-none text-secondary"><i class="fa-solid fa-house me-1"></i>Trang chủ</a></li>
                    <li class="breadcrumb-item active text-primary fw-semibold" aria-current="page">Hồ sơ cá nhân</li>
                </ol>
            </nav>
            <div class="d-flex align-items-center justify-content-between flex-wrap gap-2">
                <div>
                    <h2 class="fw-bold mb-1">Hồ sơ cá nhân</h2>
                    <p class="text-secondary mb-0">Quản lý thông tin tài khoản, ảnh đại diện và tùy chọn lưu trú của bạn</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Alert Notifications -->
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success alert-dismissible fade show rounded-4 shadow-sm border-0 d-flex align-items-center mb-4" role="alert">
            <i class="fa-solid fa-circle-check fs-4 me-3 text-success"></i>
            <div>
                <strong>Thành công!</strong> ${successMessage}
            </div>
            <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show rounded-4 shadow-sm border-0 d-flex align-items-center mb-4" role="alert">
            <i class="fa-solid fa-circle-exclamation fs-4 me-3 text-danger"></i>
            <div>
                <strong>Lỗi!</strong> ${errorMessage}
            </div>
            <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="row g-4">
        <!-- ── Left Column: User Profile Summary & Navigation ──────────────── -->
        <div class="col-lg-4">
            <!-- Profile Identity Card -->
            <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4 bg-white">
                <!-- Cover Banner -->
                <div style="height: 90px; background: linear-gradient(135deg, #6366f1 0%, #4f46e5 50%, #06b6d4 100%);"></div>
                
                <div class="card-body text-center pt-0 pb-4 px-4">
                    <!-- Avatar with Upload Badge -->
                    <div class="profile-avatar-wrapper mb-3" style="margin-top: -55px;">
                        <c:choose>
                            <c:when test="${not empty sessionScope.currentUser.avatarUrl}">
                                <img id="avatarPreview"
                                     src="${sessionScope.currentUser.avatarUrl}"
                                     class="profile-avatar-img"
                                     alt="Avatar"
                                     onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/images/default-avatar.svg';">
                            </c:when>
                            <c:otherwise>
                                <img id="avatarPreview"
                                     src="${pageContext.request.contextPath}/assets/images/default-avatar.svg"
                                     class="profile-avatar-img"
                                     alt="Avatar">
                            </c:otherwise>
                        </c:choose>
                        <label for="avatarFile" class="avatar-upload-badge" title="Đổi ảnh đại diện">
                            <i class="fa-solid fa-camera font-size-sm"></i>
                        </label>
                    </div>

                    <h5 class="fw-bold mb-1 text-dark">${sessionScope.currentUser.fullName}</h5>
                    <p class="text-secondary small mb-3">
                        <i class="fa-regular fa-envelope me-1"></i>${sessionScope.currentUser.email}
                    </p>

                    <!-- Badges -->
                    <div class="d-flex justify-content-center gap-2 flex-wrap mb-3">
                        <c:choose>
                            <c:when test="${sessionScope.currentUser.authProvider == 'GOOGLE'}">
                                <span class="badge bg-danger-subtle text-danger border border-danger-subtle px-2.5 py-1.5 rounded-pill font-weight-semibold">
                                    <i class="fa-brands fa-google me-1"></i>Google Account
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-2.5 py-1.5 rounded-pill font-weight-semibold">
                                    <i class="fa-solid fa-shield-halved me-1"></i>Tài khoản Email
                                </span>
                            </c:otherwise>
                        </c:choose>

                        <c:if test="${sessionScope.currentUser.emailVerified}">
                            <span class="badge bg-success-subtle text-success border border-success-subtle px-2.5 py-1.5 rounded-pill font-weight-semibold">
                                <i class="fa-solid fa-circle-check me-1"></i>Đã xác thực
                            </span>
                        </c:if>
                    </div>

                    <!-- Upload Action Button -->
                    <div class="pt-2 border-top">
                        <label for="avatarFile" class="btn btn-outline-primary btn-sm rounded-pill px-3 py-1.5 fw-semibold cursor-pointer">
                            <i class="fa-solid fa-upload me-1.5"></i>Chọn ảnh mới
                        </label>
                        <div class="form-text mt-1 text-muted" style="font-size: 0.78rem;">JPG, PNG, GIF, WebP — tối đa 5 MB</div>
                    </div>
                </div>
            </div>

            <!-- Quick Navigation Menu -->
            <div class="card border-0 shadow-sm rounded-4 p-3 bg-white">
                <div class="fw-bold text-dark px-2 mb-2 small text-uppercase text-secondary" style="letter-spacing: 0.5px;">Trung tâm cá nhân</div>
                <a href="${pageContext.request.contextPath}/customer/profile" class="profile-side-link active">
                    <i class="fa-solid fa-user-gear me-2.5 text-primary"></i>Thông tin tài khoản
                </a>
                <a href="${pageContext.request.contextPath}/customer/bookings" class="profile-side-link">
                    <i class="fa-solid fa-calendar-check me-2.5 text-secondary"></i>Đơn đặt phòng của tôi
                </a>
                <a href="${pageContext.request.contextPath}/customer/wishlist" class="profile-side-link">
                    <i class="fa-solid fa-heart me-2.5 text-danger"></i>Danh sách yêu thích
                </a>
                <a href="${pageContext.request.contextPath}/customer/recommendations" class="profile-side-link">
                    <i class="fa-solid fa-wand-magic-sparkles me-2.5 text-warning"></i>Gợi ý Homestay dành cho bạn
                </a>
            </div>
        </div>

        <!-- ── Right Column: Information Forms ────────────────────────────── -->
        <div class="col-lg-8">
            <!-- Form 1: General Info & Preferences -->
            <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white mb-4">
                <div class="card-header bg-white border-bottom p-4">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <h5 class="fw-bold mb-1 text-dark">
                                <i class="fa-solid fa-id-card text-primary me-2"></i>Thông tin cá nhân
                            </h5>
                            <p class="text-secondary small mb-0">Cập nhật thông tin định danh và số điện thoại liên hệ</p>
                        </div>
                    </div>
                </div>

                <div class="card-body p-4">
                    <form action="${pageContext.request.contextPath}/customer/profile"
                          method="POST" enctype="multipart/form-data" id="profileForm">
                        
                        <!-- Hidden File Input for Avatar (triggered by camera button or Choose Image) -->
                        <input type="file" id="avatarFile" name="avatarFile"
                               accept="image/jpeg,image/png,image/gif,image/webp"
                               class="d-none" onchange="previewAvatar(this)">

                        <div class="row g-3">
                            <!-- Full Name -->
                            <div class="col-md-6">
                                <label class="form-label fw-semibold text-dark">Họ và tên <span class="text-danger">*</span></label>
                                <div class="form-icon-group">
                                    <i class="fa-regular fa-user input-icon"></i>
                                    <input type="text" name="fullName" class="form-control form-control-lg rounded-3 fs-6"
                                           value="${sessionScope.currentUser.fullName}" placeholder="Nhập họ và tên..." required>
                                </div>
                            </div>

                            <!-- Phone Number -->
                            <div class="col-md-6">
                                <label class="form-label fw-semibold text-dark">Số điện thoại liên hệ</label>
                                <div class="form-icon-group">
                                    <i class="fa-solid fa-phone input-icon"></i>
                                    <input type="tel" name="phoneNumber" class="form-control form-control-lg rounded-3 fs-6"
                                           value="${sessionScope.currentUser.phoneNumber}" placeholder="Ví dụ: 0901234567">
                                </div>
                            </div>

                            <!-- Email (Readonly) -->
                            <div class="col-12">
                                <label class="form-label fw-semibold text-dark">
                                    Địa chỉ Email <span class="badge bg-light text-secondary border fw-normal ms-1">Không thể thay đổi</span>
                                </label>
                                <div class="form-icon-group">
                                    <i class="fa-regular fa-envelope input-icon"></i>
                                    <input type="email" class="form-control form-control-lg rounded-3 fs-6 bg-light text-muted"
                                           value="${sessionScope.currentUser.email}" readonly>
                                </div>
                                <div class="form-text text-muted small mt-1">
                                    Email này được sử dụng để nhận vé điện tử E-ticket, mã OTP và thông báo đặt phòng.
                                </div>
                            </div>

                            <!-- AI Preferences Section -->
                            <div class="col-12 mt-4 pt-3 border-top">
                                <div class="d-flex align-items-center gap-2 mb-2">
                                    <h6 class="fw-bold text-dark mb-0">
                                        <i class="fa-solid fa-heart text-danger me-1.5"></i>Sở thích lưu trú
                                    </h6>
                                    <span class="badge bg-primary-subtle text-primary rounded-pill small">AI Smart Matching</span>
                                </div>
                                <p class="text-secondary small mb-3">Hệ thống AI sẽ dựa vào sở thích này để gợi ý phòng nghỉ phù hợp nhất cho chuyến đi của bạn</p>

                                <div class="d-flex flex-wrap gap-2">
                                    <div>
                                        <input class="preference-pill-checkbox" type="checkbox" id="pref1" checked>
                                        <label class="preference-pill-label" for="pref1">
                                            <i class="fa-solid fa-water me-1.5 text-primary"></i>View Biển / Hồ nước
                                        </label>
                                    </div>
                                    <div>
                                        <input class="preference-pill-checkbox" type="checkbox" id="pref2" checked>
                                        <label class="preference-pill-label" for="pref2">
                                            <i class="fa-solid fa-person-swimming me-1.5 text-info"></i>Có Bể bơi riêng
                                        </label>
                                    </div>
                                    <div>
                                        <input class="preference-pill-checkbox" type="checkbox" id="pref3">
                                        <label class="preference-pill-label" for="pref3">
                                            <i class="fa-solid fa-tree me-1.5 text-success"></i>Phong cách Eco & Thiên nhiên
                                        </label>
                                    </div>
                                    <div>
                                        <input class="preference-pill-checkbox" type="checkbox" id="pref4" checked>
                                        <label class="preference-pill-label" for="pref4">
                                            <i class="fa-solid fa-fire-burner me-1.5 text-danger"></i>Tiệc nướng BBQ & Sân vườn
                                        </label>
                                    </div>
                                    <div>
                                        <input class="preference-pill-checkbox" type="checkbox" id="pref5">
                                        <label class="preference-pill-label" for="pref5">
                                            <i class="fa-solid fa-mountain me-1.5 text-warning"></i>Khu vực yên tĩnh & Săn mây
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Submit Button -->
                        <div class="d-flex justify-content-end gap-2 mt-4 pt-3 border-top">
                            <a href="${pageContext.request.contextPath}/home" class="btn btn-light rounded-pill px-4 fw-semibold text-secondary">Hủy</a>
                            <button type="submit" class="btn btn-primary-custom rounded-pill px-4 fw-semibold shadow-sm">
                                <i class="fa-solid fa-floppy-disk me-1.5"></i>Lưu thay đổi
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Card 2: Security & Password Management -->
            <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white">
                <div class="card-header bg-white border-bottom p-4">
                    <h5 class="fw-bold mb-1 text-dark">
                        <i class="fa-solid fa-shield-halved text-warning me-2"></i>Bảo mật & Đổi mật khẩu
                    </h5>
                    <p class="text-secondary small mb-0">Quản lý mật khẩu truy cập và phương thức bảo mật tài khoản</p>
                </div>

                <div class="card-body p-4">
                    <!-- Password Feedback Alerts -->
                    <c:if test="${not empty passwordSuccess}">
                        <div class="alert alert-success alert-dismissible fade show rounded-3 mb-3 d-flex align-items-center" role="alert">
                            <i class="fa-solid fa-circle-check me-2 text-success fs-5"></i>
                            <div>${passwordSuccess}</div>
                            <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty passwordError}">
                        <div class="alert alert-danger alert-dismissible fade show rounded-3 mb-3 d-flex align-items-center" role="alert">
                            <i class="fa-solid fa-circle-exclamation me-2 text-danger fs-5"></i>
                            <div>${passwordError}</div>
                            <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <c:choose>
                        <%-- Google OAuth User --%>
                        <c:when test="${sessionScope.currentUser.authProvider == 'GOOGLE' || empty sessionScope.currentUser.passwordHash}">
                            <div class="p-3.5 rounded-4 bg-light border d-flex align-items-center gap-3">
                                <div class="rounded-circle bg-white shadow-sm p-3 d-flex align-items-center justify-content-center" style="width: 52px; height: 52px;">
                                    <i class="fa-brands fa-google fs-4 text-danger"></i>
                                </div>
                                <div class="flex-grow-1">
                                    <h6 class="fw-bold mb-1 text-dark">Đăng nhập bảo mật qua Google</h6>
                                    <p class="text-secondary small mb-0">
                                        Tài khoản của bạn được liên kết và bảo vệ trực tiếp qua hệ sinh thái bảo mật Google OAuth 2.0. Bạn không cần đổi mật khẩu thủ công.
                                    </p>
                                </div>
                                <span class="badge bg-success-subtle text-success border border-success-subtle rounded-pill px-3 py-2 fw-semibold">
                                    <i class="fa-solid fa-lock me-1"></i>Đã bảo vệ
                                </span>
                            </div>
                        </c:when>

                        <%-- Normal Email/Password User --%>
                        <c:otherwise>
                            <form action="${pageContext.request.contextPath}/customer/profile" method="POST">
                                <input type="hidden" name="action" value="changePassword">
                                <div class="row g-3">
                                    <div class="col-12">
                                        <label class="form-label fw-semibold text-dark">Mật khẩu hiện tại <span class="text-danger">*</span></label>
                                        <div class="form-icon-group">
                                            <i class="fa-solid fa-lock input-icon"></i>
                                            <input type="password" name="currentPassword" class="form-control rounded-3"
                                                   placeholder="Nhập mật khẩu đang dùng..." required>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold text-dark">Mật khẩu mới <span class="text-danger">*</span></label>
                                        <div class="form-icon-group">
                                            <i class="fa-solid fa-key input-icon"></i>
                                            <input type="password" name="newPassword" class="form-control rounded-3"
                                                   placeholder="Tối thiểu 6 ký tự..." required>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold text-dark">Xác nhận mật khẩu mới <span class="text-danger">*</span></label>
                                        <div class="form-icon-group">
                                            <i class="fa-solid fa-check-double input-icon"></i>
                                            <input type="password" name="confirmPassword" class="form-control rounded-3"
                                                   placeholder="Nhập lại mật khẩu mới..." required>
                                        </div>
                                    </div>
                                    <div class="col-12 text-end mt-4">
                                        <button type="submit" class="btn btn-dark rounded-pill px-4 fw-semibold shadow-sm">
                                            <i class="fa-solid fa-shield-check me-1.5"></i>Cập nhật mật khẩu
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
/**
 * Live preview avatar when user picks an image
 */
function previewAvatar(input) {
    if (!input.files || !input.files[0]) return;
    var file = input.files[0];
    if (!file.type.startsWith('image/')) {
        alert('Vui lòng chọn file ảnh hợp lệ (JPG, PNG, GIF, WebP).');
        input.value = '';
        return;
    }
    if (file.size > 5 * 1024 * 1024) {
        alert('File ảnh không được vượt quá dung lượng 5 MB.');
        input.value = '';
        return;
    }
    var reader = new FileReader();
    reader.onload = function(e) {
        var preview = document.getElementById('avatarPreview');
        if (preview) {
            preview.src = e.target.result;
        }
    };
    reader.readAsDataURL(file);
}
</script>

<jsp:include page="../common/footer.jsp"/>
