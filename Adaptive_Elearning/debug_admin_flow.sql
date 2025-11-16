-- ===================================================================
-- Debug Admin Flow - Check course visibility
-- ===================================================================
USE [CourseHubDB]
GO

PRINT '================================================';
PRINT '1. Check Admin user chauvuonghoang50 details';
PRINT '================================================';
SELECT 
    u.Id AS UserId,
    u.UserName,
    u.FullName,
    u.Role,
    u.InstructorId AS UserInstructorId,
    i.Id AS InstructorTableId
FROM [dbo].[Users] u
LEFT JOIN [dbo].[Instructors] i ON u.InstructorId = i.Id
WHERE u.UserName = 'chauvuonghoang50';

PRINT '================================================';
PRINT '2. Check course "123" created by chauvuonghoang50';
PRINT '================================================';
SELECT 
    c.Id AS CourseId,
    c.Title,
    c.InstructorId AS CourseInstructorId,
    c.Status,
    c.ApprovalStatus,
    c.CreationTime
FROM [dbo].[Courses] c
WHERE c.Title = '123'
ORDER BY c.CreationTime DESC;

PRINT '================================================';
PRINT '3. Check if course InstructorId matches user InstructorId';
PRINT '================================================';
SELECT 
    u.UserName,
    u.Role,
    u.InstructorId AS UserInstructorId,
    c.Id AS CourseId,
    c.Title,
    c.InstructorId AS CourseInstructorId,
    CASE 
        WHEN u.InstructorId = c.InstructorId THEN 'MATCH - Should be visible'
        ELSE 'NO MATCH - Course will not appear'
    END AS VisibilityStatus
FROM [dbo].[Users] u
CROSS JOIN [dbo].[Courses] c
WHERE u.UserName = 'chauvuonghoang50'
AND c.Title = '123';

PRINT '================================================';
PRINT '4. Check ALL courses that should appear for Admin';
PRINT '================================================';
SELECT 
    c.Id,
    c.Title,
    c.InstructorId,
    c.Status,
    c.ApprovalStatus,
    c.CreationTime,
    u.UserName AS InstructorUserName,
    u.Role AS InstructorRole
FROM [dbo].[Courses] c
INNER JOIN [dbo].[Instructors] i ON c.InstructorId = i.Id
INNER JOIN [dbo].[Users] u ON i.Id = u.InstructorId
ORDER BY c.CreationTime DESC;
