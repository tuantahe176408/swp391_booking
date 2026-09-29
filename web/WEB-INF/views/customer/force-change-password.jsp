<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">
            <div class="card border-0 shadow-lg rounded-4 p-4">
                <div class="card-body">
                    <div class="text-center mb-4">
                        <div class="mb-3">
                            <span class="d-inline-flex align-items-center justify-content-center rounded-circle bg-warning-subtle p-3" style="width: 64px; height: 64px;">
                                <i class="fa-solid fa-lock fa-2x text-warning"></i>
                            </span>
                        </div>
                        <h2 class="fw-bold mb-1">Đổi mật khẩu bắt buộc</h2>
                        <p class="text-muted small">
                            Bạn đang đăng nhập bằng mật khẩu tạm thời được cấp phát. Để bảo vệ tài khoản, vui lòng thiết lập mật khẩu mới của bạn.
                        </p>
                    </div>

                    <div class="alert alert-warning d-flex align-items-center mb-4" role="alert">
                        <i class="fa-solid fa-shield-halved me-2 fs-5 text-warning"></i>
                        <div class="small">
                            <strong>Lưu ý bảo mật:</strong> Sau khi đổi mật khẩu thành công, bạn sẽ sử dụng mật khẩu mới này cho tất cả các lần đăng nhập tiếp theo.
                        </div>
                    </div>

                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center" role="alert">
                            <i class="fa-solid fa-circle-exclamation me-2 fs-5"></i>
                            <div>${errorMessage}</div>
                            <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/force-change-password" method="POST" id="forcePasswordForm">
                        <div class="mb-3">
                            <label class="form-label font-weight-semibold">Mật khẩu mới</label>
                            <div class="input-group">
                                <input type="password" id="newPassword" name="newPassword" class="form-control form-control-lg" placeholder="••••••••" required minlength="6" autofocus>
                                <button class="btn btn-outline-secondary" type="button" onclick="togglePasswordVisibility('newPassword', this)">
                                    <i class="fa-solid fa-eye"></i>
                                </button>
                            </div>
                            <div class="form-text text-muted">Mật khẩu tối thiểu 6 ký tự.</div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label font-weight-semibold">Xác nhận Mật khẩu mới</label>
                            <div class="input-group">
                                <input type="password" id="confirmPassword" name="confirmPassword" class="form-control form-control-lg" placeholder="••••••••" required minlength="6">
                                <button class="btn btn-outline-secondary" type="button" onclick="togglePasswordVisibility('confirmPassword', this)">
                                    <i class="fa-solid fa-eye"></i>
                                </button>
                            </div>
                            <div id="passwordMatchMessage" class="form-text small"></div>
                        </div>

                        <button type="submit" class="btn btn-primary-custom w-100 btn-lg mb-3">
                            <i class="fa-solid fa-check-circle me-2"></i>Lưu mật khẩu & Tiếp tục
                        </button>

                        <div class="text-center">
                            <a href="${pageContext.request.contextPath}/logout" class="text-decoration-none small text-danger">
                                <i class="fa-solid fa-arrow-right-from-bracket me-1"></i>Đăng xuất tài khoản
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function togglePasswordVisibility(inputId, btn) {
    const input = document.getElementById(inputId);
    const icon = btn.querySelector('i');
    if (input.type === 'password') {
        input.type = 'text';
        icon.classList.remove('fa-eye');
        icon.classList.add('fa-eye-slash');
    } else {
        input.type = 'password';
        icon.classList.remove('fa-eye-slash');
        icon.classList.add('fa-eye');
    }
}

document.addEventListener('DOMContentLoaded', function() {
    const newPass = document.getElementById('newPassword');
    const confirmPass = document.getElementById('confirmPassword');
    const matchMsg = document.getElementById('passwordMatchMessage');
    const form = document.getElementById('forcePasswordForm');

    function checkMatch() {
        if (!confirmPass.value) {
            matchMsg.textContent = '';
            return;
        }
        if (newPass.value === confirmPass.value) {
            matchMsg.textContent = '✓ Mật khẩu xác nhận trùng khớp';
            matchMsg.className = 'form-text small text-success';
        } else {
            matchMsg.textContent = '✗ Mật khẩu xác nhận không trùng khớp';
            matchMsg.className = 'form-text small text-danger';
        }
    }

    newPass.addEventListener('input', checkMatch);
    confirmPass.addEventListener('input', checkMatch);

    form.addEventListener('submit', function(e) {
        if (newPass.value !== confirmPass.value) {
            e.preventDefault();
            matchMsg.textContent = '✗ Mật khẩu xác nhận không trùng khớp';
            matchMsg.className = 'form-text small text-danger';
            confirmPass.focus();
        }
    });
});
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
