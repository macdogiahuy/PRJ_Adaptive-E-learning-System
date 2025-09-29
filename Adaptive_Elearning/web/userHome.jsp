<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>
<!--<!DOCTYPE html>
<html>
<head>
    <title>Home - User</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="assets/css/home.css">
</head>
<body>

<header class="page-header">
    <div class="container-fluid d-flex justify-content-between align-items-center">
        <img src="logo.png" alt="Logo" style="height:50px;">
        <nav class="top-links">
            <a href="#">Home</a>
            <a href="#">Courses</a>
            <a href="#">Learning Groups</a>
        </nav>
        
        <div class="search-bar">
            <input type="text" placeholder="Search courses...">
            <button>Search</button>
        </div>

        <div class="d-flex align-items-center gap-3">
            <span class="badge-user">Fgn85761</span>
            <div class="bell"><i class="bi bi-bell-fill"></i></div>
        </div>
    </div>
</header>

<section class="hero text-center">
    <h1>Get The Best Online Courses</h1>
</section>

<section class="courses container mt-5">
    <h3 class="mb-4">Featured Courses</h3>
    
</section>

<section class="featured-courses">
    <h2>Featured Courses</h2>
    <div class="course-list">
        <div class="course-card">
            <img src="assets/images/course1.jpg" alt="Course 1">
            <h3>Java Programming Basics</h3>
            <p>Learn the fundamentals of Java programming.</p>
            <button>View</button>
        </div>
        <div class="course-card">
            <img src="assets/images/course2.jpg" alt="Course 2">
            <h3>Web Development</h3>
            <p>Build responsive websites with HTML, CSS, and JS.</p>
            <button>Enroll</button>
        </div>
        <div class="course-card">
            <img src="assets/images/course3.jpg" alt="Course 3">
            <h3>Data Structures</h3>
            <p>Understand core data structures & algorithms.</p>
            <button>View</button>
        </div>
    </div>
</section>


</body>
</html>-->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Home - User</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="assets/css/home.css">
</head>
<body>

<header class="page-header">
    <!-- Tầng 1: Nav -->
    <div class="top-nav d-flex justify-content-center py-2">
        <nav class="d-flex gap-4">
            <a href="#">Home</a>
            <a href="#">Courses</a>
            <a href="#">Learning Groups</a>
        </nav>
    </div>

    <!-- Tầng 2: Logo + Search + User -->
    <div class="middle-nav container-fluid d-flex justify-content-between align-items-center py-3">
        <!-- Logo -->
        <img src="logo.png" alt="Logo" style="height:50px;">

        <!-- Search bar -->
        <div class="search-bar d-flex flex-grow-1 mx-4">
            <input type="text" placeholder="Search courses..." class="form-control rounded-start">
            <button class="btn btn-primary rounded-end">Search</button>
        </div>

        <!-- User info -->
        <div class="d-flex align-items-center gap-3">
            <span class="badge bg-danger px-3 py-2">Fgn85761</span>
            <div class="bell"><i class="bi bi-bell-fill fs-5"></i></div>
        </div>
    </div>
</header>

<section class="hero text-center py-5">
    <h1>Get The Best Online Courses</h1>
</section>

<section class="courses container mt-5">
    <h3 class="mb-4">Featured Courses</h3>
    <div class="row">
        <div class="col-md-4">
            <div class="card">
                <img src="assets/images/course2.jpg" class="card-img-top" alt="Web Development">
                <div class="card-body">
                    <h5 class="card-title">Web Development</h5>
                    <p class="card-text">Build responsive websites with HTML, CSS, and JS.</p>
                    <button class="btn btn-outline-primary">Enroll</button>
                </div>
            </div>
        </div>
        <!-- Add more courses -->
    </div>
</section>

</body>
</html>
