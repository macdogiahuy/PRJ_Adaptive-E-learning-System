<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="controller.ChatController" %>
<%@ page import="model.Conversations" %>
<%@ page import="model.ChatMessages" %>
<%@ page import="model.Users" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chat Nhóm Khóa Học</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
        }
        
        .chat-container {
            display: flex;
            height: 100vh;
        }
        
        .sidebar {
            width: 300px;
            background-color: #2c3e50;
            color: white;
            overflow-y: auto;
        }
        
        .sidebar-header {
            padding: 20px;
            background-color: #34495e;
            border-bottom: 1px solid #4a5f7a;
        }
        
        .conversation-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .conversation-item {
            padding: 15px 20px;
            border-bottom: 1px solid #34495e;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        
        .conversation-item:hover {
            background-color: #34495e;
        }
        
        .conversation-item.active {
            background-color: #3498db;
        }
        
        .conversation-title {
            font-weight: bold;
            margin-bottom: 5px;
        }
        
        .conversation-preview {
            font-size: 12px;
            color: #bdc3c7;
        }
        
        .chat-main {
            flex: 1;
            display: flex;
            flex-direction: column;
            background-color: white;
        }
        
        .chat-header {
            padding: 20px;
            background-color: #ecf0f1;
            border-bottom: 1px solid #ddd;
            display: flex;
            align-items: center;
        }
        
        .chat-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            margin-right: 15px;
            background-color: #3498db;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
        }
        
        .chat-info h3 {
            margin: 0;
            color: #2c3e50;
        }
        
        .chat-info .member-count {
            font-size: 12px;
            color: #7f8c8d;
        }
        
        .messages-container {
            flex: 1;
            overflow-y: auto;
            padding: 20px;
            background-color: #f8f9fa;
        }
        
        .message {
            margin-bottom: 15px;
            display: flex;
            align-items: flex-start;
        }
        
        .message.own {
            flex-direction: row-reverse;
        }
        
        .message-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            margin: 0 10px;
            background-color: #3498db;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 12px;
            font-weight: bold;
        }
        
        .message-content {
            max-width: 60%;
            background-color: white;
            padding: 10px 15px;
            border-radius: 15px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .message.own .message-content {
            background-color: #3498db;
            color: white;
        }
        
        .message-header {
            font-size: 12px;
            color: #7f8c8d;
            margin-bottom: 5px;
        }
        
        .message.own .message-header {
            color: #ecf0f1;
        }
        
        .message-text {
            word-wrap: break-word;
        }
        
        .chat-input {
            padding: 20px;
            background-color: white;
            border-top: 1px solid #ddd;
            display: flex;
            align-items: center;
        }
        
        .chat-input input {
            flex: 1;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 25px;
            outline: none;
            font-size: 14px;
        }
        
        .chat-input button {
            margin-left: 10px;
            padding: 12px 20px;
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-weight: bold;
        }
        
        .chat-input button:hover {
            background-color: #2980b9;
        }
        
        .no-conversation {
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100%;
            color: #7f8c8d;
            font-size: 18px;
        }
        
        .loading {
            text-align: center;
            padding: 20px;
            color: #7f8c8d;
        }
        
        .error {
            background-color: #e74c3c;
            color: white;
            padding: 10px;
            margin: 10px;
            border-radius: 5px;
        }
        
        .success {
            background-color: #27ae60;
            color: white;
            padding: 10px;
            margin: 10px;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <%
        // Lấy parameters từ request
        String currentUserId = request.getParameter("userId");
        String currentConversationId = request.getParameter("conversationId");
        
        if (currentUserId == null) {
            currentUserId = "9f32b3ba-e7c5-4f58-81b8-8096f6f99c79"; // Default user ID cho demo
        }
        
        ChatController chatController = new ChatController();
        List<Conversations> userConversations = null;
        Conversations currentConversation = null;
        List<ChatMessages> messages = null;
        List<Users> members = null;
        String errorMessage = null;
        
        try {
            // Lấy danh sách conversations của user
            userConversations = chatController.getUserCourseGroups(currentUserId);
            
            // Nếu có conversationId được chọn
            if (currentConversationId != null && !currentConversationId.isEmpty()) {
                currentConversation = chatController.getConversationInfo(currentConversationId);
                if (currentConversation != null) {
                    messages = chatController.getMessageHistory(currentConversationId, 50);
                    members = chatController.getConversationMembers(currentConversationId);
                }
            }
            
        } catch (Exception e) {
            errorMessage = "Lỗi khi tải dữ liệu: " + e.getMessage();
            e.printStackTrace();
        }
    %>

    <div class="chat-container">
        <!-- Sidebar - Danh sách conversations -->
        <div class="sidebar">
            <div class="sidebar-header">
                <h3>Chat Nhóm Khóa Học</h3>
                <p>Người dùng hiện tại: <%= currentUserId %></p>
            </div>
            
            <% if (errorMessage != null) { %>
                <div class="error"><%= errorMessage %></div>
            <% } %>
            
            <ul class="conversation-list">
                <% if (userConversations != null && !userConversations.isEmpty()) { %>
                    <% for (Conversations conv : userConversations) { %>
                        <li class="conversation-item <%= (currentConversationId != null && currentConversationId.equals(conv.getId())) ? "active" : "" %>"
                            onclick="selectConversation('<%= conv.getId() %>')">
                            <div class="conversation-title"><%= conv.getTitle() %></div>
                            <div class="conversation-preview">Nhấp để xem tin nhắn</div>
                        </li>
                    <% } %>
                <% } else { %>
                    <li class="conversation-item">
                        <div class="conversation-title">Không có nhóm chat nào</div>
                        <div class="conversation-preview">Đăng ký khóa học để tham gia chat nhóm</div>
                    </li>
                <% } %>
            </ul>
        </div>
        
        <!-- Main chat area -->
        <div class="chat-main">
            <% if (currentConversation != null) { %>
                <!-- Chat header -->
                <div class="chat-header">
                    <div class="chat-avatar">
                        <%= currentConversation.getTitle().substring(0, 1).toUpperCase() %>
                    </div>
                    <div class="chat-info">
                        <h3><%= currentConversation.getTitle() %></h3>
                        <div class="member-count">
                            <%= (members != null) ? members.size() + " thành viên" : "Đang tải..." %>
                        </div>
                    </div>
                </div>
                
                <!-- Messages container -->
                <div class="messages-container" id="messagesContainer">
                    <% if (messages != null && !messages.isEmpty()) { %>
                        <% for (ChatMessages msg : messages) { %>
                            <% 
                                String senderId = "";
                                String senderName = "Unknown";
                                if (msg.getCreatorId() != null) {
                                    if (msg.getCreatorId().getId() != null) {
                                        senderId = msg.getCreatorId().getId();
                                        senderName = msg.getCreatorId().getFullName() != null ? 
                                                   msg.getCreatorId().getFullName() : 
                                                   msg.getCreatorId().getUserName();
                                    }
                                }
                            %>
                            <div class="message <%= senderId.equals(currentUserId) ? "own" : "" %>">
                                <div class="message-avatar">
                                    <%= senderId.length() >= 2 ? senderId.substring(0, 2).toUpperCase() : "?" %>
                                </div>
                                <div class="message-content">
                                    <div class="message-header">
                                        <%= senderName %>
                                        • <%= msg.getCreationTime() %>
                                    </div>
                                    <div class="message-text"><%= msg.getContent() %></div>
                                </div>
                            </div>
                        <% } %>
                    <% } else { %>
                        <div class="loading">Chưa có tin nhắn nào trong nhóm này</div>
                    <% } %>
                </div>
                
                <!-- Chat input -->
                <div class="chat-input">
                    <form method="post" action="course_group_chat.jsp" style="display: flex; width: 100%;">
                        <input type="hidden" name="action" value="sendMessage">
                        <input type="hidden" name="userId" value="<%= currentUserId %>">
                        <input type="hidden" name="conversationId" value="<%= currentConversationId %>">
                        <input type="text" name="content" placeholder="Nhập tin nhắn..." required>
                        <button type="submit">Gửi</button>
                    </form>
                </div>
                
            <% } else { %>
                <div class="no-conversation">
                    <div>
                        <h3>Chọn một nhóm chat để bắt đầu trò chuyện</h3>
                        <p>Đăng ký khóa học để được tự động thêm vào nhóm chat của khóa học đó</p>
                    </div>
                </div>
            <% } %>
        </div>
    </div>

    <%
        // Xử lý POST request để gửi tin nhắn
        if ("POST".equals(request.getMethod())) {
            String action = request.getParameter("action");
            
            if ("sendMessage".equals(action)) {
                String senderId = request.getParameter("userId");
                String conversationId = request.getParameter("conversationId");
                String content = request.getParameter("content");
                
                if (senderId != null && conversationId != null && content != null && !content.trim().isEmpty()) {
                    try {
                        ChatMessages sentMessage = chatController.sendMessage(conversationId, senderId, content.trim());
                        if (sentMessage != null) {
                            // Reload trang để hiển thị tin nhắn mới
                            response.sendRedirect("course_group_chat.jsp?userId=" + senderId + "&conversationId=" + conversationId);
                            return;
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    %>

    <script>
        function selectConversation(conversationId) {
            const currentUserId = '<%= currentUserId %>';
            window.location.href = 'course_group_chat.jsp?userId=' + currentUserId + '&conversationId=' + conversationId;
        }
        
        // Auto-scroll to bottom of messages
        const messagesContainer = document.getElementById('messagesContainer');
        if (messagesContainer) {
            messagesContainer.scrollTop = messagesContainer.scrollHeight;
        }
        
        // Auto-refresh mỗi 10 giây để cập nhật tin nhắn mới (demo purpose)
        const currentConversationId = '<%= currentConversationId != null ? currentConversationId : "" %>';
        if (currentConversationId && currentConversationId !== '') {
            setTimeout(function() {
                window.location.reload();
            }, 10000);
        }
    </script>
</body>
</html>