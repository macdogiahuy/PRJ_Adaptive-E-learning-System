<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Profile Settings</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="assets/css/profileSetting.css">
</head>
<body>

<!-- Header -->
<!-- Header -->
<header class="page-header">
    <div class="top-links">
        <a href="#">Home</a>
        <a href="#">Courses</a>
        <a href="#">Learning Groups</a>
    </div>

    <div class="header-row container-fluid">
        <div class="header-left">
            <img src="logo.png" alt="Logo" style="height:44px;">
        </div>

        <div class="header-center">
            <div class="search-box" role="search" aria-label="site search">
                <i class="bi bi-search" style="margin-right:8px; font-size:18px; color:#9aa0a6;"></i>
                <input type="text" placeholder="Search" />
            </div>
        </div>

        <div class="header-right">
            <div class="badge-user">Fgn85761</div>
            <div class="bell" title="Notifications"><i class="bi bi-bell-fill"></i></div>
        </div>
    </div>
</header>


<!-- Main layout -->
<div class="layout">
    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="menu-item"><span class="icon-circle"><i class="bi bi-person-fill"></i></span> <span>Profile Settings</span></div>
        <div class="menu-item"><span class="icon-circle"><i class="bi bi-lock-fill"></i></span> <span>Change Password</span></div>
        <div class="menu-item"><span class="icon-circle"><i class="bi bi-mortarboard-fill"></i></span> <span>Become an Instructor</span></div>
        <div class="menu-item"><span class="icon-circle"><i class="bi bi-house-fill"></i></span> <span>Return Home Page</span></div>
        <div class="menu-item"><span class="icon-circle"><i class="bi bi-box-arrow-right"></i></span> <span style="color:#d9534f;">Sign Out</span></div>
    </aside>

    <!-- Content -->
    <main class="content d-flex justify-content-center align-items-start">
        <section class="card-like w-100">
            <h5 class="mb-4">Personal Info</h5>

            <div class="field">
                <div class="label">Full Name</div>
                <div class="value">Full Name</div>
            </div>

            <div class="field">
                <div class="label">Bio</div>
                <div class="value">Bio</div>
            </div>

            <div class="avatar">
                <img src="avatar.png" alt="avatar">
                <br>
                <button class="btn btn-outline-secondary btn-sm btn-edit">Edit</button>
            </div>

            <div class="field">
                <div class="label">Email</div>
                <div class="value">Email</div>
            </div>

            <div class="field">
                <div class="label">UserName</div>
                <div class="value">UserName</div>
            </div>

            <div class="field">
                <div class="label">Date of Birth</div>
                <div class="value">21/01/2000</div>
            </div>

            <div class="field">
                <div class="label">Enrollment Count</div>
                <div class="value">2</div>
            </div>

            <div class="field">
                <div class="label">Role</div>
                <div class="value">Learner</div>
            </div>

            <div class="field">
                <div class="label">Join Date</div>
                <div class="value">19/10/2023</div>
            </div>

            <div class="mt-3">
                <button class="btn save-btn" disabled>Save Changes</button>
            </div>
        </section>
    </main>
</div>

</body>
</html>
