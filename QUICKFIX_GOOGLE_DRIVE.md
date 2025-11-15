# ⚡ HƯỚNG DẪN NHANH - Sửa lỗi "invalid_grant"

## 🎯 Giải pháp nhanh nhất

### Cách 1: Dùng script tự động (KHUYẾN NGHỊ)

```powershell
.\setup-google-drive.ps1
```

Script sẽ tự động:
- Kiểm tra server
- Mở trình duyệt để lấy token
- Cập nhật vào `env.properties`

### Cách 2: Làm thủ công

1. **Truy cập URL này trong trình duyệt:**
   ```
   http://localhost:9999/Adaptive_Elearning/auth/drive
   ```

2. **Đăng nhập và cho phép quyền truy cập**

3. **Copy Refresh Token hiển thị trên màn hình**

4. **Cập nhật vào file `src/conf/env.properties`:**
   ```properties
   GOOGLE_DRIVE_REFRESH_TOKEN=REDACTED
   ```

5. **RESTART SERVER** để áp dụng thay đổi

---

## ❓ Câu hỏi thường gặp

### Q: Không thấy Refresh Token khi ủy quyền?

**A:** Thu hồi quyền truy cập trước:
1. Vào: https://myaccount.google.com/permissions
2. Tìm "AdaptiveELearning" → Nhấn "Remove Access"
3. Thử lại từ đầu

### Q: Đã cấu hình nhưng vẫn lỗi?

**A:** Kiểm tra:
- ✅ Đã restart server chưa?
- ✅ Token đã paste đúng chưa? (không thừa khoảng trắng)
- ✅ File `env.properties` có ở đúng vị trí không?

### Q: Lỗi 403 Forbidden?

**A:** Bật Google Drive API tại:
https://console.cloud.google.com/apis/library/drive.googleapis.com

---

## 📚 Tài liệu chi tiết

Xem file: `GOOGLE_DRIVE_SETUP.md` để biết thêm chi tiết.
