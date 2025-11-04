-- ================================================
-- Debug Script: Check Notification Creation
-- ================================================

USE [CourseHubDB]
GO

-- 1. Check if CourseNotifications table exists
PRINT '================================================';
PRINT '1. Checking if CourseNotifications table exists...';
PRINT '================================================';
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CourseNotifications]') AND type in (N'U'))
BEGIN
    PRINT 'CourseNotifications table exists';
    
    -- Show table structure
    EXEC sp_help 'CourseNotifications';
END
ELSE
BEGIN
    PRINT 'ERROR: CourseNotifications table does NOT exist!';
END
GO

-- 2. Count all notifications
PRINT '================================================';
PRINT '2. Counting all notifications...';
PRINT '================================================';
SELECT COUNT(*) AS TotalNotifications FROM [dbo].[CourseNotifications];
GO

-- 3. Show all notifications (limit 20)
PRINT '================================================';
PRINT '3. Showing all notifications (limit 20)...';
PRINT '================================================';
SELECT TOP 20
    Id,
    CourseId,
    InstructorId,
    InstructorName,
    CourseTitle,
    CoursePrice,
    NotificationType,
    Status,
    CreationTime,
    ProcessedTime
FROM [dbo].[CourseNotifications]
ORDER BY CreationTime DESC;
GO

-- 4. Count pending notifications
PRINT '================================================';
PRINT '4. Counting pending notifications...';
PRINT '================================================';
SELECT COUNT(*) AS PendingCount FROM [dbo].[CourseNotifications]
WHERE Status = 'pending';
GO

-- 5. Show pending notifications
PRINT '================================================';
PRINT '5. Showing pending notifications...';
PRINT '================================================';
SELECT 
    cn.Id,
    cn.CourseId,
    cn.InstructorId,
    cn.InstructorName,
    cn.CourseTitle,
    cn.CoursePrice,
    cn.Status,
    cn.CreationTime,
    c.Status AS CourseStatus,
    c.ApprovalStatus AS CourseApprovalStatus
FROM [dbo].[CourseNotifications] cn
LEFT JOIN [dbo].[Courses] c ON cn.CourseId = c.Id
WHERE cn.Status = 'pending'
ORDER BY cn.CreationTime DESC;
GO

-- 6. Check recent courses created
PRINT '================================================';
PRINT '6. Checking recent courses created (last 10)...';
PRINT '================================================';
SELECT TOP 10
    Id,
    Title,
    InstructorId,
    Status,
    ApprovalStatus,
    RejectionReason,
    CreationTime
FROM [dbo].[Courses]
ORDER BY CreationTime DESC;
GO

-- 7. Test stored procedure sp_GetPendingCourseNotifications
PRINT '================================================';
PRINT '7. Testing sp_GetPendingCourseNotifications...';
PRINT '================================================';
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetPendingCourseNotifications]') AND type in (N'P', N'PC'))
BEGIN
    EXEC sp_GetPendingCourseNotifications;
END
ELSE
BEGIN
    PRINT 'ERROR: Stored procedure sp_GetPendingCourseNotifications does NOT exist!';
END
GO

-- 8. Check if there are any courses without notifications
PRINT '================================================';
PRINT '8. Checking courses with status=pending but no notification...';
PRINT '================================================';
SELECT 
    c.Id AS CourseId,
    c.Title,
    c.InstructorId,
    c.Status,
    c.ApprovalStatus,
    c.CreationTime,
    CASE WHEN cn.Id IS NULL THEN 'NO NOTIFICATION' ELSE 'HAS NOTIFICATION' END AS NotificationStatus
FROM [dbo].[Courses] c
LEFT JOIN [dbo].[CourseNotifications] cn ON c.Id = cn.CourseId
WHERE c.Status = 'pending'
ORDER BY c.CreationTime DESC;
GO

PRINT '================================================';
PRINT 'Debug completed!';
PRINT '================================================';
