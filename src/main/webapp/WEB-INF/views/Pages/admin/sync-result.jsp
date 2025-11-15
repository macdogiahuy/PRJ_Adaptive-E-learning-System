<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sync Result - CourseHub Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .result-container {
            max-width: 1000px;
            margin: 2rem auto;
            padding: 0 1rem;
        }
        .result-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            padding: 2rem;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
            margin: 2rem 0;
        }
        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 1.5rem;
            border-radius: 8px;
            text-align: center;
        }
        .stat-number {
            font-size: 2.5rem;
            font-weight: bold;
            margin-bottom: 0.5rem;
        }
        .log-container {
            background: #1e1e1e;
            color: #f8f8f2;
            padding: 1.5rem;
            border-radius: 8px;
            font-family: 'Courier New', monospace;
            max-height: 500px;
            overflow-y: auto;
            white-space: pre-wrap;
            font-size: 0.9rem;
            line-height: 1.4;
        }
        .success-icon {
            color: #28a745;
        }
        .error-icon {
            color: #dc3545;
        }
        .info-icon {
            color: #17a2b8;
        }
    </style>
</head>
<body>
    <div class="result-container">
        <div class="result-card">
            <div class="text-center mb-4">
                <c:choose>
                    <c:when test="${videosAdded > 0}">
                        <i class="fas fa-check-circle fa-3x success-icon mb-3"></i>
                        <h2>✅ Đồng bộ thành công!</h2>
                    </c:when>
                    <c:when test="${videosProcessed > 0}">
                        <i class="fas fa-info-circle fa-3x info-icon mb-3"></i>
                        <h2>ℹ️ Hoàn thành đồng bộ</h2>
                    </c:when>
                    <c:otherwise>
                        <i class="fas fa-exclamation-triangle fa-3x error-icon mb-3"></i>
                        <h2>⚠️ Không có video nào được xử lý</h2>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-number">${videosProcessed}</div>
                    <div>Video đã quét</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">${videosAdded}</div>
                    <div>Video mới thêm</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">${videosProcessed - videosAdded}</div>
                    <div>Video đã tồn tại</div>
                </div>
            </div>

            <h4><i class="fas fa-terminal me-2"></i>Chi tiết quá trình đồng bộ</h4>
            <div class="log-container">
${syncLog}
            </div>

            <div class="mt-4 text-center">
                <a href="${pageContext.request.contextPath}/admin/auto-sync-drive" class="btn btn-primary me-3">
                    <i class="fas fa-sync-alt me-2"></i>
                    Đồng bộ lại
                </a>
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline-secondary">
                    <i class="fas fa-tachometer-alt me-2"></i>
                    Dashboard
                </a>
            </div>

            <c:if test="${videosAdded > 0}">
                <div class="alert alert-success mt-4">
                    <h5><i class="fas fa-lightbulb me-2"></i>Bước tiếp theo</h5>
                    <ul class="mb-0">
                        <li>Kiểm tra trang Course Player để xem video đã hiển thị chưa</li>
                        <li>Refresh browser cache nếu cần thiết</li>
                        <li>Thông báo cho learners về content mới</li>
                    </ul>
                </div>
            </c:if>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>