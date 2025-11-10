<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Kết quả bài kiểm tra</title>
        <style>
            body {
                margin: 0;
                padding: 0;
                font-family: 'Inter', 'Segoe UI', Arial, sans-serif;
                background: linear-gradient(135deg, #edf4ff, #f8fbff);
                color: #222;
            }

            .review-wrapper {
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                min-height: 100vh;
            }

            .review-card {
                background: #fff;
                width: 480px;
                padding: 40px 50px;
                border-radius: 20px;
                box-shadow: 0 10px 25px rgba(0,0,0,0.08);
                text-align: center;
                transition: transform 0.2s ease;
            }

            .review-card:hover {
                transform: translateY(-3px);
            }

            .review-card h2 {
                margin-bottom: 15px;
                font-size: 1.8em;
                font-weight: 600;
                color: #1a1a1a;
            }

            .emoji {
                font-size: 5.4em;
                margin-bottom: 10px;
            }

            .result-box {
                margin-top: 25px;
                margin-bottom: 25px;
                background: #f5f8ff;
                border: 1px solid #e0e6ff;
                border-radius: 12px;
                padding: 20px;
            }

            .result-metric {
                font-size: 1.05em;
                margin: 10px 0;
                color: #333;
            }

            .result-metric span {
                font-weight: 600;
                color: #0056d2;
            }

            .status {
                font-size: 1.05em;
                font-weight: 700;
                margin-top: 10px;
            }

            .passed {
                color: #16a34a;
            }

            .failed {
                color: #dc2626;
            }

            .btn-back {
                display: inline-block;
                margin-top: 25px;
                padding: 12px 28px;
                background-color: #0056d2;
                color: #fff;
                text-decoration: none;
                border-radius: 10px;
                font-weight: 600;
                letter-spacing: 0.5px;
                transition: all 0.25s ease;
            }

            .btn-back:hover {
                background-color: #0041a3;
                transform: translateY(-1px);
            }
        </style>
    </head>
    <body>
        <div class="review-wrapper">
            <div class="review-card">
                <div class="emoji">
                    &#127881;
                </div>

                <h2>Quiz Result</h2>

                <div class="result-box">
                    <div class="result-metric">
                        <b>Số câu đúng:</b> <span>${correct}</span> / ${total}
                    </div>
                    <div class="result-metric">
                        <b>Điểm đạt được:</b> <span>${mark}</span> / 10
                    </div>
                    <div class="result-metric">
                        <b>Điểm cần để qua:</b> <span>${gradeToPass}</span>
                    </div>
                    <div class="result-metric status">
                        <b>Status:</b>
                        <span class="${passed ? 'passed' : 'failed'}">
                            ${passed ? 'Passed' : 'Not Passed'}
                        </span>
                    </div>
                    <div class="result-metric">
                        <b>Xếp hạng:</b> ${rank} / ${totalParticipants}
                    </div>
                </div>

                <c:url var="backUrl" value="/my-courses"/>
                <a href="${backUrl}" class="btn-back">⬅ Quay lại khóa học</a>
            </div>
        </div>

        <!-- Hiệu ứng confetti khi Passed -->
        <c:if test="${passed}">
            <script>
                (function () {
                    const colors = ['#4f46e5', '#3b82f6', '#60a5fa', '#93c5fd'];
                    for (let i = 0; i < 80; i++) {
                        const confetti = document.createElement('div');
                        confetti.style.position = 'fixed';
                        confetti.style.width = '8px';
                        confetti.style.height = '8px';
                        confetti.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
                        confetti.style.left = Math.random() * window.innerWidth + 'px';
                        confetti.style.top = '-10px';
                        confetti.style.opacity = Math.random();
                        confetti.style.borderRadius = '50%';
                        confetti.style.zIndex = '9999';
                        document.body.appendChild(confetti);

                        const fall = confetti.animate([
                            {transform: 'translateY(0) rotate(0deg)'},
                            {transform: 'translateY(' + (window.innerHeight + 50) + 'px) rotate(720deg)'}
                        ], {
                            duration: Math.random() * 2500 + 2500,
                            easing: 'ease-out',
                            iterations: 1,
                            delay: Math.random() * 300
                        });

                        fall.onfinish = () => confetti.remove();
                    }
                })();
            </script>
        </c:if>
    </body>
</html>
