<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lỗi - CourseHub E-Learning</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
        }
        .error-container {
            background: white;
            border-radius: 15px;
            padding: 3rem;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            max-width: 500px;
        }
        .error-icon {
            font-size: 4rem;
            color: #f5576c;
            margin-bottom: 1rem;
        }
        .error-title {
            font-size: 2rem;
            color: #333;
            margin-bottom: 1rem;
        }
        .error-message {
            color: #666;
            margin-bottom: 2rem;
            line-height: 1.5;
        }
        .btn {
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
            padding: 0.75rem 2rem;
            border: none;
            border-radius: 10px;
            text-decoration: none;
            display: inline-block;
            font-weight: 500;
            transition: transform 0.3s ease;
        }
        .btn:hover {
            transform: translateY(-2px);
            color: white;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-icon">
            <i class="fas fa-exclamation-triangle"></i>
        </div>
        <h1 class="error-title">Có lỗi xảy ra!</h1>
        <p class="error-message">
            Xin lỗi, đã có lỗi xảy ra trong quá trình xử lý yêu cầu của bạn.
            Vui lòng thử lại sau hoặc liên hệ với quản trị viên.
        </p>
        <a href="<%= request.getContextPath() %>/admin_dashboard.jsp" class="btn">
            <i class="fas fa-home"></i> Về trang chủ
        </a>
    </div>
</body>
</html>