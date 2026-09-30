#!/bin/bash
# =============================================================================
# setup_fedora.sh - Cài đặt môi trường triển khai cho Fedora 39
# Dự án: swp391_booking (Smart Booking Platform)
# Yêu cầu: Java 17, Tomcat 9, MySQL 8
# Chạy với: sudo bash setup_fedora.sh
# =============================================================================

set -eo pipefail

# Màu sắc cho output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info()    { echo -e "${BLUE}[INFO]${NC}  $1"; }
log_success() { echo -e "${GREEN}[OK]${NC}    $1"; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC}  $1"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Kiểm tra chạy với quyền root
if [ "$EUID" -ne 0 ]; then
    log_error "Vui lòng chạy script với quyền root: sudo bash setup_fedora.sh"
fi

TOMCAT_VERSION="9.0.102"
TOMCAT_DIR="/opt/tomcat9"
TOMCAT_USER="tomcat"
DB_NAME="smart_booking_db"
DB_USER="booking_user"
DB_PASS="booking@2024"
DB_ROOT_PASS="root@2024"

echo ""
echo "============================================="
echo "  SWP391 Booking - Setup Môi Trường Fedora 39"
echo "============================================="
echo ""

# =============================================================================
# BƯỚC 1: Cập nhật hệ thống
# =============================================================================
log_info "Bước 1: Cập nhật hệ thống..."
dnf update -y -q
log_success "Cập nhật hệ thống xong."

# =============================================================================
# BƯỚC 2: Cài Java 17
# =============================================================================
log_info "Bước 2: Cài Java 17..."

if java -version 2>&1 | grep -q "17\."; then
    log_success "Java 17 đã được cài sẵn. Bỏ qua."
else
    dnf install -y java-17-openjdk java-17-openjdk-devel
    # Đặt Java 17 làm mặc định
    alternatives --set java /usr/lib/jvm/java-17-openjdk/bin/java 2>/dev/null || true
    alternatives --set javac /usr/lib/jvm/java-17-openjdk/bin/javac 2>/dev/null || true
    log_success "Cài Java 17 xong."
fi

# Xác định JAVA_HOME
JAVA_HOME_PATH=$(dirname $(dirname $(readlink -f $(which java))))
log_info "JAVA_HOME: $JAVA_HOME_PATH"

# Thêm JAVA_HOME vào /etc/environment
if ! grep -q "JAVA_HOME" /etc/environment; then
    echo "JAVA_HOME=$JAVA_HOME_PATH" >> /etc/environment
fi
export JAVA_HOME=$JAVA_HOME_PATH

# =============================================================================
# BƯỚC 3: Cài Ant (để build WAR)
# =============================================================================
log_info "Bước 3: Cài Apache Ant..."

if command -v ant &>/dev/null; then
    log_success "Ant đã được cài sẵn. Bỏ qua."
else
    dnf install -y ant
    log_success "Cài Ant xong: $(ant -version 2>&1 | head -1)"
fi

# =============================================================================
# BƯỚC 4: Cài Tomcat 9
# =============================================================================
log_info "Bước 4: Cài Apache Tomcat 9..."

# Đảm bảo wget và curl có sẵn (Fedora minimal thường thiếu wget)
if ! command -v wget &>/dev/null; then
    log_info "Cài wget..."
    dnf install -y wget
fi
if ! command -v curl &>/dev/null; then
    log_info "Cài curl..."
    dnf install -y curl
fi

if [ -d "$TOMCAT_DIR" ]; then
    log_warn "Tomcat 9 đã tồn tại tại $TOMCAT_DIR. Bỏ qua cài đặt."
else
    TOMCAT_URL="https://dlcdn.apache.org/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz"
    TOMCAT_MIRROR="https://archive.apache.org/dist/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz"

    log_info "Tải Tomcat $TOMCAT_VERSION..."
    cd /tmp

    # Thử wget trước, fallback sang curl
    if ! wget -q --show-progress -O "apache-tomcat-${TOMCAT_VERSION}.tar.gz" "$TOMCAT_URL" 2>/dev/null; then
        log_warn "wget thất bại, thử curl..."
        if ! curl -fL --progress-bar -o "apache-tomcat-${TOMCAT_VERSION}.tar.gz" "$TOMCAT_URL" 2>/dev/null; then
            log_warn "Mirror chính thất bại, thử mirror dự phòng..."
            curl -fL --progress-bar -o "apache-tomcat-${TOMCAT_VERSION}.tar.gz" "$TOMCAT_MIRROR" || \
                log_error "Không thể tải Tomcat. Kiểm tra kết nối mạng."
        fi
    fi

    log_info "Giải nén và cài đặt..."
    tar -xzf "apache-tomcat-${TOMCAT_VERSION}.tar.gz" -C /opt/
    mv "/opt/apache-tomcat-${TOMCAT_VERSION}" "$TOMCAT_DIR"
    rm -f "/tmp/apache-tomcat-${TOMCAT_VERSION}.tar.gz"

    log_success "Cài Tomcat 9 tại $TOMCAT_DIR xong."
fi

# Tạo user tomcat nếu chưa có
if ! id "$TOMCAT_USER" &>/dev/null; then
    useradd -r -m -U -d "$TOMCAT_DIR" -s /bin/false "$TOMCAT_USER"
    log_success "Tạo user '$TOMCAT_USER' xong."
fi

# Phân quyền
chown -R "$TOMCAT_USER":"$TOMCAT_USER" "$TOMCAT_DIR"
chmod +x "$TOMCAT_DIR/bin/"*.sh

# Tạo setenv.sh
cat > "$TOMCAT_DIR/bin/setenv.sh" << EOF
#!/bin/bash
export JAVA_HOME=${JAVA_HOME_PATH}
export CATALINA_HOME=${TOMCAT_DIR}
export CATALINA_PID=\${CATALINA_HOME}/temp/tomcat.pid
export CATALINA_OPTS="-Xms256M -Xmx512M -server -XX:+UseParallelGC"
export JAVA_OPTS="-Dfile.encoding=UTF-8 -Duser.timezone=Asia/Ho_Chi_Minh"
EOF
chmod +x "$TOMCAT_DIR/bin/setenv.sh"
chown "$TOMCAT_USER":"$TOMCAT_USER" "$TOMCAT_DIR/bin/setenv.sh"

# Tạo systemd service
cat > /etc/systemd/system/tomcat9.service << EOF
[Unit]
Description=Apache Tomcat 9 Web Application Server
After=network.target mysql.service

[Service]
Type=forking

User=${TOMCAT_USER}
Group=${TOMCAT_USER}

Environment="JAVA_HOME=${JAVA_HOME_PATH}"
Environment="CATALINA_PID=${TOMCAT_DIR}/temp/tomcat.pid"
Environment="CATALINA_HOME=${TOMCAT_DIR}"
Environment="CATALINA_BASE=${TOMCAT_DIR}"
Environment="CATALINA_OPTS=-Xms256M -Xmx512M -server -XX:+UseParallelGC"
Environment="JAVA_OPTS=-Dfile.encoding=UTF-8 -Duser.timezone=Asia/Ho_Chi_Minh"

ExecStart=${TOMCAT_DIR}/bin/startup.sh
ExecStop=${TOMCAT_DIR}/bin/shutdown.sh

RestartSec=10
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable tomcat9
log_success "Cấu hình Tomcat 9 service xong."

# =============================================================================
# BƯỚC 5: Cài MySQL 9 (Community Edition)
# Fedora 39 không có MySQL trong repo mặc định -> dùng MySQL Yum Repository
# Lưu ý: MySQL 9.0 đã xóa mysql_native_password, dùng caching_sha2_password
# =============================================================================
log_info "Bước 5: Cài MySQL 9 (Community Edition)..."

if command -v mysqld &>/dev/null; then
    log_success "MySQL đã được cài sẵn ($(mysqld --version 2>&1 | head -1)). Bỏ qua."
else
    # Thêm MySQL Community Yum Repository
    log_info "Thêm MySQL Community Repository..."
    MYSQL_REPO_RPM="mysql84-community-release-fc39-1.noarch.rpm"
    MYSQL_REPO_URL="https://dev.mysql.com/get/${MYSQL_REPO_RPM}"

    cd /tmp
    if ! wget -q -O "$MYSQL_REPO_RPM" "$MYSQL_REPO_URL"; then
        log_error "Không tải được MySQL repo. Kiểm tra kết nối mạng hoặc vào https://dev.mysql.com/downloads/repo/yum/ tải thủ công."
    fi

    dnf install -y "/tmp/$MYSQL_REPO_RPM"
    rm -f "/tmp/$MYSQL_REPO_RPM"

    # Disable mysql 8.4 LTS channel, enable mysql 9.x innovation channel
    dnf config-manager --disable mysql84-community 2>/dev/null || true
    dnf config-manager --enable mysql-9-community    2>/dev/null || true

    log_info "Cài mysql-community-server..."
    dnf install -y mysql-community-server

    log_success "Cài MySQL 9 xong."
fi

# Đảm bảo MySQL đang chạy
log_info "Khởi động MySQL..."
systemctl enable --now mysqld

# Chờ MySQL sẵn sàng
for i in $(seq 1 15); do
    if systemctl is-active --quiet mysqld; then break; fi
    sleep 1
done

if ! systemctl is-active --quiet mysqld; then
    log_error "MySQL không khởi động được. Xem log: journalctl -u mysqld -n 30"
fi

# Lấy temporary password MySQL tạo tự động (MySQL 9 bắt buộc)
log_info "Cấu hình MySQL root password..."

TEMP_PASS=$(grep 'temporary password' /var/log/mysqld.log 2>/dev/null | tail -1 | awk '{print $NF}')

if [ -n "$TEMP_PASS" ]; then
    log_info "Tìm thấy temporary password. Đặt lại password mới..."
    # MySQL 9 dùng caching_sha2_password (không còn mysql_native_password)
    mysql --connect-expired-password -u root -p"${TEMP_PASS}" << MYSQL_SETUP 2>/dev/null
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASS}';
FLUSH PRIVILEGES;
MYSQL_SETUP
    log_success "Đặt mật khẩu root MySQL: ${DB_ROOT_PASS}"
else
    # Kiểm tra xem root đã có password chưa
    if mysql -u root -p"${DB_ROOT_PASS}" -e "SELECT 1;" &>/dev/null 2>&1; then
        log_success "Root MySQL đã có password đúng. Bỏ qua."
    else
        log_warn "Không tìm thấy temporary password."
        log_warn "Hãy chạy thủ công: sudo mysql_secure_installation"
        log_warn "Sau đó đặt password root là: ${DB_ROOT_PASS}"
    fi
fi

log_success "Cài đặt MySQL 9 xong."

# =============================================================================
# BƯỚC 6: Mở firewall
# =============================================================================
log_info "Bước 6: Cấu hình firewall..."

if command -v firewall-cmd &>/dev/null && systemctl is-active --quiet firewalld; then
    firewall-cmd --permanent --add-port=8080/tcp &>/dev/null || true
    firewall-cmd --permanent --add-service=mysql &>/dev/null || true
    firewall-cmd --reload &>/dev/null || true
    log_success "Mở cổng 8080 (Tomcat) và 3306 (MySQL) xong."
else
    log_warn "firewalld không chạy. Bỏ qua cấu hình firewall."
fi

# =============================================================================
# HOÀN THÀNH
# =============================================================================
echo ""
echo "============================================="
echo -e "${GREEN}  Cài đặt môi trường HOÀN THÀNH!${NC}"
echo "============================================="
echo ""
echo "  Java 17   : $(java -version 2>&1 | head -1)"
echo "  Ant       : $(ant -version 2>&1 | head -1)"
echo "  Tomcat 9  : $TOMCAT_DIR"
echo "  MySQL     : MySQL 9 (Community Edition)"
echo ""
echo "  Thông tin MySQL:"
echo "    Root password : $DB_ROOT_PASS"
echo ""
echo "  Bước tiếp theo:"
echo "    1. Copy thư mục dự án vào VM"
echo "    2. Chạy: sudo bash deploy.sh"
echo ""
echo "  Hoặc khởi động Tomcat thủ công:"
echo "    sudo systemctl start tomcat9"
echo "    Truy cập: http://localhost:8080"
echo ""
