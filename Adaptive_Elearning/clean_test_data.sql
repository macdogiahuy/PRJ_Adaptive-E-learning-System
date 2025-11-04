-- ===================================================================
-- Script: Xóa course test cũ và chuẩn bị test mới
-- ===================================================================

USE [CourseHubDB]
GO

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

PRINT '================================================';
PRINT 'Xóa tất cả course test và notifications cũ';
PRINT '================================================';

-- Delete all test courses (title starts with 'test', 'oke', 'd', etc.)
DECLARE @TestCourseIds TABLE (Id UNIQUEIDENTIFIER);

INSERT INTO @TestCourseIds
SELECT Id FROM Courses 
WHERE Title IN ('d', 'oke test', 'TestCourse', 'test')
OR Title LIKE 'test%'
OR Title LIKE 'Test%';

DELETE FROM CourseNotifications 
WHERE CourseId IN (SELECT Id FROM @TestCourseIds);

DELETE FROM Courses 
WHERE Id IN (SELECT Id FROM @TestCourseIds);

PRINT 'Đã xóa tất cả course test cũ';
GO

PRINT '================================================';
PRINT 'Trạng thái hiện tại:';
PRINT '================================================';

SELECT 
    COUNT(*) AS TotalCourses,
    SUM(CASE WHEN Status = 'pending' THEN 1 ELSE 0 END) AS PendingCourses,
    SUM(CASE WHEN Status = 'Ongoing' THEN 1 ELSE 0 END) AS OngoingCourses
FROM Courses;

SELECT 
    COUNT(*) AS TotalNotifications
FROM CourseNotifications;
GO

PRINT '================================================';
PRINT 'Môi trường đã sẵn sàng!';
PRINT 'BÂY GIỜ HÃY:';
PRINT '1. Restart server: mvn cargo:run';
PRINT '2. Login as instructor';
PRINT '3. Tạo course mới với title: "NewTestCourse"';
PRINT '4. Kiểm tra console logs xem có lỗi gì không';
PRINT '5. Chạy verify_course_creation.sql';
PRINT '================================================';
