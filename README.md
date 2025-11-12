# Adaptive Elearning Dashboard

Đây là dự án dashboard cho hệ thống học tập thích ứng được xây dựng bằng JSP/Servlet.

## 🚀 Tính năng

- **Dashboard hiện đại** với giao diện responsive
- **Sidebar navigation** với menu đầy đủ
- **Card widgets** hiển thị thống kê (Users, Notifications, Courses, Learning Groups)
- **Chart section** với biểu đồ thống kê
- **Responsive design** tương thích với mobile và desktop

## 📁 Cấu trúc dự án

```
Adaptive_Elearning/
├── src/java/
│   ├── controller/
│   │   └── DashboardServlet.java      # Servlet xử lý dashboard
│   └── model/
│       └── DashboardData.java         # Model chứa dữ liệu dashboard
├── web/
│   ├── index.jsp                      # Trang chủ (login)
│   ├── WEB-INF/
│   │   ├── web.xml                    # Cấu hình servlet
│   │   └── views/
│   │       └── dashboard.jsp          # Giao diện dashboard chính
│   └── assets/
│       ├── css/
│       │   └── dashboard.css          # Styling cho dashboard
│       └── js/
│           └── dashboard.js           # JavaScript tương tác
```

## 🛠️ Cài đặt và Chạy

### 1. Import vào NetBeans
1. Mở NetBeans IDE
2. Chọn **File > Open Project**
3. Chọn thư mục `Adaptive_Elearning`
4. Project sẽ được import tự động

### 2. Thêm Servlet Libraries
1. Right-click vào project **Adaptive_Elearning**
2. Chọn **Properties**
3. Vào tab **Libraries**
4. Click **Add Library**
5. Chọn **Java EE Web 8** hoặc **Jakarta EE Web**
6. Click **Add Library**

### 3. Deploy và Run
1. Right-click vào project
2. Chọn **Run**
3. Project sẽ được build và deploy lên Tomcat
4. Truy cập: `http://localhost:8080/Adaptive_Elearning/`

## 🌐 Truy cập

- **Trang chủ**: `http://localhost:8080/Adaptive_Elearning/`
- **Dashboard**: `http://localhost:8080/Adaptive_Elearning/dashboard`

## 📱 Demo Mode

Project chạy ở chế độ demo với:
- User: `demo_user`
- Role: `admin`
- Dữ liệu mẫu được tạo tự động

## 🎨 Tính năng giao diện

### Sidebar Menu
- Dashboard (active)
- Users
- Notifications
- Create Admin
- Courses
- Learning Groups
- Statistical Chart
- Data Values
- Users
- Learner View
- Sign Out

### Dashboard Widgets
- **Users Card**: Hiển thị tổng số người dùng
- **Notifications Card**: Hiển thị số thông báo
- **Create Admin Card**: Chức năng tạo admin
- **Courses Card**: Hiển thị số khóa học
- **Learning Groups Card**: Hiển thị số nhóm học tập
- **Statistical Chart**: Biểu đồ thống kê

### Responsive Design
- Tương thích với desktop, tablet, mobile
- Menu responsive khi thu nhỏ màn hình
- Layout tự động điều chỉnh

## 🛠️ Công nghệ sử dụng

- **Backend**: JSP/Servlet
- **Frontend**: HTML5, CSS3, JavaScript
- **Icons**: Font Awesome 6
- **Server**: Apache Tomcat
- **IDE**: NetBeans

## 📝 Ghi chú

- Project cần servlet libraries để compile
- Chạy trên Tomcat server
- Tương thích với Java EE 8 hoặc Jakarta EE

## 🔧 Troubleshooting

### Lỗi "jakarta.servlet cannot be resolved"
1. Vào Project Properties
2. Chọn Libraries tab
3. Thêm Java EE Web library
4. Clean và Build lại project

### Lỗi 404 khi truy cập dashboard
1. Kiểm tra web.xml có servlet mapping không
2. Đảm bảo DashboardServlet được compile
3. Restart Tomcat server

## 📞 Hỗ trợ

Nếu gặp vấn đề khi setup hoặc chạy project, hãy kiểm tra:
1. Servlet libraries đã được thêm chưa
2. Tomcat server đang chạy
3. Port 8080 không bị chiếm dụng
