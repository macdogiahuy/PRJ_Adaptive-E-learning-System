# CÁC BƯỚC KIỂM TRA ĐƠN GIẢN

## 🎯 Bạn Muốn Kiểm Tra Gì?

### ✅ Option 1: Kiểm Tra Nhanh (5 giây)

**Mở SQL Server Management Studio (SSMS):**

1. Click **New Query**
2. Copy và paste đoạn này:

```sql
USE CourseHubDB
GO

SELECT COUNT(*) AS TongSoKhoaHoc
FROM Enrollments 
WHERE CreatorId = 'C90648FF-C420-4B9D-92B2-081D7CC209D5'
```

3. Nhấn **F5**
4. Xem kết quả: Nếu > 0 = Bạn có enrollments

---

### ✅ Option 2: Xem Chi Tiết Khóa Học Đã Mua

**Copy và paste đoạn này vào SSMS:**

```sql
USE CourseHubDB
GO

SELECT 
    c.Title AS TenKhoaHoc,
    e.Status AS TrangThai,
    e.CreationTime AS NgayMua,
    b.Amount AS GiaTien
FROM Enrollments e
LEFT JOIN Courses c ON e.CourseId = c.Id
LEFT JOIN Bills b ON e.BillId = b.Id
WHERE e.CreatorId = 'C90648FF-C420-4B9D-92B2-081D7CC209D5'
ORDER BY e.CreationTime DESC
```

**Kết quả sẽ hiển thị:**
- TenKhoaHoc: Tên khóa học bạn đã mua
- TrangThai: ACTIVE, Active, hoặc Ongoing
- NgayMua: Ngày giờ mua
- GiaTien: Số tiền đã trả

---

### ✅ Option 3: Kiểm Tra Toàn Bộ (Chi Tiết)

**Cách 1: Dùng File**
1. Mở SSMS
2. **File → Open → File...**
3. Chọn file: `QUICK_CHECK.sql`
4. Nhấn **F5**

**Cách 2: Copy Paste**
1. Mở file `QUICK_CHECK.sql` trong VS Code
2. **Ctrl+A** → **Ctrl+C** (copy toàn bộ)
3. Paste vào SSMS
4. Nhấn **F5**

---

## 🚨 LỖI THƯỜNG GẶP

### ❌ LỖI: "Invalid object name 'verify_enrollment_after_checkout.sql'"

**Nguyên nhân**: Bạn đang chạy:
```sql
SELECT * FROM verify_enrollment_after_checkout.sql  -- ← SAI!
```

**Giải pháp**: 
- `.sql` là file script, KHÔNG phải table
- KHÔNG dùng `SELECT * FROM filename.sql`
- Phải MỞ file và EXECUTE hoặc copy nội dung vào

---

### ❌ LỖI: "Invalid column name"

**Nguyên nhân**: Gõ sai tên cột

**Giải pháp**: Copy chính xác các query ở trên

---

## 📊 Kết Quả Mong Đợi

### Nếu Bạn ĐÃ MUA Khóa Học:

**Query 1 (Đếm):**
```
TongSoKhoaHoc
-------------
2
```
→ ✅ Bạn có 2 khóa học

**Query 2 (Chi tiết):**
```
TenKhoaHoc              TrangThai  NgayMua              GiaTien
-----------------       ---------  -------------------  -------
Java Programming        ACTIVE     2025-10-27 10:30:00  500000
Python for Beginners    ACTIVE     2025-10-27 10:30:00  400000
```
→ ✅ Có dữ liệu enrollments

### Nếu CHƯA MUA:

**Query 1:**
```
TongSoKhoaHoc
-------------
0
```
→ ⚠️ Chưa có enrollments

**Giải pháp**: Thử mua khóa học trên web rồi check lại

---

## 🎯 SAU KHI KIỂM TRA

### Nếu Query Có Kết Quả Nhưng Web KHÔNG Hiển Thị:

1. Kiểm tra terminal logs (tìm "Query returned X rows")
2. Share logs với tôi để debug

### Nếu Query KHÔNG Có Kết Quả:

1. Bạn chưa mua khóa học nào
2. Hoặc stored procedure không chạy đúng
3. Hãy thử mua 1 khóa học và check lại

---

## 🔗 Files Liên Quan

- **QUICK_CHECK.sql** - Script kiểm tra nhanh (DÙNG CÁI NÀY!)
- **debug_full_flow.sql** - Debug chi tiết (nếu cần troubleshoot)
- **test_checkout_to_mycourses.sql** - Test simulate checkout

---

## ❓ Cần Giúp Gì Tiếp?

Sau khi chạy các query trên, hãy cho tôi biết:
1. **Kết quả Query 1**: Số lượng enrollments = ?
2. **Kết quả Query 2**: Có data không?
3. **Trên web My Courses**: Có hiển thị khóa học không?

Tôi sẽ giúp bạn debug tiếp!
