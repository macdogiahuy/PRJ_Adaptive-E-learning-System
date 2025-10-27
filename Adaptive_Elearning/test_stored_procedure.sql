-- Test stored procedure trực tiếp
USE [CourseHubDB]
GO

PRINT '==================================='
PRINT '   TEST STORED PROCEDURE'
PRINT '==================================='
PRINT ''

-- Test với user admin và 2 courses từ checkout gần nhất
DECLARE @UserId UNIQUEIDENTIFIER = 'C90648FF-C420-4B9D-92B2-081D7CC209D5'
DECLARE @CourseIds NVARCHAR(MAX) = '["00EF965C-D74E-487B-AB36-55619D89EF37","670896F5-B0A1-413F-9C77-07E103A131C6"]'
DECLARE @TotalAmount BIGINT = 250000
DECLARE @PaymentMethod VARCHAR(20) = 'COD'
DECLARE @SessionId VARCHAR(100) = 'TEST_SESSION'
DECLARE @BillId UNIQUEIDENTIFIER
DECLARE @CheckoutId UNIQUEIDENTIFIER
DECLARE @ResultMessage NVARCHAR(500)

PRINT 'Input Parameters:'
PRINT '  UserId: ' + CAST(@UserId AS VARCHAR(36))
PRINT '  CourseIds: ' + @CourseIds
PRINT '  TotalAmount: ' + CAST(@TotalAmount AS VARCHAR(20))
PRINT '  PaymentMethod: ' + @PaymentMethod
PRINT ''

-- Execute stored procedure
EXEC [dbo].[ProcessCartCheckout]
    @UserId = @UserId,
    @CourseIds = @CourseIds,
    @TotalAmount = @TotalAmount,
    @PaymentMethod = @PaymentMethod,
    @SessionId = @SessionId,
    @BillId = @BillId OUTPUT,
    @CheckoutId = @CheckoutId OUTPUT,
    @ResultMessage = @ResultMessage OUTPUT

PRINT ''
PRINT 'Output:'
PRINT '  BillId: ' + CAST(@BillId AS VARCHAR(36))
PRINT '  CheckoutId: ' + CAST(@CheckoutId AS VARCHAR(36))
PRINT '  Message: ' + ISNULL(@ResultMessage, 'NULL')
PRINT ''

-- Check results
PRINT 'Checking Created Records:'
PRINT '-----------------------------------'

PRINT ''
PRINT '1. Bill created:'
SELECT 
    Id, 
    Amount, 
    Gateway, 
    IsSuccessful, 
    CreationTime
FROM Bills 
WHERE Id = @BillId

PRINT ''
PRINT '2. CartCheckout created:'
SELECT 
    Id, 
    Status, 
    TotalAmount, 
    PaymentMethod,
    CreationTime
FROM CartCheckout 
WHERE Id = @CheckoutId

PRINT ''
PRINT '3. Enrollments created:'
SELECT 
    e.CreatorId,
    e.CourseId,
    c.Title AS CourseName,
    e.Status,
    e.BillId,
    e.CreationTime
FROM Enrollments e
LEFT JOIN Courses c ON e.CourseId = c.Id
WHERE e.BillId = @BillId

PRINT ''
PRINT '==================================='
GO
