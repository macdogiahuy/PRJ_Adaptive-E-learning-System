<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Real Data Chat Test</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .chat-container {
            height: 400px;
            overflow-y: auto;
            border: 1px solid #ddd;
            background: #f8f9fa;
        }
        .message {
            margin: 10px;
            padding: 8px 12px;
            border-radius: 8px;
            max-width: 70%;
        }
        .message.own {
            background: #007bff;
            color: white;
            margin-left: auto;
        }
        .message.other {
            background: white;
            border: 1px solid #ddd;
        }
        .typing-indicator {
            font-style: italic;
            color: #666;
            padding: 5px 15px;
        }
        .user-card {
            cursor: pointer;
            transition: all 0.3s;
        }
        .user-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .status-badge {
            position: absolute;
            top: 10px;
            right: 10px;
        }
        .avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
        }
        .data-preview {
            max-height: 300px;
            overflow-y: auto;
            font-size: 0.9em;
        }
    </style>
</head>
<body>
    <div class="container-fluid py-4">
        <div class="row">
            <div class="col-12">
                <h1 class="text-center mb-4">
                    <i class="fas fa-database"></i> Real Data Chat Test
                </h1>
            </div>
        </div>
        
        <!-- Data Loading Section -->
        <div class="row mb-4">
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5><i class="fas fa-users"></i> Users</h5>
                    </div>
                    <div class="card-body">
                        <button class="btn btn-primary btn-sm w-100 mb-2" onclick="loadUsers()">
                            <i class="fas fa-refresh"></i> Load Real Users
                        </button>
                        <div id="users-data" class="data-preview"></div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header bg-success text-white">
                        <h5><i class="fas fa-book"></i> Courses</h5>
                    </div>
                    <div class="card-body">
                        <button class="btn btn-success btn-sm w-100 mb-2" onclick="loadCourses()">
                            <i class="fas fa-refresh"></i> Load Real Courses
                        </button>
                        <div id="courses-data" class="data-preview"></div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header bg-info text-white">
                        <h5><i class="fas fa-handshake"></i> Enrollments</h5>
                    </div>
                    <div class="card-body">
                        <button class="btn btn-info btn-sm w-100 mb-2" onclick="loadEnrollments()">
                            <i class="fas fa-refresh"></i> Load Real Enrollments
                        </button>
                        <div id="enrollments-data" class="data-preview"></div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Test Data Pairs -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-header bg-warning text-dark">
                        <h5><i class="fas fa-vial"></i> Test Data Pairs (User-Course)</h5>
                    </div>
                    <div class="card-body">
                        <button class="btn btn-warning btn-sm mb-3" onclick="loadTestPairs()">
                            <i class="fas fa-flask"></i> Load Test Pairs
                        </button>
                        <div id="test-pairs" class="row"></div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Chat Test Section -->
        <div class="row">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5><i class="fas fa-comments"></i> Chat Test với Dữ Liệu Thật</h5>
                        <div>
                            <span id="connection-status" class="badge bg-danger">Disconnected</span>
                            <button class="btn btn-sm btn-outline-primary ms-2" onclick="connectToChat()">
                                <i class="fas fa-plug"></i> Connect
                            </button>
                        </div>
                    </div>
                    <div class="card-body">
                        <!-- User Selection -->
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">User ID:</label>
                                <select id="user-select" class="form-select">
                                    <option value="">Select a real user...</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Course ID:</label>
                                <select id="course-select" class="form-select">
                                    <option value="">Select a real course...</option>
                                </select>
                            </div>
                        </div>
                        
                        <!-- Chat Messages -->
                        <div id="chat-messages" class="chat-container mb-3"></div>
                        
                        <!-- Message Input -->
                        <div class="input-group">
                            <input type="text" id="message-input" class="form-control" 
                                   placeholder="Nhập tin nhắn..." onkeypress="handleKeyPress(event)">
                            <button class="btn btn-primary" onclick="sendMessage()">
                                <i class="fas fa-paper-plane"></i> Send
                            </button>
                        </div>
                        
                        <div class="mt-2">
                            <small class="text-muted">
                                Chọn user và course từ dữ liệu thật, sau đó connect để test chat
                            </small>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header">
                        <h5><i class="fas fa-terminal"></i> Console Log</h5>
                    </div>
                    <div class="card-body">
                        <div id="console-log" style="height: 400px; overflow-y: auto; background: #000; color: #0f0; padding: 10px; font-family: monospace; font-size: 12px;"></div>
                        <button class="btn btn-sm btn-secondary mt-2 w-100" onclick="clearConsole()">
                            <i class="fas fa-trash"></i> Clear Log
                        </button>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Create Sample Data Button -->
        <div class="row mt-4">
            <div class="col-12 text-center">
                <button class="btn btn-danger" onclick="createSampleData()">
                    <i class="fas fa-database"></i> Create Sample Data (if database is empty)
                </button>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        let socket = null;
        let currentUserId = null;
        let currentCourseId = null;
        
        // Console logging function
        function log(message, type = 'info') {
            const console = document.getElementById('console-log');
            const timestamp = new Date().toLocaleTimeString();
            const color = type === 'error' ? '#f00' : type === 'success' ? '#0f0' : '#fff';
            console.innerHTML += `<div style="color: ${color}">[${timestamp}] ${message}</div>`;
            console.scrollTop = console.scrollHeight;
        }
        
        function clearConsole() {
            document.getElementById('console-log').innerHTML = '';
        }
        
        // Load real data functions
        async function loadUsers() {
            try {
                log('Loading real users from database...', 'info');
                const response = await fetch('/Adaptive_Elearning/api/test-data/users');
                const data = await response.json();
                
                if (data.success) {
                    displayUsers(data.users);
                    populateUserSelect(data.users);
                    log(`Loaded ${data.count} real users`, 'success');
                } else {
                    log('Error loading users: ' + data.error, 'error');
                }
            } catch (error) {
                log('Failed to load users: ' + error.message, 'error');
            }
        }
        
        async function loadCourses() {
            try {
                log('Loading real courses from database...', 'info');
                const response = await fetch('/Adaptive_Elearning/api/test-data/courses');
                const data = await response.json();
                
                if (data.success) {
                    displayCourses(data.courses);
                    populateCourseSelect(data.courses);
                    log(`Loaded ${data.count} real courses`, 'success');
                } else {
                    log('Error loading courses: ' + data.error, 'error');
                }
            } catch (error) {
                log('Failed to load courses: ' + error.message, 'error');
            }
        }
        
        async function loadEnrollments() {
            try {
                log('Loading real enrollments from database...', 'info');
                const response = await fetch('/Adaptive_Elearning/api/test-data/enrollments');
                const data = await response.json();
                
                if (data.success) {
                    displayEnrollments(data.enrollments);
                    log(`Loaded ${data.count} real enrollments`, 'success');
                } else {
                    log('Error loading enrollments: ' + data.error, 'error');
                }
            } catch (error) {
                log('Failed to load enrollments: ' + error.message, 'error');
            }
        }
        
        async function loadTestPairs() {
            try {
                log('Loading test data pairs...', 'info');
                const response = await fetch('/Adaptive_Elearning/api/test-data/sample-data');
                const data = await response.json();
                
                if (data.success) {
                    displayTestPairs(data.testPairs);
                    log(`Loaded ${data.count} test pairs`, 'success');
                } else {
                    log('Error loading test pairs: ' + data.error, 'error');
                }
            } catch (error) {
                log('Failed to load test pairs: ' + error.message, 'error');
            }
        }
        
        async function createSampleData() {
            try {
                log('Creating sample data...', 'info');
                const response = await fetch('/Adaptive_Elearning/api/test-data/create-sample');
                const data = await response.json();
                
                if (data.success) {
                    log('Sample data created successfully', 'success');
                    // Reload all data
                    loadUsers();
                    loadCourses();
                    loadEnrollments();
                } else {
                    log('Error creating sample data: ' + data.message, 'error');
                }
            } catch (error) {
                log('Failed to create sample data: ' + error.message, 'error');
            }
        }
        
        // Display functions
        function displayUsers(users) {
            const container = document.getElementById('users-data');
            let html = '';
            
            users.forEach(user => {
                html += `
                    <div class="border-bottom py-2">
                        <strong>${user.fullName}</strong> (${user.role})<br>
                        <small class="text-muted">ID: ${user.id}</small><br>
                        <small class="text-muted">Email: ${user.email}</small>
                    </div>
                `;
            });
            
            container.innerHTML = html;
        }
        
        function displayCourses(courses) {
            const container = document.getElementById('courses-data');
            let html = '';
            
            courses.forEach(course => {
                html += `
                    <div class="border-bottom py-2">
                        <strong>${course.title}</strong><br>
                        <small class="text-muted">ID: ${course.id}</small><br>
                        <small class="text-muted">Instructor: ${course.instructorName}</small><br>
                        <small class="text-muted">Learners: ${course.learnerCount}</small>
                    </div>
                `;
            });
            
            container.innerHTML = html;
        }
        
        function displayEnrollments(enrollments) {
            const container = document.getElementById('enrollments-data');
            let html = '';
            
            enrollments.forEach(enrollment => {
                html += `
                    <div class="border-bottom py-2">
                        <strong>${enrollment.studentName}</strong><br>
                        <small class="text-muted">Course: ${enrollment.courseTitle}</small><br>
                        <small class="text-muted">Status: ${enrollment.status}</small>
                    </div>
                `;
            });
            
            container.innerHTML = html;
        }
        
        function displayTestPairs(testPairs) {
            const container = document.getElementById('test-pairs');
            let html = '';
            
            testPairs.forEach((pair, index) => {
                html += `
                    <div class="col-md-6 mb-3">
                        <div class="card user-card" onclick="selectTestPair('${pair.userId}', '${pair.courseId}')">
                            <div class="card-body position-relative">
                                <span class="badge bg-primary status-badge">#${index + 1}</span>
                                <h6 class="card-title">${pair.userName}</h6>
                                <p class="card-text">
                                    <strong>Course:</strong> ${pair.courseTitle}<br>
                                    <small class="text-muted">User ID: ${pair.userId}</small><br>
                                    <small class="text-muted">Course ID: ${pair.courseId}</small>
                                </p>
                                <button class="btn btn-sm btn-primary">
                                    <i class="fas fa-mouse-pointer"></i> Select for Chat
                                </button>
                            </div>
                        </div>
                    </div>
                `;
            });
            
            container.innerHTML = html;
        }
        
        function populateUserSelect(users) {
            const select = document.getElementById('user-select');
            select.innerHTML = '<option value="">Select a real user...</option>';
            
            users.forEach(user => {
                const option = document.createElement('option');
                option.value = user.id;
                option.textContent = `${user.fullName} (${user.email})`;
                select.appendChild(option);
            });
        }
        
        function populateCourseSelect(courses) {
            const select = document.getElementById('course-select');
            select.innerHTML = '<option value="">Select a real course...</option>';
            
            courses.forEach(course => {
                const option = document.createElement('option');
                option.value = course.id;
                option.textContent = course.title;
                select.appendChild(option);
            });
        }
        
        function selectTestPair(userId, courseId) {
            document.getElementById('user-select').value = userId;
            document.getElementById('course-select').value = courseId;
            log(`Selected test pair - User: ${userId}, Course: ${courseId}`, 'success');
        }
        
        // WebSocket chat functions
        function connectToChat() {
            const userId = document.getElementById('user-select').value;
            const courseId = document.getElementById('course-select').value;
            
            if (!userId || !courseId) {
                alert('Please select both user and course');
                return;
            }
            
            currentUserId = userId;
            currentCourseId = courseId;
            
            try {
                const wsUrl = `ws://localhost:8080/Adaptive_Elearning/course-chat/${courseId}?userId=${userId}`;
                log(`Connecting to: ${wsUrl}`, 'info');
                
                socket = new WebSocket(wsUrl);
                
                socket.onopen = function(event) {
                    log('Connected to chat successfully!', 'success');
                    document.getElementById('connection-status').className = 'badge bg-success';
                    document.getElementById('connection-status').textContent = 'Connected';
                };
                
                socket.onmessage = function(event) {
                    log('Received message: ' + event.data, 'info');
                    const message = JSON.parse(event.data);
                    displayMessage(message);
                };
                
                socket.onclose = function(event) {
                    log('Chat connection closed', 'error');
                    document.getElementById('connection-status').className = 'badge bg-danger';
                    document.getElementById('connection-status').textContent = 'Disconnected';
                };
                
                socket.onerror = function(error) {
                    log('WebSocket error: ' + error, 'error');
                };
                
            } catch (error) {
                log('Failed to connect: ' + error.message, 'error');
            }
        }
        
        function sendMessage() {
            const messageInput = document.getElementById('message-input');
            const message = messageInput.value.trim();
            
            if (!message || !socket || socket.readyState !== WebSocket.OPEN) {
                return;
            }
            
            const messageData = {
                type: 'chat',
                content: message,
                userId: currentUserId,
                courseId: currentCourseId,
                timestamp: new Date().toISOString()
            };
            
            socket.send(JSON.stringify(messageData));
            log('Sent message: ' + message, 'success');
            messageInput.value = '';
        }
        
        function displayMessage(message) {
            const chatContainer = document.getElementById('chat-messages');
            const messageDiv = document.createElement('div');
            messageDiv.className = `message ${message.userId === currentUserId ? 'own' : 'other'}`;
            
            const timestamp = new Date(message.timestamp).toLocaleTimeString();
            messageDiv.innerHTML = `
                <div><strong>${message.userName || 'User'}</strong> <small>${timestamp}</small></div>
                <div>${message.content}</div>
            `;
            
            chatContainer.appendChild(messageDiv);
            chatContainer.scrollTop = chatContainer.scrollHeight;
        }
        
        function handleKeyPress(event) {
            if (event.key === 'Enter') {
                sendMessage();
            }
        }
        
        // Auto-load data when page loads
        window.onload = function() {
            log('Real Data Chat Test initialized', 'success');
            log('Click buttons to load real data from your database', 'info');
            loadUsers();
            loadCourses();
            loadEnrollments();
        };
    </script>
</body>
</html>