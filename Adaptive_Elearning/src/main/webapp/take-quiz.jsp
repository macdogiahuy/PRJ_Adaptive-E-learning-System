<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Take Quiz</title>
    <style>
        /* ... (Toàn bộ CSS của bạn giữ nguyên) ... */
        body {
            font-family: 'Inter', 'Segoe UI', Arial, sans-serif;
            background: linear-gradient(135deg, #eef4ff, #f8fbff);
            color: #222;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }
        .quiz-container {
            background: #fff;
            width: 750px;
            padding: 50px 60px;
            border-radius: 25px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
            text-align: center;
            transition: all 0.3s ease;
            position: relative;
        }
        .quiz-container:hover {
            transform: translateY(-2px);
        }
        .quiz-timer {
            position: absolute;
            top: 30px;
            right: 40px;
            font-size: 1.1em;
            font-weight: 600;
            color: #0056d2;
            background-color: #eef4ff;
            padding: 10px 15px;
            border-radius: 10px;
            font-family: 'Courier New', Courier, monospace;
        }
        .question-header {
            font-size: 1.2em;
            font-weight: 600;
            color: #0056d2;
            margin-bottom: 10px;
        }
        .question-content {
            font-size: 1.6em;
            font-weight: 600;
            color: #222;
            margin-bottom: 30px;
            line-height: 1.5;
        }
        .choices-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 40px;
        }
        .choice-label {
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 12px;
            font-size: 1.15em;
            font-weight: 600;
            color: white;
            padding: 22px;
            cursor: pointer;
            transition: all 0.25s ease;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        .choice-label[data-index="0"] { background-color: #007bff; }
        .choice-label[data-index="1"] { background-color: #28a745; }
        .choice-label[data-index="2"] { background-color: #ffc107; color: #333; }
        .choice-label[data-index="3"] { background-color: #dc3545; }
        .choice-label:hover {
            transform: scale(1.04);
            box-shadow: 0 6px 15px rgba(0,0,0,0.15);
        }
        input[type="radio"] {
            display: none;
        }
        input[type="radio"]:checked + span {
            text-decoration: underline;
            font-weight: 700;
        }
        .submit-button {
            background: #0056d2;
            color: white;
            padding: 14px 45px;
            border: none;
            border-radius: 12px;
            font-size: 1.15em;
            font-weight: 600;
            cursor: pointer;
            box-shadow: 0 4px 10px rgba(0, 86, 210, 0.3);
            transition: all 0.25s ease;
        }
        .submit-button:hover {
            background: #0041a3;
            transform: translateY(-1px);
        }
        .debug-info {
            margin-top: 15px;
            font-size: 0.9em;
            color: #888;
        }
    </style>
</head>
<body>
    <div class="quiz-container">
        
        <div id="timer" class="quiz-timer">Thời gian: 00:00</div>

        <div class="question-header">Câu hỏi ${questionNumber}</div>
        <div class="question-content">
            <c:out value="${questionContent}" />
        </div>

        <form action="adaptive-quiz" method="post">
            <input type="hidden" name="action" value="answer" />
            <input type="hidden" name="questionId" value="${questionId}" />

            <div class="choices-grid">
                <c:forEach var="choice" items="${choices}" varStatus="loop">
                    <label class="choice-label" data-index="${loop.index}" for="choice-${loop.index}">
                        <input type="radio" name="choiceId" value="${choice.Id}" id="choice-${loop.index}" required />
                        <span><c:out value="${choice.Content}" /></span>
                    </label>
                </c:forEach>
            </div>

            <button type="submit" class="submit-button">Next ➜</button>
        </form>

        <div class="debug-info">
            🧩 Đã trả lời <b>${debugAnswered}</b> câu.
        </div>
    </div>

    <script>
        // Lấy TỔNG THỜI GIAN (bằng giây) từ Servlet
        // ${durationInSeconds} sẽ được JSP render thành một con số (ví dụ: 1800)
        let totalSeconds = ${durationInSeconds};

        if (totalSeconds > 0) {
            const timerElement = document.getElementById("timer");

            // Hàm helper để cập nhật hiển thị đồng hồ
            function updateTimerDisplay(secondsLeft) {
                // Chuyển đổi sang phút và giây
                const minutes = Math.floor(secondsLeft / 60);
                const seconds = secondsLeft % 60;
                
                // Format (MM:SS) để đảm bảo có 2 chữ số (ví dụ: 01:05)
                const formattedMinutes = String(minutes).padStart(2, '0');
                const formattedSeconds = String(seconds).padStart(2, '0');
                
                // Hiển thị lên màn hình
                timerElement.innerText = `Thời gian: ${formattedMinutes}:${formattedSeconds}`;
            }

            // Cập nhật đồng hồ ngay lập tức (không chờ 1 giây đầu)
            updateTimerDisplay(totalSeconds);

            // Bắt đầu đếm ngược
            const timerInterval = setInterval(() => {
                totalSeconds--; // Giảm 1 giây

                // Cập nhật đồng hồ
                updateTimerDisplay(totalSeconds);

                // ✅ TỰ ĐỘNG NỘP BÀI KHI HẾT GIỜ
                if (totalSeconds <= 0) {
                    clearInterval(timerInterval); // Dừng đếm ngược
                    timerElement.innerText = "Hết giờ!";
                    
                    // Thông báo và chuyển hướng để nộp bài
                    alert("Đã hết thời gian làm bài. Bài của bạn sẽ được tự động nộp.");
                    // Dùng contextPath để đảm bảo link luôn đúng
                    window.location.href = '${pageContext.request.contextPath}/adaptive-quiz?action=finish';
                }
            }, 1000); // 1000ms = 1 giây
        } else {
             // Xử lý trường hợp không có thời gian (ví dụ: lỗi hoặc duration = 0)
             document.getElementById("timer").innerText = "Không giới hạn";
        }
    </script>
</body>
</html>