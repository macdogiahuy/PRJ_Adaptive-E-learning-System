-- QUICK CHECK: Copy và paste toàn bộ đoạn này vào SSMS và nhấn F5

USE CourseHubDB
GO

DECLARE @UserId UNIQUEIDENTIFIER = 'C90648FF-C420-4B9D-92B2-081D7CC209D5'

PRINT '========================================='
PRINT '  QUICK ENROLLMENT CHECK'
PRINT '========================================='
PRINT ''

-- 1. Đếm tổng số enrollments
PRINT '1. TOTAL ENROLLMENTS:'
SELECT COUNT(*) AS TotalEnrollments
FROM Enrollments 
WHERE CreatorId = @UserId
PRINT ''

-- 2. Xem chi tiết enrollments
PRINT '2. ENROLLMENT DETAILS:'
SELECT 
    c.Title AS CourseTitle,
    e.Status,
    CONVERT(VARCHAR(19), e.CreationTime, 120) AS EnrollmentDate,
    e.BillId,
    b.Amount
FROM Enrollments e
LEFT JOIN Courses c ON e.CourseId = c.Id
LEFT JOIN Bills b ON e.BillId = b.Id
WHERE e.CreatorId = @UserId
ORDER BY e.CreationTime DESC
PRINT ''

-- 3. Kiểm tra Bills
PRINT '3. RECENT BILLS (Last 3):'
SELECT TOP 3
    Id,
    Action,
    Amount,
    Gateway,
    CONVERT(VARCHAR(19), CreationTime, 120) AS BillDate
FROM Bills
WHERE CreatorId = @UserId
ORDER BY CreationTime DESC
PRINT ''

-- 4. Test MyCoursesServlet query
PRINT '4. MYCOURSES QUERY TEST:'
DECLARE @QueryResultCount INT
SELECT @QueryResultCount = COUNT(*)
FROM Courses c
INNER JOIN Enrollments e ON c.Id = e.CourseId
WHERE e.CreatorId = @UserId

PRINT 'Query returns: ' + CAST(@QueryResultCount AS VARCHAR) + ' rows'

IF @QueryResultCount > 0
BEGIN
    PRINT ''
    SELECT 
        c.Id AS CourseId,
        c.Title AS CourseTitle,
        e.Status,
        CONVERT(VARCHAR(19), e.CreationTime, 120) AS EnrolledAt
    FROM Courses c
    INNER JOIN Enrollments e ON c.Id = e.CourseId
    WHERE e.CreatorId = @UserId
    ORDER BY e.CreationTime DESC
END
ELSE
BEGIN
    PRINT '⚠ WARNING: Query returns 0 rows but enrollments exist!'
END

PRINT ''
PRINT '========================================='
PRINT '  CHECK COMPLETE'
PRINT '========================================='
