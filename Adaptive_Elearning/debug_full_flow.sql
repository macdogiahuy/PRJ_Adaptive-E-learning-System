-- Debug script: Kiểm tra tất cả các bước của flow checkout → my courses
USE CourseHubDB
GO

SET NOCOUNT ON

PRINT '========================================='
PRINT '  FULL DIAGNOSTIC: CHECKOUT → MY COURSES'
PRINT '========================================='
PRINT ''

DECLARE @UserId UNIQUEIDENTIFIER = 'C90648FF-C420-4B9D-92B2-081D7CC209D5'

-- === STEP 1: Verify User ===
PRINT '1. USER VERIFICATION'
PRINT '   ─────────────────────────────────────'
IF EXISTS (SELECT 1 FROM Users WHERE Id = @UserId)
BEGIN
    SELECT 
        'Found' AS Status,
        Id, 
        UserName, 
        Email, 
        Role 
    FROM Users 
    WHERE Id = @UserId
END
ELSE
BEGIN
    PRINT '   ✗ User not found!'
END
PRINT ''

-- === STEP 2: Check Stored Procedure ===
PRINT '2. STORED PROCEDURE CHECK'
PRINT '   ─────────────────────────────────────'
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProcessCartCheckout]') AND type in (N'P', N'PC'))
BEGIN
    PRINT '   ✓ ProcessCartCheckout exists'
    
    -- Get procedure definition
    SELECT 
        OBJECT_DEFINITION(OBJECT_ID('[dbo].[ProcessCartCheckout]')) AS ProcedureDefinition
    WHERE 1=0 -- Comment this out if you want to see full definition
END
ELSE
BEGIN
    PRINT '   ✗ ProcessCartCheckout NOT FOUND!'
END
PRINT ''

-- === STEP 3: Check Bills ===
PRINT '3. BILLS HISTORY (Last 5)'
PRINT '   ─────────────────────────────────────'
IF EXISTS (SELECT 1 FROM Bills WHERE CreatorId = @UserId)
BEGIN
    SELECT TOP 5
        Id,
        Action,
        Amount,
        Gateway,
        IsSuccessful,
        CONVERT(VARCHAR(19), CreationTime, 120) AS CreationTime
    FROM Bills
    WHERE CreatorId = @UserId
    ORDER BY CreationTime DESC
END
ELSE
BEGIN
    PRINT '   (No bills found)'
END
PRINT ''

-- === STEP 4: Check CartCheckout ===
PRINT '4. CART CHECKOUT HISTORY (Last 5)'
PRINT '   ─────────────────────────────────────'
IF EXISTS (SELECT 1 FROM CartCheckout WHERE UserId = @UserId)
BEGIN
    SELECT TOP 5
        Id,
        LEFT(CourseIds, 50) + '...' AS CourseIds,
        TotalAmount,
        PaymentMethod,
        Status,
        CONVERT(VARCHAR(19), CreationTime, 120) AS CreationTime
    FROM CartCheckout
    WHERE UserId = @UserId
    ORDER BY CreationTime DESC
END
ELSE
BEGIN
    PRINT '   (No checkout history found)'
END
PRINT ''

-- === STEP 5: Check Enrollments Table ===
PRINT '5. ENROLLMENTS TABLE STRUCTURE'
PRINT '   ─────────────────────────────────────'
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Enrollments'
ORDER BY ORDINAL_POSITION
PRINT ''

-- === STEP 6: Check All Enrollments ===
PRINT '6. ALL ENROLLMENTS FOR USER'
PRINT '   ─────────────────────────────────────'
IF EXISTS (SELECT 1 FROM Enrollments WHERE CreatorId = @UserId)
BEGIN
    SELECT 
        e.CourseId,
        c.Title AS CourseTitle,
        e.Status,
        '[' + e.Status + ']' AS StatusWithBrackets,
        LEN(e.Status) AS StatusLength,
        ASCII(LEFT(e.Status, 1)) AS FirstCharASCII,
        e.BillId,
        CONVERT(VARCHAR(19), e.CreationTime, 120) AS CreationTime
    FROM Enrollments e
    LEFT JOIN Courses c ON e.CourseId = c.Id
    WHERE e.CreatorId = @UserId
    ORDER BY e.CreationTime DESC
END
ELSE
BEGIN
    PRINT '   (No enrollments found)'
END
PRINT ''

-- === STEP 7: Test MyCoursesServlet Query ===
PRINT '7. MYCOURSES SERVLET QUERY TEST'
PRINT '   ─────────────────────────────────────'
PRINT '   Query: SELECT c.Id, c.Title, e.Status'
PRINT '          FROM Courses c'
PRINT '          INNER JOIN Enrollments e ON c.Id = e.CourseId'
PRINT '          WHERE e.CreatorId = ?'
PRINT ''

DECLARE @QueryResult INT
SELECT @QueryResult = COUNT(*)
FROM Courses c
INNER JOIN Enrollments e ON c.Id = e.CourseId
WHERE e.CreatorId = @UserId

IF @QueryResult > 0
BEGIN
    PRINT '   ✓ Query returns ' + CAST(@QueryResult AS VARCHAR) + ' rows'
    PRINT ''
    
    SELECT 
        c.Id, 
        c.Title, 
        c.ThumbUrl,
        c.Price,
        e.Status,
        '[' + e.Status + ']' AS StatusFormatted,
        CONVERT(VARCHAR(19), e.CreationTime, 120) AS EnrollmentDate,
        e.BillId
    FROM Courses c
    INNER JOIN Enrollments e ON c.Id = e.CourseId
    WHERE e.CreatorId = @UserId
    ORDER BY e.CreationTime DESC
END
ELSE
BEGIN
    PRINT '   ✗ Query returns 0 rows - THIS IS THE PROBLEM!'
    PRINT ''
    
    -- Debug: Check if problem is with JOIN
    PRINT '   Debug: Checking Enrollments alone...'
    SELECT COUNT(*) AS EnrollmentCount FROM Enrollments WHERE CreatorId = @UserId
    
    PRINT '   Debug: Checking Courses existence...'
    SELECT COUNT(*) AS CourseCount 
    FROM Enrollments e
    LEFT JOIN Courses c ON e.CourseId = c.Id
    WHERE e.CreatorId = @UserId AND c.Id IS NULL
END
PRINT ''

-- === STEP 8: Status Values Analysis ===
PRINT '8. STATUS VALUES ANALYSIS'
PRINT '   ─────────────────────────────────────'
SELECT 
    Status,
    '[' + Status + ']' AS StatusWithBrackets,
    LEN(Status) AS Length,
    COUNT(*) AS Count,
    CASE 
        WHEN Status = 'ACTIVE' THEN '✓ Matches JSP'
        WHEN Status = 'Active' THEN '✓ Matches JSP'
        WHEN Status = 'Ongoing' THEN '✓ Matches JSP'
        WHEN Status = 'COMPLETED' THEN '✓ Matches JSP'
        WHEN Status = 'Completed' THEN '✓ Matches JSP'
        ELSE '✗ NOT in JSP mapping'
    END AS JSPCompatibility
FROM Enrollments
WHERE CreatorId = @UserId
GROUP BY Status
PRINT ''

-- === STEP 9: Recent Activity Summary ===
PRINT '9. RECENT ACTIVITY SUMMARY'
PRINT '   ─────────────────────────────────────'
DECLARE @BillCount INT, @CheckoutCount INT, @EnrollmentCount INT

SELECT @BillCount = COUNT(*) FROM Bills WHERE CreatorId = @UserId
SELECT @CheckoutCount = COUNT(*) FROM CartCheckout WHERE UserId = @UserId  
SELECT @EnrollmentCount = COUNT(*) FROM Enrollments WHERE CreatorId = @UserId

PRINT '   Bills: ' + CAST(@BillCount AS VARCHAR)
PRINT '   Checkouts: ' + CAST(@CheckoutCount AS VARCHAR)
PRINT '   Enrollments: ' + CAST(@EnrollmentCount AS VARCHAR)
PRINT ''

IF @BillCount > 0 AND @CheckoutCount > 0 AND @EnrollmentCount = 0
BEGIN
    PRINT '   ⚠ WARNING: User has bills and checkouts but NO enrollments!'
    PRINT '   → Stored procedure may not be creating enrollments correctly'
END
ELSE IF @EnrollmentCount > 0 AND @QueryResult = 0
BEGIN
    PRINT '   ⚠ WARNING: Enrollments exist but query returns 0!'
    PRINT '   → JOIN or filter condition may be incorrect'
END
ELSE IF @BillCount > 0 AND @EnrollmentCount > 0 AND @QueryResult > 0
BEGIN
    PRINT '   ✓ Everything looks correct!'
END
PRINT ''

PRINT '========================================='
PRINT '  DIAGNOSTIC COMPLETE'
PRINT '========================================='
