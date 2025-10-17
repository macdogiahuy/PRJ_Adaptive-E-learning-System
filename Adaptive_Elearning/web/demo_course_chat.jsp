<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="controller.ChatController" %>
<%@ page import="model.Conversations" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Demo Auto-Join Course Group Chat</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        
        .demo-container {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        h1 {
            color: #2c3e50;
            text-align: center;
            margin-bottom: 30px;
        }
        
        .demo-section {
            margin-bottom: 30px;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            background-color: #f8f9fa;
        }
        
        .demo-section h3 {
            color: #34495e;
            margin-top: 0;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }
        
        input[type="text"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        
        button {
            background-color: #3498db;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            margin-right: 10px;
        }
        
        button:hover {
            background-color: #2980b9;
        }
        
        .success {
            background-color: #d4edda;
            color: #155724;
            padding: 10px;
            border: 1px solid #c3e6cb;
            border-radius: 5px;
            margin: 10px 0;
        }
        
        .error {
            background-color: #f8d7da;
            color: #721c24;
            padding: 10px;
            border: 1px solid #f5c6cb;
            border-radius: 5px;
            margin: 10px 0;
        }
        
        .info {
            background-color: #d1ecf1;
            color: #0c5460;
            padding: 10px;
            border: 1px solid #bee5eb;
            border-radius: 5px;
            margin: 10px 0;
        }
        
        .sample-data {
            background-color: #e9ecef;
            padding: 15px;
            border-radius: 5px;
            margin: 10px 0;
            font-family: monospace;
            font-size: 12px;
        }
        
        .navigation {
            text-align: center;
            margin-top: 30px;
        }
        
        .navigation a {
            background-color: #27ae60;
            color: white;
            text-decoration: none;
            padding: 12px 25px;
            border-radius: 5px;
            font-weight: bold;
        }
        
        .navigation a:hover {
            background-color: #229954;
        }
    </style>
</head>
<body>
    <div class="demo-container">
        <h1>🎓 Demo Auto-Join Course Group Chat</h1>
        
        <div class="info">
            <strong>Mô tả chức năng:</strong> Khi một user đăng ký (enroll) vào một khóa học, hệ thống sẽ tự động:
            <ul>
                <li>Tạo group chat cho khóa học đó (nếu chưa có)</li>
                <li>Thêm user vào group chat</li>
                <li>User có thể chat với các học viên khác trong cùng khóa học</li>
            </ul>
        </div>
        
        <!-- Demo Auto-Join Course -->
        <div class="demo-section">
            <h3>🔧 Test Auto-Join Course Group</h3>
            <p>Mô phỏng việc user đăng ký khóa học và được tự động thêm vào group chat</p>
            
            <form method="post" action="">
                <input type="hidden" name="action" value="joinCourse">
                
                <div class="form-group">
                    <label for="userId">User ID:</label>
                    <input type="text" id="userId" name="userId" value="522d2265-0532-4142-8079-0aa7e9c7d3cb" required>
                </div>
                
                <div class="form-group">
                    <label for="courseId">Course ID:</label>
                    <input type="text" id="courseId" name="courseId" value="69746c85-6109-4370-9334-1490cd2334b0" required>
                </div>
                
                <button type="submit">🚀 Đăng ký khóa học & Join Group Chat</button>
            </form>
            
            <div class="sample-data">
                <strong>Sample Data có sẵn trong database:</strong><br>
                User ID: 9f32b3ba-e7c5-4f58-81b8-8096f6f99c79<br>
                Course ID: 550e8400-e29b-41d4-a716-446655440000 (Course demo)
            </div>
        </div>
        
        <!-- Hiển thị kết quả -->
        <%
            String message = null;
            String messageType = "info";
            
            if ("POST".equals(request.getMethod())) {
                String action = request.getParameter("action");
                
                if ("joinCourse".equals(action)) {
                    String userId = request.getParameter("userId");
                    String courseId = request.getParameter("courseId");
                    
                    if (userId != null && courseId != null && !userId.trim().isEmpty() && !courseId.trim().isEmpty()) {
                        try {
                            ChatController chatController = new ChatController();
                            
                            // Mô phỏng việc user enroll vào course và auto-join group chat
                            boolean success = chatController.handleCourseEnrollment(userId.trim(), courseId.trim());
                            
                            if (success) {
                                // Lấy thông tin conversation đã join
                                Conversations conversation = chatController.getCourseConversation(courseId.trim());
                                
                                if (conversation != null) {
                                    message = "✅ Thành công! User đã được thêm vào group chat: " + conversation.getTitle() + 
                                             " (ID: " + conversation.getId() + ")";
                                    messageType = "success";
                                } else {
                                    message = "✅ User đã được thêm vào course group, nhưng không thể lấy thông tin conversation.";
                                    messageType = "success";
                                }
                            } else {
                                message = "❌ Không thể thêm user vào course group. Kiểm tra lại User ID và Course ID.";
                                messageType = "error";
                            }
                            
                        } catch (Exception e) {
                            message = "❌ Lỗi: " + e.getMessage();
                            messageType = "error";
                            e.printStackTrace();
                        }
                    } else {
                        message = "❌ Vui lòng nhập đầy đủ User ID và Course ID.";
                        messageType = "error";
                    }
                }
            }
        %>
        
        <% if (message != null) { %>
            <div class="<%= messageType %>">
                <%= message %>
            </div>
        <% } %>
        
        <!-- Hướng dẫn sử dụng -->
        <div class="demo-section">
            <h3>📖 Hướng dẫn sử dụng</h3>
            <ol>
                <li>Nhập User ID và Course ID vào form trên</li>
                <li>Nhấn "Đăng ký khóa học & Join Group Chat"</li>
                <li>Hệ thống sẽ tự động tạo group chat cho khóa học (nếu chưa có)</li>
                <li>User sẽ được thêm vào group chat</li>
                <li>Sau đó có thể vào trang chat để xem và gửi tin nhắn</li>
            </ol>
        </div>
        
        <!-- Database Info -->
        <div class="demo-section">
            <h3>🗄️ Thông tin Database</h3>
            <p>Hệ thống sử dụng các bảng sau để quản lý chat group:</p>
            <ul>
                <li><strong>Conversations:</strong> Lưu thông tin group chat</li>
                <li><strong>ConversationMembers:</strong> Lưu danh sách members trong group</li>
                <li><strong>ChatMessages:</strong> Lưu tin nhắn</li>
                <li><strong>Users:</strong> Thông tin users</li>
                <li><strong>Courses:</strong> Thông tin khóa học</li>
                <li><strong>Enrollments:</strong> Thông tin đăng ký khóa học</li>
            </ul>
        </div>
        
        <!-- Navigation -->
        <div class="navigation">
            <a href="course_group_chat.jsp?userId=9f32b3ba-e7c5-4f58-81b8-8096f6f99c79">
                🚀 Vào trang Chat Group
            </a>
        </div>
    </div>
</body>
</html>
