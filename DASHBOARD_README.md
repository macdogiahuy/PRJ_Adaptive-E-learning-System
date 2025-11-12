# CourseHub E-Learning Dashboard - CLEAN VERSION ✅

## Tổng quan
Dashboard thống kê cho hệ thống Adaptive E-learning với dữ liệu thật từ CourseHubDB database.
Code đã được dọn dẹp và tối ưu, chỉ giữ lại những file cần thiết.

## 🎯 DASHBOARD CLEAN ARCHITECTURE  

### ✅ Files chính (đã dọn dẹp):
- `src/java/controller/DashboardController.java` - Controller xử lý toàn bộ logic dashboard
- `src/java/dao/DBConnection.java` - Kết nối database CourseHubDB  
- `web/WEB-INF/views/admin/dashboard.jsp` - Dashboard chính với dữ liệu thật
- `web/admin_dashboard.jsp` - Entry point redirect
- `web/index.jsp` - Trang chủ điều hướng
- `web/error.jsp` - Trang báo lỗi
- `web/WEB-INF/web.xml` - Cấu hình web app

### ✅ Features hoàn thành (Clean Version):

1. **Thống kê tổng quan** - Realtime data từ CourseHubDB
   - 37 Users, 45 Courses, 5 Enrollments, 15 Notifications
   - Dữ liệu thật từ database CourseHubDB  
   - Tổng số Enrollments
   - Tổng số Notifications

2. **Biểu đồ theo thời gian**
   - Users đăng ký theo ngày (30 ngày gần nhất)
   - Enrollments theo tháng (năm hiện tại)
   - Courses tạo mới theo năm (5 năm gần nhất)

3. **Biểu đồ phân tích**
   - Top 5 Courses phổ biến nhất
   - Phân bố Notifications theo trạng thái

## 🏗️ Cấu trúc dự án (ĐÃ DỌN DẸP)

```
src/java/
├── controller/
│   └── DashboardController.java       # Controller điều khiển dashboard  
├── servlet/
│   └── DashboardAPIServlet.java       # API servlet (Jakarta)
└── dao/
    └── DBConnection.java              # Kết nối CourseHubDB

web/
├── index.html                         # Trang chủ demo
├── dashboard.jsp                      # Dashboard chính với dữ liệu thật
└── api/
    └── dashboard.jsp                  # API endpoint JSON
```

## 🎯 **DASHBOARD ĐÃ HOẠT ĐỘNG:**

✅ **Kết nối CourseHubDB thành công!** Dữ liệu thật từ database: 2025-09-27 22:44:57
- **37 Users** - Dữ liệu thật từ bảng Users
- **45 Courses** - Dữ liệu thật từ bảng Courses  
- **5 Enrollments** - Dữ liệu thật từ bảng Enrollments
- **15 Notifications** - Dữ liệu thật từ bảng Notifications

## 🚀 **Cách sử dụng:**

1. **Start NetBeans project**
2. **Truy cập:** `http://localhost:8080/Adaptive_Elearning/`
3. **Dashboard tự động load dữ liệu thật từ CourseHubDB**
4. **Nếu lỗi database sẽ hiển thị thông báo lỗi chi tiết**

## 🚀 Hướng dẫn sử dụng

### 1. Thiết lập Database
Đảm bảo database connection trong `DBConnection.java` đã đúng:
- Database name: `CourseHubData` 
- Server: `localhost:1433`
- Username/Password đã được cấu hình

### 2. Chạy Dashboard

#### Phương án 1: Sử dụng JSP trực tiếp (Khuyến nghị)
```
http://localhost:8080/Adaptive_Elearning/admin_dashboard.jsp
```

#### Phương án 2: Thông qua controller (cần implement servlet)
```
http://localhost:8080/Adaptive_Elearning/admin_dashboard.jsp
```

### 3. Tính năng chính

- **Tự động refresh**: Dữ liệu tự động cập nhật mỗi 5 phút
- **Responsive design**: Tương thích mobile và desktop
- **Interactive charts**: Sử dụng Chart.js cho biểu đồ đẹp
- **Real-time data**: Dữ liệu thực từ database qua JDBC

## 🛠️ Công nghệ sử dụng

- **Backend**: Java, JSP, JDBC
- **Frontend**: HTML5, CSS3, JavaScript, Bootstrap 5
- **Charts**: Chart.js
- **Icons**: Font Awesome
- **Database**: SQL Server

## 📈 Các loại biểu đồ

1. **Line Chart**: Users theo ngày, Courses theo năm
2. **Bar Chart**: Enrollments theo tháng
3. **Doughnut Chart**: Top Courses
4. **Pie Chart**: Notifications status

## 🔧 Tùy chỉnh

### Thêm loại thống kê mới:

1. **Thêm method trong DashboardService**:
```java
public Map<String, Object> getNewStatistics() {
    // Implementation
}
```

2. **Thêm method trong DashboardController**:
```java
public Map<String, Object> getNewData() {
    return dashboardService.getNewStatistics();
}
```

3. **Thêm chart trong JSP**:
```javascript
function createNewChart(data) {
    // Chart implementation
}
```

### Thay đổi màu sắc biểu đồ:
Sửa đổi các màu trong CSS và JavaScript:
```css
.stats-card.custom {
    background: linear-gradient(135deg, #your-color1, #your-color2);
}
```

## 🔍 Troubleshooting

### Lỗi kết nối database:
1. Kiểm tra SQL Server đang chạy
2. Xác nhận database name chính xác
3. Kiểm tra username/password

### Charts không hiển thị:
1. Đảm bảo internet connection (CDN Chart.js)
2. Kiểm tra console log để xem lỗi JavaScript
3. Verify dữ liệu từ database không null

### Performance issues:
1. Thêm index cho các trường Date trong database
2. Sử dụng pagination cho large datasets
3. Cache kết quả thống kê

## 📞 Hỗ trợ

Nếu gặp vấn đề, hãy kiểm tra:
1. Database connection
2. Browser console errors
3. Server logs
4. Database có dữ liệu mẫu

## 🎯 Tính năng tương lai

- [ ] Export biểu đồ sang PDF/PNG
- [ ] Real-time updates với WebSocket
- [ ] More chart types (Radar, Scatter)
- [ ] Date range picker
- [ ] Advanced filtering
- [ ] Mobile app integration