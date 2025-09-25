<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Admin Account - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <nav class="sidebar">
            <div class="sidebar-header">
                <h3>Create Admin</h3>
            </div>
            <ul class="nav-menu">
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/dashboard" class="nav-link">
                        <i class="fas fa-tachometer-alt"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/accountmanagement" class="nav-link">
                        <i class="fas fa-users"></i>
                        <span>Account Management</span>
                    </a>
                </li>
                <li class="nav-item active">
                    <a href="${pageContext.request.contextPath}/createadmin" class="nav-link">
                        <i class="fas fa-user-plus"></i>
                        <span>Create Admin</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/notification" class="nav-link">
                        <i class="fas fa-bell"></i>
                        <span>Notification Management</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link">
                        <i class="fas fa-flag"></i>
                        <span>Reported Groups</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/reportedcourse" class="nav-link">
                        <i class="fas fa-book"></i>
                        <span>Reported Courses</span>
                    </a>
                </li>
                 <li class="nav-item ">
                    <a href="" class="nav-link">
                        <i class="fas fa-book"></i>
                        <span>Leaner View</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link">
                        <i class="fas fa-sign-out-alt"></i>
                        <span>Sign Out</span>
                    </a>
                </li>
            </ul>
        </nav>

        <!-- Main Content -->
        <main class="main-content">
            <div class="content-header">
                <div class="header-left">
                    <h1>Create Admin Account</h1>
                </div>
                <div class="header-right">
                    <button class="btn-action btn-secondary" onclick="resetForm()">
                        <i class="fas fa-undo"></i>
                        Reset
                    </button>
                </div>
            </div>

            <div class="form-container">
                <form id="createAdminForm" action="${pageContext.request.contextPath}/admin/create" method="POST" class="admin-form">
                    <div class="form-section">
                        <h3>Account Information</h3>

                        <div class="form-group">
                            <label for="username">Username <span class="required">*</span></label>
                            <div class="input-group">
                                <i class="fas fa-user input-icon"></i>
                                <input type="text" id="username" name="username" required
                                       placeholder="Enter username" minlength="3" maxlength="50">
                            </div>
                            <div class="form-help">Username must be 3-50 characters long</div>
                        </div>

                        <div class="form-group">
                            <label for="email">Email Address <span class="required">*</span></label>
                            <div class="input-group">
                                <i class="fas fa-envelope input-icon"></i>
                                <input type="email" id="email" name="email" required
                                       placeholder="Enter email address">
                            </div>
                            <div class="form-help">Enter a valid email address</div>
                        </div>

                        <div class="form-group">
                            <label for="fullName">Full Name <span class="required">*</span></label>
                            <div class="input-group">
                                <i class="fas fa-id-card input-icon"></i>
                                <input type="text" id="fullName" name="fullName" required
                                       placeholder="Enter full name" minlength="2" maxlength="100">
                            </div>
                            <div class="form-help">Enter the admin's full name</div>
                        </div>

                        <div class="form-group">
                            <label for="phone">Phone Number</label>
                            <div class="input-group">
                                <i class="fas fa-phone input-icon"></i>
                                <input type="tel" id="phone" name="phone"
                                       placeholder="Enter phone number" pattern="[0-9]{10,11}">
                            </div>
                            <div class="form-help">Optional: Enter phone number (10-11 digits)</div>
                        </div>
                    </div>

                    <div class="form-section">
                        <h3>Security Settings</h3>

                        <div class="form-group">
                            <label for="password">Password <span class="required">*</span></label>
                            <div class="input-group">
                                <i class="fas fa-lock input-icon"></i>
                                <input type="password" id="password" name="password" required
                                       placeholder="Enter password" minlength="8">
                                <button type="button" class="password-toggle" onclick="togglePassword('password')">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                            <div class="form-help">Password must be at least 8 characters long</div>
                        </div>

                        <div class="form-group">
                            <label for="confirmPassword">Confirm Password <span class="required">*</span></label>
                            <div class="input-group">
                                <i class="fas fa-lock input-icon"></i>
                                <input type="password" id="confirmPassword" name="confirmPassword" required
                                       placeholder="Confirm password">
                                <button type="button" class="password-toggle" onclick="togglePassword('confirmPassword')">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                            <div class="form-help">Re-enter the password to confirm</div>
                        </div>

                        <div class="form-group">
                            <label for="role">Role</label>
                            <div class="input-group">
                                <i class="fas fa-user-shield input-icon"></i>
                                <select id="role" name="role" required>
                                    <option value="">Select Role</option>
                                    <option value="Admin">Admin</option>
                                    <option value="Super Admin">Super Admin</option>
                                    <option value="Moderator">Moderator</option>
                                </select>
                            </div>
                            <div class="form-help">Select the appropriate admin role</div>
                        </div>
                    </div>



                    <div class="form-actions">
                        <button type="button" class="btn-action btn-secondary" onclick="resetForm()">
                            <i class="fas fa-undo"></i>
                            Reset Form
                        </button>
                        <button type="submit" class="btn-action btn-primary">
                            <i class="fas fa-save"></i>
                            Create Admin Account
                        </button>
                    </div>
                </form>
            </div>
        </main>
    </div>

    <!-- JavaScript -->
    <script>
        // Toggle password visibility
        function togglePassword(fieldId) {
            const field = document.getElementById(fieldId);
            const toggle = field.parentElement.querySelector('.password-toggle i');

            if (field.type === 'password') {
                field.type = 'text';
                toggle.className = 'fas fa-eye-slash';
            } else {
                field.type = 'password';
                toggle.className = 'fas fa-eye';
            }
        }

        // Reset form
        function resetForm() {
            if (confirm('Are you sure you want to reset the form? All entered data will be lost.')) {
                document.getElementById('createAdminForm').reset();
                clearErrors();
            }
        }

        // Clear validation errors
        function clearErrors() {
            const errorElements = document.querySelectorAll('.error-message');
            errorElements.forEach(el => el.remove());
            const inputs = document.querySelectorAll('input, select');
            inputs.forEach(input => input.classList.remove('error'));
        }

        // Form validation
        document.getElementById('createAdminForm').addEventListener('submit', function(e) {
            e.preventDefault();
            clearErrors();

            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;

            // Check if passwords match
            if (password !== confirmPassword) {
                showError('confirmPassword', 'Passwords do not match');
                return false;
            }

            // Check password strength
            if (password.length < 8) {
                showError('password', 'Password must be at least 8 characters long');
                return false;
            }

            // If validation passes, submit the form
            this.submit();
        });

        // Show error message
        function showError(fieldId, message) {
            const field = document.getElementById(fieldId);
            field.classList.add('error');

            const errorDiv = document.createElement('div');
            errorDiv.className = 'error-message';
            errorDiv.textContent = message;

            field.parentElement.appendChild(errorDiv);
        }

        // Real-time validation
        document.getElementById('confirmPassword').addEventListener('input', function() {
            const password = document.getElementById('password').value;
            const confirmPassword = this.value;

            if (password && confirmPassword && password !== confirmPassword) {
                showError('confirmPassword', 'Passwords do not match');
            } else {
                clearErrors();
            }
        });

        // Username validation
        document.getElementById('username').addEventListener('input', function() {
            const username = this.value;
            if (username.length > 0 && username.length < 3) {
                showError('username', 'Username must be at least 3 characters long');
            } else {
                clearErrors();
            }
        });
    </script>
</body>
</html>
