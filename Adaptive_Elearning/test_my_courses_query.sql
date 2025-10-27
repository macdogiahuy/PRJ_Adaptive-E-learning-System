-- Test query giống MyCoursesServlet
USE [CourseHubDB]
GO

PRINT '==================================='
PRINT '   TEST MY COURSES QUERY'
PRINT '==================================='
PRINT ''

-- User admin1234567
DECLARE @UserId UNIQUEIDENTIFIER = 'C90648FF-C420-4B9D-92B2-081D7CC209D5'

PRINT 'Testing for user: ' + CAST(@UserId AS VARCHAR(36))
PRINT 'Username: admin1234567'
PRINT ''

-- Query giống trong MyCoursesServlet.getEnrolledCoursesNative()
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
PRINT 'Row count: ' + CAST(@@ROWCOUNT AS VARCHAR(10))
PRINT ''
PRINT '==================================='
GO
