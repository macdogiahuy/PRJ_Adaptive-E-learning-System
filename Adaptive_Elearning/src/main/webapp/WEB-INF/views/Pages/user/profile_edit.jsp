<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Edit Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
</head>
<body>
    <jsp:include page="/WEB-INF/views/Pages/user/header.jsp" />

    <div class="container my-5">
        <div class="row">
            <div class="col-lg-3 mb-4">
                <div class="card p-3 rounded-4 shadow-sm">
                    <h5 class="mb-3">Settings</h5>
                    <div class="list-group">
                        <a class="list-group-item list-group-item-action d-flex align-items-center" href="${pageContext.request.contextPath}/profile">
                            <i class="fas fa-user me-2"></i> Profile Settings
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-lg-9">
                <div class="card p-4 rounded-4 shadow-sm">
                    <h3 class="mb-3">Edit Profile</h3>
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger">${errorMessage}</div>
                    </c:if>
                    <form method="post" action="${pageContext.request.contextPath}/profile/edit" enctype="multipart/form-data">
                        <div class="row">
                            <div class="col-md-8">
                                <div class="mb-3">
                                    <label class="form-label">Full Name</label>
                                    <input type="text" name="fullName" class="form-control" value="${userProfile.fullName}" />
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Meta Full Name</label>
                                    <input type="text" name="metaFullName" class="form-control" value="${userProfile.metaFullName}" />
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Phone</label>
                                    <input type="text" name="phone" class="form-control" value="${userProfile.phone}" />
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Bio</label>
                                    <textarea name="bio" class="form-control" rows="4">${userProfile.bio}</textarea>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Email</label>
                                        <input type="email" name="email" class="form-control" value="${userProfile.email}" />
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Date of Birth</label>
                                        <input type="date" name="dateOfBirth" class="form-control" value="${userProfile.dateOfBirth}" />
                                    </div>
                                </div>
                                <button type="submit" class="btn btn-primary">Save Changes</button>
                            </div>

                            <div class="col-md-4 text-center">
                                <div class="mb-3">
                                    <c:choose>
                                        <c:when test="${not empty userProfile.avatarUrl}">
                                            <img src="${userProfile.avatarUrl}" class="rounded-circle" width="140" />
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/assets/img/demo/team.jpg" class="rounded-circle" width="140" />
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Upload Avatar</label>
                                    <input type="file" name="avatar" class="form-control" accept="image/*" />
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>