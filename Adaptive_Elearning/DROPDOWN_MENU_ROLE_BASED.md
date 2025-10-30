# DROPDOWN MENU PHÂN QUYỀN THEO ROLE

## 🎯 Tính Năng Đã Implement

Dropdown menu user đã được cập nhật với **phân quyền theo role**:

### ✅ Learner (Học viên)
Khi login với role **Learner**, dropdown menu hiển thị:
- ✅ **Khóa học đã đăng ký** - Link đến `/my-courses`
- ✅ **Chỉnh sửa hồ sơ** - Link đến `/profile`
- ✅ **Cài đặt** - Link đến `/settings`
- ✅ **Đăng xuất** - Link đến `/logout`

**KHÔNG hiển thị**: Dashboard

---

### ✅ Instructor (Giảng viên)
Khi login với role **Instructor**, dropdown menu hiển thị:
- ✅ **Instructor Dashboard** - Link đến `/instructor_dashboard.jsp`
- ✅ **Chỉnh sửa hồ sơ** - Link đến `/profile`
- ✅ **Cài đặt** - Link đến `/settings`
- ✅ **Đăng xuất** - Link đến `/logout`

**KHÔNG hiển thị**: Khóa học đã đăng ký (chỉ dành cho Learner)

---

### ✅ Admin (Quản trị viên)
Khi login với role **Admin**, dropdown menu hiển thị:
- ✅ **Admin Dashboard** - Link đến `/admin_dashboard.jsp`
- ✅ **Chỉnh sửa hồ sơ** - Link đến `/profile`
- ✅ **Cài đặt** - Link đến `/settings`
- ✅ **Đăng xuất** - Link đến `/logout`

**KHÔNG hiển thị**: Khóa học đã đăng ký (chỉ dành cho Learner)

---

## 📁 Files Đã Tạo/Sửa

### 1. Component Mới (Reusable)
**File**: `src/main/webapp/WEB-INF/includes/user-dropdown.jsp`

**Chức năng**:
- Component dropdown menu có thể tái sử dụng
- Tự động phân quyền dựa trên `user.getRole()`
- Hiển thị role badge (Learner/Instructor/Admin)
- Responsive và có animation

**Cách sử dụng**:
```jsp
<%-- Include dropdown menu vào bất kỳ trang nào --%>
<%@ include file="/WEB-INF/includes/user-dropdown.jsp" %>
```

### 2. Trang Đã Cập Nhật
✅ `home.jsp` - Trang chủ
✅ `my-courses.jsp` - Trang khóa học của tôi
✅ `cart.jsp` - Giỏ hàng

**Các trang khác cần cập nhật** (nếu có dropdown menu):
- `dashboard.jsp`
- `checkout-success.jsp`
- Các trang trong `/WEB-INF/views/Pages/`

---

## 🎨 Giao Diện

### Role Badge
Mỗi role có màu riêng:
- **Learner**: Badge màu xanh dương (`#1976d2`)
- **Instructor**: Badge màu cam (`#f57c00`)
- **Admin**: Badge màu hồng (`#c2185b`)

### Menu Structure
```
┌─────────────────────────────────┐
│  [Avatar]                       │
│  Username                       │
│  email@example.com              │
│  [ROLE BADGE]                   │
├─────────────────────────────────┤
│  📊 Dashboard (Admin/Instructor)│
│  📚 Khóa học đã đăng ký (Learner)│
│  ✏️ Chỉnh sửa hồ sơ             │
│  ⚙️ Cài đặt                      │
├─────────────────────────────────┤
│  🚪 Đăng xuất                    │
└─────────────────────────────────┘
```

---

## 🔧 Logic Phân Quyền

```java
String userRole = currentUser.getRole(); // "Learner", "Instructor", "Admin"

if ("Instructor".equalsIgnoreCase(userRole) || "Admin".equalsIgnoreCase(userRole)) {
    // Hiển thị Dashboard
    if ("Admin".equalsIgnoreCase(userRole)) {
        dashboardUrl = "/admin_dashboard.jsp";
    } else {
        dashboardUrl = "/instructor_dashboard.jsp";
    }
}

if ("Learner".equalsIgnoreCase(userRole)) {
    // Hiển thị "Khóa học đã đăng ký"
}

// Tất cả role đều có: Profile, Settings, Logout
```

---

## 🧪 Test Cases

### Test 1: Learner Login
1. Login với account role = "Learner"
2. Click dropdown menu
3. ✅ Expect: Thấy "Khóa học đã đăng ký"
4. ❌ Expect: KHÔNG thấy "Dashboard"

### Test 2: Instructor Login
1. Login với account role = "Instructor"
2. Click dropdown menu
3. ✅ Expect: Thấy "Instructor Dashboard"
4. ❌ Expect: KHÔNG thấy "Khóa học đã đăng ký"

### Test 3: Admin Login
1. Login với account role = "Admin"
2. Click dropdown menu
3. ✅ Expect: Thấy "Admin Dashboard"
4. ❌ Expect: KHÔNG thấy "Khóa học đã đăng ký"

### Test 4: Role Badge
1. Login với bất kỳ role nào
2. Click dropdown menu
3. ✅ Expect: Thấy role badge với màu đúng

---

## 📊 Dashboard URLs

| Role       | Dashboard URL                    | Icon                   |
|------------|----------------------------------|------------------------|
| Learner    | N/A (không có dashboard)         | -                      |
| Instructor | `/instructor_dashboard.jsp`      | `fas fa-chalkboard-teacher` |
| Admin      | `/admin_dashboard.jsp`           | `fas fa-tachometer-alt` |

---

## 🚀 Next Steps (Nếu cần)

### 1. Cập nhật các trang còn lại
Tìm tất cả trang có dropdown menu cũ:
```bash
grep -r "user-dropdown" src/main/webapp/*.jsp
```

Thay thế bằng:
```jsp
<%@ include file="/WEB-INF/includes/user-dropdown.jsp" %>
```

### 2. Thêm active state
Để highlight menu item hiện tại:
```jsp
<a href="/my-courses" class="dropdown-item <%= request.getRequestURI().contains("my-courses") ? "active" : "" %>">
```

### 3. Thêm permission checks
Trong servlet/controller, verify role trước khi cho phép access:
```java
if (!"Learner".equals(user.getRole())) {
    response.sendRedirect("/access-denied.jsp");
    return;
}
```

---

## 📝 Notes

- Component `user-dropdown.jsp` tự động lấy user từ session
- Role check không phân biệt chữ hoa/thường (`equalsIgnoreCase`)
- CSS cho role badge đã được include trong component
- Dropdown menu responsive và hoạt động trên mobile

---

## ✅ Checklist Hoàn Thành

- [x] Tạo component `user-dropdown.jsp`
- [x] Implement logic phân quyền theo role
- [x] Thêm role badge với màu sắc
- [x] Cập nhật `home.jsp`
- [x] Cập nhật `my-courses.jsp`
- [x] Cập nhật `cart.jsp`
- [x] Test với Learner role
- [ ] Test với Instructor role
- [ ] Test với Admin role
- [ ] Cập nhật các trang còn lại (nếu cần)

---

## 🎯 Summary

Dropdown menu bây giờ:
- ✅ **Smart** - Tự động hiển thị menu items dựa trên role
- ✅ **Reusable** - Dùng 1 component cho tất cả trang
- ✅ **Maintainable** - Chỉ cần sửa 1 file để update toàn bộ
- ✅ **User-friendly** - Hiển thị role badge để user biết quyền của mình
- ✅ **Secure** - Không hiển thị options mà user không được phép access
