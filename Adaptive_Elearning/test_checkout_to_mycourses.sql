-- Test script: Mô phỏng checkout và kiểm tra enrollment
USE CourseHubDB
GO

PRINT '========================================='
PRINT '  TEST: CHECKOUT TO MY COURSES FLOW'
PRINT '========================================='
PRINT ''

-- Setup test data
DECLARE @TestUserId UNIQUEIDENTIFIER = 'C90648FF-C420-4B9D-92B2-081D7CC209D5' -- admin1234567
DECLARE @TestCourseIds NVARCHAR(MAX)
DECLARE @BillId UNIQUEIDENTIFIER
DECLARE @CheckoutId UNIQUEIDENTIFIER  
DECLARE @ResultMessage NVARCHAR(500)

-- Lấy 2 course bất kỳ để test
DECLARE @Course1 UNIQUEIDENTIFIER
DECLARE @Course2 UNIQUEIDENTIFIER

SELECT TOP 1 @Course1 = Id FROM Courses WHERE Id NOT IN (
    SELECT CourseId FROM Enrollments WHERE CreatorId = @TestUserId
) ORDER BY NEWID()

SELECT TOP 1 @Course2 = Id FROM Courses WHERE Id NOT IN (
    SELECT CourseId FROM Enrollments WHERE CreatorId = @TestUserId
) AND Id != @Course1 ORDER BY NEWID()

-- Build JSON course IDs
SET @TestCourseIds = '["' + CAST(@Course1 AS VARCHAR(36)) + '","' + CAST(@Course2 AS VARCHAR(36)) + '"]'

PRINT '1. TEST SETUP'
PRINT '   User ID: ' + CAST(@TestUserId AS VARCHAR(36))
PRINT '   Course IDs: ' + @TestCourseIds
PRINT ''

-- Get course info
PRINT '2. COURSES TO PURCHASE:'
SELECT Id, Title, Price FROM Courses WHERE Id IN (@Course1, @Course2)
PRINT ''

PRINT '3. CURRENT ENROLLMENTS BEFORE CHECKOUT:'
SELECT COUNT(*) AS CurrentEnrollmentCount
FROM Enrollments 
WHERE CreatorId = @TestUserId
PRINT ''

-- Execute checkout stored procedure
PRINT '4. EXECUTING CHECKOUT PROCEDURE...'
PRINT ''

BEGIN TRY
    EXEC [dbo].[ProcessCartCheckout]
        @UserId = @TestUserId,
        @CourseIds = @TestCourseIds,
        @TotalAmount = 500000,
        @PaymentMethod = 'COD',
        @SessionId = 'TEST_SESSION_001',
        @BillId = @BillId OUTPUT,
        @CheckoutId = @CheckoutId OUTPUT,
        @ResultMessage = @ResultMessage OUTPUT
    
    PRINT '   ✓ Checkout successful!'
    PRINT '   Bill ID: ' + CAST(@BillId AS VARCHAR(36))
    PRINT '   Checkout ID: ' + CAST(@CheckoutId AS VARCHAR(36))
    PRINT '   Message: ' + @ResultMessage
    PRINT ''
    
    -- Verify enrollments created
    PRINT '5. ENROLLMENTS AFTER CHECKOUT:'
    SELECT 
        e.CourseId,
        c.Title AS CourseTitle,
        e.Status,
        e.BillId,
        e.CreationTime
    FROM Enrollments e
    LEFT JOIN Courses c ON e.CourseId = c.Id
    WHERE e.CreatorId = @TestUserId
    ORDER BY e.CreationTime DESC
    PRINT ''
    
    -- Test MyCoursesServlet query
    PRINT '6. MYCOURSES SERVLET QUERY RESULT:'
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
    WHERE e.CreatorId = @TestUserId
    ORDER BY e.CreationTime DESC
    PRINT ''
    
    -- Verify status values
    PRINT '7. STATUS VALUES IN ENROLLMENTS:'
    SELECT DISTINCT Status, COUNT(*) AS Count
    FROM Enrollments
    WHERE CreatorId = @TestUserId
    GROUP BY Status
    PRINT ''
    
    PRINT '========================================='
    PRINT '  ✓ TEST COMPLETED SUCCESSFULLY'
    PRINT '========================================='
    
END TRY
BEGIN CATCH
    PRINT '   ✗ Error occurred!'
    PRINT '   Error: ' + ERROR_MESSAGE()
    PRINT ''
    PRINT '========================================='
    PRINT '  ✗ TEST FAILED'
    PRINT '========================================='
END CATCH
