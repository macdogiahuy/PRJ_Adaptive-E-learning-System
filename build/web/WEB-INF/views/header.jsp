<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Course Hub</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-light bg-light shadow-sm">
            <div class="container">
                <a class="navbar-brand" href="${pageContext.request.contextPath}">
                    <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Logo" height="40">
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav me-auto">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/home">
                                <i class="fas fa-home"></i> Home
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="${pageContext.request.contextPath}/courses">
                                <i class="fas fa-graduation-cap"></i> Courses
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/groups">
                                <i class="fas fa-users"></i> Learning Groups
                            </a>
                        </li>
                    </ul>
                    
                    <form class="d-flex me-3" method="GET" action="${pageContext.request.contextPath}/courses">
                        <div class="input-group">
                            <input class="form-control" type="search" placeholder="Search courses..." 
                                   name="search" value="${searchTerm}">
                            <button class="btn btn-outline-primary" type="submit">
                                <i class="fas fa-search"></i>
                            </button>
                        </div>
                    </form>
                    
                    <div class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" 
                           id="userDropdown" role="button" data-bs-toggle="dropdown">
                            <c:choose>
                                <c:when test="${not empty sessionScope.user and not empty sessionScope.user.avatarUrl}">
                                    <img src="${sessionScope.user.avatarUrl}" alt="User" class="rounded-circle me-2" width="32">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/assets/img/default-avatar.png" alt="User" class="rounded-circle me-2" width="32">
                                </c:otherwise>
                            </c:choose>
                            <span class="d-none d-lg-block">${not empty sessionScope.user ? sessionScope.user.fullName : 'My Account'}</span>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
                                    <i class="fas fa-user me-2"></i> Profile
                                </a>
                            </li>
                            <li>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/my-courses">
                                    <i class="fas fa-book me-2"></i> My Courses
                                </a>
                            </li>
                            <li>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/settings">
                                    <i class="fas fa-cog me-2"></i> Settings
                                </a>
                            </li>
                            <li><hr class="dropdown-divider"></li>
                            <li>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                                    <i class="fas fa-sign-out-alt me-2"></i> Logout
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </nav>
    </body>
</html>