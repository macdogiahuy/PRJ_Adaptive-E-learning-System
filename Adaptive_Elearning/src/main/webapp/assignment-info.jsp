<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Assignment Info</title>
    <style>
        body {
            font-family: 'Inter', Arial, sans-serif;
            background: linear-gradient(135deg, #cfe0ff, #e3f0ff, #f7f9ff);
            color: #1a1a1a;
            margin: 0;
            padding: 60px 0;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: flex-start;
        }

        .info-container {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
            padding: 40px 50px;
            max-width: 850px;
            width: 90%;
        }

        h1 {
            font-size: 28px;
            text-align: center;
            background: linear-gradient(90deg, #4f46e5, #3b82f6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 10px;
        }

        .meta {
            text-align: center;
            color: #555;
            margin-bottom: 30px;
        }

        .meta p {
            margin: 6px 0;
            font-size: 15px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
            border-radius: 10px;
            overflow: hidden;
            background-color: #fff;
        }

        th, td {
            padding: 12px 15px;
            text-align: center;
        }

        th {
            background: #f1f5f9;
            color: #444;
            font-weight: 600;
        }

        tr:nth-child(even) {
            background: #f9fbfd;
        }

        tr:hover {
            background: #eef5ff;
        }

        .btn-start {
            display: inline-block;
            text-align: center;
            margin-top: 30px;
            background: linear-gradient(90deg, #4f46e5, #3b82f6);
            color: white;
            padding: 14px 32px;
            border-radius: 12px;
            text-decoration: none;
            font-weight: 600;
            font-size: 16px;
            transition: all 0.25s ease;
        }

        .btn-start:hover {
            transform: translateY(-2px);
            background: linear-gradient(90deg, #3b82f6, #2563eb);
        }

        h3 {
            margin-top: 40px;
            color: #111827;
            font-size: 20px;
            border-left: 4px solid #3b82f6;
            padding-left: 10px;
        }
    </style>
</head>
<body>
    <div class="info-container">
        <h1>${assignment.name}</h1>

        <div class="meta">
            <p><strong>Số câu hỏi:</strong> ${assignment.questionCount}</p>
            <p><strong>Thời gian:</strong> ${assignment.duration} phút</p>
            <p><strong>Điểm đạt để qua:</strong> ${assignment.gradeToPass}</p>
        </div>

        <c:url var="startQuizUrl" value="/adaptive-quiz">
            <c:param name="action" value="start" />
            <c:param name="courseId" value="${courseId}" />
            <c:param name="assignmentId" value="${assignment.id}" />
        </c:url>

        <h3>Lịch sử làm bài</h3>
        <table>
            <tr>
                <th>Lần</th>
                <th>Số câu đúng</th>
                <th>Thời gian (giây)</th>
                <th>Ngày nộp</th>
            </tr>
            <c:forEach var="h" items="${history}" varStatus="loop">
                <tr>
                    <td>${loop.index + 1}</td>
                    <td>${h.correctCount}</td>
                    <td>${h.timeSpent}</td>
                    <td><fmt:formatDate value="${h.submitTime}" pattern="dd/MM/yyyy HH:mm:ss"/></td>
                </tr>
            </c:forEach>
        </table>

        <div style="text-align:center;">
            <a class="btn-start" href="${startQuizUrl}">
                Bắt đầu Quiz
            </a>
        </div>
    </div>
</body>
</html>
