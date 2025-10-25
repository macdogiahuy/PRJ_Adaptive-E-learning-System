<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cài đặt tài khoản</title>
    <!-- Giả sử bạn đã có Bootstrap -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .settings-container {
            margin-top: 50px;
        }
        .nav-pills .nav-link.active {
            background-color: #0d6efd;
        }
        .nav-pills .nav-link {
            color: #495057;
        }
        .card {
            border: none;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>

    <!-- Giả sử có một thanh điều hướng chung (navbar) ở đây -->
    
    <div class="container settings-container">
        <div class="row">
            <div class="col-md-3">
                <div class="card">
                    <div class="card-body">
                        <h4 class="card-title">Cài đặt</h4>
                        <div class="nav flex-column nav-pills" id="v-pills-tab" role="tablist" aria-orientation="vertical">
                            <a class="nav-link active" id="v-pills-account-tab" data-bs-toggle="pill" href="#v-pills-account" role="tab" aria-controls="v-pills-account" aria-selected="true">Tài khoản</a>
                            <a class="nav-link" id="v-pills-security-tab" data-bs-toggle="pill" href="#v-pills-security" role="tab" aria-controls="v-pills-security" aria-selected="false">Bảo mật</a>
                            <a class="nav-link" id="v-pills-notifications-tab" data-bs-toggle="pill" href="#v-pills-notifications" role="tab" aria-controls="v-pills-notifications" aria-selected="false">Thông báo</a>
                            <a class="nav-link" id="v-pills-billing-tab" data-bs-toggle="pill" href="#v-pills-billing" role="tab" aria-controls="v-pills-billing" aria-selected="false">Thanh toán</a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-9">
                <div class="card">
                    <div class="card-body">
                        <div class="tab-content" id="v-pills-tabContent">
                            
                            <!-- Tab 1: Cài đặt tài khoản -->
                            <div class="tab-pane fade show active" id="v-pills-account" role="tabpanel" aria-labelledby="v-pills-account-tab">
                                <h5>Thông tin cá nhân</h5>
                                <hr>
                                <form action="settings" method="post">
                                    <input type="hidden" name="action" value="updateProfile">
                                    <div class="mb-3">
                                        <label for="email" class="form-label">Địa chỉ Email</label>
                                        <input type="email" class="form-control" id="email" value="${user.email}" disabled>
                                        <div class="form-text">Bạn không thể thay đổi email tại đây.</div>
                                    </div>
                                    <div class="mb-3">
                                        <label for="fullName" class="form-label">Họ và tên</label>
                                        <input type="text" class="form-control" id="fullName" name="fullName" value="${user.fullName}">
                                    </div>
                                    <div class="mb-3">
                                        <label for="phoneNumber" class="form-label">Số điện thoại</label>
                                        <input type="text" class="form-control" id="phoneNumber" name="phoneNumber" value="${user.phoneNumber}">
                                    </div>
                                    <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                                </form>
                            </div>

                            <!-- Tab 2: Cài đặt bảo mật -->
                            <div class="tab-pane fade" id="v-pills-security" role="tabpanel" aria-labelledby="v-pills-security-tab">
                                <h5>Bảo mật</h5>
                                <hr>
                                <form action="settings" method="post">
                                     <input type="hidden" name="action" value="changePassword">
                                    <div class="mb-3">
                                        <label for="currentPassword" class="form-label">Mật khẩu hiện tại</label>
                                        <input type="password" class="form-control" id="currentPassword" name="currentPassword">
                                    </div>
                                    <div class="mb-3">
                                        <label for="newPassword" class="form-label">Mật khẩu mới</label>
                                        <input type="password" class="form-control" id="newPassword" name="newPassword">
                                    </div>
                                    <div class="mb-3">
                                        <label for="confirmPassword" class="form-label">Xác nhận mật khẩu mới</label>
                                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword">
                                    </div>
                                    <button type="submit" class="btn btn-primary">Đổi mật khẩu</button>
                                </form>
                                <hr>
                                <h5>Xóa tài khoản</h5>
                                <p>Hành động này không thể hoàn tác. Tất cả dữ liệu của bạn sẽ bị xóa vĩnh viễn.</p>
                                <button class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#deleteAccountModal">Xóa tài khoản của tôi</button>
                            </div>

                            <!-- Tab 3: Cài đặt thông báo -->
                            <div class="tab-pane fade" id="v-pills-notifications" role="tabpanel" aria-labelledby="v-pills-notifications-tab">
                                <h5>Cài đặt thông báo</h5>
                                <hr>
                                <form action="settings" method="post">
                                    <input type="hidden" name="action" value="updateNotifications">
                                    <div class="form-check form-switch mb-3">
                                        <input class="form-check-input" type="checkbox" id="emailNotifyNewCourse" name="emailNotifyNewCourse" checked>
                                        <label class="form-check-label" for="emailNotifyNewCourse">Nhận email khi có khóa học mới</label>
                                    </div>
                                    <div class="form-check form-switch mb-3">
                                        <input class="form-check-input" type="checkbox" id="emailNotifyDeadline" name="emailNotifyDeadline" checked>
                                        <label class="form-check-label" for="emailNotifyDeadline">Nhận email nhắc nhở hạn nộp bài</label>
                                    </div>
                                    <div class="form-check form-switch mb-3">
                                        <input class="form-check-input" type="checkbox" id="emailNotifyReply" name="emailNotifyReply">
                                        <label class="form-check-label" for="emailNotifyReply">Nhận email khi có người trả lời bình luận</label>
                                    </div>
                                    <button type="submit" class="btn btn-primary">Lưu cài đặt</button>
                                </form>
                            </div>

                            <!-- Tab 4: Cài đặt thanh toán -->
                            <div class="tab-pane fade" id="v-pills-billing" role="tabpanel" aria-labelledby="v-pills-billing-tab">
                                <h5>Lịch sử thanh toán</h5>
                                <hr>
                                <p>Xem lại tất cả các giao dịch của bạn.</p>
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Khóa học</th>
                                            <th>Ngày mua</th>
                                            <th>Số tiền</th>
                                            <th>Hóa đơn</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <!-- Dữ liệu lịch sử sẽ được lặp ở đây, ví dụ: -->
                                        <tr>
                                            <td>Khóa học Lập trình Java nâng cao</td>
                                            <td>20/10/2025</td>
                                            <td>500,000đ</td>
                                            <td><a href="#">Xem</a></td>
                                        </tr>
                                        <tr>
                                            <td>Khóa học Thiết kế Web cơ bản</td>
                                            <td>15/09/2025</td>
                                            <td>350,000đ</td>
                                            <td><a href="#">Xem</a></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal xác nhận xóa tài khoản -->
    <div class="modal fade" id="deleteAccountModal" tabindex="-1" aria-labelledby="deleteAccountModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="deleteAccountModalLabel">Xác nhận xóa tài khoản</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            Bạn có chắc chắn muốn xóa tài khoản của mình không? Hành động này là vĩnh viễn và không thể hoàn tác.
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
            <form action="settings" method="post" style="display: inline;">
                <input type="hidden" name="action" value="deleteAccount">
                <button type="submit" class="btn btn-danger">Tôi chắc chắn</button>
            </form>
          </div>
        </div>
      </div>
    </div>


    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
