<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<div class="container py-5" style="max-width:480px;">
    <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5">

        <!-- Icon + heading -->
        <div class="text-center mb-4">
            <div class="rounded-circle bg-primary-subtle d-inline-flex align-items-center justify-content-center mb-3"
                 style="width:68px;height:68px;">
                <i class="fa-solid fa-envelope-circle-check text-primary fs-2"></i>
            </div>
            <h4 class="fw-bold mb-1">Xác thực tài khoản</h4>
            <p class="text-muted mb-0" style="font-size:.9rem;">
                Mã OTP đã được gửi đến
                <strong class="text-dark">${not empty pendingEmail ? pendingEmail : 'email của bạn'}</strong>
            </p>
        </div>

        <!-- Error alert -->
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger rounded-3 mb-3 d-flex gap-2 align-items-center py-2">
                <i class="fa-solid fa-circle-exclamation flex-shrink-0"></i>
                <span style="font-size:.88rem;">${errorMessage}</span>
            </div>
        </c:if>

        <!-- Success alert (resend OTP) -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success rounded-3 mb-3 d-flex gap-2 align-items-center py-2">
                <i class="fa-solid fa-circle-check flex-shrink-0"></i>
                <span style="font-size:.88rem;">${successMessage}</span>
            </div>
        </c:if>

        <!-- OTP form -->
        <form method="post" action="${pageContext.request.contextPath}/verify-activation"
              id="otpForm" novalidate>
            <div class="mb-3">
                <label class="form-label fw-semibold">Nhập mã OTP (6 chữ số)</label>
                <input type="text" name="otp" id="otpInput"
                       class="form-control form-control-lg text-center rounded-3 fw-bold"
                       style="font-size:1.6rem;letter-spacing:.5rem;"
                       maxlength="6" pattern="[0-9]{6}"
                       placeholder="______" autofocus required
                       oninput="this.value=this.value.replace(/\D/g,'')">
                <div class="form-text text-center">Mã có hiệu lực trong <strong>10 phút</strong></div>
            </div>

            <button type="submit" class="btn btn-primary-custom w-100 py-3 fw-semibold rounded-3 mb-3">
                <i class="fa-solid fa-check-circle me-2"></i>Xác thực & Kích hoạt
            </button>
        </form>

        <!-- Resend OTP -->
        <div class="text-center">
            <form method="post" action="${pageContext.request.contextPath}/verify-activation" style="display:inline;">
                <input type="hidden" name="resend" value="1">
                <button type="submit" class="btn btn-link btn-sm text-muted p-0"
                        style="font-size:.83rem;">
                    <i class="fa-solid fa-rotate-right me-1"></i>Gửi lại mã OTP
                </button>
            </form>
        </div>

        <hr class="my-3">
        <div class="text-center">
            <a href="${pageContext.request.contextPath}/login"
               class="text-muted" style="font-size:.82rem;">
                <i class="fa-solid fa-arrow-left me-1"></i>Quay lại Đăng nhập
            </a>
        </div>
    </div>
</div>

<script>
// Auto-submit khi nhập đủ 6 số
document.getElementById('otpInput').addEventListener('input', function() {
    if (this.value.length === 6) {
        document.getElementById('otpForm').submit();
    }
});
</script>

<jsp:include page="../common/footer.jsp"/>
