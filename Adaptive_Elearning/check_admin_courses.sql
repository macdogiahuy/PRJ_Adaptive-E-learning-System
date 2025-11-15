-- ===================================================================
-- Check courses created by Admin
-- ===================================================================
USE [CourseHubDB]
GO

PRINT '================================================';
PRINT '1. Check all courses created by Admin';
PRINT '================================================';
SELECT 
    c.Id,
    c.Title,
    c.InstructorId,
    c.Status,
    c.ApprovalStatus,
    c.RejectionReason,
    c.CreationTime,
    u.UserName,
    u.FullName,
    u.Role
FROM [dbo].[Courses] c
INNER JOIN [dbo].[Instructors] i ON c.InstructorId = i.Id
INNER JOIN [dbo].[Users] u ON i.Id = u.InstructorId
WHERE u.Role = 'Admin'
ORDER BY c.CreationTime DESC;

PRINT '================================================';
PRINT '2. Check Admin InstructorId mapping';
PRINT '================================================';
SELECT 
    u.Id,
    u.UserName,
    u.FullName,
    u.Role,
    u.InstructorId,
    i.Id AS InstructorTableId,
    i.CourseCount
FROM [dbo].[Users] u
LEFT JOIN [dbo].[Instructors] i ON u.InstructorId = i.Id
WHERE u.Role = 'Admin';

PRINT '================================================';
PRINT '3. Check courses with pending approval';
PRINT '================================================';
SELECT 
    c.Id,
    c.Title,
    c.InstructorId,
    c.Status,
    c.ApprovalStatus,
    u.UserName,
    u.Role
FROM [dbo].[Courses] c
INNER JOIN [dbo].[Instructors] i ON c.InstructorId = i.Id
INNER JOIN [dbo].[Users] u ON i.Id = u.InstructorId
WHERE c.ApprovalStatus = 'pending'
ORDER BY c.CreationTime DESC;
