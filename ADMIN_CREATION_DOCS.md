# 📋 Admin Creation & Management System Documentation

## 🎯 Mục đích
Hệ thống cho phép tạo admin mới và quản lý tài khoản theo mô hình MVC.

## 🏗️ Kiến trúc MVC

### Model (Lớp dữ liệu)
- **CreateAdminController.java** - Xử lý việc tạo admin mới
- **AccountManagementController.java** - Quản lý và hiển thị danh sách user
- **DBConnection.java** - Kết nối cơ sở dữ liệu

### View (Giao diện)
- **createadmin.jsp** - Form tạo admin mới
- **accountmanagement.jsp** - Hiển thị danh sách tài khoản

### Controller (Điều khiển)
- **admin_createadmin.jsp** - Entry point xử lý POST request tạo admin
- **admin_accountmanagement.jsp** - Entry point hiển thị danh sách user

## 🔄 Luồng hoạt động

### 1. Tạo Admin Mới
```
User điền form → admin_createadmin.jsp → CreateAdminController → Database
     ↓
Success/Error message ← Redirect ← Validation & Insert
```

### 2. Hiển thị danh sách Admin
```
User truy cập → admin_accountmanagement.jsp → AccountManagementController → Database
     ↓
Danh sách user ← accountmanagement.jsp ← Load data ← Query Users table
```

## 📊 Database Schema
Bảng `Users` sẽ chứa admin mới với:
- **Id**: UUID unique
- **UserName**: Tên đăng nhập (unique)
- **Password**: Mật khẩu đã hash SHA-256
- **Email**: Email (unique)  
- **FullName**: Họ tên đầy đủ
- **Role**: "Admin"
- **IsVerified**: true
- **IsApproved**: true
- **CreationTime**: Thời gian tạo
- **Phone, Bio, DateOfBirth**: Thông tin bổ sung

## 🛠️ Cách sử dụng

### Tạo Admin mới
1. Truy cập `/Adaptive_Elearning/admin_createadmin.jsp`
2. Điền thông tin:
   - **Tên đăng nhập**: Tối thiểu 3 ký tự, không trùng
   - **Email**: Định dạng email hợp lệ, không trùng
   - **Mật khẩu**: Tối thiểu 6 ký tự
   - **Họ tên**: Bắt buộc
   - **Điện thoại, Ngày sinh, Bio**: Tùy chọn
3. Click "Tạo Admin"
4. Hệ thống sẽ:
   - Validate dữ liệu
   - Kiểm tra trùng lặp
   - Hash mật khẩu
   - Insert vào database
   - Hiển thị thông báo kết quả

### Xem danh sách Admin
1. Truy cập `/Adaptive_Elearning/admin_accountmanagement.jsp`
2. Lọc theo Role = "Admin" để xem tất cả admin
3. Sử dụng phân trang để xem nhiều user
4. Thống kê hiển thị tổng số admin

## ✅ Validation Rules

### Username
- Tối thiểu 3 ký tự
- Không được trống
- Unique trong database

### Email  
- Định dạng email hợp lệ
- Unique trong database

### Password
- Tối thiểu 6 ký tự
- Được hash SHA-256 trước khi lưu

### Full Name
- Bắt buộc
- Không được trống

## 🔒 Security Features

1. **Password Hashing**: SHA-256
2. **Input Validation**: Server-side validation
3. **SQL Injection Prevention**: PreparedStatement
4. **Duplicate Prevention**: Database unique constraints

## 🧪 Testing

Chạy test tại: `/Adaptive_Elearning/test_admin_flow.jsp`

Test bao gồm:
- ✅ Database connection
- ✅ Current admin count  
- ✅ User list loading
- ✅ Form functionality
- ✅ End-to-end flow

## 📁 File Structure
```
src/java/controller/
├── CreateAdminController.java     # Tạo admin
├── AccountManagementController.java # Quản lý user
└── DBConnection.java              # Database connection

web/
├── admin_createadmin.jsp          # Entry point tạo admin
├── admin_accountmanagement.jsp    # Entry point quản lý user
└── WEB-INF/views/admin/
    ├── createadmin.jsp            # Form tạo admin
    └── accountmanagement.jsp      # Danh sách user
```

## 🚀 Kết quả
- ✅ Admin mới được tạo trong database
- ✅ Xuất hiện trong Account Management
- ✅ Có thể filter theo role "Admin"
- ✅ Statistics cards cập nhật số lượng
- ✅ Theo đúng pattern MVC

---
*Tài liệu được tạo tự động - CourseHub E-Learning System*