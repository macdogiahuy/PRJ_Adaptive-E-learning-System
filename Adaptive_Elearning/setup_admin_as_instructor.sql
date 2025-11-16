-- ===================================================================
-- Add Admin to Instructors table so Admin can create courses
-- ===================================================================
USE [CourseHubDB]
GO

PRINT '================================================';
PRINT '1. Check if Admin exists in Users table';
PRINT '================================================';
SELECT 
    Id,
    UserName,
    FullName,
    Role,
    InstructorId
FROM [dbo].[Users]
WHERE Role = 'Admin';

PRINT '================================================';
PRINT '2. Check if Admin exists in Instructors table';
PRINT '================================================';
SELECT 
    i.Id,
    u.UserName,
    u.FullName,
    u.Role
FROM [dbo].[Instructors] i
INNER JOIN [dbo].[Users] u ON i.Id = u.Id
WHERE u.Role = 'Admin';

PRINT '================================================';
PRINT '3. Add Admin to Instructors table if not exists';
PRINT '================================================';

-- For each Admin user, create corresponding Instructor record if not exists
INSERT INTO [dbo].[Instructors] (
    Id, 
    Intro, 
    Experience, 
    CreatorId, 
    CreationTime, 
    LastModificationTime, 
    Balance, 
    CourseCount
)
SELECT 
    u.Id,
    'Administrator account with full system privileges' AS Intro,
    'System Administration, Course Management, User Management' AS Experience,
    u.Id AS CreatorId,
    GETDATE() AS CreationTime,
    GETDATE() AS LastModificationTime,
    0 AS Balance,
    0 AS CourseCount
FROM [dbo].[Users] u
WHERE u.Role = 'Admin'
AND NOT EXISTS (
    SELECT 1 FROM [dbo].[Instructors] i WHERE i.Id = u.Id
);

PRINT 'Admin users have been added to Instructors table';

PRINT '================================================';
PRINT '4. Update Users.InstructorId to point to themselves';
PRINT '================================================';

UPDATE [dbo].[Users]
SET InstructorId = Id
WHERE Role = 'Admin'
AND InstructorId IS NULL;

PRINT 'Admin InstructorId updated';

PRINT '================================================';
PRINT '5. Verify Admin can now create courses';
PRINT '================================================';
SELECT 
    u.Id,
    u.UserName,
    u.FullName,
    u.Role,
    u.InstructorId,
    CASE 
        WHEN i.Id IS NOT NULL THEN 'YES - Can create courses'
        ELSE 'NO - Cannot create courses'
    END AS CanCreateCourses
FROM [dbo].[Users] u
LEFT JOIN [dbo].[Instructors] i ON u.InstructorId = i.Id
WHERE u.Role = 'Admin';
