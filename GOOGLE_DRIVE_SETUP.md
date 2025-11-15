# 🔧 Hướng dẫn cấu hình Google Drive API

## ❌ Lỗi "invalid_grant" - Bad Request (400)

Lỗi này xảy ra khi **Refresh Token** không hợp lệ, đã hết hạn, hoặc chưa được cấu hình.

---

## 🚀 Giải pháp - Cách lấy Refresh Token mới

### **Bước 1: Khởi động server**

Đảm bảo ứng dụng đang chạy trên `http://localhost:9999`

### **Bước 2: Truy cập URL để ủy quyền**

Mở trình duyệt và truy cập:

```
http://localhost:9999/Adaptive_Elearning/auth/drive
```

### **Bước 3: Chọn tài khoản Google**

- Đăng nhập vào tài khoản Google của bạn
- Cho phép ứng dụng truy cập Google Drive
- Nhấn **"Allow"** để cấp quyền

### **Bước 4: Copy Refresh Token**

Sau khi ủy quyền thành công, bạn sẽ thấy một trang hiển thị **Refresh Token**.

Click nút **"📋 Copy Token"** để copy token.

---

## 🔐 Cách cấu hình Refresh Token

Có **3 cách** để cấu hình Refresh Token:

### **Cách 1: Cấu hình qua file env.properties (KHUYẾN NGHỊ)**

Mở file: `src/conf/env.properties`

Thêm dòng sau (thay `YOUR_TOKEN_HERE` bằng token thực):

```properties
GOOGLE_DRIVE_REFRESH_TOKEN=REDACTED
```

### **Cách 2: Cấu hình qua biến môi trường (Environment Variable)**

**Windows PowerShell:**
```powershell
$env:GOOGLE_DRIVE_REFRESH_TOKEN=REDACTED
```

**Windows CMD:**
```cmd
set GOOGLE_DRIVE_REFRESH_TOKEN=REDACTED
```

**Linux/Mac:**
```bash
export GOOGLE_DRIVE_REFRESH_TOKEN=REDACTED
```

### **Cách 3: Hardcode trực tiếp (KHÔNG KHUYẾN NGHỊ)**

Mở file: `src/main/java/utils/CredentialManager.java`

Tìm dòng:
```java
return "YOUR_NEW_REFRESH_TOKEN_HERE";
```

Thay bằng:
```java
return "1//0gXXXXXXXXXXXXXXXXXXX"; // Token thực của bạn
```

---

## ⚠️ Lưu ý quan trọng

### **1. Restart Server sau khi cấu hình**

Sau khi thay đổi token trong `env.properties` hoặc environment variable, bạn **BẮT BUỘC phải restart server** để áp dụng thay đổi.

### **2. Token không xuất hiện khi ủy quyền lại**

Nếu bạn đã ủy quyền trước đó, Google có thể không trả về Refresh Token mới.

**Giải pháp:**

1. Truy cập: https://myaccount.google.com/permissions
2. Tìm ứng dụng **"AdaptiveELearning"**
3. Nhấn **"Remove Access"** (Thu hồi quyền)
4. Quay lại Bước 2 và ủy quyền lại

### **3. Bảo mật Refresh Token**

- **KHÔNG commit** token vào Git
- **KHÔNG chia sẻ** token với người khác
- Token có quyền **đầy đủ** trên Google Drive của bạn

---

## 🧪 Kiểm tra cấu hình

Sau khi cấu hình xong, thử upload một video tại:

```
http://localhost:9999/Adaptive_Elearning/instructor/upload-video
```

Nếu thành công, bạn sẽ thấy thông báo: **"✅ Upload thành công lên Google Drive!"**

---

## 🔍 Troubleshooting

### Lỗi: "Refresh Token chưa được cấu hình"

**Nguyên nhân:** Token chưa được đặt hoặc đặt sai

**Giải pháp:** Làm lại từ Bước 1

### Lỗi: "400 Bad Request - invalid_grant"

**Nguyên nhân:** Token đã hết hạn hoặc bị thu hồi

**Giải pháp:**
1. Thu hồi quyền truy cập tại Google Permissions
2. Lấy token mới theo hướng dẫn trên

### Lỗi: "403 Forbidden"

**Nguyên nhân:** Google Drive API chưa được bật hoặc quota đã hết

**Giải pháp:**
1. Truy cập: https://console.cloud.google.com/apis/library/drive.googleapis.com
2. Đảm bảo API đã được **Enable**
3. Kiểm tra quota tại: https://console.cloud.google.com/apis/api/drive.googleapis.com/quotas

---

## 📞 Hỗ trợ

Nếu gặp vấn đề, vui lòng:

1. Kiểm tra console log để xem thông báo lỗi chi tiết
2. Đảm bảo server đang chạy đúng port (9999)
3. Xác nhận Google OAuth credentials (`CLIENT_ID`, `CLIENT_SECRET`) chính xác trong `DriveService.java`

---

## 🔗 Tài liệu liên quan

- [Google Drive API Documentation](https://developers.google.com/drive/api/guides/about-sdk)
- [OAuth 2.0 for Server-side Apps](https://developers.google.com/identity/protocols/oauth2/web-server)
