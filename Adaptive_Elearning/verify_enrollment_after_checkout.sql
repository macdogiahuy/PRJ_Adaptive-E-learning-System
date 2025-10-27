-- Script kiểm tra enrollment sau khi checkout
USE CourseHubDB
GO

PRINT '=== CHECKING ENROLLMENT AFTER CHECKOUT ==='
PRINT ''

-- 1. Kiểm tra user admin1234567
DECLARE @UserId UNIQUEIDENTIFIER = 'C90648FF-C420-4B9D-92B2-081D7CC209D5'

PRINT '1. User Information:'
SELECT Id, UserName, Email, Role 
FROM Users 
WHERE Id = @UserId
PRINT ''

-- 2. Kiểm tra Bills gần đây nhất
PRINT '2. Recent Bills (Last 5):'
SELECT TOP 5 
    Id, 
    Action, 
    Amount, 
    Gateway,
    IsSuccessful,
    CreationTime,
    CreatorId
FROM Bills 
WHERE CreatorId = @UserId
ORDER BY CreationTime DESC
PRINT ''

-- 3. Kiểm tra CartCheckout gần đây nhất
PRINT '3. Recent Checkouts (Last 5):'
SELECT TOP 5
    Id,
    CourseIds,
    TotalAmount,
    PaymentMethod,
    Status,
    CreationTime,
    ProcessedTime
FROM CartCheckout
WHERE UserId = @UserId
ORDER BY CreationTime DESC
PRINT ''

-- 4. Kiểm tra Enrollments
PRINT '4. All Enrollments for User:'
SELECT 
    e.CourseId,
    c.Title AS CourseTitle,
    e.Status,
    e.BillId,
    e.CreationTime,
    b.Amount AS BillAmount,
    b.Gateway
FROM Enrollments e
LEFT JOIN Courses c ON e.CourseId = c.Id
LEFT JOIN Bills b ON e.BillId = b.Id
WHERE e.CreatorId = @UserId
ORDER BY e.CreationTime DESC
PRINT ''

-- 5. Test query giống như MyCoursesServlet
PRINT '5. Testing MyCoursesServlet Query:'
SELECT 
    c.Id, 
    c.Title, 
    c.ThumbUrl, 
    c.Price, 
    c.Level, 
    c.LearnerCount,
    e.Status, 
    e.CreationTime, 
    e.BillId
FROM Courses c
INNER JOIN Enrollments e ON c.Id = e.CourseId
WHERE e.CreatorId = @UserId
ORDER BY e.CreationTime DESC
PRINT ''

-- 6. Kiểm tra Status values trong Enrollments
PRINT '6. Distinct Status Values in Enrollments:'
SELECT DISTINCT 
    Status,
    COUNT(*) AS Count
FROM Enrollments
WHERE CreatorId = @UserId
GROUP BY Status
PRINT ''

PRINT '=== VERIFICATION COMPLETE ==='
