-- SQL Script để lấy Course ID có thể test
-- Chạy trong SQL Server Management Studio hoặc Azure Data Studio

USE CourseHubDB;

-- Lấy 5 course đầu tiên với thông tin cơ bản
SELECT TOP 5 
    Id as CourseID,
    Title as CourseTitle,
    CreatorId,
    InstructorId,
    'http://localhost:8080/Adaptive_Elearning/course-player?id=' + CAST(Id as VARCHAR(50)) as TestURL
FROM dbo.Courses
WHERE Title IS NOT NULL
ORDER BY CreatedAt DESC;

-- Kiểm tra xem có Enrollment nào không (để test với user đã enroll)
SELECT TOP 3
    c.Id as CourseID,
    c.Title,
    e.CreatorId as EnrolledUserID,
    'http://localhost:8080/Adaptive_Elearning/course-player?id=' + CAST(c.Id as VARCHAR(50)) as TestURL
FROM dbo.Courses c
INNER JOIN dbo.Enrollments e ON c.Id = e.CourseId
ORDER BY c.CreatedAt DESC;

-- Kiểm tra Sections và Lectures có tồn tại không
SELECT 
    c.Title as CourseName,
    COUNT(DISTINCT s.Id) as SectionCount,
    COUNT(DISTINCT l.Id) as LectureCount,
    COUNT(DISTINCT lm.Id) as MaterialCount,
    c.Id as CourseID
FROM dbo.Courses c
LEFT JOIN dbo.Sections s ON c.Id = s.CourseId
LEFT JOIN dbo.Lectures l ON s.Id = l.SectionId  
LEFT JOIN dbo.LectureMaterial lm ON l.Id = lm.LectureId
GROUP BY c.Id, c.Title
HAVING COUNT(DISTINCT s.Id) > 0
ORDER BY MaterialCount DESC;