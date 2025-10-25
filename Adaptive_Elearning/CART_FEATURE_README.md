# Chức năng Thêm vào Giỏ hàng - CourseHub

## Tổng quan
Chức năng "Thêm vào giỏ hàng" cho phép người dùng đã đăng nhập thêm các khóa học vào giỏ hàng của họ để mua sau.

## Cấu trúc Files

### Backend (Java)
```
src/main/java/
├── dao/CartDAO.java                 # Data Access Object cho giỏ hàng
├── servlet/AddToCartServlet.java    # Servlet xử lý thêm vào giỏ hàng
├── servlet/CartPageServlet.java     # Servlet hiển thị trang giỏ hàng  
├── servlet/HomeServlet.java         # Servlet trang chủ
└── model/
    ├── Cart.java                    # Model giỏ hàng (đã có sẵn)
    ├── CartItem.java               # Model item trong giỏ hàng (đã có sẵn)
    ├── Courses.java                # Model khóa học (đã có sẵn)
    └── Users.java                  # Model người dùng (đã có sẵn)
```

### Frontend
```
src/main/webapp/
├── home.jsp                        # Trang chủ với nút thêm vào giỏ hàng
├── assets/
│   ├── js/cart.js                 # JavaScript xử lý cart
│   └── css/cart.css               # CSS styling cho cart
└── WEB-INF/web.xml                # Cấu hình servlet mapping
```

## Flow hoạt động

### 1. Hiển thị trang chủ
- **URL**: `/`, `/home`
- **Servlet**: `HomeServlet.java`
- **View**: `home.jsp`
- **Chức năng**: 
  - Lấy danh sách khóa học nổi bật từ database
  - Hiển thị khóa học với nút "Thêm vào giỏ hàng"
  - Chỉ hiển thị nút cho user đã đăng nhập

### 2. Thêm khóa học vào giỏ hàng
- **URL**: `/add-to-cart` (POST)
- **Servlet**: `AddToCartServlet.java`
- **JavaScript**: `cart.js`
- **Flow**:
  1. User click nút "Thêm vào giỏ hàng"
  2. JavaScript gửi AJAX request với `courseId`
  3. Servlet kiểm tra:
     - User đã đăng nhập chưa
     - Khóa học có tồn tại không
     - User đã enroll chưa
     - User có phải tác giả khóa học không
  4. Nếu hợp lệ: thêm vào session cart
  5. Trả về JSON response
  6. JavaScript cập nhật UI

### 3. Xem giỏ hàng
- **URL**: `/cart-page`
- **Servlet**: `CartPageServlet.java`
- **Chức năng**: Hiển thị danh sách khóa học trong giỏ hàng

## Các tính năng chính

### 1. Validation
- ✅ Kiểm tra user đăng nhập
- ✅ Kiểm tra khóa học tồn tại
- ✅ Kiểm tra user chưa enroll
- ✅ Kiểm tra user không phải tác giả
- ✅ Kiểm tra khóa học đã published
- ✅ Kiểm tra khóa học chưa có trong cart

### 2. UI/UX
- ✅ Nút thêm vào giỏ hàng với icon
- ✅ Loading state khi đang thêm
- ✅ Thông báo thành công/lỗi
- ✅ Cập nhật counter giỏ hàng
- ✅ Mini preview khi thêm thành công
- ✅ Responsive design

### 3. Session Management
- ✅ Lưu giỏ hàng trong session
- ✅ Tự động tạo cart mới cho user
- ✅ Persist qua các request

## Cách sử dụng

### 1. Setup
1. Đảm bảo database đã được setup với bảng Users, Courses, Enrollments
2. Build và deploy project
3. Tạo user và login
4. Tạo một số khóa học sample

### 2. Test flow
1. Truy cập trang chủ: `http://localhost:8080/Adaptive_Elearning/`
2. Đăng nhập nếu chưa
3. Click nút "Thêm vào giỏ hàng" trên bất kỳ khóa học nào
4. Kiểm tra thông báo thành công
5. Kiểm tra counter giỏ hàng tăng lên
6. Click vào icon giỏ hàng để xem chi tiết

### 3. API Endpoints

#### POST /add-to-cart
**Request**:
```
Content-Type: application/x-www-form-urlencoded
courseId=<course-id>
```

**Response**:
```json
{
  "success": true,
  "message": "Đã thêm khóa học vào giỏ hàng thành công!",
  "cartItemCount": 2,
  "cartTotal": 500000,
  "course": {
    "id": "course-id",
    "title": "Course Title",
    "price": 250000
  }
}
```

#### GET /add-to-cart
**Response**:
```json
{
  "success": true,
  "cartItemCount": 2,
  "cartTotal": 500000
}
```

## Database Schema được sử dụng

### Courses Table
- `Id` (String) - Primary key
- `Title` (String) - Tên khóa học
- `Description` (String) - Mô tả
- `Price` (double) - Giá gốc
- `Discount` (double) - % giảm giá
- `Status` (String) - Trạng thái (Published/Draft)
- `CreatorId` (Users) - Tác giả khóa học

### Users Table  
- `Id` (String) - Primary key
- `FullName` (String) - Tên đầy đủ
- `Email` (String) - Email

### Enrollments Table
- `CreatorId` (String) - User ID
- `CourseId` (String) - Course ID
- Composite primary key

## Lỗi thường gặp và cách khắc phục

### 1. NullPointerException khi truy cập Course
**Nguyên nhân**: Course không tồn tại trong database
**Khắc phục**: Kiểm tra courseId và tạo sample data

### 2. Session timeout
**Nguyên nhân**: User session hết hạn
**Khắc phục**: Tăng session timeout trong web.xml

### 3. AJAX error 500
**Nguyên nhân**: Lỗi server-side trong servlet
**Khắc phục**: Kiểm tra server logs và debug

### 4. Cart không cập nhật
**Nguyên nhân**: JavaScript error hoặc session issue
**Khắc phục**: Kiểm tra browser console và session

## Mở rộng trong tương lai

### 1. Persistence
- Lưu cart vào database thay vì session
- Sync cart giữa các device

### 2. Advanced Features
- Wishlist functionality
- Cart expiration
- Bulk operations
- Cart sharing

### 3. Performance
- Cache course data
- Optimize database queries
- CDN for static assets

## Cấu hình bổ sung

### web.xml
```xml
<!-- Session timeout 30 minutes -->
<session-config>
    <session-timeout>30</session-timeout>
</session-config>

<!-- Welcome file -->
<welcome-file-list>
    <welcome-file>home</welcome-file>
</welcome-file-list>
```

### persistence.xml
Đảm bảo có đầy đủ các entity classes trong persistence unit.

## Dependencies cần thiết

### Maven (pom.xml)
- Jakarta Servlet API
- Jakarta Persistence API  
- EclipseLink JPA
- Microsoft SQL Server JDBC Driver
- Gson (cho JSON processing)

### Frontend
- Bootstrap 5.3+
- Font Awesome 6.0+
- Modern browser với ES6+ support

---

**Lưu ý**: Đây là implementation cơ bản. Trong production, cần thêm các tính năng như logging, monitoring, error handling, và security validation chi tiết hơn.