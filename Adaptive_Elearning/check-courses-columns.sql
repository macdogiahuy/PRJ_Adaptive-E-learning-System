-- Kiểm tra cột InstructorId vs CreatorId trong table Courses
USE CourseHubDB;
GO

-- 1. Kiểm tra schema của table Courses
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Courses'
ORDER BY ORDINAL_POSITION;

-- 2. Kiểm tra dữ liệu trong table Courses
SELECT TOP 5
    Id,
    Title,
    InstructorId,
    CreatorId,
    CreationTime
FROM dbo.Courses
ORDER BY CreationTime DESC;

-- 3. Kiểm tra user hiện tại (thay YOUR_USERNAME bằng username bạn đang dùng)
SELECT 
    u.Id AS UserId,
    u.UserName,
    u.FullName,
    u.Role,
    u.InstructorId,
    i.Id AS InstructorTableId,
    i.InstructorName
FROM dbo.Users u
LEFT JOIN dbo.Instructors i ON u.InstructorId = i.Id
WHERE u.UserName = 'YOUR_USERNAME'; -- ← Thay YOUR_USERNAME

-- 4. Test query với CreatorId thay vì InstructorId
-- (Thay YOUR_USER_ID bằng UserId từ query trên)
SELECT 
    Id, 
    Title,
    CreatorId,
    InstructorId
FROM dbo.Courses 
WHERE CreatorId = 'YOUR_USER_ID'
ORDER BY CreationTime DESC;
