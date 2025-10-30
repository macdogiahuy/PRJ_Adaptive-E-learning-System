<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Users"%>
<%@page import="model.Categories"%>
<%@page import="java.util.List"%>

<%
    Users user = (Users) session.getAttribute("account");
    if (user == null || !"Instructor".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    @SuppressWarnings("unchecked")
    List<Categories> categories = (List<Categories>) request.getAttribute("categories");
    
    String[] levels = {"Beginner", "Intermediate", "Advanced", "All Levels"};
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create a new course - Instructor Dashboard</title>
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
        
        /* Sidebar - Same as instructor_courses.jsp */
        .sidebar {
            width: 260px;
            background: linear-gradient(180deg, #1e3c72 0%, #2a5298 100%);
            color: white;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            z-index: 1000;
        }
        
        .sidebar-header {
            padding: 20px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        
        .logo {
            font-size: 24px;
            font-weight: bold;
            display: flex;
            align-items: center;
            gap: 10px;
            color: white;
            text-decoration: none;
        }
        
        .logo:hover {
            color: white;
            text-decoration: none;
        }
        
        .nav-menu {
            list-style: none;
            padding: 20px 0;
        }
        
        .nav-item {
            margin: 5px 0;
        }
        
        .nav-link {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 20px;
            color: rgba(255,255,255,0.8);
            text-decoration: none;
            transition: all 0.3s;
        }
        
        .nav-link:hover,
        .nav-link.active {
            background: rgba(255,255,255,0.1);
            color: white;
            border-left: 3px solid #4CAF50;
        }
        
        .nav-link i {
            width: 20px;
            text-align: center;
        }
        
        /* Main Content */
        .main-content {
            margin-left: 260px;
            flex: 1;
            padding: 30px;
            max-width: 900px;
        }
        
        .page-header {
            margin-bottom: 30px;
        }
        
        .page-title {
            font-size: 32px;
            font-weight: 700;
            color: #333;
            margin-bottom: 10px;
        }
        
        .page-subtitle {
            color: #666;
            font-size: 14px;
        }
        
        /* Form Styles */
        .form-container {
            background: white;
            border-radius: 12px;
            padding: 40px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-label {
            display: block;
            font-size: 15px;
            font-weight: 500;
            color: #333;
            margin-bottom: 8px;
        }
        
        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s;
            font-family: inherit;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #2196F3;
            box-shadow: 0 0 0 3px rgba(33, 150, 243, 0.1);
        }
        
        textarea.form-control {
            resize: vertical;
            min-height: 100px;
        }
        
        select.form-control {
            cursor: pointer;
            background-color: white;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%23333' d='M6 9L1 4h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 15px center;
            padding-right: 40px;
        }
        
        .file-input-wrapper {
            position: relative;
            display: inline-block;
            width: 100%;
        }
        
        .file-input-wrapper input[type="file"] {
            position: absolute;
            left: -9999px;
        }
        
        .file-input-label {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 12px 15px;
            border: 2px dashed #ddd;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
            background: #fafafa;
        }
        
        .file-input-label:hover {
            border-color: #2196F3;
            background: #f0f7ff;
        }
        
        .file-input-label i {
            margin-right: 8px;
            color: #666;
        }
        
        .file-name {
            margin-top: 8px;
            font-size: 13px;
            color: #666;
            font-style: italic;
        }
        
        .thumbnail-preview {
            margin-top: 15px;
            max-width: 300px;
            border-radius: 8px;
            display: none;
        }
        
        .thumbnail-preview img {
            width: 100%;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .price-input-wrapper {
            position: relative;
        }
        
        .price-input-wrapper .currency {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #666;
            font-weight: 500;
        }
        
        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 40px;
            padding-top: 30px;
            border-top: 2px solid #f0f0f0;
        }
        
        .btn {
            padding: 14px 30px;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            font-size: 15px;
            font-weight: 600;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-primary {
            background: #2196F3;
            color: white;
            flex: 1;
        }
        
        .btn-primary:hover {
            background: #1976D2;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(33, 150, 243, 0.4);
        }
        
        .btn-secondary {
            background: white;
            color: #666;
            border: 1px solid #ddd;
        }
        
        .btn-secondary:hover {
            background: #f5f5f5;
            border-color: #bbb;
        }
        
        /* Section Styles */
        .btn-add-section {
            background: #FFC107;
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 8px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.3s;
            margin-top: 15px;
        }
        
        .btn-add-section:hover {
            background: #FFA000;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(255, 193, 7, 0.4);
        }
        
        .section-item {
            background: #f9f9f9;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 15px;
            position: relative;
        }
        
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .section-title {
            font-weight: 600;
            color: #333;
            font-size: 15px;
        }
        
        .btn-remove-section {
            background: #f44336;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 12px;
            transition: all 0.3s;
        }
        
        .btn-remove-section:hover {
            background: #d32f2f;
        }
        
        .section-input {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            margin-bottom: 10px;
        }
        
        .section-input:focus {
            outline: none;
            border-color: #2196F3;
            box-shadow: 0 0 0 2px rgba(33, 150, 243, 0.1);
        }
        
        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: none;
        }
        
        .alert-success {
            background: #e8f5e9;
            color: #2e7d32;
            border-left: 4px solid #4CAF50;
        }
        
        .alert-error {
            background: #ffebee;
            color: #c62828;
            border-left: 4px solid #f44336;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
            }
            
            .main-content {
                margin-left: 0;
                padding: 20px;
            }
            
            .form-container {
                padding: 25px;
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
            <div class="page-header">
                <h1 class="page-title">Create a new course</h1>
            </div>
            
            <div id="alertContainer"></div>
            
            <div class="form-container">
                <form id="createCourseForm" action="<%= request.getContextPath() %>/create-course" method="POST" enctype="multipart/form-data">
                    
                    <!-- Course Title -->
                    <div class="form-group">
                        <label class="form-label" for="courseTitle">Course title</label>
                        <input type="text" class="form-control" id="courseTitle" name="title" required placeholder="Enter course title">
                    </div>
                    
                    <!-- Course Thumbnail -->
                    <div class="form-group">
                        <label class="form-label" for="courseThumb">Course thumb</label>
                        <div class="file-input-wrapper">
                            <input type="file" id="courseThumb" name="thumbnail" accept="image/*" required>
                            <label for="courseThumb" class="file-input-label">
                                <i class="fas fa-cloud-upload-alt"></i>
                                <span>Choose File</span>
                            </label>
                        </div>
                        <div class="file-name" id="fileName">No file chosen</div>
                        <div class="thumbnail-preview" id="thumbnailPreview">
                            <img src="" alt="Thumbnail preview" id="previewImg">
                        </div>
                    </div>
                    
                    <!-- Course Introduction -->
                    <div class="form-group">
                        <label class="form-label" for="courseIntro">Course introduction</label>
                        <textarea class="form-control" id="courseIntro" name="intro" rows="3" required placeholder="Brief introduction about the course"></textarea>
                    </div>
                    
                    <!-- Course Description -->
                    <div class="form-group">
                        <label class="form-label" for="courseDesc">Course description</label>
                        <textarea class="form-control" id="courseDesc" name="description" rows="4" required placeholder="Detailed description of the course"></textarea>
                    </div>
                    
                    <!-- Course Price -->
                    <div class="form-group">
                        <label class="form-label" for="coursePrice">Course price (VND)</label>
                        <div class="price-input-wrapper">
                            <input type="text" class="form-control" id="coursePrice" name="price" required placeholder="0" pattern="[0-9,.]+" title="Enter price in VND">
                            <span class="currency">VND</span>
                        </div>
                    </div>
                    
                    <!-- Course Level -->
                    <div class="form-group">
                        <label class="form-label" for="courseLevel">Course level</label>
                        <select class="form-control" id="courseLevel" name="level" required>
                            <option value="" disabled selected>Select level</option>
                            <% for (String level : levels) { %>
                                <option value="<%= level %>"><%= level %></option>
                            <% } %>
                        </select>
                    </div>
                    
                    <!-- Course Outcomes -->
                    <div class="form-group">
                        <label class="form-label" for="courseOutcomes">Course outcomes</label>
                        <textarea class="form-control" id="courseOutcomes" name="outcomes" rows="3" required placeholder="What will students learn from this course?"></textarea>
                    </div>
                    
                    <!-- Course Requirements -->
                    <div class="form-group">
                        <label class="form-label" for="courseReq">Course requirements</label>
                        <textarea class="form-control" id="courseReq" name="requirements" rows="3" required placeholder="Prerequisites for taking this course"></textarea>
                    </div>
                    
                    <!-- Course Category -->
                    <div class="form-group">
                        <label class="form-label" for="courseCategory">Course category</label>
                        <select class="form-control" id="courseCategory" name="categoryId" required>
                            <option value="" disabled selected>Select category</option>
                            <% if (categories != null) {
                                for (Categories cat : categories) { 
                                    if (cat.getIsLeaf()) { // Only show leaf categories %>
                                        <option value="<%= cat.getId() %>"><%= cat.getTitle() %></option>
                            <%      }
                                }
                            } %>
                        </select>
                    </div>
                    
                    <!-- Course Sections -->
                    <div class="form-group">
                        <label class="form-label">Course sections</label>
                        <div id="sectionsContainer">
                            <!-- Sections will be added here dynamically -->
                        </div>
                        <button type="button" class="btn-add-section" onclick="addSection()">
                            <i class="fas fa-plus"></i>
                            <span>Add section</span>
                        </button>
                    </div>
                    
                    <!-- Form Actions -->
                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" onclick="window.history.back()">
                            <i class="fas fa-times"></i>
                            Cancel
                        </button>
                        <button type="submit" class="btn btn-primary" id="submitBtn">
                            <i class="fas fa-check"></i>
                            Create course
                        </button>
                    </div>
                </form>
            </div>
        </main>
    </div>
    
    <script>
        // File input handling
        const fileInput = document.getElementById('courseThumb');
        const fileName = document.getElementById('fileName');
        const thumbnailPreview = document.getElementById('thumbnailPreview');
        const previewImg = document.getElementById('previewImg');
        
        fileInput.addEventListener('change', function(e) {
            if (this.files && this.files[0]) {
                fileName.textContent = this.files[0].name;
                
                // Show preview
                const reader = new FileReader();
                reader.onload = function(e) {
                    previewImg.src = e.target.result;
                    thumbnailPreview.style.display = 'block';
                };
                reader.readAsDataURL(this.files[0]);
            } else {
                fileName.textContent = 'No file chosen';
                thumbnailPreview.style.display = 'none';
            }
        });
        
        // Price formatting
        const priceInput = document.getElementById('coursePrice');
        
        priceInput.addEventListener('input', function(e) {
            // Remove all non-digit characters
            let value = this.value.replace(/[^\d]/g, '');
            
            // Format with thousand separators
            if (value) {
                value = parseInt(value).toLocaleString('vi-VN');
            }
            
            this.value = value;
        });
        
        // Form submission
        const form = document.getElementById('createCourseForm');
        const submitBtn = document.getElementById('submitBtn');
        
        form.addEventListener('submit', function(e) {
            // Validate file
            if (!fileInput.files || !fileInput.files[0]) {
                e.preventDefault();
                showAlert('Please select a thumbnail image', 'error');
                return;
            }
            
            // Convert formatted price back to number
            const priceValue = priceInput.value.replace(/[^\d]/g, '');
            const hiddenPriceInput = document.createElement('input');
            hiddenPriceInput.type = 'hidden';
            hiddenPriceInput.name = 'priceValue';
            hiddenPriceInput.value = priceValue;
            form.appendChild(hiddenPriceInput);
            
            // Disable submit button to prevent double submission
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Creating...';
        });
        
        function showAlert(message, type) {
            const alertContainer = document.getElementById('alertContainer');
            const alertClass = type === 'error' ? 'alert-error' : 'alert-success';
            
            alertContainer.innerHTML = `
                <div class="alert ${alertClass}">
                    ${message}
                </div>
            `;
            
            const alertElement = alertContainer.querySelector('.alert');
            alertElement.style.display = 'block';
            
            // Auto hide after 5 seconds
            setTimeout(() => {
                alertElement.style.display = 'none';
            }, 5000);
        }
        
        // Section Management
        let sectionCount = 0;
        
        function addSection() {
            sectionCount++;
            const sectionId = 'section_' + sectionCount;
            
            const sectionHTML = `
                <div class="section-item" id="${sectionId}">
                    <div class="section-header">
                        <span class="section-title">Section ${sectionCount}</span>
                        <button type="button" class="btn-remove-section" onclick="removeSection('${sectionId}')">
                            <i class="fas fa-times"></i> Remove
                        </button>
                    </div>
                    <input type="text" 
                           class="section-input" 
                           name="sectionTitle[]" 
                           placeholder="Section title" 
                           required>
                    <textarea class="section-input" 
                              name="sectionDescription[]" 
                              placeholder="Section description (optional)" 
                              rows="2"></textarea>
                </div>
            `;
            
            document.getElementById('sectionsContainer').insertAdjacentHTML('beforeend', sectionHTML);
        }
        
        function removeSection(sectionId) {
            const section = document.getElementById(sectionId);
            if (section) {
                section.remove();
                updateSectionNumbers();
            }
        }
        
        function updateSectionNumbers() {
            const sections = document.querySelectorAll('.section-item');
            sections.forEach((section, index) => {
                const title = section.querySelector('.section-title');
                if (title) {
                    title.textContent = 'Section ' + (index + 1);
                }
            });
        }
        
        // Check for success/error messages from server
        <% 
            String successMsg = (String) request.getAttribute("successMsg");
            String errorMsg = (String) request.getAttribute("errorMsg");
            if (successMsg != null) { %>
                showAlert('<%= successMsg %>', 'success');
        <%  } else if (errorMsg != null) { %>
                showAlert('<%= errorMsg %>', 'error');
        <%  } 
        %>
    </script>
</body>
</html>
