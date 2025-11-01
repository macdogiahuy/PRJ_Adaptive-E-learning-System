# Hướng dẫn sử dụng chức năng Quản lý Khóa học cho Instructor

## Tổng quan
Chức năng này cho phép Instructor quản lý các khóa học của mình với đầy đủ các tính năng CRUD (Create, Read, Update, Delete).

## Cấu trúc dự án

### 1. Backend Layer

#### DAO Layer (`dao/CourseDAO.java`)
- `getCoursesByInstructorId(String instructorId)`: Lấy danh sách khóa học theo instructor
- `getCourseById(String courseId)`: Lấy thông tin chi tiết một khóa học
- `createCourse(Courses course, String instructorId, String userId)`: Tạo khóa học mới
- `updateCourse(Courses course, String userId)`: Cập nhật khóa học
- `deleteCourse(String courseId)`: Xóa khóa học
- `getAllCategories()`: Lấy danh sách danh mục
- `getSectionsByCourseId(String courseId)`: Lấy danh sách sections
- `createSection(String courseId, String title, int index, String userId)`: Tạo section mới

#### Service Layer (`services/CourseService.java`)
- Xử lý business logic và validation
- Sử dụng `OperationResult<T>` để trả về kết quả
- Các phương thức tương ứng với DAO nhưng có thêm validation

#### Controller Layer (`servlet/InstructorCoursesServlet.java`)
Mapping: `/instructor-courses` và `/instructor-courses/*`

**GET Endpoints:**
- `/instructor-courses` - Hiển thị danh sách khóa học
- `/instructor-courses/create` - Hiển thị form tạo khóa học
- `/instructor-courses/edit/{courseId}` - Hiển thị form chỉnh sửa
- `/instructor-courses/view/{courseId}` - Xem chi tiết khóa học

**POST Endpoints:**
- `action=create` - Tạo khóa học mới
- `action=update` - Cập nhật khóa học
- `action=delete` - Xóa khóa học
- `action=createSection` - Tạo section mới

### 2. Frontend Layer

#### Trang danh sách khóa học (`instructor_courses.jsp`)
**Tính năng:**
- Hiển thị tất cả khóa học của instructor dạng bảng
- Thống kê: Tổng khóa học, Tổng học viên, Đánh giá trung bình
- Filter theo: Tìm kiếm, Danh mục, Trạng thái, Cấp độ
- Các thao tác: Xem, Sửa, Xóa khóa học
- Responsive design

**Cột trong bảng:**
- Hình ảnh
- Tiêu đề
- Trạng thái (Ongoing/Completed/Draft)
- Giá
- Giảm giá (%)
- Cấp độ
- Số học viên
- Đánh giá
- Danh mục
- Thao tác

#### Form tạo/chỉnh sửa khóa học (`instructor_course_form.jsp`)
**Các phần:**

1. **Thông tin cơ bản**
   - Tiêu đề khóa học (required)
   - Link ảnh thumbnail (required) - Nhập URL, có preview ảnh
   - Giới thiệu ngắn (required)
   - Mô tả chi tiết (required)

2. **Giá & Danh mục**
   - Giá khóa học (VNĐ) (required)
   - Giảm giá (%)
   - Danh mục (required)
   - Cấp độ: Beginner/Intermediate/Advanced/All (required)
   - Trạng thái: Ongoing/Completed/Draft

3. **Kết quả học tập & Yêu cầu**
   - Kết quả học tập (outcomes)
   - Yêu cầu đầu vào (requirements)

4. **Các phần của khóa học (Sections)**
   - Thêm/xóa sections động
   - Mỗi section có số thứ tự và tiêu đề
   - Nút "Thêm phần mới" với icon và animation

#### Sidebar Navigation (`WEB-INF/includes/instructor-sidebar.jsp`)
- Menu "Khóa học" đã được cấu hình mapping đến `/instructor-courses`
- Active state khi ở trang khóa học

## Cách sử dụng

### 1. Truy cập trang quản lý khóa học
- Login với tài khoản Instructor
- Click vào menu "Khóa học" ở sidebar
- URL: `http://localhost:8080/Adaptive_Elearning/instructor-courses`

### 2. Tạo khóa học mới
1. Click nút "Tạo khóa học mới" (màu tím)
2. Điền thông tin:
   - **Thumbnail**: Nhập URL của ảnh (ví dụ: https://i.imgur.com/example.jpg)
   - Preview ảnh sẽ hiện tự động
   - Điền các trường bắt buộc (có dấu *)
3. Thêm sections:
   - Click "Thêm phần mới"
   - Nhập tiêu đề cho từng section
   - Click icon thùng rác để xóa section
4. Click "Tạo khóa học"

### 3. Chỉnh sửa khóa học
1. Ở trang danh sách, click icon bút chì (màu cam)
2. Form sẽ hiển thị với dữ liệu hiện tại
3. Chỉnh sửa thông tin cần thiết
4. Click "Cập nhật khóa học"

### 4. Xóa khóa học
1. Click icon thùng rác (màu đỏ)
2. Xác nhận xóa trong dialog
3. Khóa học và tất cả sections sẽ bị xóa

### 5. Filter và tìm kiếm
- **Tìm kiếm**: Gõ từ khóa vào ô search
- **Filter theo danh mục**: Chọn dropdown danh mục
- **Filter theo trạng thái**: Chọn Ongoing/Completed/Draft
- **Filter theo cấp độ**: Chọn Beginner/Intermediate/Advanced/All

## Đặc điểm kỹ thuật

### Responsive Design
- Desktop: Hiển thị đầy đủ sidebar + main content
- Mobile: Sidebar ẩn, main content chiếm full width

### Validation
- Frontend: HTML5 validation + JavaScript
- Backend: Service layer validation
- Required fields được đánh dấu *

### Database
Sử dụng các bảng:
- `Courses`: Lưu thông tin khóa học
- `Sections`: Lưu các phần của khóa học
- `Categories`: Danh mục khóa học
- `Instructors`: Thông tin instructor
- `Users`: Thông tin user (liên kết với instructor)

### Security
- Kiểm tra role "Instructor" ở đầu mỗi trang
- Session validation
- SQL injection prevention (PreparedStatement)

## Animation và UX

1. **Hover Effects**: Tất cả buttons có hover effect với transform và shadow
2. **Section Animation**: 
   - Add section: slideIn animation
   - Remove section: slideOut animation
3. **Thumbnail Preview**: Ảnh hiện ngay khi nhập URL hợp lệ
4. **Success Messages**: Alert màu xanh khi thao tác thành công
5. **Error Messages**: Alert màu đỏ khi có lỗi

## Lưu ý quan trọng

1. **Thumbnail**: 
   - Phải nhập URL, không upload từ máy tính
   - Khuyến nghị kích thước: 800x450px
   - Format: JPG, PNG, WebP

2. **Sections**: 
   - Có thể tạo khóa học không có section
   - Sections sẽ được đánh số tự động
   - Có thể thêm sections sau khi tạo khóa học

3. **Price**: 
   - Nhập số nguyên (VNĐ)
   - Discount: 0-100%

4. **Status**:
   - Ongoing: Khóa học đang mở
   - Completed: Khóa học đã kết thúc
   - Draft: Nháp (chưa công khai)

## Troubleshooting

### Lỗi không hiển thị ảnh thumbnail
- Kiểm tra URL có hợp lệ không
- Kiểm tra URL có public access
- Thử URL khác

### Lỗi không tạo được khóa học
- Kiểm tra tất cả trường required đã điền
- Kiểm tra format giá (số nguyên dương)
- Kiểm tra connection database

### Lỗi xóa khóa học
- Khóa học có thể có ràng buộc với bảng khác
- Kiểm tra foreign key constraints

## Mở rộng tương lai

1. Upload ảnh trực tiếp thay vì URL
2. Rich text editor cho mô tả
3. Quản lý lectures trong sections
4. Thêm video preview
5. Drag & drop để sắp xếp sections
6. Bulk actions (xóa nhiều khóa học cùng lúc)
7. Export/Import khóa học

## Contact
Nếu có vấn đề, liên hệ với team phát triển.
