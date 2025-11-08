# 🎯 HƯỚNG DẪN TEST FIX LỖI "MUA 2 COURSES CHỈ HIỆN 1"

## 📋 VẤN ĐỀ ĐÃ TÌM RA

**Nguyên nhân:**
- User Snow1234 đã sở hữu course "123" từ trước (lúc 10:01 sáng)
- Khi thêm "123" vào giỏ lần nữa, frontend KHÔNG cảnh báo
- Thanh toán 2 courses (123 + dd) = 12,435,435 VND
- Stored procedure ĐÚNG khi skip "123" (duplicate prevention)
- Kết quả: Trả tiền 2 courses nhưng chỉ nhận 1 course mới (dd)

**Giải pháp:**
- Code CartServlet đã có `isAlreadyEnrolled()` check
- Cần rebuild và deploy để fix hoạt động

## 🔧 BƯỚC 1: BUILD (Đang chạy...)

```
mvn clean package -DskipTests
```

Đợi build xong, sẽ tạo file: `target\Adaptive_Elearning.war`

## 🔧 BƯỚC 2: DEPLOY

1. **Stop Tomcat:**
   - Mở Services (services.msc)
   - Tìm "Apache Tomcat"
   - Click Stop

2. **Xóa deployment cũ:**
   ```
   rmdir /s /q "C:\Program Files\Apache Software Foundation\Tomcat 10.1\webapps\Adaptive_Elearning"
   ```

3. **Copy WAR mới:**
   ```
   copy target\Adaptive_Elearning.war "C:\Program Files\Apache Software Foundation\Tomcat 10.1\webapps\"
   ```

4. **Start Tomcat:**
   - Services → Apache Tomcat → Start

## ✅ BƯỚC 3: TEST

### Test 1: Thêm course đã sở hữu vào giỏ

1. Login với Snow1234
2. Tìm course "123"
3. Click "Thêm vào giỏ hàng"
4. **Kết quả mong đợi:** 
   - ❌ KHÔNG cho thêm
   - ✅ Hiện thông báo: "Bạn đã sở hữu khóa học này rồi! Vui lòng kiểm tra trong 'Khóa học của tôi'."

### Test 2: Mua course mới

1. Login với user khác (KHÔNG phải Snow1234)
2. Thêm 2 courses MỚI vào giỏ
3. Thanh toán
4. **Kết quả mong đợi:**
   - ✅ Cả 2 courses hiện trong "My Courses"

### Test 3: Xác minh Snow1234

1. Login Snow1234
2. Vào "Khóa học của tôi"
3. **Kết quả mong đợi:**
   - ✅ Thấy course "123" (từ lúc 10:01)
   - ✅ Thấy course "dd" (từ test stored procedure lúc 11:03)

## 📊 SQL KIỂM TRA

```sql
-- Check Snow1234's enrollments
SELECT 
    c.Title,
    e.Status,
    e.CreationTime
FROM Enrollments e
JOIN Courses c ON e.CourseId = c.Id
WHERE e.CreatorId = (SELECT Id FROM Users WHERE Username = 'Snow1234')
ORDER BY e.CreationTime DESC;
```

**Kết quả mong đợi:** 2 rows (123 và dd)

## 🎯 CONFIRMATION FIX HOẠT ĐỘNG

✅ **Fix thành công khi:**
1. Không thể thêm course đã sở hữu vào giỏ
2. Có thông báo rõ ràng
3. Mua courses mới thì cả 2 hiện trong My Courses
4. Không bị mất tiền cho courses đã sở hữu

## 📝 NOTES

- File đã sửa: `src/main/java/servlet/CartServlet.java`
- Method: `isAlreadyEnrolled(userId, courseId)`
- Line 122-127: Check trước khi thêm vào giỏ
- Stored procedure hoạt động ĐÚNG (có duplicate prevention)
