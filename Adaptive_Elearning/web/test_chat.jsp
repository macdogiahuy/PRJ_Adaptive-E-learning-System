<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="controller.ChatController" %>
<%@ page import="model.Conversations" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Chat Controller</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .test-section {
            background-color: white;
            padding: 20px;
            margin: 10px 0;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .success { color: green; }
        .error { color: red; }
        .info { color: blue; }
    </style>
</head>
<body>
    <h1>🧪 Test Chat Controller</h1>

    <%
        String testUserId = "9f32b3ba-e7c5-4f58-81b8-8096f6f99c79";
        StringBuilder testResults = new StringBuilder();
        boolean hasError = false;
        
        try {
            testResults.append("<div class='test-section'>");
            testResults.append("<h3>Test 1: Tạo ChatController</h3>");
            
            ChatController chatController = new ChatController();
            testResults.append("<div class='success'>✅ ChatController tạo thành công</div>");
            
            testResults.append("<h3>Test 2: Lấy danh sách conversations</h3>");
            List<Conversations> conversations = chatController.getUserCourseGroups(testUserId);
            
            if (conversations != null) {
                testResults.append("<div class='success'>✅ Lấy conversations thành công: " + conversations.size() + " group(s)</div>");
                
                for (Conversations conv : conversations) {
                    testResults.append("<div class='info'>📝 Conversation: " + conv.getTitle() + " (ID: " + conv.getId() + ")</div>");
                }
            } else {
                testResults.append("<div class='error'>❌ Không thể lấy conversations</div>");
            }
            
            testResults.append("</div>");
            
        } catch (Exception e) {
            hasError = true;
            testResults.append("<div class='test-section'>");
            testResults.append("<div class='error'>❌ Lỗi: " + e.getMessage() + "</div>");
            testResults.append("<div class='error'>Stack trace: " + e.getClass().getName() + "</div>");
            testResults.append("</div>");
            e.printStackTrace();
        }
    %>

    <%= testResults.toString() %>

    <% if (!hasError) { %>
        <div class="test-section">
            <h3>🚀 Tất cả test đã pass!</h3>
            <p><a href="course_group_chat.jsp?userId=<%= testUserId %>">Chuyển đến trang chat chính</a></p>
        </div>
    <% } %>

    <div class="test-section">
        <h3>🔧 Debug Info</h3>
        <p><strong>Test User ID:</strong> <%= testUserId %></p>
        <p><strong>Current Time:</strong> <%= new java.util.Date() %></p>
        <p><strong>Context Path:</strong> <%= request.getContextPath() %></p>
    </div>

</body>
</html>
