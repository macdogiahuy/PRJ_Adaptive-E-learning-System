# 📋 TÓM TẮT - Đã sửa lỗi "invalid_grant" (400 Bad Request)

## 🔍 Nguyên nhân lỗi

Lỗi **"invalid_grant"** xảy ra vì:
1. ❌ Refresh Token **chưa được cấu hình** hoặc có giá trị placeholder
2. ❌ Token cũ **đã hết hạn** hoặc **bị thu hồi**
3. ❌ Token được tạo với **scope không đúng**

---

## ✅ Đã thực hiện các sửa đổi

### 1. Cập nhật `CredentialManager.java` (2 files)
- ✅ Tự động lấy token từ `env.properties` hoặc environment variable
- ✅ Hiển thị thông báo lỗi rõ ràng khi token chưa cấu hình
- ✅ Hướng dẫn user đến URL lấy token

**Files đã sửa:**
- `src/main/java/utils/CredentialManager.java`
- `src/java/utils/CredentialManager.java`

### 2. Cập nhật `env.properties`
- ✅ Thêm property `GOOGLE_DRIVE_REFRESH_TOKEN`
- ✅ Có hướng dẫn cách lấy token

**File:** `src/conf/env.properties`

### 3. Cải thiện `DriveAuthCallbackServlet.java`
- ✅ Tạo giao diện đẹp hiển thị token
- ✅ Nút copy token tiện lợi
- ✅ Hướng dẫn chi tiết cách cấu hình

**File:** `src/main/java/controller/DriveAuthCallbackServlet.java`

### 4. Thông báo lỗi rõ ràng trong `UploadVideoServlet.java`
- ✅ Phát hiện lỗi OAuth/invalid_grant
- ✅ Hiển thị link trực tiếp để lấy token mới
- ✅ Hỗ trợ HTML trong error message

**File:** `src/main/java/controller/UploadVideoServlet.java`

### 5. Tạo tài liệu hướng dẫn
- ✅ `GOOGLE_DRIVE_SETUP.md` - Hướng dẫn chi tiết
- ✅ `QUICKFIX_GOOGLE_DRIVE.md` - Hướng dẫn nhanh
- ✅ `setup-google-drive.ps1` - Script tự động

---

## 🚀 HƯỚNG DẪN SỬ DỤNG NGAY

### ⚡ Cách nhanh nhất (Dùng script)

```powershell
.\setup-google-drive.ps1
```

### 📝 Cách thủ công (3 bước)

#### Bước 1: Lấy Refresh Token
Truy cập: http://localhost:9999/Adaptive_Elearning/auth/drive

#### Bước 2: Cập nhật vào env.properties
Mở file `src/conf/env.properties`, thêm dòng:
```properties
GOOGLE_DRIVE_REFRESH_TOKEN=REDACTED
```

#### Bước 3: Restart Server
Dừng server hiện tại và khởi động lại để áp dụng thay đổi.

---

## ⚠️ LƯU Ý QUAN TRỌNG

### 🔄 BẮT BUỘC phải restart server
Sau khi cập nhật token trong `env.properties`, **BẮT BUỘC phải restart server** để thay đổi có hiệu lực.

### 🔐 Bảo mật token
- ❌ **KHÔNG commit** token vào Git
- ❌ **KHÔNG chia sẻ** token công khai
- ✅ Thêm vào `.gitignore`:
  ```
  src/conf/env.properties
  ```

### 🔄 Token không xuất hiện?
Nếu không thấy token khi ủy quyền:
1. Vào: https://myaccount.google.com/permissions
2. Tìm "AdaptiveELearning" → Remove Access
3. Thử lại từ đầu

---

## 🧪 Kiểm tra hoạt động

Sau khi cấu hình xong, thử upload video tại:
```
http://localhost:9999/Adaptive_Elearning/instructor/upload-video
```

**Kết quả mong đợi:**
- ✅ "Upload thành công lên Google Drive!"
- ✅ Video hiển thị trong Google Drive folder

---

## 📞 Troubleshooting

### Vẫn lỗi "invalid_grant"?
1. ✅ Đã restart server chưa?
2. ✅ Token có paste đúng không? (không có khoảng trắng thừa)
3. ✅ File env.properties có ở đúng vị trí `src/conf/` không?

### Lỗi "Refresh Token chưa được cấu hình"?
→ Token chưa được đặt hoặc vẫn là giá trị placeholder `YOUR_NEW_REFRESH_TOKEN_HERE`

### Lỗi 403 Forbidden?
→ Google Drive API chưa được bật, vào:
https://console.cloud.google.com/apis/library/drive.googleapis.com

---

## 📚 Tài liệu tham khảo

- `GOOGLE_DRIVE_SETUP.md` - Hướng dẫn đầy đủ
- `QUICKFIX_GOOGLE_DRIVE.md` - Hướng dẫn nhanh
- `setup-google-drive.ps1` - Script tự động

---

## ✨ Kết luận

Tất cả code đã được cập nhật để:
1. ✅ Tự động lấy token từ config file
2. ✅ Thông báo lỗi rõ ràng, dễ hiểu
3. ✅ Hướng dẫn user cách fix ngay trong UI
4. ✅ Script tự động hóa quá trình setup

**Giờ bạn chỉ cần chạy script hoặc làm theo 3 bước thủ công là xong!** 🎉
