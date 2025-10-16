<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <title>Enrolled Courses</title>
    <style>
        #dataTable th, #dataTable td {
            text-align: center;
            vertical-align: middle;
        }
    </style>
</head>
<body>
    <div class="container-fluid" style="margin-top: 40px;">
        <h1 style="font-size: 48px; text-align: center;">Enrolled Courses</h1>
        <div class="card shadow mb-4">
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                        <thead>
                            <tr>
                                <th>Course Title</th>
                                <th>Course Thumb</th>
                                <th>Instructor</th>
                                <th>Rating</th>
                                <th>Enrolled At</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                        <tr th:if="${#lists.isEmpty(enrollments)}">
                            <td colspan="6" style="color: red">You haven't enrolled in any course yet.</td>
                        </tr>
                        <tr th:each="enrollment : ${enrollments}">
                            <td>
                                <a th:href="@{'/courses/' + ${enrollment.course.id}}"
                                   th:text="${enrollment.course.title}">Course Name</a>
                            </td>
                            <td>
                                <img th:src="${enrollment.course.thumbUrl}" alt="thumb" style="aspect-ratio: 1.5; width: 120px;" />
                            </td>
                            <td>
                                <a th:href="@{'/instructors/' + ${enrollment.instructor.id}}"
                                   th:text="${enrollment.instructor.fullName}">Instructor Name</a>
                            </td>
                            <td th:text="${enrollment.rating}">0.00</td>
                            <td th:text="${#dates.format(enrollment.enrolledAt, 'dd/MM/yyyy HH:mm:ss')}">Date</td>
                            <td th:text="${enrollment.status}">Ongoing</td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</body>
</html>