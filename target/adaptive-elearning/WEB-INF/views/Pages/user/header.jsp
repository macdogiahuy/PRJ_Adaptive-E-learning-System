<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/">
            <!-- Use demo logo if custom logo not uploaded -->
            <img src="${pageContext.request.contextPath}/assets/img/demo/java.jpg" alt="Logo" height="36" class="me-2"/>
            <span class="fw-bold">Adaptive E-learning</span>
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNav" aria-controls="mainNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="mainNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/courses">Courses</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
            </ul>

            <!-- Search in header -->
            <form class="d-flex me-3" method="get" action="${pageContext.request.contextPath}/courses">
                <div class="input-group">
                    <input class="form-control" type="search" placeholder="Search courses..." name="search" value="${param.search}" />
                    <button class="btn btn-outline-primary" type="submit"><i class="fas fa-search"></i></button>
                </div>
            </form>

            <div class="nav-item dropdown">
                <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user and not empty sessionScope.user.avatarUrl}">
                            <img src="${sessionScope.user.avatarUrl}" alt="User" class="rounded-circle me-2" width="32" />
                        </c:when>
                        <c:otherwise>
                            <!-- fallback to demo avatar if user has no avatar -->
                            <img src="${pageContext.request.contextPath}/assets/img/demo/team.jpg" alt="User" class="rounded-circle me-2" width="32" />
                        </c:otherwise>
                    </c:choose>
                    <span class="d-none d-lg-block">${not empty sessionScope.user ? sessionScope.user.fullName : 'My Account'}</span>
                </a>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile"><i class="fas fa-user me-2"></i> Profile</a></li>
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/my-courses"><i class="fas fa-book me-2"></i> My Courses</a></li>
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/settings"><i class="fas fa-cog me-2"></i> Settings</a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt me-2"></i> Logout</a></li>
                </ul>
            </div>
        </div>
    </div>
</nav>