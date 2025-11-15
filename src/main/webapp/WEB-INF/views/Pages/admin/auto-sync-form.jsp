<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Auto Sync Google Drive - CourseHub Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .admin-container {
            max-width: 800px;
            margin: 2rem auto;
            padding: 0 1rem;
        }
        .sync-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            padding: 2rem;
        }
        .sync-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            color: white;
            padding: 12px 24px;
            border-radius: 8px;
            font-weight: 600;
            transition: transform 0.2s;
        }
        .sync-btn:hover {
            transform: translateY(-2px);
            color: white;
        }
        .info-card {
            background: #e3f2fd;
            border-left: 4px solid #2196f3;
            padding: 1rem;
            margin: 1rem 0;
            border-radius: 4px;
        }
        .warning-card {
            background: #fff3e0;
            border-left: 4px solid #ff9800;
            padding: 1rem;
            margin: 1rem 0;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <div class="sync-card">
            <div class="text-center mb-4">
                <i class="fas fa-cloud-download-alt fa-3x text-primary mb-3"></i>
                <h2>🔄 Auto Sync Google Drive</h2>
                <p class="text-muted">Tự động đồng bộ video từ Google Drive xuống database</p>
            </div>

            <div class="info-card">
                <h5><i class="fas fa-info-circle"></i> Cách hoạt động</h5>
                <ul class="mb-0">
                    <li>Quét thư mục <strong>CourseHubVideo</strong> trên Google Drive</li>
                    <li>Tìm kiếm cấu trúc: <code>Course → Section → Lecture → Video Files</code></li>
                    <li>Tự động tạo Section/Lecture nếu chưa có trong database</li>
                    <li>Thêm video mới vào bảng <strong>LectureMaterial</strong></li>
                    <li>Đặt quyền public cho tất cả file để learner xem được</li>
                </ul>
            </div>

            <div class="warning-card">
                <h5><i class="fas fa-exclamation-triangle"></i> Lưu ý quan trọng</h5>
                <ul class="mb-0">
                    <li>Đảm bảo Course đã tồn tại trong database trước khi sync</li>
                    <li>Tên thư mục Drive phải khớp hoặc gần giống tên Course</li>
                    <li>Quá trình có thể mất vài phút với nhiều video</li>
                    <li>Chỉ admin mới có quyền thực hiện sync</li>
                </ul>
            </div>

            <form method="POST" action="${pageContext.request.contextPath}/admin/auto-sync-drive">
                <div class="text-center">
                    <button type="submit" class="btn sync-btn btn-lg">
                        <i class="fas fa-sync-alt me-2"></i>
                        Bắt đầu đồng bộ
                    </button>
                </div>
            </form>

            <div class="mt-4">
                <h5>📋 Cấu trúc thư mục mẫu trên Google Drive:</h5>
                <div class="bg-light p-3 rounded">
<pre><code>CourseHubVideo/
├── The Complete 2023 Web Development Bootcamp/
│   ├── Section 1: Front-End Web Development/
│   │   ├── Title 1/
│   │   │   ├── intro.mp4
│   │   │   └── demo.mp4
│   │   └── Title 2/
│   │       └── lesson.mp4
│   └── Section 2: Introduction to HTML/
│       └── HTML Basics/
│           └── html-intro.mp4
└── Java Course/
    └── Introduction/
        └── Getting Started/
            └── setup.mp4</code></pre>
                </div>
            </div>

            <div class="mt-3 text-center">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left me-2"></i>
                    Quay lại Dashboard
                </a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>