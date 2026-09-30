# Hướng Dẫn Deploy - SWP391 Booking Platform

## Yêu cầu
- VM Fedora 39 (đã chạy)
- Kết nối internet trong VM
- Thư mục dự án đã được copy vào VM

---

## Bước 1: Copy dự án vào VM

Từ **Windows host**, chạy lệnh sau trong PowerShell (thay IP VM của bạn):

```powershell
# Nén thư mục dự án
Compress-Archive -Path "d:\SP SWP391\swp391_booking\*" -DestinationPath "$env:TEMP\swp391_booking.zip"

# Copy vào VM qua SCP (thay <VM_IP> bằng IP thực của VM)
scp "$env:TEMP\swp391_booking.zip" <user>@<VM_IP>:/home/<user>/swp391_booking.zip
```

Hoặc dùng **Shared Folder** của VirtualBox/VMware nếu đã cấu hình.

Trong VM, giải nén:
```bash
cd ~
unzip swp391_booking.zip -d swp391_booking
cd swp391_booking
```

---

## Bước 2: Cài đặt môi trường

Chạy script một lần duy nhất để cài Java 17, Tomcat 9, MySQL:

```bash
sudo bash setup_fedora.sh
```

Script sẽ tự động:
- ✅ Cài **Java 17** (OpenJDK)
- ✅ Cài **Apache Ant** (công cụ build)
- ✅ Cài **Tomcat 9.0.102** vào `/opt/tomcat9`
- ✅ Tạo systemd service `tomcat9` (tự khởi động cùng hệ thống)
- ✅ Cài **MySQL 8**
- ✅ Mở cổng **8080** trên firewall

Thời gian ước tính: **5–10 phút** (tùy tốc độ mạng)

---

## Bước 3: Deploy ứng dụng

```bash
sudo bash deploy.sh
```

Script sẽ tự động:
- ✅ Import `schema.sql` → tạo database `smart_booking_db`
- ✅ Import `seed_search_data.sql` → thêm dữ liệu mẫu
- ✅ Tạo DB user `booking_user` / `booking@2024`
- ✅ Build file WAR bằng Ant
- ✅ Deploy WAR lên Tomcat 9
- ✅ Khởi động lại Tomcat

Sau khi xong, truy cập:
```
http://localhost:8080/swp391_booking/home
```

---

## Thông tin cấu hình

| Thành phần | Giá trị |
|---|---|
| Tomcat port | 8080 |
| Tomcat home | `/opt/tomcat9` |
| Context path | `/swp391_booking` |
| MySQL | `smart_booking_db` |
| DB user (app) | `booking_user` |
| DB pass (app) | `booking@2024` |
| DB root pass | `root@2024` |
| Java | 17 (OpenJDK) |
| MySQL | 9 (Community Edition) |

---

## Các lệnh quản lý thường dùng

### Tomcat
```bash
# Xem trạng thái
sudo systemctl status tomcat9

# Khởi động / Dừng / Restart
sudo systemctl start tomcat9
sudo systemctl stop tomcat9
sudo systemctl restart tomcat9

# Xem log realtime
sudo tail -f /opt/tomcat9/logs/catalina.out

# Xem 100 dòng log gần nhất
sudo tail -100 /opt/tomcat9/logs/catalina.out
```

### MySQL
```bash
# Đăng nhập MySQL
mysql -u root -proot@2024

# Kiểm tra database
mysql -u root -proot@2024 -e "SHOW DATABASES;"
mysql -u root -proot@2024 -e "USE smart_booking_db; SHOW TABLES;"

# Kiểm tra kết nối từ app user
mysql -u booking_user -pbooking@2024 smart_booking_db -e "SHOW TABLES;"
```

---

## Re-deploy khi có thay đổi code

```bash
# Pull code mới (nếu dùng git)
git pull

# Build và deploy lại (bỏ qua import DB)
sudo bash deploy.sh --skip-db
```

---

## Xử lý sự cố

### Lỗi: "Connection refused" khi vào trang web
```bash
# Kiểm tra Tomcat có đang chạy không
sudo systemctl status tomcat9

# Kiểm tra cổng 8080 có đang lắng nghe không
ss -tlnp | grep 8080

# Xem log lỗi
sudo tail -50 /opt/tomcat9/logs/catalina.out
```

### Lỗi: Database connection failed
```bash
# Kiểm tra MySQL đang chạy
sudo systemctl status mysqld

# Kiểm tra biến môi trường DB trong setenv.sh
cat /opt/tomcat9/bin/setenv.sh

# Test kết nối thủ công
mysql -u booking_user -pbooking@2024 smart_booking_db
```

### Lỗi: Build WAR thất bại
```bash
# Kiểm tra Java version
java -version

# Kiểm tra Ant
ant -version

# Build thủ công và xem lỗi chi tiết
cd ~/swp391_booking
ant dist -Dj2ee.server.home=/opt/tomcat9 -verbose 2>&1 | less
```

### Lỗi: Không tải được Tomcat (mạng yếu)
```bash
# Tải thủ công rồi copy vào VM
# Trên Windows, tải từ: https://tomcat.apache.org/download-90.cgi
# Sau đó scp vào VM và giải nén thủ công:
sudo tar -xzf apache-tomcat-9.0.102.tar.gz -C /opt/
sudo mv /opt/apache-tomcat-9.0.102 /opt/tomcat9
```

---

## Lấy IP của VM

```bash
ip addr show | grep "inet " | grep -v 127.0.0.1
```

Từ Windows host, truy cập qua IP VM:
```
http://<VM_IP>:8080/swp391_booking/home
```
