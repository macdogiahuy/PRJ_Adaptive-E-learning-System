-- =============================================
-- Simple Test cho Cart Checkout System
-- Author: EduHub Development Team
-- Create date: 2025-10-25  
-- Description: Test đơn giản với cấu trúc bảng thực tế
-- =============================================

USE [CourseHubDB]
GO

PRINT '=== TESTING CART CHECKOUT SYSTEM ==='
PRINT ''

-- Test 1: Kiểm tra stored procedure có tồn tại
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'ProcessCartCheckout')
    PRINT '✓ ProcessCartCheckout procedure exists'
ELSE
    PRINT '✗ ProcessCartCheckout procedure NOT found'

-- Test 2: Kiểm tra bảng CartCheckout
IF EXISTS (SELECT * FROM sysobjects WHERE name='CartCheckout' AND xtype='U')
    PRINT '✓ CartCheckout table exists'
ELSE
    PRINT '✗ CartCheckout table NOT found'

-- Test 3: Lấy một user thật từ database để test
DECLARE @RealUserId UNIQUEIDENTIFIER
DECLARE @RealUserName NVARCHAR(255)

SELECT TOP 1 @RealUserId = [Id], @RealUserName = [UserName] 
FROM [dbo].[Users] 
WHERE [UserName] IS NOT NULL

IF @RealUserId IS NOT NULL
BEGIN
    PRINT '✓ Found real user for testing: ' + @RealUserName + ' (' + CAST(@RealUserId AS VARCHAR(36)) + ')'
    
    -- Test 4: Lấy courses thật để test
    DECLARE @Course1Id UNIQUEIDENTIFIER  
    DECLARE @Course2Id UNIQUEIDENTIFIER
    DECLARE @Course1Title NVARCHAR(255)
    DECLARE @Course2Title NVARCHAR(255)
    
    SELECT TOP 1 @Course1Id = [Id], @Course1Title = [Title] 
    FROM [dbo].[Courses] 
    WHERE [Title] IS NOT NULL
    ORDER BY [CreationTime] DESC
    
    SELECT TOP 1 @Course2Id = [Id], @Course2Title = [Title] 
    FROM [dbo].[Courses] 
    WHERE [Title] IS NOT NULL AND [Id] != @Course1Id
    ORDER BY [CreationTime] DESC
    
    IF @Course1Id IS NOT NULL AND @Course2Id IS NOT NULL
    BEGIN
        PRINT '✓ Found courses for testing:'
        PRINT '  Course 1: ' + @Course1Title + ' (' + CAST(@Course1Id AS VARCHAR(36)) + ')'
        PRINT '  Course 2: ' + @Course2Title + ' (' + CAST(@Course2Id AS VARCHAR(36)) + ')'
        PRINT ''
        
        -- Test 5: Test COD checkout với dữ liệu thật
        PRINT '=== TESTING COD CHECKOUT ==='
        
        DECLARE @BillId UNIQUEIDENTIFIER
        DECLARE @CheckoutId UNIQUEIDENTIFIER  
        DECLARE @ResultMessage NVARCHAR(500)
        DECLARE @CourseIdsJson NVARCHAR(MAX) = '["' + CAST(@Course1Id AS VARCHAR(36)) + '","' + CAST(@Course2Id AS VARCHAR(36)) + '"]'
        
        BEGIN TRY
            EXEC [dbo].[ProcessCartCheckout]
                @UserId = @RealUserId,
                @CourseIds = @CourseIdsJson,
                @TotalAmount = 250000,
                @PaymentMethod = 'COD',
                @SessionId = 'TEST_SESSION_COD',
                @BillId = @BillId OUTPUT,
                @CheckoutId = @CheckoutId OUTPUT,
                @ResultMessage = @ResultMessage OUTPUT
            
            PRINT '✓ COD Checkout Success!'
            PRINT '  Bill ID: ' + CAST(@BillId AS VARCHAR(36))
            PRINT '  Checkout ID: ' + CAST(@CheckoutId AS VARCHAR(36))
            PRINT '  Message: ' + @ResultMessage
            
        END TRY
        BEGIN CATCH
            PRINT '✗ COD Checkout Failed: ' + ERROR_MESSAGE()
        END CATCH
        
        PRINT ''
        
        -- Test 6: Test Online checkout
        PRINT '=== TESTING ONLINE CHECKOUT ==='
        
        DECLARE @BillId2 UNIQUEIDENTIFIER
        DECLARE @CheckoutId2 UNIQUEIDENTIFIER  
        DECLARE @ResultMessage2 NVARCHAR(500)
        
        BEGIN TRY
            EXEC [dbo].[ProcessCartCheckout]
                @UserId = @RealUserId,
                @CourseIds = @CourseIdsJson,
                @TotalAmount = 300000,
                @PaymentMethod = 'Online',
                @SessionId = 'TEST_SESSION_ONLINE',
                @BillId = @BillId2 OUTPUT,
                @CheckoutId = @CheckoutId2 OUTPUT,
                @ResultMessage = @ResultMessage2 OUTPUT
            
            PRINT '✓ Online Checkout Success!'
            PRINT '  Bill ID: ' + CAST(@BillId2 AS VARCHAR(36))
            PRINT '  Checkout ID: ' + CAST(@CheckoutId2 AS VARCHAR(36))
            PRINT '  Message: ' + @ResultMessage2
            
        END TRY
        BEGIN CATCH
            PRINT '✗ Online Checkout Failed: ' + ERROR_MESSAGE()
        END CATCH
        
        PRINT ''
        
        -- Test 7: Kiểm tra dữ liệu đã tạo
        PRINT '=== VERIFYING CREATED DATA ==='
        
        DECLARE @BillCount INT
        DECLARE @CheckoutCount INT  
        DECLARE @EnrollmentCount INT
        
        SELECT @BillCount = COUNT(*) FROM [dbo].[Bills] WHERE [CreatorId] = @RealUserId
        SELECT @CheckoutCount = COUNT(*) FROM [dbo].[CartCheckout] WHERE [UserId] = @RealUserId  
        SELECT @EnrollmentCount = COUNT(*) FROM [dbo].[Enrollments] WHERE [CreatorId] = @RealUserId
        
        PRINT '✓ Bills created: ' + CAST(@BillCount AS VARCHAR)
        PRINT '✓ Checkout records: ' + CAST(@CheckoutCount AS VARCHAR)
        PRINT '✓ Enrollments created: ' + CAST(@EnrollmentCount AS VARCHAR)
        
        -- Test 8: Test GetUserCheckoutHistory
        PRINT ''
        PRINT '=== TESTING CHECKOUT HISTORY ==='
        
        BEGIN TRY
            EXEC [dbo].[GetUserCheckoutHistory] @UserId = @RealUserId, @Top = 3
            PRINT '✓ Checkout history retrieved successfully'
        END TRY
        BEGIN CATCH
            PRINT '✗ Checkout history failed: ' + ERROR_MESSAGE()
        END CATCH
        
    END
    ELSE
    BEGIN
        PRINT '✗ Not enough courses found for testing'
    END
END
ELSE
BEGIN
    PRINT '✗ No users found in database for testing'
END

PRINT ''
PRINT '=== TEST COMPLETED ==='
PRINT 'Cart Checkout System is ready!'
PRINT ''

-- Show recent activity
PRINT '=== RECENT ACTIVITY ==='
SELECT TOP 5 
    'Recent Bills' AS Activity,
    b.[Id],
    b.[Gateway],
    b.[Amount],
    b.[CreationTime]
FROM [dbo].[Bills] b
ORDER BY b.[CreationTime] DESC

SELECT TOP 5
    'Recent Checkouts' AS Activity,
    cc.[Id], 
    cc.[PaymentMethod],
    cc.[Status],
    cc.[TotalAmount],
    cc.[CreationTime]
FROM [dbo].[CartCheckout] cc
ORDER BY cc.[CreationTime] DESC