<%-- 
    Document   : aichatbot_advice.jsp
    Created on : Nov 14, 2025, 6:42:31 PM
    Author     : LP
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tư Vấn Khóa Học Với AI - CourseHub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ai-chatbot.css">
</head>
<body>
    <!-- Back Button -->
    <a href="${pageContext.request.contextPath}/home" class="back-to-home-btn">
        <span class="back-icon">←</span>
        <span>Quay lại trang chủ</span>
    </a>

    <!-- Header Section -->
    <div class="chatbot-header">
        <h1>
            <span class="ai-icon">🤖</span>
            Tư Vấn Khóa Học Với AI
        </h1>
        <p>Trợ lý thông minh giúp bạn tìm khóa học phù hợp nhất</p>
    </div>

    <!-- Main Chat Container -->
    <div class="chat-container">
        <!-- Chat Header -->
        <div class="chat-header">
            <div class="chat-header-avatar">🎓</div>
            <div class="chat-header-info">
                <h2>AI Course Advisor</h2>
                <div class="chat-header-status">
                    <span class="status-dot"></span>
                    <span>Đang hoạt động</span>
                </div>
            </div>
        </div>

        <!-- Messages Area -->
        <div class="chat-messages" id="chat-messages">
            <!-- Welcome Message -->
            <div class="welcome-message" id="welcome-message">
                <div class="robot-icon">🤖</div>
                <h3>Xin chào! Tôi là trợ lý AI của CourseHub</h3>
                <p>Tôi có thể giúp bạn:</p>
                <ul style="text-align: left; display: inline-block; margin-top: 15px; line-height: 1.8;">
                    <li>Tư vấn khóa học phù hợp với mục tiêu của bạn</li>
                    <li>Giải đáp thắc mắc về nội dung khóa học</li>
                    <li>Đề xuất lộ trình học tập cá nhân hóa</li>
                    <li>Cung cấp thông tin về giảng viên và chứng chỉ</li>
                </ul>
                
                <div class="suggestion-chips">
                    <div class="suggestion-chip">Giới thiệu khóa học Java Backend</div>
                    <div class="suggestion-chip">Khóa học nào phù hợp cho người mới bắt đầu?</div>
                    <div class="suggestion-chip">Lộ trình học lập trình web</div>
                    <div class="suggestion-chip">Khóa học có chứng chỉ không?</div>
                </div>
            </div>
        </div>

        <!-- Input Area -->
        <div class="chat-input-area">
            <div class="quick-actions">
                <button class="quick-action-btn" data-message="Tôi muốn học lập trình web">💻 Lập trình web</button>
                <button class="quick-action-btn" data-message="Giới thiệu khóa học về AI">🤖 Khóa học AI</button>
                <button class="quick-action-btn" data-message="Khóa học phù hợp cho người mới bắt đầu">🎯 Người mới</button>
                <button class="quick-action-btn" data-message="Lộ trình học Backend">🚀 Backend</button>
            </div>
            
            <div class="input-wrapper">
                <div class="input-container">
                    <textarea 
                        id="message-input" 
                        placeholder="Nhập câu hỏi của bạn..." 
                        rows="1"
                        maxlength="500"></textarea>
                    <div class="char-counter">0/500</div>
                </div>
                <button id="send-button" disabled title="Gửi tin nhắn">
                    ✈️
                </button>
            </div>
        </div>
    </div>

    <!-- JavaScript -->
    <script src="${pageContext.request.contextPath}/assets/js/ai-chatbot.js"></script>
</body>
</html>

