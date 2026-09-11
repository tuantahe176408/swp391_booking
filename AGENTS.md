# Smart Booking Platform - JSP/Servlet Coding Conventions & Guidelines
Priority Order:
1. Reuse existing code.
2. Refactor existing code if necessary.
3. Only write new code when no reusable implementation exists.

## Mandatory instruction loading

Before answering or acting on any request that involves creating, editing, reviewing, refactoring, debugging, testing, or explaining project code for the Smart Booking Platform (Hệ thống Đặt phòng Homestay & Hotel Thông minh), read this `AGENTS.md` file completely.

- Do not implement or propose code changes until all applicable project rules have been reviewed.
- Search from the repository root to the target file for nested `AGENTS.md` files. Read and apply every applicable file; rules closest to the target file take precedence when instructions conflict.
- Re-read the relevant rule sections when the task scope changes or additional files become involved.
- Before completing a task, verify all changes and recommendations against every applicable rule in this file.
- If a user request conflicts with a project rule, clearly identify the conflict before proceeding and follow higher-priority system or user instructions.
- In the completion report, briefly confirm that the applicable project rules were reviewed and followed. Mention any rule that could not be satisfied and explain why.

## 1. Scope and priorities

These rules apply to the entire repository of the Smart Booking Platform, covering 26 Use Cases divided across 5 core actors: Customer, Receptionist, Homestay Owner, System Admin, and System Services.

**Tech Stack & IDE Requirements:**
- **IDE:** NetBeans IDE 8.2 / 12 / 17 / 20+ (NetBeans Java Web Application project setup)
- **Application Server:** Apache Tomcat 10.0+
- **Language & Runtime:** Java 17
- **Web Standard:** Servlet 4.0+ (`javax.servlet.*`), JSP/JSTL 1.2
- **Architecture:** Classic MVC Pattern (Session-based Auth, Servlet Filters, PreparedStatement DAOs, protected JSPs in `/WEB-INF/views/`)
- **Connection Pool:** HikariCP Connection Pool / JDBC DriverManager (`com.project.config.DBContext`)
- **Database:** MySQL 8.0+
- **Security & Sanitization:** BCrypt (`PasswordUtil`), JSoup Sanitizer (anti-XSS for rich text/reviews)
- **Integrations & Libraries:** 
  - Cloudinary API (Media & HD Image Uploads)
  - JavaMail API (`EmailUtil` for OTP, e-tickets, notifications)
  - Apache POI (`PoiReportUtil` for Excel `.xlsx` exports)
  - Chart.js (Dashboard Analytics)
  - Google OAuth2 API (Social Login)
  - Payment Gateway APIs (VNPay / MoMo integration with SHA-256 HMAC checksum verification)
  - OCR API Service (CCCD/Passport scanning for Reception Check-in)

Before implementing a change:
1. Inspect nearby code, `pom.xml`, `build.xml`, `nbproject/`, `web.xml`, server configuration, and current package names.
2. Maintain Java EE (`javax.*`) namespace consistently for Tomcat 9 / NetBeans standard. Never mix API namespaces.
3. Support both standard NetBeans Web App (`src/java/`, `web/`) and Maven Web App (`src/main/java/`, `src/main/webapp/` or `web/`) structures.
4. Reuse existing conventions, utilities, and DAOs.
5. Make the smallest complete change and preserve unrelated user changes.

## 2. Standard project structure for NetBeans JSP/Servlet

Organize backend code under package `com.project` and view/static files under `web/` (or `src/main/webapp/`) for NetBeans IDE as follows:

```text
src/java/ (or src/main/java/)
`-- com/project/
    |-- config/        # Database Connection Pool (HikariCP / DBContext), App Config, Constants
    |-- controller/    # HttpServlet Request/Response Orchestration (grouped by actor)
    |   |-- admin/     # AdminUserController, AdminApprovalController, AdminAnalyticsController...
    |   |-- customer/  # AuthController, SearchController, BookingController, PaymentController, ProfileController...
    |   |-- owner/     # OwnerHomestayController, OwnerCalendarController, OwnerAnalyticsController...
    |   `-- reception/ # ReceptionController, RoomMatrixController, HousekeepingController, WalkInController...
    |-- filter/        # Servlet Filters (EncodingFilter, AuthenticationFilter, CSRFFilter)
    |-- service/       # Business Logic & Transactions (BookingService, HomestayService, PaymentService...)
    |-- dao/           # JDBC Persistence via DBContext + PreparedStatement (UserDAOImpl, HomestayDAOImpl...)
    |-- model/         # Domain entities & DTOs (User, Homestay, Room, Booking, Invoice, Review, Voucher...)
    `-- util/          # Technical helpers: PasswordUtil (BCrypt), EmailUtil (JavaMail), PoiReportUtil (Excel)...

web/ (or src/main/webapp/)
|-- assets/            # Public static resources
|   |-- css/           # Modular stylesheets
|   |-- js/            # Client scripts & AJAX Fetch calls
|   `-- images/        # Static images, logos, placeholders
|-- META-INF/
|-- WEB-INF/
|   |-- views/         # Protected JSP views (Inaccessible directly via URL)
|   |   |-- admin/     # user-list.jsp, approval-list.jsp, analytics.jsp, config.jsp, voucher-form.jsp
|   |   |-- customer/  # home.jsp, login.jsp, search.jsp, detail.jsp, checkout.jsp, profile.jsp, booking-list.jsp, recommendations.jsp
|   |   |-- owner/     # homestay-form.jsp, calendar.jsp, analytics.jsp, staff-list.jsp, addons.jsp
|   |   |-- reception/ # checkin.jsp, room-matrix.jsp, daily-report.jsp, walk-in.jsp
|   |   `-- common/    # Header, footer, navbar, sidebar, pagination fragments
|   `-- web.xml
`-- index.jsp          # Entry point redirecting to home controller
```