<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Users"%>
<%@page import="model.Courses"%>
<%@page import="model.Categories"%>
<%@page import="model.Sections"%>
<%@page import="java.util.List"%>

<%
    Users user = (Users) session.getAttribute("account");
    if (user == null || (!("Instructor".equalsIgnoreCase(user.getRole()) || "Admin".equalsIgnoreCase(user.getRole())))) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    Courses course = (Courses) request.getAttribute("course");
    @SuppressWarnings("unchecked")
    List<Categories> categories = (List<Categories>) request.getAttribute("categories");
    @SuppressWarnings("unchecked")
    List<Sections> sections = (List<Sections>) request.getAttribute("sections");
    String action = (String) request.getAttribute("action");
    boolean isEdit = "update".equals(action);
    String errorMessage = (String) request.getAttribute("errorMessage");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isEdit ? "Chỉnh sửa" : "Tạo mới" %> Khóa học - Instructor Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            background: #f5f7fa;
            color: #333;
        }
        
        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }
        
        .main-content {
            margin-left: 260px;
            flex: 1;
            padding: 30px;
            max-width: 1400px;
        }
        
        .page-header {
            margin-bottom: 30px;
        }
        
        .page-title {
            font-size: 28px;
            font-weight: 700;
            color: #1e3c72;
            margin-bottom: 10px;
        }
        
        .page-subtitle {
            color: #666;
            font-size: 14px;
        }
        
        .form-container {
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .form-section {
            margin-bottom: 30px;
        }
        
        .section-title {
            font-size: 18px;
            font-weight: 600;
            color: #1e3c72;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        
        .form-group label {
            font-size: 14px;
            font-weight: 600;
            color: #555;
        }
        
        .form-group label .required {
            color: #f44336;
        }
        
        .form-control {
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s;
            font-family: inherit;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        textarea.form-control {
            resize: vertical;
            min-height: 100px;
        }
        
        select.form-control {
            cursor: pointer;
        }
        
        .thumb-preview {
            margin-top: 10px;
            border-radius: 8px;
            overflow: hidden;
            max-width: 400px;
            display: none;
        }
        
        .thumb-preview img {
            width: 100%;
            height: auto;
            display: block;
        }
        
        .thumb-preview.show {
            display: block;
        }
        
        /* Sections Management */
        .sections-container {
            margin-top: 20px;
        }
        
        .section-item {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 15px;
            animation: slideIn 0.3s ease-out;
        }
        
        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .section-number {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            flex-shrink: 0;
        }
        
        .section-input {
            flex: 1;
        }
        
        .section-input input {
            width: 100%;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
        }
        
        .btn-remove-section {
            width: 40px;
            height: 40px;
            border: none;
            background: #ffebee;
            color: #f44336;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
            flex-shrink: 0;
        }
        
        .btn-remove-section:hover {
            background: #f44336;
            color: white;
            transform: scale(1.05);
        }
        
        .btn-add-section {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 24px;
            background: #fff3e0;
            color: #FF9800;
            border: 2px dashed #FF9800;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .btn-add-section:hover {
            background: #FF9800;
            color: white;
            border-style: solid;
        }
        
        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: slideInDown 0.4s ease-out;
        }
        
        .alert-success {
            background: #e8f5e9;
            color: #2e7d32;
            border-left: 4px solid #4caf50;
        }
        
        .alert-error {
            background: #ffebee;
            color: #c62828;
            border-left: 4px solid #f44336;
        }
        
        .alert.fade-out {
            animation: fadeOut 0.4s ease-out forwards;
        }
        
        @keyframes slideInDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @keyframes fadeOut {
            from {
                opacity: 1;
                transform: translateY(0);
            }
            to {
                opacity: 0;
                transform: translateY(-20px);
            }
        }
        
        .form-actions {
            display: flex;
            gap: 15px;
            justify-content: flex-end;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid #f0f0f0;
        }
        
        .btn {
            padding: 12px 32px;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-primary {
            background: #4caf50;
            color: white;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
        }
        
        .btn-secondary {
            background: white;
            color: #666;
            border: 2px solid #ddd;
        }
        
        .btn-secondary:hover {
            background: #f5f5f5;
            border-color: #bbb;
        }
        
        .form-hint {
            font-size: 12px;
            color: #999;
            margin-top: 5px;
        }
        
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 15px;
            }
            
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .form-actions {
                flex-direction: column-reverse;
            }
            
            .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <%@ include file="/WEB-INF/includes/instructor-sidebar.jsp" %>
        
        <!-- Main Content -->
        <main class="main-content">
            <!-- Page Header -->
            <div class="page-header">
                <h1 class="page-title"><%= isEdit ? "Chỉnh sửa" : "Tạo mới" %> Khóa học</h1>
                <p class="page-subtitle"><%= isEdit ? "Cập nhật thông tin khóa học của bạn" : "Điền thông tin để tạo khóa học mới" %></p>
            </div>
            
            <!-- Success Message -->
            <% if (request.getParameter("success") != null) { %>
                <div class="alert alert-success" id="successAlert">
                    <i class="fas fa-check-circle"></i>
                    <span>
                        <% if ("created".equals(request.getParameter("success"))) { %>
                            Khóa học đã được tạo thành công!
                        <% } else if ("updated".equals(request.getParameter("success"))) { %>
                            Khóa học đã được cập nhật thành công!
                        <% } %>
                    </span>
                </div>
            <% } %>
            
            <!-- Error Message -->
            <% if (errorMessage != null) { %>
                <div class="alert alert-error" id="errorAlert">
                    <i class="fas fa-exclamation-circle"></i>
                    <%= errorMessage %>
                </div>
            <% } %>
            
            <!-- Form -->
            <form action="<%= request.getContextPath() %>/instructor-courses" method="post" class="form-container" id="courseForm">
                <input type="hidden" name="action" value="<%= isEdit ? "update" : "create" %>">
                <% if (isEdit && course != null) { %>
                    <input type="hidden" name="courseId" value="<%= course.getId() %>">
                <% } %>
                
                <!-- Basic Information -->
                <div class="form-section">
                    <h3 class="section-title">Thông tin cơ bản</h3>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label>Tiêu đề khóa học <span class="required">*</span></label>
                            <input type="text" name="title" class="form-control" 
                                   value="<%= course != null ? course.getTitle() : "" %>" 
                                   required placeholder="Nhập tiêu đề khóa học">
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label>Link ảnh thumbnail <span class="required">*</span></label>
                            <input type="url" name="thumbUrl" class="form-control" id="thumbUrl"
                                   value="<%= course != null ? course.getThumbUrl() : "" %>" 
                                   required placeholder="https://example.com/image.jpg">
                            <p class="form-hint">Nhập URL của ảnh thumbnail (khuyến nghị: 800x450px)</p>
                            <div class="thumb-preview" id="thumbPreview">
                                <img src="" alt="Preview" id="thumbPreviewImg">
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label>Giới thiệu ngắn <span class="required">*</span></label>
                            <textarea name="intro" class="form-control" required 
                                      placeholder="Viết giới thiệu ngắn về khóa học (2-3 câu)"><%= course != null && course.getIntro() != null ? course.getIntro() : "" %></textarea>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label>Mô tả chi tiết <span class="required">*</span></label>
                            <textarea name="description" class="form-control" required 
                                      style="min-height: 150px;" 
                                      placeholder="Mô tả chi tiết về khóa học"><%= course != null && course.getDescription() != null ? course.getDescription() : "" %></textarea>
                        </div>
                    </div>
                </div>
                
                <!-- Pricing & Category -->
                <div class="form-section">
                    <h3 class="section-title">Giá & Danh mục</h3>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label>Giá khóa học (VNĐ) <span class="required">*</span></label>
                            <input type="number" name="price" class="form-control" 
                                   value="<%= course != null ? String.format("%.0f", course.getPrice()) : "" %>" 
                                   required min="0" step="1" placeholder="0">
                            <p class="form-hint">Nhập giá bằng VNĐ (ví dụ: 500000, 1000000)</p>
                        </div>
                        
                        <div class="form-group">
                            <label>Giảm giá (%)</label>
                            <input type="number" name="discount" class="form-control" 
                                   value="<%= course != null ? String.format("%.0f", course.getDiscount()) : "" %>" 
                                   min="0" max="100" step="1" placeholder="0">
                            <p class="form-hint">Nhập % giảm giá (0-100)</p>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label>Danh mục <span class="required">*</span></label>
                            <select name="categoryId" class="form-control" required>
                                <option value="">Chọn danh mục</option>
                                <% if (categories != null) {
                                    for (Categories cat : categories) { 
                                        boolean selected = course != null && course.getLeafCategoryId() != null && 
                                                         course.getLeafCategoryId().getId().equals(cat.getId());
                                %>
                                    <option value="<%= cat.getId() %>" <%= selected ? "selected" : "" %>>
                                        <%= cat.getTitle() %>
                                    </option>
                                <%  }
                                } %>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label>Cấp độ <span class="required">*</span></label>
                            <select name="level" class="form-control" required>
                                <option value="Beginner" <%= course != null && "Beginner".equals(course.getLevel()) ? "selected" : "" %>>Beginner</option>
                                <option value="Intermediate" <%= course != null && "Intermediate".equals(course.getLevel()) ? "selected" : "" %>>Intermediate</option>
                                <option value="Advanced" <%= course != null && "Advanced".equals(course.getLevel()) ? "selected" : "" %>>Advanced</option>
                                <option value="All" <%= course != null && "All".equals(course.getLevel()) ? "selected" : "" %>>All</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label>Trạng thái</label>
                            <select name="status" class="form-control">
                                <option value="Ongoing" <%= course != null && "Ongoing".equals(course.getStatus()) ? "selected" : "" %>>Đang diễn ra</option>
                                <option value="Completed" <%= course != null && "Completed".equals(course.getStatus()) ? "selected" : "" %>>Hoàn thành</option>
                                <option value="Draft" <%= course != null && "Draft".equals(course.getStatus()) ? "selected" : "" %>>Nháp</option>
                            </select>
                        </div>
                    </div>
                </div>
                
                <!-- Learning Outcomes & Requirements -->
                <div class="form-section">
                    <h3 class="section-title">Kết quả học tập & Yêu cầu</h3>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label>Kết quả học tập</label>
                            <textarea name="outcomes" class="form-control" 
                                      placeholder="Học viên sẽ học được gì sau khóa học? (Mỗi kết quả một dòng)"><%= course != null && course.getOutcomes() != null ? course.getOutcomes() : "" %></textarea>
                            <p class="form-hint">Mỗi kết quả một dòng</p>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label>Yêu cầu đầu vào</label>
                            <textarea name="requirements" class="form-control" 
                                      placeholder="Yêu cầu về kiến thức hoặc kỹ năng trước khi học (Mỗi yêu cầu một dòng)"><%= course != null && course.getRequirements() != null ? course.getRequirements() : "" %></textarea>
                            <p class="form-hint">Mỗi yêu cầu một dòng</p>
                        </div>
                    </div>
                </div>
                
                <!-- Course Sections -->
                <div class="form-section">
                    <h3 class="section-title">Các phần của khóa học (Sections)</h3>
                    
                    <div class="sections-container" id="sectionsContainer">
                        <% if (sections != null && !sections.isEmpty()) {
                            int index = 0;
                            for (Sections section : sections) { 
                                index++;
                        %>
                            <div class="section-item">
                                <div class="section-number"><%= index %></div>
                                <div class="section-input">
                                    <input type="text" name="sectionTitles[]" 
                                           value="<%= section.getTitle() %>" 
                                           placeholder="Tiêu đề phần <%= index %>">
                                </div>
                                <button type="button" class="btn-remove-section" onclick="removeSection(this)">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </div>
                        <%  }
                        } else { %>
                            <!-- Empty state - will be filled by JavaScript if needed -->
                        <% } %>
                    </div>
                    
                    <button type="button" class="btn-add-section" onclick="addSection()">
                        <i class="fas fa-plus"></i>
                        Thêm phần mới
                    </button>
                </div>
                
                <!-- Form Actions -->
                <div class="form-actions">
                    <a href="<%= request.getContextPath() %>/instructor-courses" class="btn btn-secondary">
                        <i class="fas fa-times"></i>
                        Hủy
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i>
                        <%= isEdit ? "Cập nhật" : "Tạo" %> khóa học
                    </button>
                </div>
            </form>
        </main>
    </div>
    
    <script>
        // Auto-hide alerts after 5 seconds
        window.addEventListener('DOMContentLoaded', function() {
            const successAlert = document.getElementById('successAlert');
            const errorAlert = document.getElementById('errorAlert');
            
            if (successAlert) {
                setTimeout(function() {
                    successAlert.classList.add('fade-out');
                    setTimeout(function() {
                        successAlert.remove();
                    }, 400);
                }, 5000);
            }
            
            if (errorAlert) {
                setTimeout(function() {
                    errorAlert.classList.add('fade-out');
                    setTimeout(function() {
                        errorAlert.remove();
                    }, 400);
                }, 8000); // Error messages stay longer (8 seconds)
            }
        });
        
        let sectionCount = <%= (sections != null ? sections.size() : 0) %>;
        
        // Thumbnail preview
        document.getElementById('thumbUrl').addEventListener('input', function() {
            const url = this.value;
            const preview = document.getElementById('thumbPreview');
            const img = document.getElementById('thumbPreviewImg');
            
            if (url && isValidURL(url)) {
                img.src = url;
                preview.classList.add('show');
                
                img.onerror = function() {
                    preview.classList.remove('show');
                };
            } else {
                preview.classList.remove('show');
            }
        });
        
        // Load existing thumbnail on page load
        window.addEventListener('DOMContentLoaded', function() {
            const thumbUrl = document.getElementById('thumbUrl').value;
            if (thumbUrl) {
                const preview = document.getElementById('thumbPreview');
                const img = document.getElementById('thumbPreviewImg');
                img.src = thumbUrl;
                preview.classList.add('show');
            }
        });
        
        function isValidURL(string) {
            try {
                new URL(string);
                return true;
            } catch (_) {
                return false;  
            }
        }
        
        // Section management
        function addSection() {
            sectionCount++;
            const container = document.getElementById('sectionsContainer');
            
            const sectionItem = document.createElement('div');
            sectionItem.className = 'section-item';
            sectionItem.innerHTML = `
                <div class="section-number">${sectionCount}</div>
                <div class="section-input">
                    <input type="text" name="sectionTitles[]" 
                           placeholder="Tiêu đề phần ${sectionCount}">
                </div>
                <button type="button" class="btn-remove-section" onclick="removeSection(this)">
                    <i class="fas fa-trash"></i>
                </button>
            `;
            
            container.appendChild(sectionItem);
        }
        
        function removeSection(button) {
            const sectionItem = button.closest('.section-item');
            sectionItem.style.animation = 'slideOut 0.3s ease-out';
            
            setTimeout(() => {
                sectionItem.remove();
                updateSectionNumbers();
            }, 300);
        }
        
        function updateSectionNumbers() {
            const sections = document.querySelectorAll('.section-item');
            sections.forEach((section, index) => {
                const number = section.querySelector('.section-number');
                number.textContent = index + 1;
                
                const input = section.querySelector('input');
                input.placeholder = `Tiêu đề phần ${index + 1}`;
            });
            sectionCount = sections.length;
        }
        
        // Add slide out animation
        const style = document.createElement('style');
        style.textContent = `
            @keyframes slideOut {
                from {
                    opacity: 1;
                    transform: translateX(0);
                }
                to {
                    opacity: 0;
                    transform: translateX(-20px);
                }
            }
        `;
        document.head.appendChild(style);
        
        // Form validation
        document.getElementById('courseForm').addEventListener('submit', function(e) {
            const title = document.querySelector('input[name="title"]').value.trim();
            const thumbUrl = document.querySelector('input[name="thumbUrl"]').value.trim();
            const priceInput = document.querySelector('input[name="price"]');
            const price = parseFloat(priceInput.value);
            const discountInput = document.querySelector('input[name="discount"]');
            const discount = parseFloat(discountInput.value) || 0;
            
            if (!title) {
                e.preventDefault();
                alert('Vui lòng nhập tiêu đề khóa học');
                return;
            }
            
            if (!thumbUrl || !isValidURL(thumbUrl)) {
                e.preventDefault();
                alert('Vui lòng nhập URL hợp lệ cho ảnh thumbnail');
                return;
            }
            
            if (isNaN(price) || price < 0) {
                e.preventDefault();
                alert('Vui lòng nhập giá khóa học hợp lệ (VNĐ, không âm)');
                return;
            }
            
            if (discount < 0 || discount > 100) {
                e.preventDefault();
                alert('Giảm giá phải từ 0-100%');
                return;
            }
            
            // Ensure price is formatted correctly (no decimal issues)
            priceInput.value = Math.round(price);
        });
    </script>
</body>
</html>
