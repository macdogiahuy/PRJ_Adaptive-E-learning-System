## ✅ HƯỚNG DẪN TEST SAU KHI FIX

### 🔧 **VẤN ĐỀ ĐÃ FIX:**
- ❌ **Lỗi cũ**: Foreign Key constraint - InstructorId không tồn tại trong Users table
- ✅ **Fix**: Đã sửa line 313 trong InstructorCoursesServlet
  - **Trước**: `instructorId` (= Instructors.Id = F2FBE555...)
  - **Sau**: `user.getId()` (= Users.Id = 8C3D6D81...)

---

### 📝 **BƯỚC 1: STOP SERVER**
Nếu server đang chạy, dừng lại (Ctrl+C)

---

### 📝 **BƯỚC 2: RESTART SERVER**
```cmd
cd "c:\Users\LP\Desktop\New folder (3)\PRJ_Adaptive-E-learning-System\Adaptive_Elearning"
mvn cargo:run
```

---

### 📝 **BƯỚC 3: TEST TẠO COURSE**

1. **Login as Instructor**: `HuynhGiang59`

2. **Tạo course mới**:
   - Title: `FinalTestCourse`
   - Price: `500000`
   - Category: Bất kỳ
   - Level: Beginner

3. **Kiểm tra logs** - Bạn SẼ THẤY:
   ```
   ✅ Course created successfully with ID: xxx
   ✅ Course notification created for admin approval: FinalTestCourse
   ```
   
   **KHÔNG CÒN LỖI**:
   ~~FK_CourseNotifications_Instructor constraint error~~

---

### 📝 **BƯỚC 4: VERIFY DATABASE**

Chạy SQL:
```cmd
sqlcmd -S localhost -d CourseHubDB -E -i verify_course_creation.sql
```

**Kết quả mong đợi**:
- ✅ Course có `Status='pending'`
- ✅ Course có `ApprovalStatus='pending'`  
- ✅ **TotalNotifications = 1** (QUAN TRỌNG!)
- ✅ Notification có `Status='pending'`

---

### 📝 **BƯỚC 5: TEST ADMIN NOTIFICATION**

1. **Login as Admin**: `chauvuonghoang50`

2. **Vào trang**:
   ```
   http://localhost:8080/Adaptive_Elearning/admin_notification.jsp
   ```

3. **Kiểm tra**:
   - ✅ **Thấy course "FinalTestCourse"** trong table
   - ✅ Button "Duyệt" và "Từ chối" hoạt động
   - ✅ Click "Duyệt" → Course status = 'ongoing'
   - ✅ Click "Từ chối" → Nhập lý do → Course status = 'off'

---

### 🎯 **EXPECTED RESULT:**
```
┌─────────────────────────────────────────────────┐
│  Khóa học chờ phê duyệt (1)                    │
├─────────────────────────────────────────────────┤
│  Hình  │ Tên khóa học    │ Giảng viên │ Giá   │
│  ────  │ FinalTestCourse │ HuynhGiang │ 500k  │
│        │                 │ [Duyệt] [Từ chối]  │
└─────────────────────────────────────────────────┘
```

---

### 🚀 **BÂY GIỜ HÃY:**
1. **Stop server** (nếu đang chạy)
2. **Restart**: `mvn cargo:run`
3. **Test tạo course**: "FinalTestCourse"
4. **Check admin notification page**
5. **Báo kết quả!** 🎉
