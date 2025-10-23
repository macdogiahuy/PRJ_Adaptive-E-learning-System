<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Database Viewer - Real Data</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .table-container {
            max-height: 400px;
            overflow-y: auto;
        }
        .data-card {
            transition: transform 0.2s;
        }
        .data-card:hover {
            transform: translateY(-2px);
        }
        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .refresh-btn {
            position: absolute;
            top: 10px;
            right: 10px;
        }
        .json-view {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 5px;
            padding: 10px;
            font-family: monospace;
            font-size: 0.9em;
            max-height: 300px;
            overflow-y: auto;
        }
    </style>
</head>
<body>
    <div class="container-fluid py-4">
        <div class="row">
            <div class="col-12">
                <h1 class="text-center mb-4">
                    <i class="fas fa-database"></i> Database Viewer - Dữ Liệu Thật
                </h1>
            </div>
        </div>
        
        <!-- Statistics Cards -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card stat-card">
                    <div class="card-body text-center">
                        <i class="fas fa-users fa-2x mb-2"></i>
                        <h3 id="users-count">-</h3>
                        <p class="mb-0">Users</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card">
                    <div class="card-body text-center">
                        <i class="fas fa-book fa-2x mb-2"></i>
                        <h3 id="courses-count">-</h3>
                        <p class="mb-0">Courses</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card">
                    <div class="card-body text-center">
                        <i class="fas fa-handshake fa-2x mb-2"></i>
                        <h3 id="enrollments-count">-</h3>
                        <p class="mb-0">Enrollments</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card">
                    <div class="card-body text-center">
                        <i class="fas fa-comments fa-2x mb-2"></i>
                        <h3 id="conversations-count">-</h3>
                        <p class="mb-0">Conversations</p>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Data Tables -->
        <div class="row">
            <!-- Users Table -->
            <div class="col-md-6 mb-4">
                <div class="card data-card position-relative">
                    <button class="btn btn-sm btn-outline-primary refresh-btn" onclick="loadUsers()">
                        <i class="fas fa-refresh"></i>
                    </button>
                    <div class="card-header bg-primary text-white">
                        <h5><i class="fas fa-users"></i> Users Table</h5>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-container">
                            <table class="table table-striped table-hover mb-0">
                                <thead class="table-dark sticky-top">
                                    <tr>
                                        <th>Full Name</th>
                                        <th>Email</th>
                                        <th>Role</th>
                                        <th>Verified</th>
                                    </tr>
                                </thead>
                                <tbody id="users-table-body">
                                    <tr>
                                        <td colspan="4" class="text-center">
                                            <i class="fas fa-spinner fa-spin"></i> Loading...
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Courses Table -->
            <div class="col-md-6 mb-4">
                <div class="card data-card position-relative">
                    <button class="btn btn-sm btn-outline-success refresh-btn" onclick="loadCourses()">
                        <i class="fas fa-refresh"></i>
                    </button>
                    <div class="card-header bg-success text-white">
                        <h5><i class="fas fa-book"></i> Courses Table</h5>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-container">
                            <table class="table table-striped table-hover mb-0">
                                <thead class="table-dark sticky-top">
                                    <tr>
                                        <th>Title</th>
                                        <th>Status</th>
                                        <th>Price</th>
                                        <th>Learners</th>
                                    </tr>
                                </thead>
                                <tbody id="courses-table-body">
                                    <tr>
                                        <td colspan="4" class="text-center">
                                            <i class="fas fa-spinner fa-spin"></i> Loading...
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row">
            <!-- Enrollments Table -->
            <div class="col-12 mb-4">
                <div class="card data-card position-relative">
                    <button class="btn btn-sm btn-outline-info refresh-btn" onclick="loadEnrollments()">
                        <i class="fas fa-refresh"></i>
                    </button>
                    <div class="card-header bg-info text-white">
                        <h5><i class="fas fa-handshake"></i> Enrollments Table</h5>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-container">
                            <table class="table table-striped table-hover mb-0">
                                <thead class="table-dark sticky-top">
                                    <tr>
                                        <th>Student Name</th>
                                        <th>Course Title</th>
                                        <th>Status</th>
                                        <th>Enrollment Date</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody id="enrollments-table-body">
                                    <tr>
                                        <td colspan="5" class="text-center">
                                            <i class="fas fa-spinner fa-spin"></i> Loading...
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Action Buttons -->
        <div class="row mb-4">
            <div class="col-12 text-center">
                <button class="btn btn-primary me-2" onclick="loadAllData()">
                    <i class="fas fa-sync"></i> Refresh All Data
                </button>
                <button class="btn btn-warning me-2" onclick="showTestPairs()">
                    <i class="fas fa-vial"></i> Show Test Pairs
                </button>
                <button class="btn btn-success me-2" onclick="openChatTest()" id="chat-test-btn" disabled>
                    <i class="fas fa-comments"></i> Open Chat Test
                </button>
                <button class="btn btn-danger" onclick="createSampleData()">
                    <i class="fas fa-plus"></i> Create Sample Data
                </button>
            </div>
        </div>
        
        <!-- Test Pairs Modal -->
        <div class="modal fade" id="testPairsModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-vial"></i> Test Data Pairs
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div id="test-pairs-content">
                            <div class="text-center">
                                <i class="fas fa-spinner fa-spin"></i> Loading test pairs...
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="button" class="btn btn-primary" onclick="openChatWithTestData()">
                            <i class="fas fa-comments"></i> Open Chat Test
                        </button>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- JSON Detail Modal -->
        <div class="modal fade" id="jsonModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-code"></i> JSON Details
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div id="json-content" class="json-view"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        let allUsers = [];
        let allCourses = [];
        let allEnrollments = [];
        let testPairs = [];
        
        // Load all data on page load
        window.onload = function() {
            loadAllData();
        };
        
        function loadAllData() {
            loadUsers();
            loadCourses();
            loadEnrollments();
        }
        
        async function loadUsers() {
            try {
                const response = await fetch('/Adaptive_Elearning/api/test-data/users');
                const data = await response.json();
                
                if (data.success) {
                    allUsers = data.users;
                    displayUsers(data.users);
                    document.getElementById('users-count').textContent = data.count;
                    updateChatTestButton();
                } else {
                    console.error('Error loading users:', data.error);
                    displayError('users-table-body', 'Error loading users: ' + data.error);
                }
            } catch (error) {
                console.error('Failed to load users:', error);
                displayError('users-table-body', 'Failed to load users');
            }
        }
        
        async function loadCourses() {
            try {
                const response = await fetch('/Adaptive_Elearning/api/test-data/courses');
                const data = await response.json();
                
                if (data.success) {
                    allCourses = data.courses;
                    displayCourses(data.courses);
                    document.getElementById('courses-count').textContent = data.count;
                    updateChatTestButton();
                } else {
                    console.error('Error loading courses:', data.error);
                    displayError('courses-table-body', 'Error loading courses: ' + data.error);
                }
            } catch (error) {
                console.error('Failed to load courses:', error);
                displayError('courses-table-body', 'Failed to load courses');
            }
        }
        
        async function loadEnrollments() {
            try {
                const response = await fetch('/Adaptive_Elearning/api/test-data/enrollments');
                const data = await response.json();
                
                if (data.success) {
                    allEnrollments = data.enrollments;
                    displayEnrollments(data.enrollments);
                    document.getElementById('enrollments-count').textContent = data.count;
                } else {
                    console.error('Error loading enrollments:', data.error);
                    displayError('enrollments-table-body', 'Error loading enrollments: ' + data.error);
                }
            } catch (error) {
                console.error('Failed to load enrollments:', error);
                displayError('enrollments-table-body', 'Failed to load enrollments');
            }
        }
        
        function displayUsers(users) {
            const tbody = document.getElementById('users-table-body');
            
            if (users.length === 0) {
                tbody.innerHTML = '<tr><td colspan="4" class="text-center text-muted">No users found</td></tr>';
                return;
            }
            
            let html = '';
            users.forEach(user => {
                html += `
                    <tr onclick="showJsonDetail('User', ${JSON.stringify(user).replace(/"/g, '&quot;')})" style="cursor: pointer;">
                        <td>${user.fullName || 'N/A'}</td>
                        <td>${user.email || 'N/A'}</td>
                        <td><span class="badge bg-${user.role === 'Student' ? 'primary' : 'success'}">${user.role}</span></td>
                        <td><span class="badge bg-${user.isVerified ? 'success' : 'danger'}">${user.isVerified ? 'Yes' : 'No'}</span></td>
                    </tr>
                `;
            });
            
            tbody.innerHTML = html;
        }
        
        function displayCourses(courses) {
            const tbody = document.getElementById('courses-table-body');
            
            if (courses.length === 0) {
                tbody.innerHTML = '<tr><td colspan="4" class="text-center text-muted">No courses found</td></tr>';
                return;
            }
            
            let html = '';
            courses.forEach(course => {
                html += `
                    <tr onclick="showJsonDetail('Course', ${JSON.stringify(course).replace(/"/g, '&quot;')})" style="cursor: pointer;">
                        <td>${course.title || 'N/A'}</td>
                        <td><span class="badge bg-success">${course.status}</span></td>
                        <td>$${course.price || '0'}</td>
                        <td>${course.learnerCount || '0'}</td>
                    </tr>
                `;
            });
            
            tbody.innerHTML = html;
        }
        
        function displayEnrollments(enrollments) {
            const tbody = document.getElementById('enrollments-table-body');
            
            if (enrollments.length === 0) {
                tbody.innerHTML = '<tr><td colspan="5" class="text-center text-muted">No enrollments found</td></tr>';
                return;
            }
            
            let html = '';
            enrollments.forEach(enrollment => {
                const date = new Date(enrollment.creationTime).toLocaleDateString();
                
                html += `
                    <tr onclick="showJsonDetail('Enrollment', ${JSON.stringify(enrollment).replace(/"/g, '&quot;')})" style="cursor: pointer;">
                        <td>${enrollment.studentName || 'N/A'}</td>
                        <td>${enrollment.courseTitle || 'N/A'}</td>
                        <td><span class="badge bg-success">${enrollment.status}</span></td>
                        <td>${date}</td>
                        <td>
                            <button class="btn btn-sm btn-primary" onclick="event.stopPropagation(); testChatWithEnrollment('${enrollment.userId}', '${enrollment.courseId}')">
                                <i class="fas fa-comments"></i> Test Chat
                            </button>
                        </td>
                    </tr>
                `;
            });
            
            tbody.innerHTML = html;
        }
        
        function displayError(elementId, message) {
            const element = document.getElementById(elementId);
            element.innerHTML = `<tr><td colspan="10" class="text-center text-danger">${message}</td></tr>`;
        }
        
        function updateChatTestButton() {
            const btn = document.getElementById('chat-test-btn');
            if (allUsers.length > 0 && allCourses.length > 0) {
                btn.disabled = false;
                btn.classList.remove('btn-secondary');
                btn.classList.add('btn-success');
            }
        }
        
        async function showTestPairs() {
            try {
                const response = await fetch('/Adaptive_Elearning/api/test-data/sample-data');
                const data = await response.json();
                
                if (data.success) {
                    testPairs = data.testPairs;
                    displayTestPairsModal(data.testPairs);
                } else {
                    alert('Error loading test pairs: ' + data.error);
                }
            } catch (error) {
                alert('Failed to load test pairs: ' + error.message);
            }
        }
        
        function displayTestPairsModal(pairs) {
            const content = document.getElementById('test-pairs-content');
            
            if (pairs.length === 0) {
                content.innerHTML = '<div class="text-center text-muted">No valid user-course pairs found</div>';
            } else {
                let html = '<div class="row">';
                pairs.forEach((pair, index) => {
                    html += `
                        <div class="col-md-6 mb-3">
                            <div class="card">
                                <div class="card-body">
                                    <h6 class="card-title">${pair.userName}</h6>
                                    <p class="card-text">
                                        <strong>Course:</strong> ${pair.courseTitle}<br>
                                        <small class="text-muted">User ID: ${pair.userId}</small><br>
                                        <small class="text-muted">Course ID: ${pair.courseId}</small>
                                    </p>
                                    <button class="btn btn-sm btn-primary" onclick="testChatWithPair('${pair.userId}', '${pair.courseId}')">
                                        <i class="fas fa-comments"></i> Test Chat
                                    </button>
                                </div>
                            </div>
                        </div>
                    `;
                });
                html += '</div>';
                content.innerHTML = html;
            }
            
            new bootstrap.Modal(document.getElementById('testPairsModal')).show();
        }
        
        function showJsonDetail(type, data) {
            document.querySelector('#jsonModal .modal-title').innerHTML = `<i class="fas fa-code"></i> ${type} Details`;
            document.getElementById('json-content').textContent = JSON.stringify(data, null, 2);
            new bootstrap.Modal(document.getElementById('jsonModal')).show();
        }
        
        function openChatTest() {
            window.open('real_data_chat_test.jsp', '_blank');
        }
        
        function openChatWithTestData() {
            window.open('real_data_chat_test.jsp', '_blank');
            bootstrap.Modal.getInstance(document.getElementById('testPairsModal')).hide();
        }
        
        function testChatWithPair(userId, courseId) {
            const url = `real_data_chat_test.jsp?userId=${userId}&courseId=${courseId}`;
            window.open(url, '_blank');
        }
        
        function testChatWithEnrollment(userId, courseId) {
            const url = `real_data_chat_test.jsp?userId=${userId}&courseId=${courseId}`;
            window.open(url, '_blank');
        }
        
        async function createSampleData() {
            if (!confirm('This will create sample data in your database. Continue?')) {
                return;
            }
            
            try {
                const response = await fetch('/Adaptive_Elearning/api/test-data/create-sample');
                const data = await response.json();
                
                if (data.success) {
                    alert('Sample data created successfully!');
                    loadAllData();
                } else {
                    alert('Error creating sample data: ' + data.message);
                }
            } catch (error) {
                alert('Failed to create sample data: ' + error.message);
            }
        }
    </script>
</body>
</html>