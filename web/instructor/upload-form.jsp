<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Upload Lecture Material</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style> body { padding: 2rem; } </style>
</head>
<body>
<div class="container">
    <h2 class="mb-3">Upload Lecture Material</h2>

    <c:if test="${not empty alertMessage}">
        <div class="alert ${alertStatus != null && alertStatus ? 'alert-success' : 'alert-info'}" role="alert">
            ${alertMessage}
        </div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/instructor/uploadMaterial" enctype="multipart/form-data">
        <div class="mb-2">
            <label for="courseId">Course ID (optional)</label>
            <input type="text" id="courseId" name="courseId" class="form-control" />
        </div>

        <div class="mb-2">
            <label for="sectionId">Section ID (optional)</label>
            <input type="text" id="sectionId" name="sectionId" class="form-control" />
        </div>

        <div class="mb-2">
            <label for="index">Section Index (optional)</label>
            <input type="number" id="index" name="index" class="form-control" />
        </div>

        <div class="mb-2">
            <label for="title">Section Title (optional)</label>
            <input type="text" id="title" name="title" class="form-control" />
        </div>

        <div class="mb-2">
            <label for="lectureCount">Lecture Count (optional)</label>
            <input type="number" id="lectureCount" name="lectureCount" class="form-control" />
        </div>

        <div class="mb-3">
            <label for="file">Choose file</label>
            <input type="file" id="file" name="file" class="form-control" required />
        </div>

        <button type="submit" class="btn btn-primary">Upload</button>
    </form>
</div>

</body>
</html>
