# HƯỚNG DẪN SỬ DỤNG CHỨC NĂNG GIỎ HÀNG

## Tổng quan
Chức năng giỏ hàng đã được tích hợp vào hệ thống E-Learning. Người dùng có thể thêm khóa học vào giỏ hàng, xem, xóa và thanh toán.

## Cấu trúc đã tạo

### 1. Model - CartItem.java
**Đường dẫn:** `src/main/java/model/CartItem.java`

**Mô tả:** Class lưu thông tin khóa học trong giỏ hàng
- courseId: ID khóa học
- courseName: Tên khóa học  
- courseImage: Ảnh khóa học
- instructorName: Tên giảng viên
- originalPrice: Giá gốc
- discountPrice: Giá sau giảm
- level: Cấp độ khóa học

### 2. Servlet - CartServlet.java
**Đường dẫn:** `src/main/java/servlet/CartServlet.java`

**URL Pattern:** `/cart`

**Chức năng:**
- **GET /cart?action=view** - Xem giỏ hàng (mặc định)
- **POST /cart?action=add&courseId={id}** - Thêm khóa học vào giỏ
- **POST /cart?action=remove&courseId={id}** - Xóa khóa học khỏi giỏ
- **POST /cart?action=clear** - Xóa tất cả khóa học
- **GET /cart?action=count** - Lấy số lượng sản phẩm trong giỏ

### 3. View - cart.jsp
**Đường dẫn:** `src/main/webapp/cart.jsp`

**Mô tả:** Trang hiển thị giỏ hàng với:
- Danh sách khóa học đã thêm
- Tính tổng tiền
- Nút xóa từng khóa học
- Nút xóa tất cả
- Nút thanh toán

### 4. JavaScript - home.js (đã cập nhật)
**Đường dẫn:** `src/main/webapp/assets/js/home.js`

**Chức năng:**
- CartManager class xử lý AJAX thêm vào giỏ
- Cập nhật cart badge số lượng
- Hiển thị notification khi thêm/xóa thành công

### 5. CSS - cart.css
**Đường dẫn:** `src/main/webapp/assets/css/cart.css`

**Mô tả:** Style cho trang giỏ hàng với thiết kế responsive

### 6. Cập nhật home.jsp
**Đường dẫn:** `src/main/webapp/home.jsp`

**Thay đổi:**
- Thêm logic hiển thị số lượng cart badge từ session
- Icon giỏ hàng hiển thị đúng số lượng khi tải trang
- Button "Thêm vào giỏ" đã có data-course-id

## Flow hoạt động

### 1. Khi người dùng vào trang home:
```
1. HomeServlet load danh sách khóa học
2. home.jsp hiển thị các card khóa học
3. CartManager.updateCartBadge() gọi API /cart?action=count
4. Hiển thị số lượng khóa học trong giỏ (nếu có)
```

### 2. Khi click "Thêm vào giỏ hàng":
```
1. JavaScript bắt sự kiện click button .add-to-cart-btn
2. Lấy courseId từ data-course-id attribute
3. Gửi AJAX POST request đến /cart?action=add
4. CartServlet xử lý:
   - Lấy giỏ hàng từ session
   - Kiểm tra khóa học đã tồn tại chưa
   - Query database lấy thông tin khóa học
   - Tạo CartItem và thêm vào giỏ
   - Lưu lại vào session
   - Trả về JSON response
5. JavaScript nhận response:
   - Hiển thị notification thành công/thất bại
   - Cập nhật cart badge
   - Đổi trạng thái button thành "Đã thêm"
```

### 3. Khi vào trang giỏ hàng:
```
1. Click icon giỏ hàng trên header
2. Truy cập /cart (mặc định action=view)
3. CartServlet:
   - Lấy giỏ hàng từ session
   - Tính tổng tiền
   - Forward đến cart.jsp
4. cart.jsp hiển thị:
   - Danh sách khóa học trong giỏ
   - Tổng tiền
   - Các nút action
```

### 4. Khi xóa khóa học:
```
1. Click nút X trên từng item
2. JavaScript confirm xác nhận
3. Gửi POST request đến /cart?action=remove&courseId={id}
4. CartServlet xóa item khỏi session
5. Reload trang để cập nhật
```

## Cách test

### 1. Build và deploy project:
```bash
mvn clean package
# Deploy file WAR vào Tomcat
```

### 2. Đăng nhập vào hệ thống:
```
- Truy cập: http://localhost:8080/Adaptive_Elearning/
- Đăng nhập với tài khoản user
```

### 3. Test chức năng:
```
✓ Thêm khóa học vào giỏ từ trang home
✓ Kiểm tra cart badge tăng lên
✓ Click vào icon giỏ hàng xem danh sách
✓ Xóa một khóa học khỏi giỏ
✓ Xóa tất cả khóa học
✓ Test responsive trên mobile
```

## Session Storage

Giỏ hàng được lưu trong session với key: `"cart"`
- Type: `Map<String, CartItem>`
- Key: courseId
- Value: CartItem object

**Lưu ý:** 
- Session timeout mặc định: 30 phút
- Khi logout session sẽ bị xóa, giỏ hàng cũng mất
- Nếu cần lưu persistent, phải lưu vào database

## API Endpoints

### Thêm vào giỏ
```
POST /Adaptive_Elearning/cart?action=add
Body: courseId={courseId}
Response: {
  "success": true|false,
  "message": "...",
  "cartCount": 3,
  "cartItem": {...}
}
```

### Xóa khỏi giỏ
```
POST /Adaptive_Elearning/cart?action=remove
Body: courseId={courseId}
Response: {
  "success": true|false,
  "message": "...",
  "cartCount": 2
}
```

### Xóa tất cả
```
POST /Adaptive_Elearning/cart?action=clear
Response: {
  "success": true|false,
  "message": "...",
  "cartCount": 0
}
```

### Lấy số lượng
```
GET /Adaptive_Elearning/cart?action=count
Response: {
  "success": true,
  "cartCount": 3
}
```

### Xem giỏ hàng
```
GET /Adaptive_Elearning/cart
Response: cart.jsp page
```

## Các cải tiến có thể thực hiện

1. **Lưu giỏ hàng vào database** - Persistent cart
2. **Thêm quantity cho mỗi item** - Hiện tại mặc định là 1
3. **Tính năng wishlist** - Danh sách yêu thích
4. **Coupon/Voucher** - Mã giảm giá
5. **Checkout process** - Quy trình thanh toán hoàn chỉnh
6. **Email notification** - Gửi email khi thanh toán
7. **Payment gateway integration** - Tích hợp cổng thanh toán

## Troubleshooting

### Lỗi: Cart badge không hiển thị
- Kiểm tra session có null không
- Xem console browser có lỗi JavaScript không
- Đảm bảo API /cart?action=count trả về đúng format JSON

### Lỗi: Không thêm được vào giỏ
- Kiểm tra courseId có hợp lệ không
- Xem log server có exception không
- Đảm bảo database connection OK

### Lỗi: 404 Not Found khi truy cập /cart
- Kiểm tra CartServlet đã được compile chưa
- Xem @WebServlet annotation có đúng không
- Rebuild project và redeploy

## Support
Nếu có vấn đề, kiểm tra:
1. Server logs (catalina.out hoặc localhost.log)
2. Browser console (F12)
3. Network tab để xem API response
4. Database có dữ liệu khóa học không

---
**Ngày tạo:** 2024-10-25
**Version:** 1.0
