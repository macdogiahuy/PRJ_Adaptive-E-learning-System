-- =============================================
-- Final Fix ProcessCartCheckout Procedure  
-- Author: EduHub Development Team
-- Create date: 2025-10-25
-- Description: Sửa cuối cùng với SET options đúng
-- =============================================

USE [CourseHubDB]
GO

-- Set proper options
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Drop và tạo lại stored procedure 
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
    SET ANSI_NULLS ON;
    SET QUOTED_IDENTIFIER ON;
    
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
        
        -- Tạo Enrollments cho từng course - Simple approach
        -- Parse JSON courses và tạo enrollments
        INSERT INTO [dbo].[Enrollments] (
            [CreatorId], [CourseId], [Status], [BillId], [CreationTime],
            [AssignmentMilestones], [LectureMilestones], [SectionMilestones]
        )
        SELECT 
            @UserId,
            CAST([value] AS UNIQUEIDENTIFIER),
            N'Active',
            @BillId,
            GETDATE(),
            N'[]',
            N'[]', 
            N'[]'
        FROM OPENJSON(@CourseIds)
        WHERE EXISTS (
            SELECT 1 FROM [dbo].[Courses] c 
            WHERE c.[Id] = CAST([value] AS UNIQUEIDENTIFIER)
        )
        AND NOT EXISTS (
            SELECT 1 FROM [dbo].[Enrollments] e
            WHERE e.[CreatorId] = @UserId 
            AND e.[CourseId] = CAST([value] AS UNIQUEIDENTIFIER)
        )
        
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
        
        -- Cập nhật checkout status failed nếu có
        IF @CheckoutId IS NOT NULL
        BEGIN
            UPDATE [dbo].[CartCheckout] 
            SET [Status] = 'FAILED', [ProcessedTime] = GETDATE(), [Notes] = @ErrorMsg
            WHERE [Id] = @CheckoutId
        END
        
        RAISERROR(@ErrorMsg, 16, 1)
    END CATCH
END
GO

PRINT '========================================='
PRINT 'ProcessCartCheckout Procedure - FINAL VERSION'
PRINT 'Ready for production use!'
PRINT '========================================='