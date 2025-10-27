# 🎯 HƯỚNG DẪN TEST FLOW MY COURSES

## 📋 Các thay đổi đã thực hiện

### 1. ✅ Fixed Stored Procedure
- **File**: `fix_enrollment_procedure.sql`
- **Thay đổi**: Status = 'ACTIVE' (chữ hoa) thay vì 'Active'
- **Status**: ✅ Đã chạy thành công

### 2. ✅ Fixed Cart Clearing
- **File**: `CheckoutServlet.java`
- **Thay đổi**: Xóa cả `cart` (Map) và `cartItems` (List) từ session
- **Status**: ✅ Đã áp dụng

### 3. ✅ Fixed Status Display
- **File**: `my-courses.jsp`
- **Thay đổi**: Chấp nhận tất cả Status variants:
  - 'ACTIVE', 'Active', 'Ongoing' → Hiển thị "Đang học"
  - 'COMPLETED', 'Completed' → Hiển thị "Hoàn thành"
  - Other → Hiển thị status gốc
- **Status**: ✅ Đã áp dụng

### 4. ✅ Query Optimization
- **File**: `MyCoursesServlet.java`
- **Thay đổi**: Dùng Native SQL, không filter Status
- **Status**: ✅ Đã có logging chi tiết

## 🧪 BƯỚC TEST HOÀN CHỈNH

### Bước 1: Rebuild Project
```bash
# Clean và build lại project
cd c:\Users\LP\Desktop\code 50%\PRJ_Adaptive-E-learning-System\Adaptive_Elearning
mvn clean package
```

### Bước 2: Restart Server
```bash
# Stop Tomcat nếu đang chạy
# Start lại Tomcat
run-tomcat10.bat
```

### Bước 3: Mở Browser và Login
1. Truy cập: http://localhost:8080/Adaptive_Elearning/
2. Đăng nhập với tài khoản test (ví dụ: `hoangcvde180551@fpt.edu.vn`)

### Bước 4: Test Checkout Flow

#### 4.1 Thêm course vào giỏ hàng
```
1. Vào trang Home hoặc Course listing
2. Click "Add to Cart" trên một khóa học
3. Kiểm tra badge giỏ hàng ở header (số lượng tăng lên)
4. Click vào icon giỏ hàng để xem cart page
5. Xác nhận khóa học hiển thị trong giỏ
```

#### 4.2 Thanh toán
```
1. Ở trang Cart, click "Proceed to Checkout"
2. Chọn phương thức thanh toán:
   - COD (Cash on Delivery) - Recommended cho test
   - Online Payment (cần config VNPay)
3. Confirm payment
4. Đợi redirect đến checkout-success.jsp
```

#### 4.3 Verify sau thanh toán
```
1. Kiểm tra badge giỏ hàng = 0 (hoặc ẩn đi)
2. Click vào giỏ hàng → Nên rỗng hoặc không có items cũ
3. Kiểm tra URL bar - Nên ở /checkout-success.jsp
```

### Bước 5: Kiểm tra My Courses

#### 5.1 Truy cập trang My Courses
```
1. Hover vào avatar ở header
2. Click "Khóa học của tôi" trong dropdown
   HOẶC
   Truy cập trực tiếp: http://localhost:8080/Adaptive_Elearning/my-courses
```

#### 5.2 Verify hiển thị
```
✅ Trang My Courses hiển thị:
   - Stats section (tổng số khóa học, đang học, hoàn thành)
   - Course cards với:
     ✓ Course thumbnail
     ✓ Course title
     ✓ Price
     ✓ Level
     ✓ Status badge "Đang học" (màu xanh)
     ✓ Progress bar (có thể 0%)
     ✓ Button "Tiếp tục học"

❌ Nếu KHÔNG hiển thị:
   - Check console logs (Xem Bước 6)
   - Run verify_checkout.sql (Xem Bước 7)
```

### Bước 6: Check Console Logs

#### 6.1 Trong Tomcat console, tìm logs:
```
=== NATIVE QUERY FOR ENROLLMENTS ===
User ID: xxx-xxx-xxx-xxx
Query returned X rows
Added course: [Course Name] - Status: ACTIVE
Successfully processed X enrollments
```

#### 6.2 Nếu thấy "Query returned 0 rows":
```
→ Enrollment chưa được tạo trong DB
→ Chạy verify_checkout.sql để kiểm tra
```

#### 6.3 Nếu thấy error:
```
→ Copy full error message
→ Check line number và fix theo error
```

### Bước 7: Run Database Verification

#### 7.1 Chạy verify_checkout.sql
```bash
# Mở SQL Server Management Studio
# Kết nối đến CourseHubDB
# Mở file: verify_checkout.sql
# Execute (F5)
```

#### 7.2 Kiểm tra output:

**Section 1: LATEST CHECKOUT INFO**
```
✅ Status = 'Success' hoặc 'Completed'
✅ PaymentMethod = 'COD' hoặc 'Online'
✅ TotalAmount > 0
```

**Section 2: BILL CREATED**
```
✅ IsSuccessful = 1
✅ Gateway = 'COD' hoặc 'VNPAY'
✅ CreationTime gần với thời gian checkout
```

**Section 3: ENROLLMENTS CREATED**
```
✅ Count > 0 (ít nhất 1 enrollment)
✅ Status = 'ACTIVE' (UPPERCASE)
✅ BillMatch = '✓ Matched'
✅ CourseName match với course đã mua
```

**Section 4: RECENT ENROLLMENTS**
```
✅ SecondsAgo < 300 (tạo trong vòng 5 phút)
```

**Section 5: STATUS DISTRIBUTION**
```
Check xem có bao nhiêu Status variants:
- ACTIVE (chữ hoa) ← New enrollments
- Active (chữ thường) ← Old enrollments
- Ongoing ← Old enrollments
- Completed/COMPLETED ← Finished courses
```

**Section 6: VERIFY USER CAN SEE**
```
✅ Query trả về >= 1 rows
✅ DisplayStatus = '✓ Will show as "Đang học"'
✅ CourseId, Title, ThumbUrl không NULL
```

### Bước 8: Troubleshooting

#### Problem 1: Enrollment không được tạo
**Symptoms**: Section 3 trả về 0 rows

**Debug**:
```sql
-- Check Bill được tạo không
SELECT TOP 1 * FROM Bills 
WHERE Action = 'Pay for course'
ORDER BY CreationTime DESC

-- Check stored procedure có chạy không
SELECT TOP 1 * FROM CartCheckout
ORDER BY CreationTime DESC

-- Manual test stored procedure
DECLARE @UserId UNIQUEIDENTIFIER = 'YOUR_USER_ID'
DECLARE @CourseIds NVARCHAR(MAX) = '["COURSE_ID_HERE"]'
DECLARE @BillId UNIQUEIDENTIFIER
DECLARE @CheckoutId UNIQUEIDENTIFIER
DECLARE @Message NVARCHAR(500)

EXEC ProcessCartCheckout
    @UserId = @UserId,
    @CourseIds = @CourseIds,
    @TotalAmount = 100000,
    @PaymentMethod = 'COD',
    @SessionId = 'TEST',
    @BillId = @BillId OUTPUT,
    @CheckoutId = @CheckoutId OUTPUT,
    @ResultMessage = @Message OUTPUT

PRINT @Message
SELECT * FROM Enrollments WHERE BillId = @BillId
```

#### Problem 2: Status mismatch
**Symptoms**: Enrollment tồn tại nhưng không hiển thị

**Fix**: Đã fix trong my-courses.jsp (chấp nhận cả 'ACTIVE', 'Active', 'Ongoing')

**Verify**:
```sql
SELECT DISTINCT Status FROM Enrollments
-- Should see: ACTIVE, Active, Ongoing, Completed, COMPLETED
```

#### Problem 3: Query không trả về data
**Symptoms**: Console log "Query returned 0 rows" nhưng DB có data

**Debug**:
```java
// Check userId format
logger.info("User ID type: " + userId.getClass().getName());
logger.info("User ID value: " + userId);

// Test query trực tiếp trong DB
SELECT * FROM Enrollments WHERE CreatorId = 'USER_ID_HERE'
```

#### Problem 4: Cart không bị xóa
**Symptoms**: Sau checkout, badge vẫn hiển thị số

**Fix**: Đã fix trong CheckoutServlet.java

**Verify trong code**:
```java
// Line 133-135 trong CheckoutServlet.java
session.removeAttribute("cartItems");  // ✓
session.removeAttribute("cart");       // ✓ 
session.removeAttribute("totalAmount"); // ✓
```

**Test lại**:
```jsp
<!-- Trong header JSP -->
<c:if test="${not empty cart}">
    Cart still exists! Size: ${fn:length(cart)}
</c:if>
```

## 📊 Expected Results Summary

### ✅ Sau khi thanh toán thành công:

**Database:**
```
CartCheckout table:
- 1 new row với Status = 'Success'

Bills table:
- 1 new row với IsSuccessful = 1

Enrollments table:
- N new rows (N = số course trong cart)
- Status = 'ACTIVE' (uppercase)
- BillId giống nhau cho tất cả enrollments
```

**Session:**
```
session.getAttribute("cart") = null
session.getAttribute("cartItems") = null
session.getAttribute("totalAmount") = null
```

**UI:**
```
Header:
✓ Cart badge = 0 hoặc hidden
✓ Dropdown menu có "Khóa học của tôi"

My Courses page:
✓ Stats section hiển thị đúng số
✓ Course cards hiển thị với status "Đang học"
✓ Button "Tiếp tục học" hoạt động
✓ Empty state KHÔNG hiển thị
```

**Console Logs:**
```
=== NATIVE QUERY FOR ENROLLMENTS ===
User ID: xxx-xxx-xxx
Query returned 1 rows (hoặc nhiều hơn)
Added course: Course Title - Status: ACTIVE
Successfully processed 1 enrollments
```

## 🔄 Test Cases

### Test Case 1: Single Course Purchase
```
1. Add 1 course to cart
2. Checkout with COD
3. Verify:
   - Cart empty
   - My Courses shows 1 course
   - Status = "Đang học"
```

### Test Case 2: Multiple Courses Purchase
```
1. Add 3 courses to cart
2. Checkout with COD
3. Verify:
   - Cart empty
   - My Courses shows 3 courses
   - All have Status = "Đang học"
   - Stats: "Đang học: 3"
```

### Test Case 3: Duplicate Purchase Prevention
```
1. Buy Course A
2. Try to buy Course A again
3. Verify:
   - Should be prevented (already enrolled)
   - OR create new enrollment (check business logic)
```

### Test Case 4: Mixed Status Display
```
Pre-condition: User có enrollments cũ với Status = 'Ongoing'

1. Buy new course (Status = 'ACTIVE')
2. Go to My Courses
3. Verify:
   - Old courses (Ongoing) hiển thị "Đang học"
   - New course (ACTIVE) hiển thị "Đang học"
   - Both display correctly
```

## 📝 Checklist

Trước khi test:
- [ ] Chạy fix_enrollment_procedure.sql
- [ ] Rebuild project (mvn clean package)
- [ ] Restart Tomcat server
- [ ] Clear browser cache/cookies

Trong quá trình test:
- [ ] Console logs hiển thị query results
- [ ] Browser network tab không có errors
- [ ] Database có enrollment records mới

Sau khi test:
- [ ] Chạy verify_checkout.sql
- [ ] Check tất cả 6 sections pass
- [ ] Screenshot My Courses page
- [ ] Document any issues

## 🎉 Success Criteria

**✅ TEST PASSED nếu:**
1. Cart được xóa sạch sau checkout
2. Enrollment được tạo trong database với Status='ACTIVE'
3. My Courses page hiển thị khóa học vừa mua
4. Status badge hiển thị "Đang học"
5. Console logs không có errors
6. verify_checkout.sql tất cả sections pass

**❌ TEST FAILED nếu:**
1. Cart vẫn còn items sau checkout
2. My Courses page rỗng (empty state)
3. Console có errors
4. Database không có enrollment records
5. Status không hiển thị đúng

---

**Files liên quan:**
- `CheckoutServlet.java` - Clear cart logic
- `MyCoursesServlet.java` - Query enrollments
- `my-courses.jsp` - Display UI
- `fix_enrollment_procedure.sql` - Update stored procedure
- `verify_checkout.sql` - Verification script

**Last Updated**: October 26, 2025  
**Version**: 3.0
