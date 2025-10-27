# HƯỚNG DẪN: THÊM KHÓA HỌC VÀO MY COURSES SAU KHI MUA

## 🎯 Mục Tiêu
Sau khi mua khóa học thành công, khóa học tự động hiển thị trong trang **My Courses**.

## 📋 Luồng Hoạt Động Hiện Tại

```
[Giỏ Hàng] 
    ↓ Nhấn "Checkout"
[CheckoutServlet.java]
    ↓ Gọi processCheckoutWithStoredProcedure()
[CartCheckoutService.java]
    ↓ Gọi stored procedure
[ProcessCartCheckout - SQL]
    ↓ Tạo Bill
    ↓ Tạo CartCheckout record
    ↓ Tạo Enrollments (cho mỗi course)
    ✓ Redirect → checkout-success.jsp
    
[My Courses Page]
    ↓ User click "My Courses"
[MyCoursesServlet.java]
    ↓ Query Enrollments với JOIN Courses
    ↓ WHERE e.CreatorId = ? (positional parameter)
    ↓ Hiển thị danh sách khóa học
```

## ✅ Các Fixes Đã Thực Hiện

### 1. **Fixed SQL Query Syntax** ✓
- **File**: `MyCoursesServlet.java`
- **Vấn đề**: Named parameter `:userId` không được hỗ trợ trong native query
- **Fix**: Chuyển sang positional parameter `?` với `setParameter(1, userId)`

```java
// TRƯỚC (SAI):
WHERE e.CreatorId = :userId
query.setParameter("userId", userId);

// SAU (ĐÚNG):
WHERE e.CreatorId = ?
query.setParameter(1, userId);
```

### 2. **Fixed Stored Procedure** ✓
- **File**: `fix_enrollment_procedure.sql`
- **Vấn đề**: SET QUOTED_IDENTIFIER phải ở ngoài BEGIN block
- **Fix**: Di chuyển SET statements ra ngoài và thêm GO separators

```sql
-- Đúng cấu trúc:
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ProcessCartCheckout]
...
```

### 3. **Fixed Cart Clearing** ✓
- **File**: `CheckoutServlet.java`
- **Vấn đề**: Chỉ xóa `cartItems` (List), không xóa `cart` (Map)
- **Fix**: Xóa cả hai loại cart

```java
session.removeAttribute("cartItems");  // List for checkout
session.removeAttribute("cart");       // Map for cart badge
session.removeAttribute("totalAmount");
```

### 4. **Fixed Status Display** ✓
- **File**: `my-courses.jsp`
- **Vấn đề**: JSP chỉ check 'ACTIVE' và 'COMPLETED'
- **Fix**: Thêm các variants: 'Active', 'Ongoing', 'Completed'

```jsp
<c:when test="${courseInfo.enrollment.status == 'ACTIVE' 
            || courseInfo.enrollment.status == 'Active' 
            || courseInfo.enrollment.status == 'Ongoing'}">
    <span class="course-status status-active">Đang học</span>
</c:when>
```

## 🔍 Các Script Kiểm Tra

### Script 1: Debug Full Flow
**File**: `debug_full_flow.sql`
**Mục đích**: Kiểm tra toàn bộ flow từ user → bills → checkouts → enrollments → query

```sql
-- Chạy trong SQL Server Management Studio:
USE CourseHubDB
GO
EXEC debug_full_flow.sql
```

**Kết quả mong đợi**:
- ✓ User tồn tại
- ✓ ProcessCartCheckout procedure tồn tại
- ✓ Bills có records
- ✓ CartCheckout có records với Status = 'COMPLETED'
- ✓ Enrollments có records với Status = 'ACTIVE'
- ✓ MyCoursesServlet query returns > 0 rows

### Script 2: Test Checkout Flow
**File**: `test_checkout_to_mycourses.sql`
**Mục đích**: Mô phỏng một checkout mới và verify enrollment được tạo

```sql
-- Chạy để test checkout:
USE CourseHubDB
GO
-- Script sẽ tự động:
-- 1. Chọn 2 courses ngẫu nhiên chưa enroll
-- 2. Gọi ProcessCartCheckout
-- 3. Verify enrollments được tạo
-- 4. Test MyCoursesServlet query
```

### Script 3: Verify After Real Checkout
**File**: `verify_enrollment_after_checkout.sql`
**Mục đích**: Kiểm tra sau khi bạn thực hiện checkout thật trên web

## 🧪 Quy Trình Test

### Bước 1: Kiểm tra Server đang chạy
```cmd
netstat -ano | findstr :8080
```
**Kết quả mong đợi**: Thấy process listening trên port 8080

### Bước 2: Kiểm tra Database trước khi test
```sql
-- Chạy trong SSMS:
USE CourseHubDB
GO

-- Đếm enrollments hiện tại:
SELECT COUNT(*) AS CurrentEnrollments
FROM Enrollments
WHERE CreatorId = 'C90648FF-C420-4B9D-92B2-081D7CC209D5'
```

### Bước 3: Test trên Web
1. Vào `http://localhost:8080/Adaptive_Elearning/`
2. Login với: **admin1234567**
3. Thêm 1-2 courses vào giỏ hàng
4. Click **Checkout** → Chọn **COD**
5. Xác nhận thấy trang "Thanh toán thành công"

### Bước 4: Kiểm tra My Courses
1. Click **My Courses** trong menu
2. **MONG ĐỢI**: Thấy courses vừa mua xuất hiện
3. **NẾU KHÔNG THẤY**: Check terminal logs

### Bước 5: Analyze Logs
Tìm trong terminal logs:

```
✓ CẦN THẤY:
[INFO] === PROCESSING CHECKOUT WITH STORED PROCEDURE ===
[INFO] User: admin1234567
[INFO] Cart Items: 2
[INFO] === CHECKOUT SUCCESSFUL ===
[INFO] Bill ID: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
[INFO] === CART CLEARED FROM SESSION ===

[INFO] === MY COURSES SERVLET START ===
[INFO] User ID: C90648FF-C420-4B9D-92B2-081D7CC209D5
[INFO] === NATIVE QUERY FOR ENROLLMENTS ===
[INFO] Query returned 2 rows  ← Phải > 0
[INFO] Added course: [Course Title]

✗ KHÔNG NÊN THẤY:
[SEVERE] Error in native query
com.microsoft.sqlserver.jdbc.SQLServerException: Incorrect syntax near ':'
```

### Bước 6: Kiểm tra Database sau khi test

**CÁCH 1: Sử dụng QUICK_CHECK.sql (ĐƠN GIẢN NHẤT)**
```sql
-- Trong SSMS, mở file và nhấn F5:
-- File → Open → File... → chọn QUICK_CHECK.sql
-- Hoặc copy toàn bộ nội dung file QUICK_CHECK.sql và paste vào SSMS
```

**CÁCH 2: Manual Check**
```sql
USE CourseHubDB
GO

-- Đếm enrollments:
SELECT COUNT(*) AS TotalEnrollments
FROM Enrollments 
WHERE CreatorId = 'C90648FF-C420-4B9D-92B2-081D7CC209D5'

-- Xem chi tiết:
SELECT 
    c.Title AS CourseTitle,
    e.Status,
    e.CreationTime,
    b.Amount
FROM Enrollments e
LEFT JOIN Courses c ON e.CourseId = c.Id
LEFT JOIN Bills b ON e.BillId = b.Id
WHERE e.CreatorId = 'C90648FF-C420-4B9D-92B2-081D7CC209D5'
ORDER BY e.CreationTime DESC
```

**⚠️ LƯU Ý**: 
- KHÔNG chạy: `SELECT * FROM verify_enrollment_after_checkout.sql` ← SAI!
- `.sql` là file script, không phải table
- Phải MỞ file và EXECUTE, không phải SELECT FROM

## 🐛 Troubleshooting

### Vấn đề 1: "Incorrect syntax near ':'"
**Nguyên nhân**: Code cũ vẫn đang chạy, chưa rebuild
**Giải pháp**:
```cmd
cd c:\Users\LP\Desktop\code 50%\PRJ_Adaptive-E-learning-System\Adaptive_Elearning
mvn clean package -DskipTests
# Restart server
```

### Vấn đề 2: Query returns 0 rows nhưng Enrollments tồn tại
**Nguyên nhân**: 
- JOIN fails (CourseId không khớp)
- UserId không đúng format
- Status filter sai

**Debug**:
```sql
-- Check enrollments alone:
SELECT * FROM Enrollments WHERE CreatorId = 'C90648FF-C420-4B9D-92B2-081D7CC209D5'

-- Check if courses exist:
SELECT e.CourseId, c.Id, c.Title
FROM Enrollments e
LEFT JOIN Courses c ON e.CourseId = c.Id
WHERE e.CreatorId = 'C90648FF-C420-4B9D-92B2-081D7CC209D5'
```

### Vấn đề 3: Stored Procedure không tạo Enrollments
**Check**:
```sql
-- Xem logs của procedure:
SELECT * FROM CartCheckout 
WHERE UserId = 'C90648FF-C420-4B9D-92B2-081D7CC209D5'
ORDER BY CreationTime DESC

-- Nếu Notes có "Enrollments: 0", procedure có vấn đề
```

**Fix**: Chạy lại `fix_enrollment_procedure.sql`

### Vấn đề 4: Cart không bị clear
**Check**: Xem badge vẫn hiển thị số lượng items
**Fix**: Đã fix ở `CheckoutServlet.java` line 133-135

## 📊 Expected Database State

Sau khi checkout thành công, database phải có:

```
Bills Table:
├─ Id: [UUID]
├─ Action: "Pay for course"
├─ Amount: [Total Amount]
├─ Gateway: "COD" hoặc "VietQR"
├─ IsSuccessful: 1
└─ CreatorId: [User ID]

CartCheckout Table:
├─ Id: [UUID]
├─ UserId: [User ID]
├─ CourseIds: ["course1", "course2"]
├─ TotalAmount: [Amount]
├─ Status: "COMPLETED"
└─ ProcessedTime: [Timestamp]

Enrollments Table (1 record per course):
├─ CreatorId: [User ID]
├─ CourseId: [Course ID]
├─ Status: "ACTIVE"
├─ BillId: [Bill UUID]
└─ CreationTime: [Timestamp]
```

## ✅ Checklist Hoàn Thành

- [x] Fix native query syntax (positional parameters)
- [x] Fix stored procedure SET options
- [x] Fix cart clearing logic
- [x] Fix JSP status mapping
- [x] Build project successfully
- [x] Server running on port 8080
- [ ] **User test checkout flow** ← BẠN CẦN LÀM
- [ ] Verify courses appear in My Courses
- [ ] Verify logs show correct query results

## 🎯 Next Steps

1. **Bạn hãy test** trên web theo Bước 3-5 ở trên
2. Sau khi checkout, **share logs** từ terminal
3. Nếu không thấy courses, chạy `debug_full_flow.sql` và share kết quả
4. Tôi sẽ analyze và fix thêm nếu cần

## 📝 Files Đã Modified

```
✓ src/main/java/servlet/MyCoursesServlet.java (line 127-129)
✓ src/main/java/servlet/CheckoutServlet.java (line 133-135)
✓ src/main/webapp/my-courses.jsp (line 681-697)
✓ fix_enrollment_procedure.sql (deployed to DB)
```

## 🔗 Related Files

- Debug: `debug_full_flow.sql`
- Test: `test_checkout_to_mycourses.sql`
- Verify: `verify_enrollment_after_checkout.sql`
