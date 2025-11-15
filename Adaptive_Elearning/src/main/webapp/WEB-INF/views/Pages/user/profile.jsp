<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
</head>
<body>
    <jsp:include page="/WEB-INF/views/Pages/user/header.jsp" />

    <style>
        /* Make labels darker and values more prominent */
        .profile-card { background: linear-gradient(180deg, #ffffff 0%, #fbfbff 100%); }
        .profile-card .label { color: #4b5563; font-weight:600; }
        .profile-card .value { color: #111827; font-size:1rem; font-weight:600; }
        .profile-left .card { border-radius:12px; }
        .avatar-wrapper img { box-shadow: 0 6px 18px rgba(12,34,60,0.08); }
    </style>

    <div class="container my-5">
        <div class="row">
            <div class="col-lg-3 mb-4">
                <div class="card p-3 rounded-4 shadow-sm">
                    <h5 class="mb-3">Settings</h5>
                    <div class="list-group">
                        <a class="list-group-item list-group-item-action d-flex align-items-center" href="${pageContext.request.contextPath}/profile">
                            <i class="fas fa-user me-2"></i> Profile Settings
                        </a>
                        <a class="list-group-item list-group-item-action d-flex align-items-center" href="${pageContext.request.contextPath}/change-password">
                            <i class="fas fa-lock me-2"></i> Change Password
                        </a>
                        <a class="list-group-item list-group-item-action d-flex align-items-center" href="${pageContext.request.contextPath}/become-instructor">
                            <i class="fas fa-chalkboard-teacher me-2"></i> Become an Instructor
                        </a>
                        <a class="list-group-item list-group-item-action d-flex align-items-center" href="${pageContext.request.contextPath}/">
                            <i class="fas fa-home me-2"></i> Return Home Page
                        </a>
                        <a class="list-group-item list-group-item-action text-danger d-flex align-items-center" href="${pageContext.request.contextPath}/logout">
                            <i class="fas fa-sign-out-alt me-2"></i> Sign Out
                        </a>
                    </div>
                </div>
            </div>

            <div class="col-lg-9">
                <div class="card p-4 rounded-4 shadow-sm profile-card">
                    <div class="d-flex justify-content-between align-items-start mb-3">
                        <h3>Personal Info</h3>
                        <div class="text-center">
                            <c:if test="${not empty successMessage}">
                                <div class="alert alert-success">${successMessage}</div>
                            </c:if>
                            <c:if test="${not empty errorMessage}">
                                <div class="alert alert-danger">${errorMessage}</div>
                            </c:if>
                            <c:choose>
                                <c:when test="${not empty userProfile and not empty userProfile.avatarUrl}">
                                    <div class="avatar-wrapper mb-2"><img src="${userProfile.avatarUrl}" alt="Avatar" class="rounded-circle" width="80" /></div>
                                </c:when>
                                <c:otherwise>
                                    <div class="avatar-wrapper mb-2"><img src="${pageContext.request.contextPath}/assets/img/demo/team.jpg" alt="Avatar" class="rounded-circle" width="80" /></div>
                                </c:otherwise>
                            </c:choose>
                            <div class="mt-2">
                                <a class="btn btn-outline-secondary btn-sm me-2" href="${pageContext.request.contextPath}/profile/edit"><i class="fas fa-pen me-1"></i> Edit Profile</a>
                                <a class="btn btn-outline-secondary btn-sm" href="${pageContext.request.contextPath}/profile/edit"><i class="fas fa-image me-1"></i> Change Avatar</a>
                            </div>
                            <small class="d-block mt-2 text-muted">Avatar will be displayed on your profile and next to comments</small>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-8">
                            <div class="mb-3">
                                <label class="form-label small label">Full Name</label>
                                <div class="value">${userProfile.fullName}</div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label small label">Meta Full Name</label>
                                <div class="value">${userProfile.metaFullName}</div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label small label">Phone</label>
                                <div class="value">${userProfile.phone}</div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label small label">Bio</label>
                                <div class="value">${userProfile.bio}</div>
                                <small class="text-muted">Your bio appears on your profile</small>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label small label">Email</label>
                                    <div class="value">${userProfile.email}</div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label small label">Date of Birth</label>
                                    <div class="value">
                                        <c:choose>
                                            <c:when test="${not empty userProfile.dateOfBirth}">
                                                <fmt:formatDate value="${userProfile.dateOfBirth}" pattern="dd/MM/yyyy"/>
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label small label">UserName</label>
                                    <div class="value">${userProfile.userName}</div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label small label">Enrollment Count</label>
                                    <div class="value">${userProfile.enrollmentCount}</div>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label small label">Role</label>
                                <div class="value">${userProfile.role}</div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label small label">Join Date</label>
                                <div class="value">
                                    <c:choose>
                                        <c:when test="${not empty userProfile.creationTime}">
                                            <fmt:formatDate value="${userProfile.creationTime}" pattern="dd/MM/yyyy"/>
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>