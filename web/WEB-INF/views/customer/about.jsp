<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<style>
    /* ─── About Page Styles ──────────────────────────────────────── */
    .about-hero {
        background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
        padding: 100px 0 80px;
        position: relative;
        overflow: hidden;
    }
    .about-hero::before {
        content: '';
        position: absolute;
        top: -50%;
        right: -20%;
        width: 600px;
        height: 600px;
        background: radial-gradient(circle, rgba(99,102,241,0.15) 0%, transparent 70%);
        border-radius: 50%;
    }
    .about-hero h1 {
        font-size: 3rem;
        font-weight: 800;
        background: linear-gradient(135deg, #fff 0%, #a5b4fc 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        line-height: 1.2;
    }
    .about-hero .lead {
        color: rgba(255,255,255,0.75);
        font-size: 1.2rem;
        max-width: 600px;
        margin: 0 auto;
    }
    .stat-card {
        background: linear-gradient(135deg, #f8f9ff 0%, #fff 100%);
        border: 1px solid rgba(99,102,241,0.15);
        border-radius: 20px;
        padding: 2rem;
        text-align: center;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    .stat-card:hover {
        transform: translateY(-8px);
        box-shadow: 0 20px 60px rgba(99,102,241,0.15);
    }
    .stat-card .stat-number {
        font-size: 2.8rem;
        font-weight: 800;
        background: linear-gradient(135deg, #6366f1, #8b5cf6);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
    }
    .stat-card .stat-label {
        color: #6b7280;
        font-size: 0.95rem;
        font-weight: 500;
        margin-top: 0.3rem;
    }
    .feature-icon {
        width: 64px;
        height: 64px;
        border-radius: 16px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.6rem;
        margin-bottom: 1.2rem;
    }
    .feature-card {
        background: #fff;
        border: 1px solid rgba(0,0,0,0.06);
        border-radius: 20px;
        padding: 2rem;
        height: 100%;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    .feature-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 20px 50px rgba(0,0,0,0.08);
    }
    .team-card {
        background: #fff;
        border-radius: 20px;
        overflow: hidden;
        border: 1px solid rgba(0,0,0,0.06);
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    .team-card:hover {
        transform: translateY(-6px);
        box-shadow: 0 20px 60px rgba(99,102,241,0.15);
    }
    .team-avatar {
        width: 80px;
        height: 80px;
        border-radius: 50%;
        font-size: 2rem;
        font-weight: 700;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 1rem;
        color: #fff;
    }
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
        letter-spacing: 0.5px;
        text-transform: uppercase;
        margin-bottom: 1rem;
    }
    .mission-section {
        background: linear-gradient(135deg, #0f0c29, #302b63, #24243e);
        color: #fff;
        padding: 80px 0;
    }
    .mission-section .card {
        background: rgba(255,255,255,0.07);
        backdrop-filter: blur(10px);
        border: 1px solid rgba(255,255,255,0.12);
        border-radius: 20px;
    }
    .tech-badge {
        background: rgba(99,102,241,0.1);
        border: 1px solid rgba(99,102,241,0.2);
        color: #6366f1;
        border-radius: 8px;
        padding: 0.4rem 0.9rem;
        font-size: 0.82rem;
        font-weight: 600;
        display: inline-block;
        margin: 4px;
    }
    @keyframes float {
        0%, 100% { transform: translateY(0); }
        50% { transform: translateY(-10px); }
    }
    .float-anim { animation: float 3s ease-in-out infinite; }
</style>

<!-- ── Hero Section ──────────────────────────────────────────── -->
<div class="about-hero text-center">
    <div class="container">
        <div class="float-anim mb-4">
            <i class="fa-solid fa-hotel" style="font-size:3.5rem; color: #6366f1;"></i>
        </div>
        <h1>Về Smart Booking Platform</h1>
        <p class="lead mx-auto mt-3">
            Nền tảng đặt phòng Homestay &amp; Hotel thông minh hàng đầu Việt Nam —
            tích hợp AI gợi ý cá nhân hóa, thanh toán cổng trực tuyến và quản lý check-in OCR nhanh chóng.
        </p>
        <div class="d-flex justify-content-center gap-3 mt-4 flex-wrap">
            <a href="${pageContext.request.contextPath}/search" class="btn btn-primary px-4 py-2 fw-semibold">
                <i class="fa-solid fa-magnifying-glass me-2"></i>Tìm phòng ngay
            </a>
            <a href="${pageContext.request.contextPath}/contact" class="btn btn-outline-light px-4 py-2 fw-semibold">
                <i class="fa-solid fa-headset me-2"></i>Liên hệ chúng tôi
            </a>
        </div>
    </div>
</div>

<!-- ── Stats Section ─────────────────────────────────────────── -->
<section class="py-5" style="background: #f8f9ff;">
    <div class="container">
        <div class="row g-4">
            <div class="col-6 col-md-3">
                <div class="stat-card">
                    <div class="stat-number">5000+</div>
                    <div class="stat-label"><i class="fa-solid fa-house me-1"></i> Homestay & Khách sạn</div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="stat-card">
                    <div class="stat-number">50K+</div>
                    <div class="stat-label"><i class="fa-solid fa-users me-1"></i> Khách hàng tin dùng</div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="stat-card">
                    <div class="stat-number">63</div>
                    <div class="stat-label"><i class="fa-solid fa-map-location-dot me-1"></i> Tỉnh thành phủ sóng</div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="stat-card">
                    <div class="stat-number">4.9★</div>
                    <div class="stat-label"><i class="fa-solid fa-star me-1"></i> Đánh giá trung bình</div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ── Features Section ──────────────────────────────────────── -->
<section class="py-5">
    <div class="container">
        <div class="text-center mb-5">
            <span class="section-badge"><i class="fa-solid fa-bolt"></i> Tính năng nổi bật</span>
            <h2 class="fw-bold fs-1">Tại sao chọn Smart Booking?</h2>
            <p class="text-muted" style="max-width:580px; margin:0 auto;">Chúng tôi kết hợp công nghệ AI hiện đại với trải nghiệm đặt phòng mượt mà nhất thị trường.</p>
        </div>
        <div class="row g-4">
            <div class="col-md-4">
                <div class="feature-card">
                    <div class="feature-icon" style="background: rgba(99,102,241,0.1); color: #6366f1;">
                        <i class="fa-solid fa-wand-magic-sparkles"></i>
                    </div>
                    <h5 class="fw-bold mb-2">AI Gợi ý Cá nhân hóa</h5>
                    <p class="text-muted mb-0">Hệ thống AI phân tích lịch sử đặt phòng và sở thích của bạn để đề xuất chỗ ở phù hợp nhất.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-card">
                    <div class="feature-icon" style="background: rgba(16,185,129,0.1); color: #10b981;">
                        <i class="fa-solid fa-credit-card"></i>
                    </div>
                    <h5 class="fw-bold mb-2">Thanh toán Cổng Trực tuyến</h5>
                    <p class="text-muted mb-0">Tích hợp VNPay & MoMo với xác thực SHA-256 HMAC, giao dịch an toàn và tức thì.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-card">
                    <div class="feature-icon" style="background: rgba(245,158,11,0.1); color: #f59e0b;">
                        <i class="fa-solid fa-id-card"></i>
                    </div>
                    <h5 class="fw-bold mb-2">Check-in OCR Nhanh chóng</h5>
                    <p class="text-muted mb-0">Quét CCCD/Hộ chiếu tự động bằng OCR — lễ tân hoàn tất check-in chỉ trong vài giây.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-card">
                    <div class="feature-icon" style="background: rgba(239,68,68,0.1); color: #ef4444;">
                        <i class="fa-solid fa-heart"></i>
                    </div>
                    <h5 class="fw-bold mb-2">Danh sách Yêu thích</h5>
                    <p class="text-muted mb-0">Lưu các homestay yêu thích và nhận thông báo khi giá giảm hoặc có phòng trống.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-card">
                    <div class="feature-icon" style="background: rgba(6,182,212,0.1); color: #06b6d4;">
                        <i class="fa-solid fa-chart-line"></i>
                    </div>
                    <h5 class="fw-bold mb-2">Dashboard Analytics</h5>
                    <p class="text-muted mb-0">Báo cáo doanh thu trực quan bằng Chart.js, xuất Excel với Apache POI cho chủ nhà.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-card">
                    <div class="feature-icon" style="background: rgba(139,92,246,0.1); color: #8b5cf6;">
                        <i class="fa-brands fa-google"></i>
                    </div>
                    <h5 class="fw-bold mb-2">Đăng nhập Google OAuth2</h5>
                    <p class="text-muted mb-0">Đăng nhập nhanh bằng tài khoản Google, bảo mật mật khẩu bằng BCrypt chuẩn.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ── Mission Section ───────────────────────────────────────── -->
<section class="mission-section">
    <div class="container">
        <div class="row align-items-center g-5">
            <div class="col-lg-6">
                <span class="section-badge" style="background: rgba(255,255,255,0.1); border-color: rgba(255,255,255,0.2); color: #a5b4fc;">
                    <i class="fa-solid fa-bullseye"></i> Sứ mệnh
                </span>
                <h2 class="fw-bold text-white fs-1 mb-4">Kết nối Khách du lịch với Chủ nhà Uy tín</h2>
                <p style="color: rgba(255,255,255,0.75); line-height: 1.8;">
                    Smart Booking Platform được xây dựng với mục tiêu mang lại trải nghiệm đặt phòng minh bạch,
                    an toàn và tiện lợi nhất. Chúng tôi trao quyền cho các chủ homestay quản lý tài sản hiệu quả
                    và giúp khách du lịch tìm thấy chỗ ở hoàn hảo với giá tốt nhất.
                </p>
                <div class="d-flex gap-4 mt-4 flex-wrap">
                    <div>
                        <div class="fw-bold text-white fs-4">2024</div>
                        <div style="color: rgba(255,255,255,0.6); font-size:0.85rem;">Năm thành lập</div>
                    </div>
                    <div>
                        <div class="fw-bold text-white fs-4">SWP391</div>
                        <div style="color: rgba(255,255,255,0.6); font-size:0.85rem;">Dự án FPT University</div>
                    </div>
                    <div>
                        <div class="fw-bold text-white fs-4">5 TV</div>
                        <div style="color: rgba(255,255,255,0.6); font-size:0.85rem;">Thành viên nhóm</div>
                    </div>
                </div>
            </div>
            <div class="col-lg-6">
                <div class="row g-3">
                    <div class="col-6">
                        <div class="card p-3">
                            <i class="fa-solid fa-shield-halved text-primary mb-2 fs-4"></i>
                            <h6 class="text-white mb-1">Bảo mật cao</h6>
                            <p class="mb-0" style="color: rgba(255,255,255,0.6); font-size:0.82rem;">BCrypt + CSRF Filter + JSoup Anti-XSS</p>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="card p-3">
                            <i class="fa-solid fa-bolt text-warning mb-2 fs-4"></i>
                            <h6 class="text-white mb-1">Hiệu năng cao</h6>
                            <p class="mb-0" style="color: rgba(255,255,255,0.6); font-size:0.82rem;">HikariCP Connection Pool</p>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="card p-3">
                            <i class="fa-solid fa-envelope text-info mb-2 fs-4"></i>
                            <h6 class="text-white mb-1">Thông báo Email</h6>
                            <p class="mb-0" style="color: rgba(255,255,255,0.6); font-size:0.82rem;">JavaMail OTP & E-Ticket tự động</p>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="card p-3">
                            <i class="fa-solid fa-image text-success mb-2 fs-4"></i>
                            <h6 class="text-white mb-1">Hình ảnh HD</h6>
                            <p class="mb-0" style="color: rgba(255,255,255,0.6); font-size:0.82rem;">Cloudinary API tốc độ cao</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ── Tech Stack ────────────────────────────────────────────── -->
<section class="py-5 bg-light">
    <div class="container text-center">
        <span class="section-badge"><i class="fa-solid fa-code"></i> Công nghệ</span>
        <h2 class="fw-bold mb-2">Stack Công nghệ</h2>
        <p class="text-muted mb-4">Xây dựng trên nền tảng Java Enterprise vững chắc với kiến trúc MVC chuẩn</p>
        <div class="d-flex flex-wrap justify-content-center gap-2">
            <span class="tech-badge"><i class="fa-brands fa-java me-1"></i> Java 17</span>
            <span class="tech-badge">JSP / Servlet 4.0</span>
            <span class="tech-badge">Apache Tomcat 9</span>
            <span class="tech-badge">MySQL 8.0</span>
            <span class="tech-badge">HikariCP</span>
            <span class="tech-badge">BCrypt</span>
            <span class="tech-badge">VNPay / MoMo</span>
            <span class="tech-badge">Cloudinary API</span>
            <span class="tech-badge">JavaMail API</span>
            <span class="tech-badge">Apache POI</span>
            <span class="tech-badge">Chart.js</span>
            <span class="tech-badge"><i class="fa-brands fa-google me-1"></i> OAuth2</span>
            <span class="tech-badge">OCR API</span>
            <span class="tech-badge">JSoup Anti-XSS</span>
            <span class="tech-badge">NetBeans IDE</span>
        </div>
    </div>
</section>

<!-- ── Team Section ──────────────────────────────────────────── -->
<section class="py-5">
    <div class="container">
        <div class="text-center mb-5">
            <span class="section-badge"><i class="fa-solid fa-people-group"></i> Nhóm phát triển</span>
            <h2 class="fw-bold fs-1">Đội ngũ SWP391 — Fall 2026</h2>
            <p class="text-muted">5 thành viên — 26 Use Cases — 5 Actor Roles</p>
        </div>
        <div class="row g-4 justify-content-center">
            <div class="col-6 col-md-4 col-lg-2-5">
                <div class="team-card text-center p-4">
                    <div class="team-avatar" style="background: linear-gradient(135deg,#6366f1,#8b5cf6);">T</div>
                    <h6 class="fw-bold mb-1">Tuấn (TV1)</h6>
                    <span class="badge bg-primary-subtle text-primary mb-2">UC12 – UC16</span>
                    <p class="text-muted mb-0" style="font-size:0.8rem;">Search, Detail, Booking, Payment, Review</p>
                </div>
            </div>
            <div class="col-6 col-md-4 col-lg-2-5">
                <div class="team-card text-center p-4">
                    <div class="team-avatar" style="background: linear-gradient(135deg,#10b981,#059669);">S</div>
                    <h6 class="fw-bold mb-1">Sang (TV2)</h6>
                    <span class="badge bg-success-subtle text-success mb-2">UC07 – UC11</span>
                    <p class="text-muted mb-0" style="font-size:0.8rem;">Owner Homestay, Calendar, Analytics</p>
                </div>
            </div>
            <div class="col-6 col-md-4 col-lg-2-5">
                <div class="team-card text-center p-4">
                    <div class="team-avatar" style="background: linear-gradient(135deg,#f59e0b,#d97706);">B</div>
                    <h6 class="fw-bold mb-1">Bình (TV3)</h6>
                    <span class="badge bg-warning-subtle text-warning mb-2">UC01 – UC06</span>
                    <p class="text-muted mb-0" style="font-size:0.8rem;">Auth, Profile, Wishlist, AI Feed</p>
                </div>
            </div>
            <div class="col-6 col-md-4 col-lg-2-5">
                <div class="team-card text-center p-4">
                    <div class="team-avatar" style="background: linear-gradient(135deg,#ef4444,#dc2626);">K</div>
                    <h6 class="fw-bold mb-1">Khoa (TV4)</h6>
                    <span class="badge bg-danger-subtle text-danger mb-2">UC17 – UC21</span>
                    <p class="text-muted mb-0" style="font-size:0.8rem;">Reception, Check-in OCR, Room Matrix</p>
                </div>
            </div>
            <div class="col-6 col-md-4 col-lg-2-5">
                <div class="team-card text-center p-4">
                    <div class="team-avatar" style="background: linear-gradient(135deg,#06b6d4,#0891b2);">T</div>
                    <h6 class="fw-bold mb-1">Thanh (TV5)</h6>
                    <span class="badge bg-info-subtle text-info mb-2">UC22 – UC26</span>
                    <p class="text-muted mb-0" style="font-size:0.8rem;">Admin, Approval, Voucher, Config</p>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
