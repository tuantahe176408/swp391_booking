#!/bin/bash
# =============================================================================
# deploy.sh - Build WAR và Deploy lên Tomcat 9
# Dự án: swp391_booking (Smart Booking Platform)
# Yêu cầu: Chạy setup_fedora.sh trước
# Chạy với: sudo bash deploy.sh
# Hoặc chỉ build (không cần sudo): bash deploy.sh --build-only
# =============================================================================

set -eo pipefail

# Màu sắc
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info()    { echo -e "${BLUE}[INFO]${NC}  $1"; }
log_success() { echo -e "${GREEN}[OK]${NC}    $1"; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC}  $1"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }
log_step()    { echo -e "\n${CYAN}>>> $1${NC}"; }

# =============================================================================
# BIẾN CẤU HÌNH
# =============================================================================
TOMCAT_DIR="/opt/tomcat9"
TOMCAT_USER="tomcat"
WEBAPPS_DIR="$TOMCAT_DIR/webapps"
APP_NAME="swp391_booking"
WAR_FILE="dist/${APP_NAME}.war"

# Database
DB_NAME="smart_booking_db"
DB_USER="root"
DB_PASS="root@2024"          # Root password đã đặt trong setup_fedora.sh
APP_DB_USER="booking_user"
APP_DB_PASS="booking@2024"

# Tomcat server home (dùng để build với Ant)
J2EE_SERVER_HOME="$TOMCAT_DIR"

# =============================================================================
# PARSE ARGUMENTS
# =============================================================================
BUILD_ONLY=false
SKIP_DB=false
SKIP_BUILD=false

for arg in "$@"; do
    case $arg in
        --build-only)   BUILD_ONLY=true ;;
        --skip-db)      SKIP_DB=true ;;
        --skip-build)   SKIP_BUILD=true ;;
        --help|-h)
            echo "Cách dùng: bash deploy.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --build-only   Chỉ build WAR, không deploy"
            echo "  --skip-db      Bỏ qua khởi tạo database"
            echo "  --skip-build   Bỏ qua build, dùng WAR có sẵn"
            echo "  --help         Hiển thị trợ giúp"
            exit 0
            ;;
    esac
done

# Kiểm tra quyền root (không cần nếu chỉ build)
if [ "$BUILD_ONLY" = false ] && [ "$EUID" -ne 0 ]; then
    log_error "Cần quyền root để deploy. Chạy: sudo bash deploy.sh\nHoặc chỉ build: bash deploy.sh --build-only"
fi

# =============================================================================
# XÁC ĐỊNH THƯ MỤC DỰ ÁN
# =============================================================================
# Tìm thư mục dự án (script có thể chạy từ bất kỳ đâu)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR"

# Kiểm tra đúng thư mục dự án
if [ ! -f "$PROJECT_DIR/build.xml" ]; then
    log_error "Không tìm thấy build.xml tại: $PROJECT_DIR\nHãy chạy script từ thư mục gốc của dự án."
fi

log_info "Thư mục dự án: $PROJECT_DIR"
cd "$PROJECT_DIR"

echo ""
echo "============================================="
echo "  SWP391 Booking - Deploy lên Tomcat 9"
echo "============================================="
echo ""

# =============================================================================
# BƯỚC 1: KIỂM TRA ĐIỀU KIỆN
# =============================================================================
log_step "Kiểm tra môi trường..."

# Java 17
if ! java -version 2>&1 | grep -q "17\."; then
    log_error "Java 17 chưa được cài. Chạy setup_fedora.sh trước."
fi
log_success "Java: $(java -version 2>&1 | head -1)"

# Ant
if ! command -v ant &>/dev/null; then
    log_error "Ant chưa được cài. Chạy: sudo dnf install ant -y"
fi
log_success "Ant: $(ant -version 2>&1 | head -1)"

# Tomcat
if [ ! -d "$TOMCAT_DIR" ]; then
    log_error "Tomcat 9 không tìm thấy tại $TOMCAT_DIR. Chạy setup_fedora.sh trước."
fi
log_success "Tomcat: $TOMCAT_DIR"

# MySQL (chỉ cần khi không skip-db)
if [ "$SKIP_DB" = false ]; then
    if ! command -v mysql &>/dev/null; then
        log_error "MySQL chưa được cài. Chạy setup_fedora.sh trước."
    fi
    log_success "MySQL: $(mysql --version 2>&1 | head -1)"
fi

# =============================================================================
# BƯỚC 2: KHỞI TẠO DATABASE
# =============================================================================
if [ "$SKIP_DB" = false ]; then
    log_step "Khởi tạo database MySQL..."

    # Đảm bảo MySQL đang chạy
    if ! systemctl is-active --quiet mysqld; then
        log_info "Khởi động MySQL..."
        systemctl start mysqld
        sleep 2
    fi

    # Kiểm tra database đã tồn tại chưa
    DB_EXISTS=0
    DB_CHECK=$(mysql -u "$DB_USER" -p"$DB_PASS" -e "SHOW DATABASES LIKE '${DB_NAME}';" 2>/dev/null || true)
    if echo "$DB_CHECK" | grep -q "$DB_NAME"; then
        DB_EXISTS=1
    fi

    if [ "$DB_EXISTS" -gt 0 ]; then
        log_warn "Database '$DB_NAME' đã tồn tại."
        read -r -p "  Xóa và tạo lại? Mất toàn bộ dữ liệu cũ! (y/N): " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            log_info "Xóa database cũ..."
            mysql -u "$DB_USER" -p"$DB_PASS" -e "DROP DATABASE IF EXISTS ${DB_NAME};" 2>/dev/null
            DB_EXISTS=0
        else
            log_warn "Giữ nguyên database cũ. Bỏ qua bước import schema."
        fi
    fi

    if [ "$DB_EXISTS" -eq 0 ]; then
        log_info "Import schema.sql..."
        mysql -u "$DB_USER" -p"$DB_PASS" < "$PROJECT_DIR/sql/schema.sql" 2>/dev/null || \
            log_error "Lỗi import schema.sql. Kiểm tra mật khẩu MySQL root tại biến DB_PASS trong script."
        log_success "Import schema.sql xong."

        # Import seed data nếu có
        if [ -f "$PROJECT_DIR/sql/seeds/seed_search_data.sql" ]; then
            log_info "Import seed_search_data.sql..."
            mysql -u "$DB_USER" -p"$DB_PASS" < "$PROJECT_DIR/sql/seeds/seed_search_data.sql" 2>/dev/null || \
                log_warn "Lỗi import seed data. Có thể bỏ qua."
            log_success "Import seed data xong."
        fi

        # Tạo user riêng cho ứng dụng
        log_info "Tạo database user: $APP_DB_USER..."
        mysql -u "$DB_USER" -p"$DB_PASS" << MYSQL_CMDS 2>/dev/null || log_warn "User có thể đã tồn tại."
CREATE USER IF NOT EXISTS '${APP_DB_USER}'@'localhost' IDENTIFIED BY '${APP_DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${APP_DB_USER}'@'localhost';
FLUSH PRIVILEGES;
MYSQL_CMDS
        log_success "Tạo user database xong."
    fi
else
    log_warn "Bỏ qua khởi tạo database (--skip-db)."
fi

# =============================================================================
# BƯỚC 3: BUILD WAR
# =============================================================================
if [ "$SKIP_BUILD" = false ]; then
    log_step "Build WAR bằng Ant..."

    # Dọn build cũ
    if [ -d "$PROJECT_DIR/build" ] || [ -d "$PROJECT_DIR/dist" ]; then
        log_info "Dọn build cũ..."
        ant clean -q 2>/dev/null || rm -rf "$PROJECT_DIR/build" "$PROJECT_DIR/dist"
    fi

    # Build với j2ee.server.home trỏ đến Tomcat
    log_info "Chạy ant dist (Java 17)..."
    ant dist \
        -Dj2ee.server.home="$J2EE_SERVER_HOME" \
        -Djavac.source=17 \
        -Djavac.target=17 \
        2>&1 | tail -20

    # Kiểm tra WAR tồn tại
    if [ ! -f "$PROJECT_DIR/$WAR_FILE" ]; then
        log_error "Build thất bại! WAR không được tạo tại: $PROJECT_DIR/$WAR_FILE"
    fi

    WAR_SIZE=$(du -sh "$PROJECT_DIR/$WAR_FILE" | cut -f1)
    log_success "Build thành công: $WAR_FILE ($WAR_SIZE)"
else
    log_warn "Bỏ qua build (--skip-build). Dùng WAR có sẵn."
    if [ ! -f "$PROJECT_DIR/$WAR_FILE" ]; then
        log_error "Không tìm thấy WAR tại: $PROJECT_DIR/$WAR_FILE"
    fi
fi

# Dừng nếu chỉ build
if [ "$BUILD_ONLY" = true ]; then
    log_success "Build xong tại: $PROJECT_DIR/$WAR_FILE"
    echo ""
    echo "  Để deploy thủ công:"
    echo "    sudo cp $PROJECT_DIR/$WAR_FILE $WEBAPPS_DIR/"
    echo "    sudo chown ${TOMCAT_USER}:${TOMCAT_USER} $WEBAPPS_DIR/${APP_NAME}.war"
    echo "    sudo systemctl restart tomcat9"
    exit 0
fi

# =============================================================================
# BƯỚC 4: DEPLOY LÊN TOMCAT
# =============================================================================
log_step "Deploy WAR lên Tomcat 9..."

# Dừng Tomcat trước khi deploy
log_info "Dừng Tomcat..."
systemctl stop tomcat9 2>/dev/null || true
sleep 3

# Xóa deploy cũ
if [ -d "$WEBAPPS_DIR/$APP_NAME" ]; then
    log_info "Xóa deployment cũ..."
    rm -rf "$WEBAPPS_DIR/$APP_NAME"
fi
rm -f "$WEBAPPS_DIR/${APP_NAME}.war"

# Copy WAR mới
log_info "Copy WAR vào webapps..."
cp "$PROJECT_DIR/$WAR_FILE" "$WEBAPPS_DIR/"
chown "$TOMCAT_USER":"$TOMCAT_USER" "$WEBAPPS_DIR/${APP_NAME}.war"

# =============================================================================
# BƯỚC 5: CẤU HÌNH BIẾN MÔI TRƯỜNG CHO TOMCAT
# =============================================================================
log_step "Cập nhật cấu hình Tomcat..."

# Cập nhật setenv.sh với thông tin DB
# Dùng 'EOF' (single-quoted) để tránh shell expand $(...) ngay tại đây
# Các biến ${TOMCAT_DIR}, ${DB_NAME}, v.v. đã là string literals nên OK không cần escape
cat > "$TOMCAT_DIR/bin/setenv.sh" << 'SETENV_EOF'
#!/bin/bash
# Tomcat environment - swp391_booking
export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))
export CATALINA_PID=${CATALINA_HOME}/temp/tomcat.pid
export CATALINA_OPTS="-Xms256M -Xmx512M -server -XX:+UseParallelGC"
export JAVA_OPTS="-Dfile.encoding=UTF-8 -Duser.timezone=Asia/Ho_Chi_Minh"
SETENV_EOF

# Ghi các biến DB riêng (cần expand lúc này)
cat >> "$TOMCAT_DIR/bin/setenv.sh" << EOF
# Database connection
export DB_HOST=localhost
export DB_PORT=3306
export DB_NAME=${DB_NAME}
export DB_USER=${APP_DB_USER}
export DB_PASS=${APP_DB_PASS}
export CATALINA_HOME=${TOMCAT_DIR}
EOF

chmod +x "$TOMCAT_DIR/bin/setenv.sh"
chown "$TOMCAT_USER":"$TOMCAT_USER" "$TOMCAT_DIR/bin/setenv.sh"
log_success "Cấu hình biến môi trường DB xong."

# =============================================================================
# BƯỚC 6: KHỞI ĐỘNG LẠI TOMCAT
# =============================================================================
log_step "Khởi động Tomcat..."
systemctl start tomcat9

# Chờ Tomcat khởi động và unpack WAR
log_info "Chờ Tomcat khởi động (tối đa 30 giây)..."
for i in $(seq 1 30); do
    if [ -d "$WEBAPPS_DIR/$APP_NAME" ]; then
        log_success "Tomcat đã unpack WAR sau ${i}s."
        break
    fi
    sleep 1
    echo -n "."
done
echo ""

# Kiểm tra Tomcat có thực sự chạy không
sleep 2
if systemctl is-active --quiet tomcat9; then
    log_success "Tomcat 9 đang chạy."
else
    log_error "Tomcat khởi động thất bại! Xem log: sudo journalctl -u tomcat9 -n 50"
fi

# =============================================================================
# HOÀN THÀNH
# =============================================================================
echo ""
echo "============================================="
echo -e "${GREEN}  Deploy THÀNH CÔNG!${NC}"
echo "============================================="
echo ""
echo "  Ứng dụng:"
echo "    http://localhost:8080/${APP_NAME}/home"
echo ""
echo "  Database:"
echo "    Tên DB   : $DB_NAME"
echo "    User DB  : $APP_DB_USER"
echo "    Pass DB  : $APP_DB_PASS"
echo ""
echo "  Quản lý Tomcat:"
echo "    Xem status : sudo systemctl status tomcat9"
echo "    Xem log    : sudo tail -f $TOMCAT_DIR/logs/catalina.out"
echo "    Restart    : sudo systemctl restart tomcat9"
echo "    Stop       : sudo systemctl stop tomcat9"
echo ""
echo "  Nếu có lỗi, kiểm tra log:"
echo "    sudo tail -100 $TOMCAT_DIR/logs/catalina.out"
echo ""
