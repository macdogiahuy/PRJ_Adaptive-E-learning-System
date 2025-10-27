# 🔧 FIX: Khóa học không hiện sau thanh toán

## 🐛 Vấn đề

1. ❌ Sau thanh toán thành công, **giỏ hàng vẫn còn items**
2. ❌ Khóa học **không hiển thị** trong trang "My Courses"

## 🔍 Nguyên nhân

### Vấn đề 1: Cart không bị xóa
**Root cause**: Có **2 loại cart** trong session:
- `cart` (Map<String, CartItem>) - Dùng cho badge/icon giỏ hàng
- `cartItems` (List<CartItem>) - Dùng cho checkout

Checkout chỉ xóa `cartItems` nhưng **KHÔNG XÓA `cart`**!

### Vấn đề 2: Enrollment không hiển thị
**Root cause**: 
- Query enrollment có thể lỗi do JPQL JOIN syntax
- UserId format có thể không đúng
- Status mismatch: stored procedure tạo `'Active'` nhưng code check `'ACTIVE'`

## ✅ Giải pháp

### Bước 1: Chạy Fix Stored Procedure

```bash
# Mở SQL Server Management Studio
# Kết nối đến CourseHubDB
# Mở file: fix_enrollment_procedure.sql
# Execute (F5)
```

File `fix_enrollment_procedure.sql` đã được tạo và fix:
- ✅ Status = 'ACTIVE' (chữ hoa thống nhất)
- ✅ BillId chung cho tất cả enrollments trong 1 checkout
- ✅ CreationTime được set đúng

### Bước 2: Update CheckoutServlet

**File đã được fix**: `CheckoutServlet.java`

**Thay đổi**:
```java
// CŨ - Chỉ xóa cartItems
session.removeAttribute("cartItems");
session.removeAttribute("totalAmount");

// MỚI - Xóa TẤT CẢ các loại cart
session.removeAttribute("cartItems");  // List cart cho checkout
session.removeAttribute("cart");       // Map cart cho badge  ✅ NEW
session.removeAttribute("totalAmount");
```

### Bước 3: Update MyCoursesServlet

**File đã được fix**: `MyCoursesServlet.java`

**Thay đổi**:
- ✅ Dùng Native SQL thay vì JPQL (tránh lỗi JOIN)
- ✅ Named parameter thay vì positional (`:userId` thay vì `?`)
- ✅ Better error handling và logging
- ✅ Type conversion an toàn cho Timestamp/Date

### Bước 4: Debug & Verify

Chạy script debug:
```bash
# Mở SSMS
# Kết nối CourseHubDB
# Mở file: debug_enrollments.sql
# Thay username ở line 35: WHERE UserName = 'YOUR_USERNAME'
# Execute (F5)
```

Script sẽ kiểm tra:
1. Tất cả enrollments gần nhất
2. Enrollments của user cụ thể
3. Checkout history
4. Bills history
5. Orphaned enrollments
6. Enrollment count per user

## 📝 Checklist Test

### Test Flow Hoàn chỉnh:

```
1. ✅ Đăng nhập vào hệ thống
2. ✅ Thêm 1-2 khóa học vào giỏ hàng
3. ✅ Kiểm tra badge giỏ hàng hiển thị số lượng
4. ✅ Vào trang giỏ hàng, xem danh sách
5. ✅ Tiến hành thanh toán (COD hoặc Online)
6. ✅ Xác nhận thanh toán thành công
7. ✅ Kiểm tra badge giỏ hàng = 0
8. ✅ Truy cập /my-courses
9. ✅ Khóa học hiển thị với status "Đang học"
```

### Kiểm tra trong Database:

```sql
-- 1. Kiểm tra enrollment được tạo
SELECT * FROM Enrollments 
WHERE CreatorId = 'YOUR_USER_ID'
ORDER BY CreationTime DESC

-- 2. Kiểm tra status là ACTIVE
SELECT Status, COUNT(*) 
FROM Enrollments 
WHERE CreatorId = 'YOUR_USER_ID'
GROUP BY Status

-- 3. Kiểm tra Bill và Enrollment liên kết
SELECT 
    b.Id AS BillId,
    b.Amount,
    b.IsSuccessful,
    COUNT(e.CourseId) AS EnrollmentCount
FROM Bills b
LEFT JOIN Enrollments e ON b.Id = e.BillId
WHERE b.CreatorId = 'YOUR_USER_ID'
AND b.Action = 'Pay for course'
GROUP BY b.Id, b.Amount, b.IsSuccessful
ORDER BY b.CreationTime DESC
```

## 🚨 Troubleshooting

### Problem: Giỏ hàng vẫn còn items sau checkout

**Debug**:
```java
// Thêm logging trong CheckoutServlet
System.out.println("Cart before clear: " + session.getAttribute("cart"));
System.out.println("CartItems before clear: " + session.getAttribute("cartItems"));

// Sau khi clear
System.out.println("Cart after clear: " + session.getAttribute("cart"));
System.out.println("CartItems after clear: " + session.getAttribute("cartItems"));
```

**Fix**: Đảm bảo cả 2 attributes được xóa (đã fix trong code)

### Problem: Enrollment không hiển thị

**Debug steps**:

1. **Check logs trong console**:
```
=== NATIVE QUERY FOR ENROLLMENTS ===
User ID: xxx-xxx-xxx
Query returned X rows
Added course: Course Name - Status: ACTIVE
Successfully processed X enrollments
```

2. **Run SQL query trực tiếp**:
```sql
SELECT 
    e.CreatorId,
    u.UserName,
    c.Title,
    e.Status,
    e.CreationTime
FROM Enrollments e
LEFT JOIN Users u ON e.CreatorId = u.Id
LEFT JOIN Courses c ON e.CourseId = c.Id
WHERE u.UserName = 'YOUR_USERNAME'
ORDER BY e.CreationTime DESC
```

3. **Check User ID format**:
```sql
-- Lấy user ID
SELECT Id, UserName, Email FROM Users WHERE UserName = 'YOUR_USERNAME'

-- Verify type
SELECT 
    COLUMN_NAME, 
    DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Enrollments' 
AND COLUMN_NAME = 'CreatorId'
-- Should be: uniqueidentifier
```

### Problem: Status mismatch

**Triệu chứng**: Query trả về data nhưng JSP không hiển thị status badge

**Fix**: Đã update stored procedure để tạo Status = 'ACTIVE' (chữ hoa)

**Verify**:
```sql
SELECT DISTINCT Status FROM Enrollments
-- Should see: ACTIVE, COMPLETED (not Active, Completed)
```

### Problem: Stored procedure không hoạt động

**Debug**:
```sql
-- Test procedure trực tiếp
DECLARE @TestUserId UNIQUEIDENTIFIER = 'YOUR_USER_ID'
DECLARE @TestCourseIds NVARCHAR(MAX) = '["COURSE_ID_1"]'
DECLARE @TestAmount BIGINT = 100000
DECLARE @TestMethod VARCHAR(20) = 'COD'
DECLARE @OutBillId UNIQUEIDENTIFIER
DECLARE @OutCheckoutId UNIQUEIDENTIFIER
DECLARE @OutMessage NVARCHAR(500)

EXEC [dbo].[ProcessCartCheckout]
    @UserId = @TestUserId,
    @CourseIds = @TestCourseIds,
    @TotalAmount = @TestAmount,
    @PaymentMethod = @TestMethod,
    @SessionId = 'TEST',
    @BillId = @OutBillId OUTPUT,
    @CheckoutId = @OutCheckoutId OUTPUT,
    @ResultMessage = @OutMessage OUTPUT

PRINT 'Bill ID: ' + CAST(@OutBillId AS VARCHAR(36))
PRINT 'Message: ' + @OutMessage

-- Check enrollments created
SELECT * FROM Enrollments WHERE BillId = @OutBillId
```

## 📊 Monitoring Queries

### Query 1: Recent enrollments
```sql
SELECT TOP 20
    e.CreationTime,
    u.UserName,
    c.Title AS CourseName,
    e.Status,
    b.Amount
FROM Enrollments e
LEFT JOIN Users u ON e.CreatorId = u.Id
LEFT JOIN Courses c ON e.CourseId = c.Id
LEFT JOIN Bills b ON e.BillId = b.Id
ORDER BY e.CreationTime DESC
```

### Query 2: Enrollment stats by day
```sql
SELECT 
    CAST(CreationTime AS DATE) AS EnrollmentDate,
    COUNT(*) AS Count,
    COUNT(DISTINCT CreatorId) AS UniqueUsers
FROM Enrollments
WHERE CreationTime >= DATEADD(day, -7, GETDATE())
GROUP BY CAST(CreationTime AS DATE)
ORDER BY EnrollmentDate DESC
```

### Query 3: Checkout success rate
```sql
SELECT 
    Status,
    COUNT(*) AS Count,
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS Percentage
FROM CartCheckout
WHERE CreationTime >= DATEADD(day, -7, GETDATE())
GROUP BY Status
```

## ✨ Expected Behavior Sau Khi Fix

### 1. Checkout Flow
```
User click "Thanh toán"
   ↓
CheckoutServlet.processCheckoutWithStoredProcedure()
   ↓
Stored Procedure: ProcessCartCheckout
   ├─ Create Bill ✅
   ├─ Create CartCheckout ✅
   └─ Create Enrollments (Status=ACTIVE) ✅
   ↓
Clear session:
   ├─ Remove cartItems ✅
   ├─ Remove cart ✅
   └─ Remove totalAmount ✅
   ↓
Redirect to /checkout-success.jsp ✅
```

### 2. My Courses Display
```
User visit /my-courses
   ↓
MyCoursesServlet.doGet()
   ↓
getEnrolledCoursesNative(userId)
   ├─ Execute native SQL ✅
   ├─ Convert results to objects ✅
   └─ Return List<CourseEnrollmentInfo> ✅
   ↓
Forward to my-courses.jsp
   ↓
Display courses with:
   ├─ Course info ✅
   ├─ Status badge (ACTIVE = "Đang học") ✅
   ├─ Progress bar ✅
   └─ "Tiếp tục học" button ✅
```

## 🎯 Summary

**Files đã fix**:
1. ✅ `fix_enrollment_procedure.sql` - Update stored procedure
2. ✅ `CheckoutServlet.java` - Xóa cả 2 loại cart
3. ✅ `MyCoursesServlet.java` - Cải thiện query enrollment
4. ✅ `debug_enrollments.sql` - Script debug
5. ✅ `FIX_GUIDE.md` - Document này

**Các bước thực hiện**:
1. ✅ Chạy `fix_enrollment_procedure.sql` trong SSMS
2. ✅ Rebuild và restart application
3. ✅ Test checkout flow
4. ✅ Verify với `debug_enrollments.sql`

---
**Version**: 2.0  
**Last Updated**: October 26, 2025  
**Status**: Ready to test
