-- Debug Course Dropdown Issue
-- Kiểm tra tại sao Select Course không hiển thị khóa học

USE CourseHubDB;

-- 1. Kiểm tra user hiện tại (thay USER_ID bằng ID thực)
DECLARE @UserId UNIQUEIDENTIFIER = '520E054F-8E25-4486-985E-027D4FD0B31D'; -- Fgn85761

SELECT 
    Id,
    UserName,
    FullName,
    Role,
    InstructorId,
    CASE 
        WHEN InstructorId IS NULL THEN '❌ NULL - User is NOT an instructor'
        ELSE '✅ Has InstructorId - User IS an instructor'
    END as InstructorStatus
FROM dbo.Users 
WHERE Id = @UserId;

-- 2. Kiểm tra Courses table structure
SELECT TOP 5
    Id,
    Title,
    InstructorId,
    CreatorId,
    CreationTime
FROM dbo.Courses
ORDER BY CreationTime DESC;

-- 3. Test query của getCoursesByInstructor với user hiện tại
-- Query hiện tại trong code: WHERE InstructorId = ?
SELECT 'Current Query (InstructorId)' as QueryType, Id, Title 
FROM dbo.Courses 
WHERE InstructorId = @UserId
ORDER BY CreationTime DESC;

-- 4. Test alternative query với CreatorId  
SELECT 'Alternative Query (CreatorId)' as QueryType, Id, Title 
FROM dbo.Courses 
WHERE CreatorId = @UserId
ORDER BY CreationTime DESC;

-- 5. Test với InstructorId từ Users table
DECLARE @InstructorId UNIQUEIDENTIFIER;
SELECT @InstructorId = InstructorId FROM dbo.Users WHERE Id = @UserId;

IF @InstructorId IS NOT NULL
BEGIN
    SELECT 'Query with Users.InstructorId' as QueryType, Id, Title 
    FROM dbo.Courses 
    WHERE InstructorId = @InstructorId
    ORDER BY CreationTime DESC;
END
ELSE
BEGIN
    PRINT 'User does not have InstructorId - cannot filter courses by instructor';
END

-- 6. Hiển thị tất cả courses để debug
SELECT 'All Courses' as QueryType, Id, Title, InstructorId, CreatorId
FROM dbo.Courses
ORDER BY CreationTime DESC;

-- 7. Kiểm tra relationship giữa Users và Instructors
SELECT 
    u.Id as UserId,
    u.UserName,
    u.InstructorId,
    i.Id as InstructorTableId,
    i.Intro,
    i.Experience
FROM dbo.Users u
LEFT JOIN dbo.Instructors i ON u.InstructorId = i.Id
WHERE u.Id = @UserId;