-- =============================================
-- Cart Checkout Trigger và Stored Procedures
-- Author: EduHub Development Team
-- Create date: 2025-10-25
-- Description: Xử lý checkout giỏ hàng và tạo bill thanh toán
-- =============================================

USE [CourseHubDB]
GO

-- Tạo bảng CartCheckout để lưu thông tin checkout tạm thời
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='CartCheckout' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[CartCheckout](
        [Id] [uniqueidentifier] NOT NULL DEFAULT NEWID(),
        [UserId] [uniqueidentifier] NOT NULL,
        [CourseIds] [nvarchar](max) NOT NULL, -- JSON array của course IDs
        [TotalAmount] [bigint] NOT NULL,
        [PaymentMethod] [varchar](20) NOT NULL, -- 'COD' hoặc 'Online'
        [Status] [varchar](20) NOT NULL DEFAULT 'PENDING', -- 'PENDING', 'PROCESSING', 'COMPLETED', 'FAILED'
        [CreationTime] [datetime2](7) NOT NULL DEFAULT GETDATE(),
        [ProcessedTime] [datetime2](7) NULL,
        [Notes] [nvarchar](500) NULL,
        [SessionId] [varchar](100) NULL,
        CONSTRAINT [PK_CartCheckout] PRIMARY KEY CLUSTERED ([Id] ASC)
    )
    
    -- Tạo index cho performance
    CREATE INDEX [IX_CartCheckout_UserId] ON [dbo].[CartCheckout] ([UserId])
    CREATE INDEX [IX_CartCheckout_Status] ON [dbo].[CartCheckout] ([Status])
    CREATE INDEX [IX_CartCheckout_CreationTime] ON [dbo].[CartCheckout] ([CreationTime])
    
    PRINT 'Table CartCheckout created successfully'
END
GO

-- =============================================
-- Stored Procedure: ProcessCartCheckout
-- Description: Xử lý checkout giỏ hàng
-- =============================================
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'ProcessCartCheckout')
    DROP PROCEDURE [dbo].[ProcessCartCheckout]
GO

CREATE PROCEDURE [dbo].[ProcessCartCheckout]
    @UserId UNIQUEIDENTIFIER,
    @CourseIds NVARCHAR(MAX), -- JSON format: ["courseId1", "courseId2"]
    @TotalAmount BIGINT,
    @PaymentMethod VARCHAR(20), -- 'COD' or 'Online'
    @SessionId VARCHAR(100) = NULL,
    @BillId UNIQUEIDENTIFIER OUTPUT,
    @CheckoutId UNIQUEIDENTIFIER OUTPUT,
    @ResultMessage NVARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @TransactionId VARCHAR(100)
    DECLARE @ClientTransactionId VARCHAR(100)
    DECLARE @Gateway VARCHAR(20)
    DECLARE @Note NVARCHAR(255)
    DECLARE @ErrorMsg NVARCHAR(500)
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        -- Tạo IDs
        SET @BillId = NEWID()
        SET @CheckoutId = NEWID()
        SET @TransactionId = 'EDU' + FORMAT(GETDATE(), 'yyyyMMddHHmmss') + RIGHT('000' + CAST(ABS(CHECKSUM(NEWID())) % 1000 AS VARCHAR), 3)
        SET @ClientTransactionId = @TransactionId
        
        -- Thiết lập thông tin theo payment method
        IF @PaymentMethod = 'COD'
        BEGIN
            SET @Gateway = 'COD'
            SET @Note = N'Thanh toán khi nhận hàng - Đơn hàng khóa học'
        END
        ELSE
        BEGIN
            SET @Gateway = 'VietQR'
            SET @Note = N'Thanh toán online qua VietQR - Đơn hàng khóa học'
        END
        
        -- Kiểm tra user tồn tại
        IF NOT EXISTS (SELECT 1 FROM [dbo].[Users] WHERE [Id] = @UserId)
        BEGIN
            SET @ErrorMsg = N'Người dùng không tồn tại'
            RAISERROR(@ErrorMsg, 16, 1)
            RETURN
        END
        
        -- Tạo record checkout
        INSERT INTO [dbo].[CartCheckout] (
            [Id], [UserId], [CourseIds], [TotalAmount], 
            [PaymentMethod], [Status], [SessionId], [Notes]
        )
        VALUES (
            @CheckoutId, @UserId, @CourseIds, @TotalAmount, 
            @PaymentMethod, 'PROCESSING', @SessionId, @Note
        )
        
        -- Tạo Bill
        INSERT INTO [dbo].[Bills] (
            [Id], [Action], [Note], [Amount], [Gateway],
            [TransactionId], [ClientTransactionId], [Token],
            [IsSuccessful], [CreationTime], [CreatorId]
        )
        VALUES (
            @BillId, 'Pay for course', @Note, @TotalAmount, @Gateway,
            @TransactionId, @ClientTransactionId, '1',
            1, GETDATE(), @UserId
        )
        
        -- Tạo Enrollments cho từng course
        DECLARE @CourseId UNIQUEIDENTIFIER
        DECLARE @JSON NVARCHAR(MAX) = @CourseIds
        DECLARE @Index INT = 0
        DECLARE @MaxIndex INT
        
        -- Đếm số lượng course IDs trong JSON array
        SELECT @MaxIndex = COUNT(*)
        FROM OPENJSON(@JSON)
        
        -- Parse JSON và tạo enrollments
        WHILE @Index < @MaxIndex
        BEGIN
            SET @CourseId = CAST(JSON_VALUE(@JSON, '$[' + CAST(@Index AS VARCHAR) + ']') AS UNIQUEIDENTIFIER)
            
            -- Kiểm tra course tồn tại
            IF EXISTS (SELECT 1 FROM [dbo].[Courses] WHERE [Id] = @CourseId)
            BEGIN
                -- Kiểm tra chưa enroll trước đó
                IF NOT EXISTS (
                    SELECT 1 FROM [dbo].[Enrollments] 
                    WHERE [CreatorId] = @UserId AND [CourseId] = @CourseId
                )
                BEGIN
                    INSERT INTO [dbo].[Enrollments] (
                        [CreatorId], [CourseId], [Status], [BillId], [CreationTime],
                        [AssignmentMilestones], [LectureMilestones], [SectionMilestones]
                    )
                    VALUES (
                        @UserId, @CourseId, N'Active', @BillId, GETDATE(),
                        N'[]', N'[]', N'[]'
                    )
                END
            END
            
            SET @Index = @Index + 1
        END
        
        -- Cập nhật checkout status
        UPDATE [dbo].[CartCheckout] 
        SET [Status] = 'COMPLETED', [ProcessedTime] = GETDATE()
        WHERE [Id] = @CheckoutId
        
        COMMIT TRANSACTION
        
        SET @ResultMessage = N'Checkout thành công. Bill ID: ' + CAST(@BillId AS VARCHAR(36))
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
            
        SET @ErrorMsg = ERROR_MESSAGE()
        SET @ResultMessage = N'Lỗi xử lý checkout: ' + @ErrorMsg
        
        -- Cập nhật checkout status failed
        UPDATE [dbo].[CartCheckout] 
        SET [Status] = 'FAILED', [ProcessedTime] = GETDATE(), [Notes] = @ErrorMsg
        WHERE [Id] = @CheckoutId
        
        RAISERROR(@ErrorMsg, 16, 1)
    END CATCH
END
GO

-- =============================================
-- Stored Procedure: GetUserCheckoutHistory
-- Description: Lấy lịch sử checkout của user
-- =============================================
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'GetUserCheckoutHistory')
    DROP PROCEDURE [dbo].[GetUserCheckoutHistory]
GO

CREATE PROCEDURE [dbo].[GetUserCheckoutHistory]
    @UserId UNIQUEIDENTIFIER,
    @Top INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT TOP (@Top)
        cc.[Id] AS CheckoutId,
        cc.[TotalAmount],
        cc.[PaymentMethod],
        cc.[Status],
        cc.[CreationTime],
        cc.[ProcessedTime],
        cc.[Notes],
        b.[Id] AS BillId,
        b.[TransactionId],
        b.[IsSuccessful]
    FROM [dbo].[CartCheckout] cc
    LEFT JOIN [dbo].[Bills] b ON cc.[UserId] = b.[CreatorId] 
        AND ABS(DATEDIFF(SECOND, cc.[CreationTime], b.[CreationTime])) <= 5
    WHERE cc.[UserId] = @UserId
    ORDER BY cc.[CreationTime] DESC
END
GO

-- =============================================
-- Stored Procedure: CleanupOldCheckouts
-- Description: Dọn dẹp các checkout cũ (older than 30 days)
-- =============================================
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'CleanupOldCheckouts')
    DROP PROCEDURE [dbo].[CleanupOldCheckouts]
GO

CREATE PROCEDURE [dbo].[CleanupOldCheckouts]
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @DeletedCount INT
    
    DELETE FROM [dbo].[CartCheckout]
    WHERE [CreationTime] < DATEADD(DAY, -30, GETDATE())
        AND [Status] IN ('COMPLETED', 'FAILED')
    
    SET @DeletedCount = @@ROWCOUNT
    
    PRINT 'Cleaned up ' + CAST(@DeletedCount AS VARCHAR) + ' old checkout records'
END
GO

-- =============================================
-- Trigger: tg_CartCheckout_AfterInsert
-- Description: Tự động xử lý sau khi insert vào CartCheckout
-- =============================================
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tg_CartCheckout_AfterInsert')
    DROP TRIGGER [dbo].[tg_CartCheckout_AfterInsert]
GO

CREATE TRIGGER [dbo].[tg_CartCheckout_AfterInsert]
ON [dbo].[CartCheckout]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @CheckoutId UNIQUEIDENTIFIER
    DECLARE @UserId UNIQUEIDENTIFIER
    DECLARE @PaymentMethod VARCHAR(20)
    DECLARE @TotalAmount BIGINT
    
    -- Lấy thông tin từ inserted record
    SELECT 
        @CheckoutId = [Id],
        @UserId = [UserId],
        @PaymentMethod = [PaymentMethod],
        @TotalAmount = [TotalAmount]
    FROM inserted
    
    -- Log trigger execution
    PRINT 'Trigger executed for CheckoutId: ' + CAST(@CheckoutId AS VARCHAR(36))
    
    -- Có thể thêm logic bổ sung ở đây:
    -- - Gửi notification
    -- - Update cache
    -- - Log audit trail
    -- - etc.
END
GO

-- =============================================
-- Function: GetCheckoutStats
-- Description: Lấy thống kê checkout
-- =============================================
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'FN' AND name = 'GetCheckoutStats')
    DROP FUNCTION [dbo].[GetCheckoutStats]
GO

CREATE FUNCTION [dbo].[GetCheckoutStats](@FromDate DATETIME2, @ToDate DATETIME2)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        COUNT(*) AS TotalCheckouts,
        SUM(CASE WHEN [Status] = 'COMPLETED' THEN 1 ELSE 0 END) AS CompletedCheckouts,
        SUM(CASE WHEN [Status] = 'FAILED' THEN 1 ELSE 0 END) AS FailedCheckouts,
        SUM(CASE WHEN [PaymentMethod] = 'COD' THEN 1 ELSE 0 END) AS CODCheckouts,
        SUM(CASE WHEN [PaymentMethod] = 'Online' THEN 1 ELSE 0 END) AS OnlineCheckouts,
        SUM(CASE WHEN [Status] = 'COMPLETED' THEN [TotalAmount] ELSE 0 END) AS TotalRevenue,
        AVG(CASE WHEN [Status] = 'COMPLETED' THEN CAST([TotalAmount] AS FLOAT) ELSE NULL END) AS AvgOrderValue
    FROM [dbo].[CartCheckout]
    WHERE [CreationTime] BETWEEN @FromDate AND @ToDate
)
GO

-- =============================================
-- Test Data và Examples
-- =============================================
PRINT '========================================='
PRINT 'Cart Checkout System - Database Objects Created Successfully!'
PRINT '========================================='
PRINT ''
PRINT 'Available Procedures:'
PRINT '1. ProcessCartCheckout - Xử lý checkout giỏ hàng'
PRINT '2. GetUserCheckoutHistory - Lấy lịch sử checkout'
PRINT '3. CleanupOldCheckouts - Dọn dẹp dữ liệu cũ'
PRINT ''
PRINT 'Available Functions:'
PRINT '1. GetCheckoutStats - Thống kê checkout'
PRINT ''
PRINT 'Available Triggers:'
PRINT '1. tg_CartCheckout_AfterInsert - Xử lý sau khi insert checkout'
PRINT ''
PRINT 'Example Usage:'
PRINT 'DECLARE @BillId UNIQUEIDENTIFIER, @CheckoutId UNIQUEIDENTIFIER, @Msg NVARCHAR(500)'
PRINT 'EXEC ProcessCartCheckout @UserId=''user-guid'', @CourseIds=''["course1","course2"]'', @TotalAmount=100000, @PaymentMethod=''COD'', @BillId=@BillId OUTPUT, @CheckoutId=@CheckoutId OUTPUT, @ResultMessage=@Msg OUTPUT'
PRINT '========================================='