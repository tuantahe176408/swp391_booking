<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card border-0 shadow-lg rounded-4 overflow-hidden">
                <div class="card-header bg-primary text-white p-4">
                    <div class="d-flex align-items-center gap-3">
                        <c:choose>
                            <c:when test="${not empty sessionScope.currentUser.avatarUrl}">
                                <img src="${sessionScope.currentUser.avatarUrl}" class="rounded-circle border border-2 border-white shadow-sm" width="64" height="64" alt="Avatar" onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/images/default-avatar.svg';">
                            </c:when>
                            <c:otherwise>
                                <div class="rounded-circle bg-white text-primary d-flex align-items-center justify-content-center fw-bold fs-3 shadow-sm" style="width: 64px; height: 64px;">
                                    ${sessionScope.currentUser.fullName.substring(0,1).toUpperCase()}
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <div>
                            <h4 class="mb-1 text-white">${sessionScope.currentUser.fullName}</h4>
                            <p class="mb-0 text-white-50"><i class="fa-regular fa-envelope me-1"></i> ${sessionScope.currentUser.email}</p>
                        </div>
                    </div>
                </div>
                <div class="card-body p-4">

                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success alert-dismissible fade show rounded-3 mb-4" role="alert">
                            <i class="fa-solid fa-circle-check me-2"></i> ${successMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show rounded-3 mb-4" role="alert">
                            <i class="fa-solid fa-circle-exclamation me-2"></i> ${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/customer/profile" method="POST">
                        <h5 class="fw-bold text-dark border-bottom pb-2 mb-4">
                            <i class="fa-solid fa-user-pen text-primary me-2"></i>UC02: Thông tin cá nhân & Sở thích
                        </h5>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Họ và tên <span class="text-danger">*</span></label>
                                <input type="text" name="fullName" class="form-control rounded-3" value="${sessionScope.currentUser.fullName}" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Số điện thoại</label>
                                <input type="tel" name="phoneNumber" class="form-control rounded-3" value="${sessionScope.currentUser.phoneNumber}" placeholder="0901234567">
                            </div>
                            <div class="col-md-12">
                                <label class="form-label fw-semibold">Email liên hệ (Cố định)</label>
                                <input type="email" class="form-control rounded-3 bg-light" value="${sessionScope.currentUser.email}" readonly>
                            </div>
                            <div class="col-md-12">
                                <label class="form-label fw-semibold">Ảnh đại diện (URL / Cloudinary)</label>
                                <input type="url" name="avatarUrl" class="form-control rounded-3" value="${sessionScope.currentUser.avatarUrl}" placeholder="https://res.cloudinary.com/...">
                            </div>

                            <div class="col-12 mt-4">
                                <h6 class="fw-bold text-dark border-bottom pb-2 mb-3">
                                    <i class="fa-solid fa-heart text-danger me-2"></i>Sở thích du lưu trú (Dữ liệu AI Recommendation)
                                </h6>
                                <div class="d-flex flex-wrap gap-2">
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" id="pref1" checked>
                                        <label class="form-check-label" for="pref1">Homestay view biển</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" id="pref2" checked>
                                        <label class="form-check-label" for="pref2">Villa có bể bơi</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" id="pref3">
                                        <label class="form-check-label" for="pref3">Phòng phong cách Eco Natural</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" id="pref4" checked>
                                        <label class="form-check-label" for="pref4">Thích phục vụ tiệc BBQ</label>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="d-flex justify-content-end gap-2 mt-4 pt-3 border-top">
                            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary px-4">Hủy</a>
                            <button type="submit" class="btn btn-primary-custom px-4">Lưu thay đổi</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Card: Đổi Mật Khẩu -->
            <div class="card border-0 shadow-lg rounded-4 overflow-hidden mt-4">
                <div class="card-header bg-dark text-white p-3 px-4">
                    <h5 class="mb-0 fw-bold"><i class="fa-solid fa-key me-2 text-warning"></i>Đổi mật khẩu tài khoản</h5>
                </div>
                <div class="card-body p-4">
                    <c:if test="${not empty passwordSuccess}">
                        <div class="alert alert-success alert-dismissible fade show rounded-3 mb-3">
                            <i class="fa-solid fa-circle-check me-2"></i> ${passwordSuccess}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty passwordError}">
                        <div class="alert alert-danger alert-dismissible fade show rounded-3 mb-3">
                            <i class="fa-solid fa-circle-exclamation me-2"></i> ${passwordError}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/customer/profile" method="POST">
                        <input type="hidden" name="action" value="changePassword">
                        <div class="row g-3">
                            <div class="col-md-12">
                                <label class="form-label fw-semibold">Mật khẩu hiện tại <span class="text-danger">*</span></label>
                                <input type="password" name="currentPassword" class="form-control rounded-3" placeholder="Nhập mật khẩu đang dùng" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Mật khẩu mới <span class="text-danger">*</span></label>
                                <input type="password" name="newPassword" class="form-control rounded-3" placeholder="Tối thiểu 6 ký tự" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Xác nhận mật khẩu mới <span class="text-danger">*</span></label>
                                <input type="password" name="confirmPassword" class="form-control rounded-3" placeholder="Nhập lại mật khẩu mới" required>
                            </div>
                            <div class="col-12 text-end mt-4">
                                <button type="submit" class="btn btn-outline-dark px-4">
                                    <i class="fa-solid fa-shield-check me-2"></i>Cập nhật mật khẩu
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>
