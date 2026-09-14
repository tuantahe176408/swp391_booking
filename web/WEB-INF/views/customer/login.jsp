<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">
            <div class="card border-0 shadow-lg rounded-4 p-4">
                <div class="card-body">
                    <h2 class="text-center font-weight-bold mb-4">Đăng nhập / Đăng ký</h2>

                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fa-solid fa-circle-exclamation me-2"></i>${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <!-- Tabs for Login / Register -->
                    <ul class="nav nav-pills nav-justified mb-4" id="authTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active fw-semibold" id="login-tab" data-bs-toggle="tab" data-bs-target="#login-panel" type="button" role="tab">Đăng nhập</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link fw-semibold" id="register-tab" data-bs-toggle="tab" data-bs-target="#register-panel" type="button" role="tab">Tạo tài khoản</button>
                        </li>
                    </ul>

                    <div class="tab-content" id="authTabsContent">
                        <!-- Login Form -->
                        <div class="tab-pane fade show active" id="login-panel" role="tabpanel">
                            <form action="${pageContext.request.contextPath}/login" method="POST">
                                <div class="mb-3">
                                    <label class="form-label font-weight-semibold">Địa chỉ Email</label>
                                    <input type="email" name="email" class="form-control form-control-lg" placeholder="nhapemail@example.com" required>
                                </div>
                                <div class="mb-3">
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <label class="form-label font-weight-semibold mb-0">Mật khẩu</label>
                                        <a href="#" class="text-decoration-none small text-primary">Quên mật khẩu?</a>
                                    </div>
                                    <input type="password" name="password" class="form-control form-control-lg" placeholder="••••••••" required>
                                </div>
                                <button type="submit" class="btn btn-primary-custom w-100 btn-lg mb-3">Đăng nhập ngay</button>
                            </form>
                        </div>

                        <!-- Register Form -->
                        <div class="tab-pane fade" id="register-panel" role="tabpanel">
                            <form action="${pageContext.request.contextPath}/register" method="POST">
                                <div class="mb-3">
                                    <label class="form-label font-weight-semibold">Họ và Tên</label>
                                    <input type="text" name="fullName" class="form-control form-control-lg" placeholder="Nguyễn Văn A" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label font-weight-semibold">Địa chỉ Email</label>
                                    <input type="email" name="email" class="form-control form-control-lg" placeholder="nhapemail@example.com" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label font-weight-semibold">Số điện thoại</label>
                                    <input type="tel" name="phone" class="form-control form-control-lg" placeholder="0901234567">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label font-weight-semibold">Mật khẩu</label>
                                    <input type="password" name="password" class="form-control form-control-lg" placeholder="••••••••" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label font-weight-semibold">Xác nhận Mật khẩu</label>
                                    <input type="password" name="confirmPassword" class="form-control form-control-lg" placeholder="••••••••" required>
                                </div>
                                <button type="submit" class="btn btn-primary-custom w-100 btn-lg">Đăng ký tài khoản</button>
                            </form>
                        </div>
                    </div>

                    <div class="text-center mt-4">
                        <span class="text-muted small">Hoặc đăng nhập nhanh bằng</span>
                        <div class="mt-2">
                            <a href="${pageContext.request.contextPath}/auth/google" class="btn btn-outline-danger w-100 btn-lg"><i class="fa-brands fa-google me-2"></i>Đăng nhập với Google</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
