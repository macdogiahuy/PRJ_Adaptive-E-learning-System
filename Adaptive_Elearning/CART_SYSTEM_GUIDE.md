# Hệ thống Giỏ hàng - EduHub

## Tổng quan
Hệ thống giỏ hàng cho phép người dùng thêm các khóa học vào giỏ hàng và quản lý chúng trước khi thanh toán.

## Cấu trúc dự án

### 1. Models
- **CartItem.java**: Đại diện cho một item trong giỏ hàng
- **Cart.java**: Quản lý collection các CartItem

### 2. Services  
- **CartService.java**: Xử lý logic nghiệp vụ của giỏ hàng

### 3. Servlets
- **CartServlet.java**: Xử lý các HTTP requests:
  - `/cart` - Hiển thị trang giỏ hàng
  - `/add-to-cart` - Thêm khóa học vào giỏ hàng
  - `/remove-from-cart` - Xóa khóa học khỏi giỏ hàng
  - `/cart-count` - Lấy số lượng items trong giỏ hàng

### 4. Views
- **cart.jsp**: Giao diện trang giỏ hàng
- **home.jsp**: Đã được cập nhật với nút "Add to Cart"

## Tính năng chính

### 1. Thêm vào giỏ hàng
- Nút "Thêm vào giỏ" trên mỗi course card
- AJAX request không reload trang
- Hiển thị notification kết quả
- Cập nhật số lượng trong cart icon

### 2. Quản lý giỏ hàng
- Hiển thị danh sách khóa học đã chọn
- Xóa khóa học khỏi giỏ hàng
- Tính tổng tiền và giảm giá
- Tóm tắt đơn hàng

### 3. Session Management
- Lưu trữ giỏ hàng trong session
- Riêng biệt cho mỗi user
- Tự động clear khi logout

## API Endpoints

### POST /add-to-cart
```
Parameters: courseId
Response: JSON
{
  "success": true/false,
  "message": "Thông báo",
  "cartCount": số_lượng_items,
  "redirectLogin": true/false (nếu chưa login)
}
```

### POST /remove-from-cart
```
Parameters: courseId
Response: JSON
{
  "success": true/false,
  "message": "Thông báo", 
  "cartCount": số_lượng_items,
  "totalPrice": tổng_tiền
}
```

### GET /cart-count
```
Response: JSON
{
  "success": true,
  "cartCount": số_lượng_items
}
```

### GET /cart
```
Hiển thị trang giỏ hàng với:
- cart: Cart object
- cartItems: List<CartItem>
- totalPrice: Double
- totalItems: Integer  
- discountAmount: Double
```

## Cách sử dụng

### 1. Thêm khóa học vào giỏ hàng
1. Người dùng xem danh sách khóa học trên trang chủ
2. Click nút "Thêm vào giỏ" trên khóa học mong muốn
3. Hệ thống kiểm tra đăng nhập
4. Nếu đã đăng nhập: thêm vào giỏ hàng và hiển thị thông báo
5. Nếu chưa đăng nhập: yêu cầu đăng nhập

### 2. Xem giỏ hàng
1. Click icon giỏ hàng trên header
2. Xem danh sách khóa học đã thêm
3. Kiểm tra tổng tiền và giảm giá

### 3. Quản lý giỏ hàng
1. Xóa khóa học không muốn mua
2. Xem tóm tắt đơn hàng
3. Tiến hành thanh toán (chức năng sẽ được phát triển)

## Cài đặt và chạy

### 1. Cấu hình Database
Đảm bảo các bảng sau có trong database:
- `courses` - Thông tin khóa học
- `users` - Thông tin người dùng

### 2. Deploy
1. Build project với Maven
2. Deploy WAR file lên Tomcat
3. Truy cập `http://localhost:8080/Adaptive_Elearning/home`

### 3. Test chức năng
1. Đăng nhập với tài khoản hợp lệ
2. Thêm khóa học vào giỏ hàng
3. Kiểm tra icon giỏ hàng cập nhật số lượng
4. Truy cập trang giỏ hàng
5. Test xóa khóa học

## Lưu ý kỹ thuật

### 1. Session Storage
- Giỏ hàng được lưu trong session với key "userCart"
- Mỗi user có giỏ hàng riêng biệt
- Session timeout sẽ clear giỏ hàng

### 2. AJAX Requests
- Sử dụng Fetch API cho các request
- Content-Type: application/x-www-form-urlencoded
- Response format: JSON

### 3. Error Handling
- Kiểm tra đăng nhập trước khi thao tác
- Validate courseId tồn tại
- Hiển thị thông báo lỗi thân thiện

### 4. UI/UX
- Loading states cho buttons
- Notification system
- Responsive design
- Animation effects

## Phát triển tương lai

1. **Thanh toán**:
   - Tích hợp payment gateway
   - Tạo orders và enrollments
   - Email xác nhận

2. **Wishlist**:
   - Danh sách yêu thích
   - So sánh khóa học

3. **Coupons**:
   - Mã giảm giá
   - Khuyến mãi

4. **Recommendations**:
   - Gợi ý khóa học liên quan
   - AI recommendations

## Support
Liên hệ team development để được hỗ trợ thêm về hệ thống giỏ hàng.