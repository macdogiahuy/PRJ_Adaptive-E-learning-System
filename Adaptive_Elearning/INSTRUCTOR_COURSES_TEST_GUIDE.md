# HƯỚNG DẪN TEST TRANG INSTRUCTOR COURSES

## ✅ Đã Hoàn Thành

### 1. **InstructorCoursesServlet.java**
- **Location**: `src/main/java/servlet/InstructorCoursesServlet.java`
- **URL Pattern**: `/instructor-courses`
- **Chức năng**: 
  - Lấy danh sách khóa học của instructor từ database
  - Tính toán thống kê: tổng khóa học, active, draft, tổng học viên
  - Trả về dữ liệu cho JSP

### 2. **instructor_courses.jsp**
- **Location**: `src/main/webapp/instructor_courses.jsp`
- **Tính năng**:
  - Hiển thị sidebar menu với navigation
  - Stats cards: Tổng khóa học, Đang hoạt động, Bản nháp, Tổng học viên
  - Search và filter khóa học
  - Grid view courses với thumbnail, status, metadata
  - Actions: Edit, View, Analytics cho mỗi course

### 3. **instructor_dashboard.jsp**
- **Updated**: Link "Khóa học" trong sidebar đã được cập nhật
- **Link**: `<%= request.getContextPath() %>/instructor-courses`

---

## 🧪 CÁCH TEST

### Bước 1: Đảm Bảo Server Đang Chạy
```cmd
netstat -ano | findstr :8080
```
**Kết quả mong đợi**: Thấy port 8080 LISTENING

---

### Bước 2: Login với Instructor Account

1. Vào: `http://localhost:8080/Adaptive_Elearning/`
2. Click **Đăng nhập**
3. Login với account có **Role = "Instructor"**

**Lưu ý**: Cần có account Instructor trong database. Nếu chưa có:
```sql
-- Check xem có instructor nào không:
SELECT Id, UserName, Email, Role 
FROM Users 
WHERE Role = 'Instructor'

-- Nếu không có, update 1 user thành instructor:
UPDATE Users 
SET Role = 'Instructor' 
WHERE UserName = 'your_username'
```

---

### Bước 3: Vào Instructor Dashboard

Sau khi login, vào:
```
http://localhost:8080/Adaptive_Elearning/instructor_dashboard.jsp
```

---

### Bước 4: Click Menu "Khóa học"

Trong sidebar bên trái, click vào:
- **📚 Khóa học**

**URL sẽ chuyển đến**:
```
http://localhost:8080/Adaptive_Elearning/instructor-courses
```

---

### Bước 5: Verify Trang Khóa Học

Trang `instructor_courses.jsp` sẽ hiển thị:

#### Stats Cards (Trên cùng):
- **Tổng khóa học**: Số lượng courses của instructor
- **Đang hoạt động**: Courses có Status = 'Active'
- **Bản nháp**: Courses có Status = 'Draft'
- **Tổng học viên**: Tổng số learners từ tất cả courses

#### Action Bar:
- **Search box**: Tìm kiếm khóa học theo tên
- **Filter**: Lọc theo trạng thái (All/Active/Draft/Inactive)
- **Sort**: Sắp xếp (Mới nhất/Cũ nhất/Phổ biến/Đánh giá)
- **Button**: "Tạo khóa học mới"

#### Courses Grid:
Mỗi course card hiển thị:
- Thumbnail/Image
- Status badge (Active/Draft/Inactive)
- Title
- Số học viên
- Rating + số reviews
- Price
- Actions: Edit, View, Analytics

---

## 📊 Database Query

Servlet query dữ liệu từ:

```sql
SELECT 
    c.Id,
    c.Title,
    c.ThumbUrl,
    c.Price,
    c.Level,
    c.LearnerCount,
    c.Rating,
    c.ReviewCount,
    c.Status,
    c.CreationTime
FROM Courses c
WHERE c.CreatorId = ? -- Instructor's User ID
ORDER BY c.CreationTime DESC
```

---

## 🐛 Troubleshooting

### Lỗi 1: 404 Not Found khi click "Khóa học"

**Nguyên nhân**: Servlet chưa được deploy

**Giải pháp**:
```cmd
# Rebuild project
cd c:\Users\LP\Desktop\code 50%\PRJ_Adaptive-E-learning-System\Adaptive_Elearning
mvn clean package -DskipTests

# Restart server
taskkill /F /PID [PID_NUMBER]
start cmd /k "mvn cargo:run"
```

---

### Lỗi 2: Trang trống, không có khóa học

**Nguyên nhân**: Instructor chưa có course nào trong database

**Kiểm tra**:
```sql
-- Lấy Instructor ID
SELECT Id, UserName FROM Users WHERE Role = 'Instructor'

-- Check courses của instructor
SELECT * FROM Courses WHERE CreatorId = 'INSTRUCTOR_ID_HERE'
```

**Nếu không có**: Trang sẽ hiển thị empty state với message:
```
"Chưa có khóa học nào"
"Bắt đầu tạo khóa học đầu tiên..."
```

---

### Lỗi 3: Access Denied / Redirect to Login

**Nguyên nhân**: Account không phải Instructor role

**Giải pháp**: Update role trong database:
```sql
UPDATE Users 
SET Role = 'Instructor' 
WHERE UserName = 'your_username'
```

---

### Lỗi 4: Sidebar menu không active

**Kiểm tra**: Class `active` có được apply không?

Trong `instructor_courses.jsp` line 286:
```html
<a href="<%= request.getContextPath() %>/instructor-courses" class="nav-link active">
```

---

## 📝 Test Data Sample

Nếu muốn test với dữ liệu mẫu:

```sql
-- Tạo 1 instructor
INSERT INTO Users (Id, UserName, Email, Role, Password, FullName)
VALUES (
    NEWID(),
    'instructor_test',
    'instructor@test.com',
    'Instructor',
    'hashed_password',
    'Test Instructor'
)

-- Lấy Instructor ID vừa tạo
DECLARE @InstructorId UNIQUEIDENTIFIER = (SELECT Id FROM Users WHERE UserName = 'instructor_test')

-- Tạo courses cho instructor
INSERT INTO Courses (Id, Title, ThumbUrl, Price, Level, LearnerCount, Rating, ReviewCount, Status, CreatorId, CreationTime)
VALUES
(NEWID(), 'Java Programming Basics', 'https://example.com/java.jpg', 500000, 'Beginner', 150, 4.5, 45, 'Active', @InstructorId, GETDATE()),
(NEWID(), 'Advanced React Development', 'https://example.com/react.jpg', 800000, 'Advanced', 89, 4.8, 32, 'Active', @InstructorId, GETDATE()),
(NEWID(), 'Python for Data Science', 'https://example.com/python.jpg', 1200000, 'Intermediate', 234, 4.7, 67, 'Draft', @InstructorId, GETDATE())
```

---

## ✅ Expected Results

Sau khi test thành công:

1. ✅ Click "Khóa học" trong sidebar → Redirect đến `/instructor-courses`
2. ✅ Trang load với đầy đủ layout và data
3. ✅ Stats cards hiển thị số liệu đúng
4. ✅ Courses grid hiển thị tất cả courses của instructor
5. ✅ Search, filter, sort hoạt động (client-side JavaScript)
6. ✅ Responsive design trên mobile

---

## 🎯 Next Steps (Optional)

Các chức năng có thể develop tiếp:

1. **Create Course**: Implement `/create-course` endpoint
2. **Edit Course**: Implement `/edit-course?id=xxx` endpoint
3. **Course Analytics**: Implement `/course-analytics?id=xxx`
4. **Delete Course**: Add delete functionality
5. **Bulk Actions**: Select multiple courses để enable/disable
6. **Export Data**: Export danh sách courses ra CSV/Excel

---

## 📞 Support

Nếu gặp lỗi, check:
1. Server logs trong terminal window
2. Browser console (F12) để xem JavaScript errors
3. Network tab để verify API calls
4. Database để verify data exists

---

## 🎉 Summary

**Đã implement**:
- ✅ Servlet lấy danh sách courses từ DB
- ✅ JSP trang hiển thị courses với full UI
- ✅ Sidebar navigation link
- ✅ Stats calculation
- ✅ Responsive design
- ✅ Empty state handling

**URL để test**:
```
http://localhost:8080/Adaptive_Elearning/instructor-courses
```

Good luck testing! 🚀
