<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Profile Settings</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        .settings-container { max-width:900px; margin:28px auto; padding:18px; }
        .profile-avatar { width:96px; height:96px; border-radius:12px; object-fit:cover; }
        .field-row { margin-bottom:16px; }
        .field-label { font-weight:600; margin-bottom:6px; }
        .small-muted { color:#777; font-size:0.9rem; }
    </style>
</head>
<body>
<jsp:include page="header.jsp" />
<div class="settings-container glass p-4">
    <h4>Profile Settings</h4>
    <c:if test="${not empty sessionScope.success}">
        <div class="success" style="color:#059669;margin-bottom:12px">${sessionScope.success}</div>
        <c:remove var="success" scope="session" />
    </c:if>
    <c:if test="${not empty error}">
        <div class="error" style="color:#b91c1c;margin-bottom:8px">${error}</div>
    </c:if>
    <form method="post" action="${pageContext.request.contextPath}/profile" enctype="multipart/form-data">
        <input type="hidden" name="id" value="${user.id}" />

        <div style="display:flex; gap:20px; align-items:flex-start;">
            <div style="flex:1">
                <div class="field-row">
                    <div class="field-label">Full Name</div>
                    <input type="text" name="fullName" class="form-control" value="${user.fullName}" required />
                </div>

                <div class="field-row">
                    <div class="field-label">Meta Full Name</div>
                    <input type="text" name="metaFullName" class="form-control" value="${user.metaFullName}" />
                </div>

                <div class="field-row">
                    <div class="field-label">Phone</div>
                    <input type="text" name="phone" class="form-control" value="${user.phone}" />
                </div>

                <div class="field-row">
                    <div class="field-label">Bio</div>
                    <textarea name="bio" class="form-control" rows="4">${user.bio}</textarea>
                    <div class="small-muted">Your bio appears on your profile</div>
                </div>

                <div class="field-row">
                    <div class="field-label">Date of Birth</div>
                    <c:choose>
                        <c:when test="${user.dateOfBirth != null}">
                            <fmt:formatDate value="${user.dateOfBirth}" pattern="yyyy-MM-dd" var="dobIso" />
                            <input type="date" name="dateOfBirth" class="form-control" value="${dobIso}" />
                        </c:when>
                        <c:otherwise>
                            <input type="date" name="dateOfBirth" class="form-control" value="" />
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="mt-3">
                    <button type="submit" class="save-btn">Save Changes</button>
                </div>
            </div>

            <div style="width:160px;text-align:center;">
                <c:choose>
                    <c:when test="${not empty user.avatarUrl}">
                        <c:set var="avatarSrc" value="${user.avatarUrl}" />
                    </c:when>
                    <c:otherwise>
                        <c:set var="avatarSrc" value="${pageContext.request.contextPath}/assets/img/default-avatar.png" />
                    </c:otherwise>
                </c:choose>
                <img id="avatarPreview" src="${avatarSrc}" alt="Avatar" class="profile-avatar mb-2">

                <div style="margin-top:10px; text-align:left">
                    <div class="field-label">Choose System Avatar</div>
                    <div id="avatarGallery" style="display:flex; gap:8px; margin-bottom:8px;">
                        <label style="cursor:pointer">
                            <input type="radio" name="selectedAvatar" value="${pageContext.request.contextPath}/assets/img/avatars/avatar1.svg" style="display:none">
                            <img src="${pageContext.request.contextPath}/assets/img/avatars/avatar1.svg" width="48" height="48" style="border:2px solid transparent;border-radius:8px">
                        </label>
                        <label style="cursor:pointer">
                            <input type="radio" name="selectedAvatar" value="${pageContext.request.contextPath}/assets/img/avatars/avatar2.svg" style="display:none">
                            <img src="${pageContext.request.contextPath}/assets/img/avatars/avatar2.svg" width="48" height="48" style="border:2px solid transparent;border-radius:8px">
                        </label>
                        <label style="cursor:pointer">
                            <input type="radio" name="selectedAvatar" value="${pageContext.request.contextPath}/assets/img/avatars/avatar3.svg" style="display:none">
                            <img src="${pageContext.request.contextPath}/assets/img/avatars/avatar3.svg" width="48" height="48" style="border:2px solid transparent;border-radius:8px">
                        </label>
                    </div>

                    <div class="field-label">Or upload your own</div>
                    <div>
                        <label class="btn btn-outline-secondary" style="border-radius:8px; display:inline-block;">
                            Upload
                            <input id="fileInput" type="file" name="avatar" accept="image/*" style="display:none">
                        </label>
                    </div>
                </div>
                <div class="small-muted mt-2">Avatar will be displayed on your profile and next to comments</div>
            </div>
        </div>
    </form>
</div>
</body>
</html>

<script>
    document.addEventListener('DOMContentLoaded', function(){
        const gallery = document.getElementById('avatarGallery');
        const fileInput = document.getElementById('fileInput');
        const preview = document.getElementById('avatarPreview');

        // click on thumbnail sets radio and preview
        gallery.querySelectorAll('label').forEach(function(lbl){
            lbl.addEventListener('click', function(e){
                gallery.querySelectorAll('img').forEach(img=>img.style.border='2px solid transparent');
                const img = lbl.querySelector('img');
                if(img) img.style.border = '2px solid #2563eb';
                const radio = lbl.querySelector('input[type=radio]');
                if(radio) radio.checked = true;
                preview.src = radio.value;
                // clear file input
                if (fileInput) fileInput.value = '';
            });
        });

        // upload preview overrides gallery selection
        if (fileInput) {
            fileInput.addEventListener('change', function(e){
                const f = e.target.files[0];
                if(!f) return;
                const url = URL.createObjectURL(f);
                preview.src = url;
                // uncheck gallery radios and remove borders
                gallery.querySelectorAll('input[type=radio]').forEach(r=>r.checked = false);
                gallery.querySelectorAll('img').forEach(img=>img.style.border='2px solid transparent');
            });
        }
    });
</script>