-- Kiểm tra Enrollments và lấy thông tin User + Course để test Course Player
-- Chạy trong SQL Server Management Studio

USE CourseHubDB;

-- 1. Kiểm tra tất cả enrollments hiện có
SELECT 
    e.CourseId,
    e.CreatorId as UserId,
    u.UserName,
    u.FullName,
    u.Role,
    c.Title as CourseName,
    e.EnrollmentDate,
    'http://localhost:8080/Adaptive_Elearning/course-player?id=' + CAST(e.CourseId AS VARCHAR(50)) as TestURL
FROM dbo.Enrollments e
INNER JOIN dbo.Users u ON e.CreatorId = u.Id
INNER JOIN dbo.Courses c ON e.CourseId = c.Id
ORDER BY e.EnrollmentDate DESC;

-- 2. Đếm số enrollments
SELECT 
    COUNT(*) as TotalEnrollments,
    COUNT(DISTINCT e.CreatorId) as UniqueUsers,
    COUNT(DISTINCT e.CourseId) as UniqueCourses
FROM dbo.Enrollments e;

-- 3. Lấy users có role Learner (để test)
SELECT TOP 5
    Id as UserId,
    UserName,
    FullName,
    Role,
    Email
FROM dbo.Users 
WHERE Role = 'Learner'
ORDER BY CreatedAt DESC;

-- 4. Lấy courses có sẵn
SELECT TOP 5
    Id as CourseId,
    Title,
    CreatorId,
    InstructorId,
    CreatedAt
FROM dbo.Courses
ORDER BY CreatedAt DESC;

-- 5. Kiểm tra user Fgn85761 cụ thể
SELECT 
    u.Id as UserId,
    u.UserName,
    u.FullName,
    u.Role,
    COUNT(e.CourseId) as EnrolledCourseCount
FROM dbo.Users u
LEFT JOIN dbo.Enrollments e ON u.Id = e.CreatorId
WHERE u.UserName = 'Fgn85761'
GROUP BY u.Id, u.UserName, u.FullName, u.Role;

-- 6. Nếu không có enrollments, tạo enrollment test cho user Fgn85761
IF NOT EXISTS (SELECT 1 FROM dbo.Enrollments WHERE CreatorId = '520E054F-8E25-4486-985E-027D4FD0B31D')
BEGIN
    PRINT 'No enrollments found for user Fgn85761. Creating test enrollment...';
    
    -- Lấy course đầu tiên
    DECLARE @TestCourseId UNIQUEIDENTIFIER;
    SELECT TOP 1 @TestCourseId = Id FROM dbo.Courses ORDER BY CreatedAt DESC;
    
    IF @TestCourseId IS NOT NULL
    BEGIN
        INSERT INTO dbo.Enrollments (CourseId, CreatorId, EnrollmentDate)
        VALUES (@TestCourseId, '520E054F-8E25-4486-985E-027D4FD0B31D', GETDATE());
        
        -- Hiển thị kết quả
        SELECT 
            @TestCourseId as CourseId,
            '520E054F-8E25-4486-985E-027D4FD0B31D' as UserId,
            'Fgn85761' as UserName,
            c.Title as CourseName,
            'http://localhost:8080/Adaptive_Elearning/course-player?id=' + CAST(@TestCourseId AS VARCHAR(50)) as TestURL
        FROM dbo.Courses c 
        WHERE c.Id = @TestCourseId;
        
        PRINT 'Created test enrollment successfully!';
    END
    ELSE
    BEGIN
        PRINT 'No courses available to enroll in.';
    END
END
ELSE
BEGIN
    PRINT 'User Fgn85761 already has enrollments.';
END

-- 7. Final: Hiển thị tất cả test URLs có thể dùng
SELECT 
    'TEST URLS FOR COURSE PLAYER:' as Message,
    '' as URL
UNION ALL
SELECT 
    CONCAT('User: ', u.UserName, ' (', u.Role, ')') as Message,
    'http://localhost:8080/Adaptive_Elearning/course-player?id=' + CAST(e.CourseId AS VARCHAR(50)) as URL
FROM dbo.Enrollments e
INNER JOIN dbo.Users u ON e.CreatorId = u.Id
INNER JOIN dbo.Courses c ON e.CourseId = c.Id
WHERE u.Role = 'Learner'
ORDER BY Message;