-- ===================================================================
-- Verify Script: Check if Course Creation Flow Works Correctly
-- Chạy script này SAU KHI tạo course mới
-- ===================================================================

USE [CourseHubDB]
GO

PRINT '================================================';
PRINT 'KIỂM TRA 1: Course mới nhất được tạo';
PRINT '================================================';

SELECT TOP 1
    Id,
    Title,
    InstructorId,
    Status,
    ApprovalStatus,
    RejectionReason,
    CreationTime,
    CASE 
        WHEN Status = 'pending' THEN '✓ ĐÚNG - Course ở trạng thái pending'
        WHEN Status = 'Ongoing' THEN '✗ SAI - Course đã là Ongoing (code cũ chưa deploy)'
        ELSE '? KHÁC - Status: ' + Status
    END AS StatusCheck
FROM Courses
ORDER BY CreationTime DESC;
GO

PRINT '================================================';
PRINT 'KIỂM TRA 2: Notification được tạo cho course';
PRINT '================================================';

SELECT TOP 1
    cn.Id,
    cn.CourseId,
    cn.CourseTitle,
    cn.InstructorName,
    cn.Status,
    cn.CreationTime,
    c.Status AS CourseStatus,
    c.ApprovalStatus AS CourseApprovalStatus,
    CASE 
        WHEN cn.Id IS NOT NULL THEN '✓ ĐÚNG - Notification đã được tạo'
        ELSE '✗ SAI - Không có notification'
    END AS NotificationCheck
FROM CourseNotifications cn
INNER JOIN Courses c ON cn.CourseId = c.Id
ORDER BY cn.CreationTime DESC;
GO

PRINT '================================================';
PRINT 'KIỂM TRA 3: Stored Procedure hoạt động';
PRINT '================================================';

EXEC sp_GetPendingCourseNotifications;
GO

PRINT '================================================';
PRINT 'KIỂM TRA 4: Tổng quan hệ thống';
PRINT '================================================';

SELECT 
    'Courses' AS TableName,
    COUNT(*) AS Total,
    SUM(CASE WHEN Status = 'pending' THEN 1 ELSE 0 END) AS Pending,
    SUM(CASE WHEN Status = 'Ongoing' THEN 1 ELSE 0 END) AS Ongoing,
    SUM(CASE WHEN ApprovalStatus = 'pending' THEN 1 ELSE 0 END) AS WaitingApproval,
    SUM(CASE WHEN ApprovalStatus = 'approved' THEN 1 ELSE 0 END) AS Approved
FROM Courses

UNION ALL

SELECT 
    'Notifications' AS TableName,
    COUNT(*) AS Total,
    SUM(CASE WHEN Status = 'pending' THEN 1 ELSE 0 END) AS Pending,
    NULL AS Ongoing,
    NULL AS WaitingApproval,
    SUM(CASE WHEN Status = 'approved' THEN 1 ELSE 0 END) AS Approved
FROM CourseNotifications;
GO

PRINT '================================================';
PRINT 'KẾT LUẬN:';
PRINT 'Nếu course mới có Status="pending" và có notification => SUCCESS ✓';
PRINT 'Nếu course mới có Status="Ongoing" => Code cũ chưa deploy ✗';
PRINT '================================================';
