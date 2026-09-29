<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<style>
    /* ─── Contact Page Styles ─────────────────────────────────── */
    .contact-hero {
        background: linear-gradient(135deg, #0f172a 0%, #1e293b 50%, #0f3460 100%);
        padding: 80px 0 70px;
        position: relative;
        overflow: hidden;
    }
    .contact-hero::before {
        content: '';
        position: absolute;
        bottom: -100px;
        left: -100px;
        width: 500px;
        height: 500px;
        background: radial-gradient(circle, rgba(16,185,129,0.12) 0%, transparent 70%);
        border-radius: 50%;
    }
    .contact-hero h1 {
        font-size: 2.8rem;
        font-weight: 800;
        background: linear-gradient(135deg, #fff 0%, #6ee7b7 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
    }
    .contact-card {
        background: #fff;
        border-radius: 20px;
        padding: 2.5rem;
        border: 1px solid rgba(0,0,0,0.07);
        box-shadow: 0 4px 24px rgba(0,0,0,0.06);
    }
    .contact-info-card {
        background: linear-gradient(135deg, #6366f1, #8b5cf6);
        border-radius: 20px;
        padding: 2.5rem;
        color: #fff;
        height: 100%;
    }
    .info-item {
        display: flex;
        align-items: flex-start;
        gap: 1rem;
        padding: 1rem 0;
        border-bottom: 1px solid rgba(255,255,255,0.15);
    }
    .info-item:last-child { border-bottom: none; }
    .info-icon {
        width: 44px;
        height: 44px;
        background: rgba(255,255,255,0.15);
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.1rem;
        flex-shrink: 0;
    }
    .form-control:focus, .form-select:focus {
        border-color: #6366f1;
        box-shadow: 0 0 0 3px rgba(99,102,241,0.12);
    }
    .btn-contact {
        background: linear-gradient(135deg, #6366f1, #8b5cf6);
        border: none;
        color: #fff;
        padding: 0.75rem 2rem;
        border-radius: 12px;
        font-weight: 600;
        transition: all 0.3s ease;
    }
    .btn-contact:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 24px rgba(99,102,241,0.35);
        color: #fff;
    }
    .faq-item {
        background: #fff;
        border: 1px solid rgba(0,0,0,0.07);
        border-radius: 16px;
        padding: 1.5rem;
        margin-bottom: 1rem;
        transition: box-shadow 0.3s;
    }
    .faq-item:hover { box-shadow: 0 8px 30px rgba(0,0,0,0.08); }
    .faq-item h6 { color: #1e293b; font-weight: 700; margin-bottom: 0.5rem; }
    .faq-item p { color: #64748b; font-size: 0.9rem; margin: 0; }
    .section-badge {
        display: inline-flex;
        align-items: center;
        gap: 0.4rem;
        background: linear-gradient(135deg, rgba(99,102,241,0.1), rgba(139,92,246,0.1));
        border: 1px solid rgba(99,102,241,0.25);
        color: #6366f1;
        border-radius: 50px;
        padding: 0.35rem 1rem;
        font-size: 0.82rem;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        margin-bottom: 1rem;
    }
    .alert-success-custom {
        background: linear-gradient(135deg, rgba(16,185,129,0.1), rgba(5,150,105,0.05));
        border: 1px solid rgba(16,185,129,0.3);
        border-radius: 12px;
        color: #065f46;
    }
</style>

<!-- ── Hero ───────────────────────────────────────────────────── -->
<div class="contact-hero text-center">
    <div class="container">
        <i class="fa-solid fa-headset mb-3" style="font-size:3rem; color:#6ee7b7;"></i>
        <h1>Liên hệ &amp; Hỗ trợ</h1>
        <p class="lead" style="color:rgba(255,255,255,0.75); max-width:560px; margin:0.75rem auto 0;">
            Đội ngũ hỗ trợ của chúng tôi luôn sẵn sàng giải đáp mọi thắc mắc trong vòng 24h.
        </p>
    </div>
</div>

<!-- ── Main Content ──────────────────────────────────────────── -->
<section class="py-5" style="background:#f8f9ff;">
    <div class="container">

        <!-- Success Message -->
        <c:if test="${not empty successMsg}">
            <div class="alert alert-success-custom d-flex align-items-center gap-3 mb-4">
                <i class="fa-solid fa-circle-check fs-4 text-success"></i>
                <span>${successMsg}</span>
            </div>
        </c:if>

        <div class="row g-4">
            <!-- Contact Info -->
            <div class="col-lg-4">
                <div class="contact-info-card">
                    <h4 class="fw-bold mb-4"><i class="fa-solid fa-address-card me-2"></i> Thông tin liên hệ</h4>
                    <div class="info-item">
                        <div class="info-icon"><i class="fa-solid fa-envelope"></i></div>
                        <div>
                            <div style="font-weight:600; font-size:0.85rem; opacity:0.8; text-transform:uppercase; letter-spacing:0.5px;">Email hỗ trợ</div>
                            <div class="fw-semibold">smartbookingg@gmail.com</div>
                        </div>
                    </div>
                    <div class="info-item">
                        <div class="info-icon"><i class="fa-solid fa-phone"></i></div>
                        <div>
                            <div style="font-weight:600; font-size:0.85rem; opacity:0.8; text-transform:uppercase; letter-spacing:0.5px;">Hotline 24/7</div>
                            <div class="fw-semibold">(024) 7300 5588</div>
                        </div>
                    </div>
                    <div class="info-item">
                        <div class="info-icon"><i class="fa-solid fa-location-dot"></i></div>
                        <div>
                            <div style="font-weight:600; font-size:0.85rem; opacity:0.8; text-transform:uppercase; letter-spacing:0.5px;">Địa chỉ</div>
                            <div class="fw-semibold">FPT University, Hoa Lac Hi-tech Park, CT03</div>
                            <div style="opacity:0.75; font-size:0.85rem;">Đại học FPT Hà Nội</div>
                        </div>
                    </div>
                    <div class="info-item">
                        <div class="info-icon"><i class="fa-solid fa-clock"></i></div>
                        <div>
                            <div style="font-weight:600; font-size:0.85rem; opacity:0.8; text-transform:uppercase; letter-spacing:0.5px;">Giờ làm việc</div>
                            <div class="fw-semibold">Thứ 2 – Thứ 6: 8:00 – 17:30</div>
                            <div style="opacity:0.75; font-size:0.85rem;">Hỗ trợ khẩn cấp 24/7 qua hotline</div>
                        </div>
                    </div>
                    <div class="mt-4 pt-2">
                        <div style="font-weight:600; font-size:0.85rem; opacity:0.8; text-transform:uppercase; letter-spacing:0.5px; margin-bottom:0.75rem;">Mạng xã hội</div>
                        <div class="d-flex gap-2">
                            <a href="#" class="btn btn-sm" style="background:rgba(255,255,255,0.15); color:#fff; border-radius:10px; width:40px; height:40px; display:flex; align-items:center; justify-content:center;">
                                <i class="fa-brands fa-facebook-f"></i>
                            </a>
                            <a href="#" class="btn btn-sm" style="background:rgba(255,255,255,0.15); color:#fff; border-radius:10px; width:40px; height:40px; display:flex; align-items:center; justify-content:center;">
                                <i class="fa-brands fa-youtube"></i>
                            </a>
                            <a href="#" class="btn btn-sm" style="background:rgba(255,255,255,0.15); color:#fff; border-radius:10px; width:40px; height:40px; display:flex; align-items:center; justify-content:center;">
                                <i class="fa-brands fa-tiktok"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Contact Form -->
            <div class="col-lg-8">
                <div class="contact-card">
                    <span class="section-badge"><i class="fa-solid fa-paper-plane"></i> Gửi tin nhắn</span>
                    <h4 class="fw-bold mb-4">Chúng tôi luôn lắng nghe bạn</h4>
                    <form action="${pageContext.request.contextPath}/contact" method="POST" id="contactForm">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label fw-semibold" for="contactName">
                                    <i class="fa-solid fa-user text-primary me-1"></i> Họ và tên <span class="text-danger">*</span>
                                </label>
                                <input type="text" id="contactName" name="contactName" class="form-control" placeholder="Nguyễn Văn A" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold" for="contactEmail">
                                    <i class="fa-solid fa-envelope text-primary me-1"></i> Email <span class="text-danger">*</span>
                                </label>
                                <input type="email" id="contactEmail" name="contactEmail" class="form-control" placeholder="email@example.com" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold" for="contactPhone">
                                    <i class="fa-solid fa-phone text-primary me-1"></i> Số điện thoại
                                </label>
                                <input type="tel" id="contactPhone" name="contactPhone" class="form-control" placeholder="0912 345 678">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold" for="contactSubject">
                                    <i class="fa-solid fa-tag text-primary me-1"></i> Chủ đề <span class="text-danger">*</span>
                                </label>
                                <select id="contactSubject" name="contactSubject" class="form-select" required>
                                    <option value="">-- Chọn chủ đề --</option>
                                    <option value="booking">Hỗ trợ đặt phòng</option>
                                    <option value="payment">Vấn đề thanh toán</option>
                                    <option value="checkin">Check-in / Check-out</option>
                                    <option value="owner">Đăng ký làm chủ nhà</option>
                                    <option value="refund">Yêu cầu hoàn tiền</option>
                                    <option value="other">Khác</option>
                                </select>
                            </div>
                            <div class="col-12">
                                <label class="form-label fw-semibold" for="contactMessage">
                                    <i class="fa-solid fa-message text-primary me-1"></i> Nội dung <span class="text-danger">*</span>
                                </label>
                                <textarea id="contactMessage" name="contactMessage" class="form-control" rows="5"
                                          placeholder="Mô tả chi tiết vấn đề hoặc câu hỏi của bạn..." required></textarea>
                            </div>
                            <div class="col-12">
                                <button type="submit" class="btn btn-contact" id="btnSubmitContact">
                                    <i class="fa-solid fa-paper-plane me-2"></i> Gửi tin nhắn
                                </button>
                                <span class="text-muted ms-3" style="font-size:0.85rem;">
                                    <i class="fa-solid fa-clock me-1"></i> Phản hồi trong vòng 24 giờ
                                </span>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ── FAQ Section ───────────────────────────────────────────── -->
<section class="py-5">
    <div class="container">
        <div class="text-center mb-5">
            <span class="section-badge"><i class="fa-solid fa-circle-question"></i> FAQ</span>
            <h2 class="fw-bold">Câu hỏi thường gặp</h2>
        </div>
        <div class="row g-3">
            <div class="col-md-6">
                <div class="faq-item">
                    <h6><i class="fa-solid fa-calendar-check text-primary me-2"></i>Tôi có thể hủy đặt phòng không?</h6>
                    <p>Có. Bạn có thể hủy đặt phòng trước thời gian quy định trong chính sách của chủ nhà. Vào mục "Đơn đặt phòng" → chọn đơn → nhấn "Hủy đặt phòng".</p>
                </div>
                <div class="faq-item">
                    <h6><i class="fa-solid fa-credit-card text-success me-2"></i>Các hình thức thanh toán được hỗ trợ?</h6>
                    <p>Chúng tôi hỗ trợ VNPay, MoMo và thẻ ngân hàng. Mọi giao dịch đều được mã hóa SHA-256 HMAC đảm bảo an toàn tuyệt đối.</p>
                </div>
                <div class="faq-item">
                    <h6><i class="fa-solid fa-house-user text-warning me-2"></i>Làm sao để đăng ký làm chủ nhà?</h6>
                    <p>Đăng ký tài khoản, chọn vai trò "Chủ nhà" và gửi yêu cầu phê duyệt. Quản trị viên sẽ xét duyệt trong vòng 24–48h.</p>
                </div>
            </div>
            <div class="col-md-6">
                <div class="faq-item">
                    <h6><i class="fa-solid fa-wand-magic-sparkles text-purple me-2"></i>AI gợi ý hoạt động như thế nào?</h6>
                    <p>Hệ thống phân tích lịch sử đặt phòng, điểm đánh giá và sở thích của bạn để gợi ý các homestay phù hợp nhất trong thời gian thực.</p>
                </div>
                <div class="faq-item">
                    <h6><i class="fa-solid fa-rotate-left text-danger me-2"></i>Khi nào tiền hoàn về tài khoản?</h6>
                    <p>Sau khi yêu cầu hoàn tiền được duyệt, tiền sẽ về tài khoản trong 3–7 ngày làm việc tùy theo ngân hàng của bạn.</p>
                </div>
                <div class="faq-item">
                    <h6><i class="fa-solid fa-id-card text-info me-2"></i>Check-in bằng OCR hoạt động thế nào?</h6>
                    <p>Lễ tân chụp ảnh CCCD/Hộ chiếu của khách, hệ thống tự động nhận dạng và điền thông tin check-in — chỉ mất vài giây.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
