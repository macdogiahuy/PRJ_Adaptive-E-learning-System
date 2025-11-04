-- ===================================================================
-- Test Script: Verify Course Creation Flow
-- Chạy script này TRƯỚC KHI tạo course để reset môi trường test
-- ===================================================================

USE [CourseHubDB]
GO

PRINT '================================================';
PRINT 'BƯỚC 1: Xóa course test cũ (nếu có)';
PRINT '================================================';

-- Delete test course "d" and its notification
DECLARE @TestCourseId UNIQUEIDENTIFIER;
SELECT @TestCourseId = Id FROM Courses WHERE Title = 'd';

IF @TestCourseId IS NOT NULL
BEGIN
    -- Delete notification first (foreign key)
    DELETE FROM CourseNotifications WHERE CourseId = @TestCourseId;
    PRINT 'Deleted old notifications for course "d"';
    
    -- Delete course
    DELETE FROM Courses WHERE Id = @TestCourseId;
    PRINT 'Deleted old course "d"';
END
ELSE
BEGIN
    PRINT 'No old course "d" found';
END
GO

PRINT '================================================';
PRINT 'BƯỚC 2: Kiểm tra trạng thái hiện tại';
PRINT '================================================';

SELECT 
    COUNT(*) AS TotalCourses,
    SUM(CASE WHEN Status = 'pending' THEN 1 ELSE 0 END) AS PendingCourses,
    SUM(CASE WHEN Status = 'Ongoing' THEN 1 ELSE 0 END) AS OngoingCourses
FROM Courses;
GO

SELECT 
    COUNT(*) AS TotalNotifications,
    SUM(CASE WHEN Status = 'pending' THEN 1 ELSE 0 END) AS PendingNotifications
FROM CourseNotifications;
GO

PRINT '================================================';
PRINT 'Môi trường đã sẵn sàng để test!';
PRINT 'Bây giờ hãy:';
PRINT '1. Đảm bảo server đã restart với code mới';
PRINT '2. Login as instructor';
PRINT '3. Tạo course mới với title "TestCourse_' + CONVERT(VARCHAR, GETDATE(), 108) + '"';
PRINT '4. Chạy script verify_course_creation.sql để kiểm tra kết quả';
PRINT '================================================';
