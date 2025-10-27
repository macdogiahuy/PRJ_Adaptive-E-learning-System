-- Script để debug enrollment issues
-- Chạy trong SQL Server Management Studio

USE [CourseHubDB]
GO

PRINT '==================================='
PRINT '   ENROLLMENT DEBUG SCRIPT'
PRINT '==================================='
PRINT ''

-- 1. Kiểm tra tất cả enrollments
PRINT '1. ALL ENROLLMENTS (Latest 10):'
PRINT '-----------------------------------'
SELECT TOP 10
    e.CreatorId,
    u.UserName,
    e.CourseId,
    c.Title AS CourseName,
    e.Status,
    e.CreationTime,
    e.BillId
FROM Enrollments e
LEFT JOIN Users u ON e.CreatorId = u.Id
LEFT JOIN Courses c ON e.CourseId = c.Id
ORDER BY e.CreationTime DESC
GO

PRINT ''
PRINT '2. ENROLLMENTS BY USER:'
PRINT '-----------------------------------'
-- Thay YOUR_USER_ID bằng ID của user bạn đang test
-- Bạn có thể lấy user ID bằng query: SELECT Id, UserName, Email FROM Users WHERE UserName = 'your_username'

DECLARE @TestUserId UNIQUEIDENTIFIER
-- Uncomment và thay YOUR_USER_ID
-- SET @TestUserId = 'YOUR_USER_ID_HERE'

-- Nếu không biết user ID, có thể query theo username:
SELECT @TestUserId = Id FROM Users WHERE UserName = 'de180551chauvuonghoan@gmail.com' -- Thay bằng username của bạn

IF @TestUserId IS NOT NULL
BEGIN
    PRINT 'User ID: ' + CAST(@TestUserId AS VARCHAR(36))
    
    SELECT 
        e.CreatorId,
        u.UserName,
        u.Email,
        c.Id AS CourseId,
        c.Title AS CourseName,
        c.Price,
        e.Status,
        e.CreationTime,
        b.Amount AS BillAmount,
        b.Gateway AS PaymentMethod
    FROM Enrollments e
    LEFT JOIN Users u ON e.CreatorId = u.Id
    LEFT JOIN Courses c ON e.CourseId = c.Id
    LEFT JOIN Bills b ON e.BillId = b.Id
    WHERE e.CreatorId = @TestUserId
    ORDER BY e.CreationTime DESC
END
ELSE
BEGIN
    PRINT 'User not found! Please update the username in the script.'
END
GO

PRINT ''
PRINT '3. RECENT CHECKOUT HISTORY:'
PRINT '-----------------------------------'
SELECT TOP 5
    cc.Id AS CheckoutId,
    cc.UserId,
    u.UserName,
    cc.CourseIds,
    cc.TotalAmount,
    cc.PaymentMethod,
    cc.Status,
    cc.CreationTime,
    cc.ProcessedTime,
    cc.Notes
FROM CartCheckout cc
LEFT JOIN Users u ON cc.UserId = u.Id
ORDER BY cc.CreationTime DESC
GO

PRINT ''
PRINT '4. RECENT BILLS:'
PRINT '-----------------------------------'
SELECT TOP 5
    b.Id AS BillId,
    b.CreatorId,
    u.UserName,
    b.Action,
    b.Amount,
    b.Gateway,
    b.IsSuccessful,
    b.CreationTime,
    -- Count enrollments linked to this bill
    (SELECT COUNT(*) FROM Enrollments e WHERE e.BillId = b.Id) AS EnrollmentCount
FROM Bills b
LEFT JOIN Users u ON b.CreatorId = u.Id
WHERE b.Action = 'Pay for course'
ORDER BY b.CreationTime DESC
GO

PRINT ''
PRINT '5. ORPHANED ENROLLMENTS (Without valid Bill):'
PRINT '-----------------------------------'
SELECT 
    e.CreatorId,
    u.UserName,
    c.Title AS CourseName,
    e.Status,
    e.CreationTime,
    e.BillId,
    CASE 
        WHEN b.Id IS NULL THEN 'Bill not found'
        WHEN b.IsSuccessful = 0 THEN 'Bill failed'
        ELSE 'Bill OK'
    END AS BillStatus
FROM Enrollments e
LEFT JOIN Users u ON e.CreatorId = u.Id
LEFT JOIN Courses c ON e.CourseId = c.Id
LEFT JOIN Bills b ON e.BillId = b.Id
WHERE b.Id IS NULL OR b.IsSuccessful = 0
ORDER BY e.CreationTime DESC
GO

PRINT ''
PRINT '6. USERS WITH ENROLLMENT COUNT:'
PRINT '-----------------------------------'
SELECT 
    u.Id,
    u.UserName,
    u.Email,
    COUNT(e.CourseId) AS TotalEnrollments,
    COUNT(CASE WHEN e.Status = 'ACTIVE' THEN 1 END) AS ActiveEnrollments,
    COUNT(CASE WHEN e.Status = 'COMPLETED' THEN 1 END) AS CompletedEnrollments,
    MAX(e.CreationTime) AS LastEnrollment
FROM Users u
LEFT JOIN Enrollments e ON u.Id = e.CreatorId
GROUP BY u.Id, u.UserName, u.Email
HAVING COUNT(e.CourseId) > 0
ORDER BY TotalEnrollments DESC
GO

PRINT ''
PRINT '==================================='
PRINT '   DEBUG SCRIPT COMPLETED'
PRINT '==================================='
PRINT ''
PRINT 'NEXT STEPS:'
PRINT '1. Check if enrollments were created after checkout'
PRINT '2. Verify Status is ACTIVE (not Active)'
PRINT '3. Check if BillId matches between Bills and Enrollments'
PRINT '4. Verify userId format (UNIQUEIDENTIFIER)'
PRINT ''
GO
