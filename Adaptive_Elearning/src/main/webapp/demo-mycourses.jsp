<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Users"%>
<%
    Users u = (Users) session.getAttribute("account");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Demo - My Courses Feature</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .demo-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 3rem 0;
        }
        .feature-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        .feature-card:hover {
            transform: translateY(-5px);
        }
        .btn-demo {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 10px;
            padding: 12px 30px;
            color: white;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-demo:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
            color: white;
        }
        .workflow-step {
            background: #f8f9fa;
            padding: 1.5rem;
            border-radius: 10px;
            margin-bottom: 1rem;
            border-left: 4px solid #667eea;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="#">
                <i class="fas fa-graduation-cap me-2"></i>CourseHub Demo
            </a>
            <div class="navbar-nav ms-auto">
                <% if (u != null) { %>
                    <span class="navbar-text me-3">
                        <i class="fas fa-user-circle me-1"></i>Welcome, <%= u.getUserName() %>
                    </span>
                <% } else { %>
                    <span class="navbar-text text-warning">
                        <i class="fas fa-exclamation-triangle me-1"></i>Please login to test features
                    </span>
                <% } %>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <div class="demo-section">
        <div class="container text-center">
            <h1 class="display-4 fw-bold mb-4">
                <i class="fas fa-book-open me-3"></i>My Courses Feature Demo
            </h1>
            <p class="lead mb-4">
                Test the complete checkout → my-courses integration flow
            </p>
            <div class="row justify-content-center">
                <div class="col-md-8">
                    <div class="alert alert-light" role="alert">
                        <strong>🎯 Feature Overview:</strong> 
                        After successful checkout, users are redirected to "My Courses" page where they can view and manage their enrolled courses permanently.
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="container py-5">
        <!-- Demo Buttons -->
        <div class="row mb-5">
            <div class="col-md-6 mb-3">
                <div class="card feature-card h-100">
                    <div class="card-body text-center">
                        <i class="fas fa-play-circle fa-3x text-primary mb-3"></i>
                        <h5>Test Checkout Flow</h5>
                        <p class="text-muted">Simulate the complete checkout process with test data</p>
                        <a href="<%=request.getContextPath()%>/test-checkout-flow" class="btn btn-demo">
                            <i class="fas fa-cog me-2"></i>Run Test
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-6 mb-3">
                <div class="card feature-card h-100">
                    <div class="card-body text-center">
                        <i class="fas fa-book fa-3x text-success mb-3"></i>
                        <h5>My Courses Page</h5>
                        <p class="text-muted">View your enrolled courses and learning progress</p>
                        <a href="<%=request.getContextPath()%>/my-courses" class="btn btn-demo">
                            <i class="fas fa-book me-2"></i>View My Courses
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Workflow -->
        <div class="row">
            <div class="col-12">
                <h2 class="text-center mb-4">
                    <i class="fas fa-route me-2 text-primary"></i>Complete User Journey
                </h2>
                
                <div class="workflow-step">
                    <div class="d-flex align-items-center">
                        <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center me-3" style="width: 40px; height: 40px;">
                            <strong>1</strong>
                        </div>
                        <div>
                            <h6 class="mb-1">Browse Courses & Add to Cart</h6>
                            <small class="text-muted">User explores courses and builds their cart</small>
                        </div>
                    </div>
                </div>

                <div class="workflow-step">
                    <div class="d-flex align-items-center">
                        <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center me-3" style="width: 40px; height: 40px;">
                            <strong>2</strong>
                        </div>
                        <div>
                            <h6 class="mb-1">Proceed to Checkout</h6>
                            <small class="text-muted">Choose payment method (COD or Online VietQR)</small>
                        </div>
                    </div>
                </div>

                <div class="workflow-step">
                    <div class="d-flex align-items-center">
                        <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center me-3" style="width: 40px; height: 40px;">
                            <strong>3</strong>
                        </div>
                        <div>
                            <h6 class="mb-1">Database Processing</h6>
                            <small class="text-muted">Stored procedures create Bills and Enrollments</small>
                        </div>
                    </div>
                </div>

                <div class="workflow-step">
                    <div class="d-flex align-items-center">
                        <div class="rounded-circle bg-success text-white d-flex align-items-center justify-content-center me-3" style="width: 40px; height: 40px;">
                            <strong>4</strong>
                        </div>
                        <div>
                            <h6 class="mb-1">Redirect to My Courses</h6>
                            <small class="text-muted">Success message + permanent course access</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Features -->
        <div class="row mt-5">
            <div class="col-12">
                <h2 class="text-center mb-4">
                    <i class="fas fa-star me-2 text-warning"></i>Key Features
                </h2>
            </div>
            <div class="col-md-4 mb-3">
                <div class="card feature-card h-100">
                    <div class="card-body">
                        <i class="fas fa-infinity text-primary mb-3" style="font-size: 2rem;"></i>
                        <h6>Permanent Storage</h6>
                        <small class="text-muted">Courses are permanently linked to user accounts</small>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-3">
                <div class="card feature-card h-100">
                    <div class="card-body">
                        <i class="fas fa-chart-line text-success mb-3" style="font-size: 2rem;"></i>
                        <h6>Progress Tracking</h6>
                        <small class="text-muted">Visual progress bars and learning statistics</small>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-3">
                <div class="card feature-card h-100">
                    <div class="card-body">
                        <i class="fas fa-mobile-alt text-info mb-3" style="font-size: 2rem;"></i>
                        <h6>Responsive Design</h6>
                        <small class="text-muted">Perfect experience on all devices</small>
                    </div>
                </div>
            </div>
        </div>

        <!-- Navigation Test -->
        <div class="row mt-5">
            <div class="col-12">
                <div class="card">
                    <div class="card-header bg-light">
                        <h5 class="mb-0">
                            <i class="fas fa-compass me-2"></i>Navigation Test
                        </h5>
                    </div>
                    <div class="card-body">
                        <p class="mb-3">Test all navigation paths:</p>
                        <div class="d-flex flex-wrap gap-2">
                            <a href="<%=request.getContextPath()%>/" class="btn btn-outline-primary btn-sm">
                                <i class="fas fa-home me-1"></i>Home
                            </a>
                            <a href="<%=request.getContextPath()%>/cart.jsp" class="btn btn-outline-info btn-sm">
                                <i class="fas fa-shopping-cart me-1"></i>Cart
                            </a>
                            <a href="<%=request.getContextPath()%>/checkout.jsp" class="btn btn-outline-warning btn-sm">
                                <i class="fas fa-credit-card me-1"></i>Checkout
                            </a>
                            <a href="<%=request.getContextPath()%>/my-courses" class="btn btn-outline-success btn-sm">
                                <i class="fas fa-book me-1"></i>My Courses
                            </a>
                            <a href="<%=request.getContextPath()%>/my-courses?checkout=success" class="btn btn-outline-danger btn-sm">
                                <i class="fas fa-check-circle me-1"></i>Success Flow
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Debug Info -->
        <% if (u != null) { %>
        <div class="row mt-4">
            <div class="col-12">
                <div class="alert alert-info">
                    <h6><i class="fas fa-info-circle me-2"></i>Debug Information</h6>
                    <ul class="mb-0">
                        <li><strong>User ID:</strong> <%= u.getId() %></li>
                        <li><strong>Username:</strong> <%= u.getUserName() %></li>
                        <li><strong>Email:</strong> <%= u.getEmail() %></li>
                        <li><strong>Session ID:</strong> <%= session.getId() %></li>
                        <li><strong>Context Path:</strong> <%= request.getContextPath() %></li>
                    </ul>
                </div>
            </div>
        </div>
        <% } %>
    </div>

    <!-- Footer -->
    <footer class="bg-dark text-light py-4 mt-5">
        <div class="container text-center">
            <p class="mb-0">
                <i class="fas fa-code me-2"></i>
                My Courses Feature Demo - CourseHub Platform
            </p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>