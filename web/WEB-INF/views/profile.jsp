<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Settings — Profile</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        /* Minimal page-specific styles to match the provided screenshot */
        .settings-container { max-width:1200px; margin:28px auto; padding:18px; }
        .settings-aside { width:260px; }
        .settings-main { flex:1; }
        .nav-link-icon { width:36px; height:36px; display:inline-flex; align-items:center; justify-content:center; border-radius:8px; background:#fff; box-shadow:0 2px 6px rgba(0,0,0,0.06); margin-right:10px; }
        .profile-avatar { width:96px; height:96px; border-radius:12px; object-fit:cover; }
        .field-row { margin-bottom:18px; }
        .field-label { font-weight:600; color:#333; font-size:0.95rem; margin-bottom:6px; }
        .small-muted { color:#777; font-size:0.9rem; }
        .save-btn { background:linear-gradient(90deg,#6366f1 0%,#00bcd4 100%); color:#fff; border:none; padding:8px 18px; border-radius:10px; }
        @media (max-width: 991px){ .settings-aside{ width:100%; margin-bottom:16px } .settings-container{padding:12px} }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />

    <div class="settings-container">
        <div style="display:flex; gap:24px; align-items:flex-start;">
            <aside class="settings-aside glass p-3">
                <h5 class="mb-3">Settings</h5>
                <ul class="list-unstyled">
                    <li class="mb-2"><a class="d-flex align-items-center text-decoration-none" href="${pageContext.request.contextPath}/settings/profile"><span class="nav-link-icon"><i class="fas fa-user"></i></span> Profile Settings</a></li>
                    <li class="mb-2"><a class="d-flex align-items-center text-decoration-none" href="${pageContext.request.contextPath}/settings/password"><span class="nav-link-icon"><i class="fas fa-lock"></i></span> Change Password</a></li>
                    <li class="mb-2"><a class="d-flex align-items-center text-decoration-none" href="${pageContext.request.contextPath}/become-instructor"><span class="nav-link-icon"><i class="fas fa-chalkboard-teacher"></i></span> Become an Instructor</a></li>
                    <li class="mb-2"><a class="d-flex align-items-center text-decoration-none" href="${pageContext.request.contextPath}/"><span class="nav-link-icon"><i class="fas fa-home"></i></span> Return Home Page</a></li>
                    <li class="mt-3"><a class="d-flex align-items-center text-decoration-none text-danger" href="${pageContext.request.contextPath}/logout"><span class="nav-link-icon"><i class="fas fa-sign-out-alt"></i></span> Sign Out</a></li>
                </ul>
            </aside>

            <main class="settings-main glass p-4">
                <h4 class="mb-3">Personal Info</h4>
                <c:if test="${not empty sessionScope.success}">
                    <div class="success" style="color:#059669;margin-bottom:12px">${sessionScope.success}</div>
                    <c:remove var="success" scope="session" />
                </c:if>

                <div id="profileView">
                    <input type="hidden" name="id" value="${user.id}" />
                    <div class="row">
                        <div class="col-md-8">
                            <div class="field-row">
                                <div class="field-label">Full Name</div>
                                <div class="form-control-plaintext">${user.fullName}</div>
                                <div class="small-muted">Your name appears on your profile and next to your comments</div>
                            </div>

                            <div class="field-row">
                                <div class="field-label">Meta Full Name</div>
                                <div class="form-control-plaintext">${user.metaFullName}</div>
                            </div>

                            <div class="field-row">
                                <div class="field-label">Phone</div>
                                <div class="form-control-plaintext">${user.phone}</div>
                            </div>

                            <div class="field-row">
                                <div class="field-label">Bio</div>
                                <div class="form-control-plaintext" style="white-space:pre-wrap">${user.bio}</div>
                                <div class="small-muted">Your bio appears on your profile</div>
                            </div>

                            <div class="field-row">
                                <div class="field-label">Email</div>
                                <div class="form-control-plaintext">${user.email}</div>
                            </div>

                            <div class="field-row">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="field-label">UserName</div>
                                        <div class="form-control-plaintext">${user.userName}</div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="field-label">Date of Birth</div>
                                        <div class="form-control-plaintext">
                                            <c:if test="${user.dateOfBirth != null}">
                                                <fmt:formatDate value="${user.dateOfBirth}" pattern="dd/MM/yyyy" />
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="field-row">
                                <div class="field-label">Enrollment Count</div>
                                <div class="form-control-plaintext">${user.enrollmentCount}</div>
                            </div>

                            <div class="field-row">
                                <div class="field-label">Role</div>
                                <div class="form-control-plaintext">${user.role}</div>
                            </div>

                            <div class="field-row">
                                <div class="field-label">Join Date</div>
                                <div class="form-control-plaintext">
                                    <c:if test="${user.creationTime != null}">
                                        <fmt:formatDate value="${user.creationTime}" pattern="dd/MM/yyyy" />
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4 text-center">
                            <div style="display:inline-block;text-align:center;">
                                    <c:choose>
                                        <c:when test="${not empty user.avatarUrl}">
                                            <c:set var="avatarSrc" value="${user.avatarUrl}" />
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="avatarSrc" value="${pageContext.request.contextPath}/assets/img/default-avatar.png" />
                                        </c:otherwise>
                                    </c:choose>
                                    <img src="${avatarSrc}" alt="Avatar" class="profile-avatar mb-2">
                                    <div class="small-muted mt-2">Avatar will be displayed on your profile and next to comments</div>
                                </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- display-only page: no client-side upload script required -->
</body>
</html>

