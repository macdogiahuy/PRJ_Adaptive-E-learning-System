-- Script sửa lại Stored Procedure ProcessCartCheckout
-- Để đảm bảo enrollment được tạo đúng với BillId và Status

USE [CourseHubDB]
GO

-- Drop procedure cũ nếu tồn tại
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProcessCartCheckout]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ProcessCartCheckout]
GO

-- Set options BEFORE creating procedure
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
    DECLARE @EnrollmentCount INT = 0
    DECLARE @SkippedCount INT = 0
    
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
            [PaymentMethod], [Status], [SessionId], [Notes], [CreationTime]
        )
        VALUES (
            @CheckoutId, @UserId, @CourseIds, @TotalAmount, 
            @PaymentMethod, 'PROCESSING', @SessionId, @Note, GETDATE()
        )
        
        -- Tạo Bill chính
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
        DECLARE @CourseIdStr VARCHAR(36)
        DECLARE @CourseTitle NVARCHAR(255)
        
        -- Sử dụng cursor để xử lý từng course
        DECLARE course_cursor CURSOR FOR
        SELECT [value] 
        FROM OPENJSON(@CourseIds)
        
        OPEN course_cursor
        FETCH NEXT FROM course_cursor INTO @CourseIdStr
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            BEGIN TRY
                -- Convert string to UNIQUEIDENTIFIER
                SET @CourseId = CAST(@CourseIdStr AS UNIQUEIDENTIFIER)
                
                -- Lấy thông tin course
                SELECT @CourseTitle = [Title] 
                FROM [dbo].[Courses] 
                WHERE [Id] = @CourseId
                
                -- Kiểm tra course tồn tại
                IF @CourseTitle IS NOT NULL
                BEGIN
                    -- Kiểm tra chưa enroll trước đó
                    IF NOT EXISTS (
                        SELECT 1 FROM [dbo].[Enrollments] 
                        WHERE [CreatorId] = @UserId AND [CourseId] = @CourseId
                    )
                    BEGIN
                        -- Tạo enrollment với BillId chính và Status = ACTIVE (chữ hoa)
                        INSERT INTO [dbo].[Enrollments] (
                            [CreatorId], [CourseId], [Status], [BillId], [CreationTime],
                            [AssignmentMilestones], [LectureMilestones], [SectionMilestones]
                        )
                        VALUES (
                            @UserId, @CourseId, N'ACTIVE', @BillId, GETDATE(),
                            N'[]', N'[]', N'[]'
                        )
                        
                        SET @EnrollmentCount = @EnrollmentCount + 1
                        PRINT 'Created enrollment for course: ' + ISNULL(@CourseTitle, @CourseIdStr)
                    END
                    ELSE
                    BEGIN
                        SET @SkippedCount = @SkippedCount + 1
                        PRINT 'User already enrolled in course: ' + ISNULL(@CourseTitle, @CourseIdStr)
                    END
                END
                ELSE
                BEGIN
                    PRINT 'Course not found: ' + @CourseIdStr
                END
            END TRY
            BEGIN CATCH
                PRINT 'Error processing course ' + @CourseIdStr + ': ' + ERROR_MESSAGE()
            END CATCH
            
            FETCH NEXT FROM course_cursor INTO @CourseIdStr
        END
        
        CLOSE course_cursor
        DEALLOCATE course_cursor
        
        -- Cập nhật checkout status
        UPDATE [dbo].[CartCheckout] 
        SET [Status] = 'COMPLETED', [ProcessedTime] = GETDATE(),
            [Notes] = @Note + N' - Enrollments: ' + CAST(@EnrollmentCount AS VARCHAR) + N', Skipped: ' + CAST(@SkippedCount AS VARCHAR)
        WHERE [Id] = @CheckoutId
        
        COMMIT TRANSACTION
        
        SET @ResultMessage = N'Checkout thành công. Bill ID: ' + CAST(@BillId AS VARCHAR(36)) + 
                           N', Enrollments: ' + CAST(@EnrollmentCount AS VARCHAR) + 
                           N', Skipped: ' + CAST(@SkippedCount AS VARCHAR)
        
        PRINT 'Checkout completed successfully for user: ' + CAST(@UserId AS VARCHAR(36))
        PRINT 'Enrollments created: ' + CAST(@EnrollmentCount AS VARCHAR)
        PRINT 'Enrollments skipped: ' + CAST(@SkippedCount AS VARCHAR)
        
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
        
        PRINT 'Checkout failed: ' + @ErrorMsg
        RAISERROR(@ErrorMsg, 16, 1)
    END CATCH
END
GO

-- Test procedure với sample data
PRINT '=== Testing ProcessCartCheckout Procedure ==='
GO

-- Bạn có thể test bằng cách uncomment các dòng dưới đây
/*
DECLARE @TestUserId UNIQUEIDENTIFIER = 'YOUR_USER_ID_HERE'
DECLARE @TestCourseIds NVARCHAR(MAX) = '["COURSE_ID_1", "COURSE_ID_2"]'
DECLARE @TestAmount BIGINT = 500000
DECLARE @TestMethod VARCHAR(20) = 'COD'
DECLARE @OutBillId UNIQUEIDENTIFIER
DECLARE @OutCheckoutId UNIQUEIDENTIFIER
DECLARE @OutMessage NVARCHAR(500)

EXEC [dbo].[ProcessCartCheckout]
    @UserId = @TestUserId,
    @CourseIds = @TestCourseIds,
    @TotalAmount = @TestAmount,
    @PaymentMethod = @TestMethod,
    @SessionId = 'TEST_SESSION',
    @BillId = @OutBillId OUTPUT,
    @CheckoutId = @OutCheckoutId OUTPUT,
    @ResultMessage = @OutMessage OUTPUT

PRINT 'Bill ID: ' + CAST(@OutBillId AS VARCHAR(36))
PRINT 'Checkout ID: ' + CAST(@OutCheckoutId AS VARCHAR(36))
PRINT 'Message: ' + @OutMessage
*/

PRINT '=== Procedure updated successfully ==='
GO
