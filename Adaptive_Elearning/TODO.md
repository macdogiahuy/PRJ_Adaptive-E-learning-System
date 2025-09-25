# TODO cho Tính năng Reported Course

Dựa trên kế hoạch đã phê duyệt, các bước thực hiện:

- [ ] Bước 1: Tạo file `src/java/dao/ReportedCourseDTO.java` - Class DTO để chứa dữ liệu báo cáo (reporterFullName, courseTitle, message, notificationId).
- [ ] Bước 2: Tạo file `src/java/controller/ReportedCourseServlet.java` - Servlet xử lý lấy dữ liệu từ DB (join Notifications với Users và Courses), set attribute cho JSP, và xử lý action Approve/Dismiss.
- [ ] Bước 3: Cập nhật file `web/WEB-INF/web.xml` - Thêm mapping servlet cho `/reportedcourse`.
- [ ] Bước 4: Cập nhật file `web/WEB-INF/views/admin/reportedcourse.jsp` - Thêm phần main-content với bảng hiển thị dữ liệu sử dụng JSTL, và form cho nút action.
- [ ] Bước 5: (Tùy chọn) Cập nhật `src/java/controller/InsertSampleData.java` - Thêm dữ liệu mẫu cho Notification báo cáo khóa học để test.
- [ ] Bước 6: Build dự án và test tính năng (chạy server, truy cập trang, kiểm tra dữ liệu và action).

Tôi sẽ thực hiện từng bước một cách tuần tự và cập nhật TODO.md sau mỗi bước hoàn thành.
