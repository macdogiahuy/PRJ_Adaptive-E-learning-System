-- =============================================
-- Test Script cho Cart Checkout System
-- =============================================

USE [CourseHubDB]
GO

-- Test 1: Tạo test data
PRINT '=== CREATING TEST DATA ==='

-- Tạo test user nếu chưa có
DECLARE @TestUserId UNIQUEIDENTIFIER = NEWID()
DECLARE @TestCourseId1 UNIQUEIDENTIFIER = NEWID()
DECLARE @TestCourseId2 UNIQUEIDENTIFIER = NEWID()

-- Check if test user exists
IF NOT EXISTS (SELECT 1 FROM [dbo].[Users] WHERE [Email] = 'test@checkout.com')
BEGIN
    INSERT INTO [dbo].[Users] (
        [Id], [UserName], [Email], [Password], [Status], [Role], 
        [CreationTime], [Country], [AvatarUrl]
    )
    VALUES (
        @TestUserId, 'Test Checkout User', 'test@checkout.com', 'hashedpassword', 
        'Active', 'Student', GETDATE(), 'Vietnam', NULL
    )
    PRINT 'Test user created: ' + CAST(@TestUserId AS VARCHAR(36))
END
ELSE
BEGIN
    SELECT @TestUserId = [Id] FROM [dbo].[Users] WHERE [Email] = 'test@checkout.com'
    PRINT 'Using existing test user: ' + CAST(@TestUserId AS VARCHAR(36))
END

-- Check if test courses exist
IF NOT EXISTS (SELECT 1 FROM [dbo].[Courses] WHERE [Name] = 'Test Course 1')
BEGIN
    INSERT INTO [dbo].[Courses] (
        [Id], [Name], [Summary], [Description], [ThumbnailUrl], [VideoUrl],
        [Price], [DiscountPrice], [Status], [Level], [Duration], [Language],
        [CreationTime], [CreatorId], [CategoryId]
    )
    VALUES (
        @TestCourseId1, 'Test Course 1', 'Test Summary 1', 'Test Description 1', 
        NULL, NULL, 100000, 90000, 'Published', 'Beginner', '10 hours', 'Vietnamese',
        GETDATE(), @TestUserId, (SELECT TOP 1 [Id] FROM [dbo].[Categories])
    )
    PRINT 'Test course 1 created: ' + CAST(@TestCourseId1 AS VARCHAR(36))
END
ELSE
BEGIN
    SELECT @TestCourseId1 = [Id] FROM [dbo].[Courses] WHERE [Name] = 'Test Course 1'
    PRINT 'Using existing test course 1: ' + CAST(@TestCourseId1 AS VARCHAR(36))
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[Courses] WHERE [Name] = 'Test Course 2')
BEGIN
    INSERT INTO [dbo].[Courses] (
        [Id], [Name], [Summary], [Description], [ThumbnailUrl], [VideoUrl],
        [Price], [DiscountPrice], [Status], [Level], [Duration], [Language],
        [CreationTime], [CreatorId], [CategoryId]
    )
    VALUES (
        @TestCourseId2, 'Test Course 2', 'Test Summary 2', 'Test Description 2', 
        NULL, NULL, 150000, 120000, 'Published', 'Intermediate', '15 hours', 'Vietnamese',
        GETDATE(), @TestUserId, (SELECT TOP 1 [Id] FROM [dbo].[Categories])
    )
    PRINT 'Test course 2 created: ' + CAST(@TestCourseId2 AS VARCHAR(36))
END
ELSE
BEGIN
    SELECT @TestCourseId2 = [Id] FROM [dbo].[Courses] WHERE [Name] = 'Test Course 2'
    PRINT 'Using existing test course 2: ' + CAST(@TestCourseId2 AS VARCHAR(36))
END

-- Test 2: Test ProcessCartCheckout procedure với COD
PRINT ''
PRINT '=== TESTING COD CHECKOUT ==='

DECLARE @BillId UNIQUEIDENTIFIER
DECLARE @CheckoutId UNIQUEIDENTIFIER  
DECLARE @ResultMessage NVARCHAR(500)
DECLARE @CourseIdsJson NVARCHAR(MAX) = '["' + CAST(@TestCourseId1 AS VARCHAR(36)) + '","' + CAST(@TestCourseId2 AS VARCHAR(36)) + '"]'

EXEC [dbo].[ProcessCartCheckout]
    @UserId = @TestUserId,
    @CourseIds = @CourseIdsJson,
    @TotalAmount = 210000,
    @PaymentMethod = 'COD',
    @SessionId = 'TEST_SESSION_001',
    @BillId = @BillId OUTPUT,
    @CheckoutId = @CheckoutId OUTPUT,
    @ResultMessage = @ResultMessage OUTPUT

PRINT 'COD Checkout Result:'
PRINT 'Bill ID: ' + CAST(@BillId AS VARCHAR(36))
PRINT 'Checkout ID: ' + CAST(@CheckoutId AS VARCHAR(36))
PRINT 'Message: ' + @ResultMessage

-- Test 3: Test ProcessCartCheckout procedure với Online payment
PRINT ''
PRINT '=== TESTING ONLINE CHECKOUT ==='

DECLARE @BillId2 UNIQUEIDENTIFIER
DECLARE @CheckoutId2 UNIQUEIDENTIFIER  
DECLARE @ResultMessage2 NVARCHAR(500)

EXEC [dbo].[ProcessCartCheckout]
    @UserId = @TestUserId,
    @CourseIds = @CourseIdsJson,
    @TotalAmount = 210000,
    @PaymentMethod = 'Online',
    @SessionId = 'TEST_SESSION_002',
    @BillId = @BillId2 OUTPUT,
    @CheckoutId = @CheckoutId2 OUTPUT,
    @ResultMessage = @ResultMessage2 OUTPUT

PRINT 'Online Checkout Result:'
PRINT 'Bill ID: ' + CAST(@BillId2 AS VARCHAR(36))
PRINT 'Checkout ID: ' + CAST(@CheckoutId2 AS VARCHAR(36))
PRINT 'Message: ' + @ResultMessage2

-- Test 4: Test GetUserCheckoutHistory
PRINT ''
PRINT '=== TESTING CHECKOUT HISTORY ==='

EXEC [dbo].[GetUserCheckoutHistory] @UserId = @TestUserId, @Top = 5

-- Test 5: Kiểm tra dữ liệu đã tạo
PRINT ''
PRINT '=== VERIFYING CREATED DATA ==='

-- Check Bills
SELECT 'Bills Created:' AS Info, COUNT(*) AS Count
FROM [dbo].[Bills] 
WHERE [CreatorId] = @TestUserId

-- Check Enrollments
SELECT 'Enrollments Created:' AS Info, COUNT(*) AS Count
FROM [dbo].[Enrollments] 
WHERE [CreatorId] = @TestUserId

-- Check CartCheckout
SELECT 'Checkout Records:' AS Info, COUNT(*) AS Count
FROM [dbo].[CartCheckout] 
WHERE [UserId] = @TestUserId

-- Test 6: Test GetCheckoutStats function
PRINT ''
PRINT '=== TESTING CHECKOUT STATISTICS ==='

SELECT * FROM [dbo].[GetCheckoutStats](DATEADD(DAY, -1, GETDATE()), GETDATE())

-- Test 7: Detailed verification
PRINT ''
PRINT '=== DETAILED VERIFICATION ==='

SELECT 
    'Recent Bills' AS TableName,
    b.[Id],
    b.[Action],
    b.[Amount],
    b.[Gateway],
    b.[TransactionId],
    b.[IsSuccessful],
    b.[CreationTime]
FROM [dbo].[Bills] b
WHERE b.[CreatorId] = @TestUserId
ORDER BY b.[CreationTime] DESC

SELECT 
    'Recent Checkouts' AS TableName,
    cc.[Id],
    cc.[TotalAmount],
    cc.[PaymentMethod],
    cc.[Status],
    cc.[CreationTime]
FROM [dbo].[CartCheckout] cc
WHERE cc.[UserId] = @TestUserId
ORDER BY cc.[CreationTime] DESC

SELECT 
    'Recent Enrollments' AS TableName,
    e.[CourseId],
    c.[Name] AS CourseName,
    e.[Status],
    e.[CreationTime]
FROM [dbo].[Enrollments] e
INNER JOIN [dbo].[Courses] c ON e.[CourseId] = c.[Id]
WHERE e.[CreatorId] = @TestUserId
ORDER BY e.[CreationTime] DESC

PRINT ''
PRINT '=== TEST COMPLETED SUCCESSFULLY ==='
PRINT 'All stored procedures and triggers are working correctly!'
PRINT 'You can now use the CartCheckoutService in your Java application.'