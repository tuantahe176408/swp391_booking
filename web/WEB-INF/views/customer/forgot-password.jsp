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
                            <span class="d-inline-flex align-items-center justify-content-center rounded-circle bg-primary-subtle p-3" style="width: 64px; height: 64px;">
                                <i class="fa-solid fa-key fa-2x text-primary"></i>
                            </span>
                        </div>
                        <h2 class="fw-bold mb-1">Quên mật khẩu?</h2>
                        <p class="text-muted small">
                            Đừng lo lắng! Nhập email đã đăng ký của bạn để nhận mật khẩu tạm thời được hệ thống cấp ngẫu nhiên.
                        </p>
                    </div>

                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center" role="alert">
                            <i class="fa-solid fa-circle-exclamation me-2 fs-5"></i>
                            <div>${errorMessage}</div>
                            <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <div class="d-flex align-items-start">
                                <i class="fa-solid fa-circle-check me-2 fs-5 mt-1"></i>
                                <div>
                                    <div class="fw-bold mb-1">Thành công!</div>
                                    <div>${successMessage}</div>
                                </div>
                            </div>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <c:choose>
                        <c:when test="${tempPasswordSent}">
                            <div class="card bg-light border-0 rounded-3 p-3 my-3">
                                <h6 class="fw-bold text-dark mb-2"><i class="fa-solid fa-shield-halved text-success me-2"></i>Hướng dẫn tiếp theo:</h6>
                                <ol class="small text-secondary mb-0 ps-3">
                                    <li class="mb-1">Kiểm tra hòm thư đến (hoặc mục Spam/Rác) của email <strong><c:out value="${email}"/></strong>.</li>
                                    <li class="mb-1">Sao chép mật khẩu tạm thời được cấp.</li>
                                    <li>Đăng nhập vào hệ thống; bạn sẽ được yêu cầu đổi sang mật khẩu chính thức của riêng mình.</li>
                                </ol>
                            </div>

                            <a href="${pageContext.request.contextPath}/login?email=<c:out value='${email}'/>" class="btn btn-primary-custom w-100 btn-lg mb-3">
                                <i class="fa-solid fa-right-to-bracket me-2"></i>Đi đến trang Đăng nhập
                            </a>
                            <div class="text-center">
                                <a href="${pageContext.request.contextPath}/forgot-password" class="text-decoration-none small text-muted">
                                    <i class="fa-solid fa-rotate-left me-1"></i>Gửi lại yêu cầu khác
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <form action="${pageContext.request.contextPath}/forgot-password" method="POST">
                                <div class="mb-4">
                                    <label class="form-label font-weight-semibold">Địa chỉ Email tài khoản</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-transparent border-end-0"><i class="fa-solid fa-envelope text-muted"></i></span>
                                        <input type="email" name="email" class="form-control form-control-lg border-start-0" placeholder="nhapemail@example.com" value="<c:out value='${email}'/>" required autofocus>
                                    </div>
                                    <div class="form-text text-muted">Hệ thống sẽ cập nhật mật khẩu tạm ngẫu nhiên và gửi về email này.</div>
                                </div>

                                <button type="submit" class="btn btn-primary-custom w-100 btn-lg mb-3">
                                    <i class="fa-solid fa-paper-plane me-2"></i>Gửi mật khẩu mới qua Email
                                </button>

                                <div class="text-center">
                                    <a href="${pageContext.request.contextPath}/login" class="text-decoration-none small text-primary fw-semibold">
                                        <i class="fa-solid fa-arrow-left me-1"></i>Quay lại Đăng nhập
                                    </a>
                                </div>
                            </form>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
