-- ===================================================================
-- Check course "123" approval status
-- ===================================================================
USE [CourseHubDB]
GO

SELECT 
    c.Id,
    c.Title,
    c.Status,
    c.ApprovalStatus,
    c.RejectionReason,
    c.LastModificationTime
FROM [dbo].[Courses] c
WHERE c.Title = '123';

-- Check notification for this course
SELECT 
    cn.Id,
    cn.CourseId,
    cn.CourseTitle,
    cn.Status AS NotificationStatus,
    cn.CreationTime,
    cn.ProcessedTime,
    cn.ProcessedBy
FROM [dbo].[CourseNotifications] cn
WHERE cn.CourseTitle = '123';
