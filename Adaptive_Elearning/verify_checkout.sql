-- Script kiểm tra sau khi thanh toán
-- Chạy script này NGAY SAU KHI thanh toán thành công

USE [CourseHubDB]
GO

PRINT '======================================='
PRINT '   CHECKOUT VERIFICATION SCRIPT'
PRINT '======================================='
PRINT ''

-- Lấy checkout gần nhất
DECLARE @LatestCheckoutId UNIQUEIDENTIFIER
DECLARE @LatestUserId UNIQUEIDENTIFIER

SELECT TOP 1 
    @LatestCheckoutId = cc.Id,
    @LatestUserId = cc.UserId
FROM CartCheckout cc
ORDER BY cc.CreationTime DESC

PRINT '1. LATEST CHECKOUT INFO:'
PRINT '---------------------------------------'
SELECT 
    cc.Id AS CheckoutId,
    cc.UserId,
    u.UserName,
    cc.CourseIds,
    cc.TotalAmount,
    cc.PaymentMethod,
    cc.Status,
    cc.CreationTime,
    cc.ProcessedTime
FROM CartCheckout cc
LEFT JOIN Users u ON cc.UserId = u.Id
WHERE cc.Id = @LatestCheckoutId
GO

PRINT ''
PRINT '2. BILL CREATED FROM CHECKOUT:'
PRINT '---------------------------------------'
SELECT TOP 1
    b.Id AS BillId,
    b.CreatorId,
    u.UserName,
    b.Action,
    b.Amount,
    b.Gateway,
    b.IsSuccessful,
    b.CreationTime,
    b.Note
FROM Bills b
LEFT JOIN Users u ON b.CreatorId = u.Id
WHERE b.Action = 'Pay for course'
ORDER BY b.CreationTime DESC
GO

PRINT ''
PRINT '3. ENROLLMENTS CREATED FROM BILL:'
PRINT '---------------------------------------'
-- Lấy BillId gần nhất
DECLARE @LastBillId UNIQUEIDENTIFIER
SELECT TOP 1 @LastBillId = Id 
FROM Bills 
WHERE Action = 'Pay for course'
ORDER BY CreationTime DESC

SELECT 
    e.CreatorId,
    u.UserName,
    e.CourseId,
    c.Title AS CourseName,
    c.Price,
    e.Status,
    e.CreationTime,
    e.BillId,
    CASE 
        WHEN e.BillId = @LastBillId THEN '✓ Matched'
        ELSE '✗ Mismatch'
    END AS BillMatch
FROM Enrollments e
LEFT JOIN Users u ON e.CreatorId = u.Id
LEFT JOIN Courses c ON e.CourseId = c.Id
WHERE e.BillId = @LastBillId
ORDER BY e.CreationTime DESC
GO

PRINT ''
PRINT '4. ALL RECENT ENROLLMENTS (Last 5):'
PRINT '---------------------------------------'
SELECT TOP 5
    e.CreatorId,
    u.UserName,
    c.Title AS CourseName,
    e.Status,
    e.CreationTime,
    DATEDIFF(SECOND, e.CreationTime, GETDATE()) AS SecondsAgo
FROM Enrollments e
LEFT JOIN Users u ON e.CreatorId = u.Id
LEFT JOIN Courses c ON e.CourseId = c.Id
ORDER BY e.CreationTime DESC
GO

PRINT ''
PRINT '5. STATUS DISTRIBUTION:'
PRINT '---------------------------------------'
SELECT 
    Status,
    COUNT(*) AS Count,
    MIN(CreationTime) AS FirstCreated,
    MAX(CreationTime) AS LastCreated
FROM Enrollments
GROUP BY Status
ORDER BY Count DESC
GO

PRINT ''
PRINT '6. VERIFY USER CAN SEE COURSES:'
PRINT '---------------------------------------'
-- Lấy user từ checkout gần nhất
DECLARE @TestUser UNIQUEIDENTIFIER
SELECT TOP 1 @TestUser = UserId 
FROM CartCheckout 
ORDER BY CreationTime DESC

PRINT 'Testing query for user: ' + CAST(@TestUser AS VARCHAR(36))

-- Query giống MyCoursesServlet
SELECT 
    c.Id AS CourseId,
    c.Title,
    c.ThumbUrl,
    c.Price,
    c.Level,
    c.LearnerCount,
    e.Status,
    e.CreationTime,
    e.BillId,
    -- Check if status will be displayed correctly
    CASE 
        WHEN e.Status IN ('ACTIVE', 'Active', 'Ongoing') THEN '✓ Will show as "Đang học"'
        WHEN e.Status IN ('COMPLETED', 'Completed') THEN '✓ Will show as "Hoàn thành"'
        ELSE '⚠ Will show raw status: ' + e.Status
    END AS DisplayStatus
FROM Courses c
INNER JOIN Enrollments e ON c.Id = e.CourseId
WHERE e.CreatorId = @TestUser
ORDER BY e.CreationTime DESC
GO

PRINT ''
PRINT '======================================='
PRINT '   VERIFICATION COMPLETED'
PRINT '======================================='
PRINT ''
PRINT 'EXPECTED RESULTS:'
PRINT '1. Checkout Status = "Success" or "Completed"'
PRINT '2. Bill IsSuccessful = 1'
PRINT '3. Enrollments count > 0'
PRINT '4. Enrollment Status = "ACTIVE" (uppercase)'
PRINT '5. BillMatch = "✓ Matched"'
PRINT '6. DisplayStatus shows correct Vietnamese label'
PRINT ''
PRINT 'IF ALL CHECKS PASS:'
PRINT '→ Courses should appear in /my-courses page'
PRINT '→ Cart should be empty'
PRINT ''
GO
