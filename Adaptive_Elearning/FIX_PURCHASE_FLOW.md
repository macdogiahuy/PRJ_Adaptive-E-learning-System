# FIX PURCHASE FLOW - Troubleshooting Guide

## Vấn đề
Khi mua 2 khóa học thành công, nhưng trong "Khóa học của tôi" chỉ hiện 1 khóa học.

## Các nguyên nhân có thể

### 1. **Type Mismatch trong Query** ✅ FIXED
- **Vấn đề**: Query sử dụng `WHERE e.CreatorId = ?` có thể không match đúng với UNIQUEIDENTIFIER trong SQL Server
- **Giải pháp**: Đã thêm `CAST(e.CreatorId AS VARCHAR(36))` trong MyCoursesServlet.java

### 2. **Stored Procedure không tạo đủ Enrollments**
- **Vấn đề**: ProcessCartCheckout có thể skip một số courses
- **Kiểm tra**: Chạy `run_test_stored_procedure.bat` để test

### 3. **Transaction Rollback**
- **Vấn đề**: Nếu có lỗi trong quá trình tạo enrollment, toàn bộ transaction bị rollback
- **Kiểm tra**: Xem server logs

## Các file đã fix

### ✅ MyCoursesServlet.java
- Thêm CAST trong query: `CAST(e.CreatorId AS VARCHAR(36)) = ?`
- Thêm debug logging để track số lượng enrollments
- Thêm count query để verify data

### ✅ CartCheckoutService.java
- Thêm chi tiết logging cho từng course được process
- Log User ID type để debug

## Scripts để Debug

### 1. Quick Check
```cmd
run_quick_fix.bat
```
Kiểm tra nhanh:
- Enrollments hiện có
- Bills không có enrollments
- User ID type mismatch

### 2. Test Stored Procedure
```cmd
run_test_stored_procedure.bat
```
Test stored procedure với 2 courses để verify logic

### 3. Full Purchase Flow Test
```cmd
run_test_purchase_flow.bat
```
Kiểm tra toàn bộ flow từ Bill → Enrollment

### 4. Debug Enrollments
```cmd
run_debug_enrollments.bat
```
Xem chi tiết tất cả enrollments trong database

## Cách test sau khi fix

1. **Xóa cache và restart server**
   ```cmd
   force-rebuild.bat
   ```

2. **Thêm 2 khóa học vào giỏ hàng**
   - Vào trang chủ
   - Chọn 2 khóa học khác nhau
   - Thêm vào giỏ hàng

3. **Thanh toán**
   - Chọn phương thức thanh toán (VNPay hoặc VietQR)
   - Hoàn tất thanh toán

4. **Kiểm tra "Khóa học của tôi"**
   - Vào /my-courses
   - Verify cả 2 khóa học đều hiển thị

5. **Kiểm tra database**
   ```cmd
   run_quick_fix.bat
   ```
   - Xem output để verify số lượng enrollments

## Các điểm cần chú ý

### Database Schema
```sql
-- Enrollments table
CREATE TABLE Enrollments (
    CreatorId UNIQUEIDENTIFIER,  -- User ID
    CourseId UNIQUEIDENTIFIER,   -- Course ID
    BillId UNIQUEIDENTIFIER,     -- Bill ID
    Status NVARCHAR(50),
    CreationTime DATETIME2,
    ...
)
```

### Query Fix
```java
// OLD - Có thể không work với UNIQUEIDENTIFIER
WHERE e.CreatorId = ?

// NEW - Work với mọi trường hợp
WHERE CAST(e.CreatorId AS VARCHAR(36)) = ?
```

### Stored Procedure Logic
```sql
-- ProcessCartCheckout
1. Tạo Bill
2. Loop qua từng Course ID trong JSON array
3. Kiểm tra đã enrolled chưa
4. Nếu chưa → Tạo Enrollment
5. Nếu rồi → Skip (SkippedCount++)
```

## Logs để kiểm tra

### Server Logs (Catalina)
```
=== PROCESSING CHECKOUT WITH STORED PROCEDURE ===
User ID: <uuid>
Course IDs: ["uuid1","uuid2"]
Number of courses: 2
```

### Database Output
```
Enrolled: Course Title 1
Enrolled: Course Title 2
Checkout thành công. Enrollments: 2, Skipped: 0
```

## Nếu vẫn có lỗi

1. **Kiểm tra logs**
   - Xem `debug_output.txt`
   - Xem Tomcat logs trong `logs/` folder

2. **Verify database state**
   ```cmd
   run_test_purchase_flow.bat
   ```

3. **Check for duplicates**
   ```sql
   SELECT CourseId, CreatorId, COUNT(*)
   FROM Enrollments
   GROUP BY CourseId, CreatorId
   HAVING COUNT(*) > 1
   ```

4. **Manual enrollment (emergency)**
   ```sql
   -- Nếu cần tạo enrollment thủ công
   INSERT INTO Enrollments (CreatorId, CourseId, BillId, Status, CreationTime, AssignmentMilestones, LectureMilestones, SectionMilestones)
   VALUES (
       '<user-id>',
       '<course-id>',
       '<bill-id>',
       'In Progress',
       GETDATE(),
       '{}', '{}', '{}'
   )
   ```

## Contact Debug Info

Nếu cần support, gửi kèm:
1. Output của `run_quick_fix.bat`
2. Output của `run_test_purchase_flow.bat`
3. Server logs (catalina.out hoặc localhost log)
4. Screenshot của "Khóa học của tôi"

---

**Version**: 1.0
**Last Updated**: 2025-11-07
**Status**: ✅ FIXES APPLIED
