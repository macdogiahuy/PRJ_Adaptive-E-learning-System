# Hướng Dẫn Thiết Lập Enrollment Tự Động

## 📋 Tổng quan

Hệ thống đã được thiết kế để **TỰ ĐỘNG TẠO ENROLLMENT** khi người dùng thanh toán khóa học thành công thông qua **Stored Procedure** `ProcessCartCheckout`.

## 🔧 Các thành phần chính

### 1. Database Components

#### Stored Procedure: `ProcessCartCheckout`
- **Vị trí**: `databasemoi.sql` (line 2437+)
- **Chức năng**: 
  - Tạo Bill cho đơn hàng
  - Tạo CartCheckout record
  - **Tự động tạo Enrollments** cho từng khóa học
- **Parameters**:
  - `@UserId`: ID của user mua khóa học
  - `@CourseIds`: Danh sách ID khóa học (JSON format)
  - `@TotalAmount`: Tổng số tiền
  - `@PaymentMethod`: 'COD' hoặc 'Online'
  - `@BillId` (OUTPUT): ID của Bill được tạo
  - `@CheckoutId` (OUTPUT): ID của Checkout
  - `@ResultMessage` (OUTPUT): Thông báo kết quả

#### Tables liên quan:
- `Bills`: Lưu thông tin hóa đơn
- `CartCheckout`: Lưu thông tin checkout
- `Enrollments`: Lưu thông tin đăng ký khóa học
- `Courses`: Thông tin khóa học

### 2. Backend Components

#### `CheckoutServlet.java`
- **URL Pattern**: `/checkout`
- **Chức năng**:
  - Xử lý thanh toán COD (GET)
  - Xử lý callback thanh toán Online (POST)
  - Gọi `CartCheckoutService` để thực thi stored procedure

#### `CartCheckoutService.java`
- **Method**: `processCheckout()`
- **Chức năng**:
  - Kết nối database
  - Gọi stored procedure `ProcessCartCheckout`
  - Xử lý kết quả và thông báo lỗi

#### `MyCoursesServlet.java`
- **URL Pattern**: `/my-courses`
- **Chức năng**:
  - Lấy danh sách khóa học đã đăng ký từ bảng `Enrollments`
  - Hiển thị thông tin chi tiết và tiến độ học tập

### 3. Frontend Components

#### `my-courses.jsp`
- Hiển thị danh sách khóa học đã đăng ký
- Hiển thị thống kê học tập
- Hiển thị thông báo thanh toán thành công

## 🚀 Quy trình hoạt động

```
1. User thêm khóa học vào giỏ hàng
   ↓
2. User chọn phương thức thanh toán (COD/Online)
   ↓
3. CheckoutServlet.processCheckoutWithStoredProcedure() được gọi
   ↓
4. CartCheckoutService.processCheckout() gọi stored procedure
   ↓
5. Stored Procedure ProcessCartCheckout:
   - Tạo Bill
   - Tạo CartCheckout
   - **TỰ ĐỘNG TẠO ENROLLMENTS** cho mỗi course
   ↓
6. Xóa giỏ hàng khỏi session
   ↓
7. Redirect đến /checkout-success.jsp
   ↓
8. User truy cập /my-courses để xem khóa học đã mua
```

## 🔍 Kiểm tra Enrollment

### SQL Query để kiểm tra enrollment của user:

```sql
-- Xem tất cả enrollments của một user
SELECT 
    e.CreatorId,
    u.UserName,
    c.Title AS CourseName,
    e.Status,
    e.CreationTime,
    e.BillId
FROM Enrollments e
INNER JOIN Users u ON e.CreatorId = u.Id
INNER JOIN Courses c ON e.CourseId = c.Id
WHERE e.CreatorId = 'YOUR_USER_ID_HERE'
ORDER BY e.CreationTime DESC

-- Kiểm tra enrollment mới nhất
SELECT TOP 10
    e.CreatorId,
    u.UserName,
    c.Title AS CourseName,
    e.Status,
    e.CreationTime,
    b.Amount,
    b.Gateway
FROM Enrollments e
INNER JOIN Users u ON e.CreatorId = u.Id
INNER JOIN Courses c ON e.CourseId = c.Id
LEFT JOIN Bills b ON e.BillId = b.Id
ORDER BY e.CreationTime DESC
```

## ⚠️ Vấn đề đã được fix

### 1. Status inconsistency
**Vấn đề**: Stored procedure tạo enrollment với `Status = 'Active'` nhưng JSP check `'ACTIVE'`

**Giải pháp**: File `fix_enrollment_procedure.sql` đã sửa lại:
```sql
-- Cũ
INSERT INTO [dbo].[Enrollments] (..., [Status], ...)
VALUES (..., N'Active', ...)

-- Mới
INSERT INTO [dbo].[Enrollments] (..., [Status], ...)
VALUES (..., N'ACTIVE', ...)
```

### 2. BillId mismatch
**Vấn đề**: Mỗi enrollment có BillId riêng (NEWID()) thay vì dùng BillId chung

**Giải pháp**: Đã sửa để tất cả enrollments trong cùng 1 checkout dùng chung 1 `@BillId`

## 📝 Cách chạy fix

### Bước 1: Chạy script SQL
```bash
# Mở SQL Server Management Studio (SSMS)
# Kết nối đến CourseHubDB
# Mở file: fix_enrollment_procedure.sql
# Chạy script (F5 hoặc Execute)
```

### Bước 2: Restart application server
```bash
# Nếu đang chạy trên Tomcat
# Stop server và Start lại
```

### Bước 3: Test checkout flow
1. Đăng nhập với một user
2. Thêm khóa học vào giỏ hàng
3. Tiến hành thanh toán (COD hoặc Online)
4. Sau khi thanh toán thành công, truy cập `/my-courses`
5. Kiểm tra xem khóa học đã xuất hiện chưa

## 🐛 Debug & Troubleshooting

### 1. Kiểm tra logs
```java
// CheckoutServlet logs
System.out.println("=== PROCESSING CHECKOUT WITH STORED PROCEDURE ===");
System.out.println("Bill ID: " + result.getBillId());

// CartCheckoutService logs
logger.info("=== CHECKOUT SUCCESSFUL ===");
logger.info("Enrollments created: " + ...);
```

### 2. Kiểm tra database
```sql
-- Kiểm tra CartCheckout records gần nhất
SELECT TOP 5 * FROM CartCheckout ORDER BY CreationTime DESC

-- Kiểm tra Bills gần nhất
SELECT TOP 5 * FROM Bills ORDER BY CreationTime DESC

-- Kiểm tra Enrollments gần nhất
SELECT TOP 5 * FROM Enrollments ORDER BY CreationTime DESC
```

### 3. Common Issues

#### Issue: "Không có khóa học trong My Courses"
**Nguyên nhân có thể**:
- Stored procedure chưa được update
- User đã enroll khóa học từ trước (bị skip)
- Lỗi trong quá trình tạo enrollment

**Cách fix**:
1. Chạy lại `fix_enrollment_procedure.sql`
2. Xóa enrollment cũ nếu cần test lại
3. Kiểm tra logs trong console

#### Issue: "Status hiển thị sai"
**Nguyên nhân**: Status trong DB là 'Active' nhưng code check 'ACTIVE'

**Cách fix**: Đã fix trong stored procedure mới

## 📊 Monitoring

### Query để theo dõi enrollments:
```sql
-- Số lượng enrollments theo ngày
SELECT 
    CAST(CreationTime AS DATE) AS Date,
    COUNT(*) AS EnrollmentCount
FROM Enrollments
WHERE CreationTime >= DATEADD(day, -7, GETDATE())
GROUP BY CAST(CreationTime AS DATE)
ORDER BY Date DESC

-- Enrollments theo user
SELECT 
    u.UserName,
    COUNT(e.CourseId) AS CourseCount,
    MAX(e.CreationTime) AS LastEnrollment
FROM Users u
LEFT JOIN Enrollments e ON u.Id = e.CreatorId
GROUP BY u.Id, u.UserName
HAVING COUNT(e.CourseId) > 0
ORDER BY CourseCount DESC
```

## 🎯 Kết luận

Hệ thống hiện tại **ĐÃ HOẠT ĐỘNG ĐÚNG** với flow:
1. ✅ Thanh toán thành công
2. ✅ Tự động tạo Enrollment
3. ✅ Hiển thị trong My Courses

Chỉ cần **chạy script fix** để đảm bảo Status và BillId được set đúng!

---
**Last Updated**: October 26, 2025
**Version**: 1.0
