-- Fix ProcessCartCheckout để support nhiều payment methods
-- Version: Không cần USE database - chạy trực tiếp trong Azure Data Studio

-- Drop existing procedure
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProcessCartCheckout]') AND type in (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[ProcessCartCheckout]
    PRINT 'Old procedure dropped'
END
GO

-- Recreate với logic mới
CREATE PROCEDURE [dbo].[ProcessCartCheckout]
    @UserId UNIQUEIDENTIFIER,
    @CourseIds NVARCHAR(MAX), -- JSON format: ["courseId1", "courseId2"]
    @TotalAmount BIGINT,
    @PaymentMethod VARCHAR(50), -- Tăng length để chứa 'VNPay Online', 'VietQR Banking'
    @SessionId VARCHAR(100) = NULL,
    @BillId UNIQUEIDENTIFIER OUTPUT,
    @CheckoutId UNIQUEIDENTIFIER OUTPUT,
    @ResultMessage NVARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @TransactionId VARCHAR(100)
    DECLARE @ClientTransactionId VARCHAR(100)
    DECLARE @Gateway VARCHAR(50) -- Tăng length
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
        
        -- Thiết lập thông tin theo payment method (DYNAMIC) - Gateway max 20 chars
        IF @PaymentMethod = 'COD'
        BEGIN
            SET @Gateway = 'COD'
            SET @Note = N'Thanh toán khi nhận hàng - Đơn hàng khóa học'
        END
        ELSE IF @PaymentMethod = 'VNPay Online'
        BEGIN
            SET @Gateway = 'VNPay'
            SET @Note = N'Thanh toán online qua VNPay Gateway - Đơn hàng khóa học'
        END
        ELSE IF @PaymentMethod = 'VietQR Banking'
        BEGIN
            SET @Gateway = 'VietQR'
            SET @Note = N'Thanh toán qua VietQR Banking - Đơn hàng khóa học'
        END
        ELSE
        BEGIN
            -- Default: Use payment method as gateway (limit 20 chars)
            SET @Gateway = LEFT(@PaymentMethod, 20)
            SET @Note = N'Thanh toán online - Đơn hàng khóa học'
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
        
        -- Tạo Bill chính với Gateway DYNAMIC
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
                SET @CourseId = CAST(@CourseIdStr AS UNIQUEIDENTIFIER)
                
                -- Lấy title course
                SELECT @CourseTitle = [Title]
                FROM [dbo].[Courses]
                WHERE [Id] = @CourseId
                
                -- Kiểm tra đã enroll chưa
                IF NOT EXISTS (
                    SELECT 1 FROM [dbo].[Enrollments]
                    WHERE [CourseId] = @CourseId AND [CreatorId] = @UserId
                )
                BEGIN
                    -- Tạo enrollment với schema đúng
                    INSERT INTO [dbo].[Enrollments] (
                        [CreatorId], [CourseId], [BillId], [Status],
                        [CreationTime], [AssignmentMilestones], [LectureMilestones], [SectionMilestones]
                    )
                    VALUES (
                        @UserId, @CourseId, @BillId, N'In Progress',
                        GETDATE(), '{}', '{}', '{}'
                    )
                    
                    SET @EnrollmentCount = @EnrollmentCount + 1
                    
                    PRINT 'Enrolled: ' + @CourseTitle
                END
                ELSE
                BEGIN
                    SET @SkippedCount = @SkippedCount + 1
                    PRINT 'Already enrolled: ' + @CourseTitle
                END
            END TRY
            BEGIN CATCH
                PRINT 'Error enrolling course: ' + ERROR_MESSAGE()
                SET @SkippedCount = @SkippedCount + 1
            END CATCH
            
            FETCH NEXT FROM course_cursor INTO @CourseIdStr
        END
        
        CLOSE course_cursor
        DEALLOCATE course_cursor
        
        COMMIT TRANSACTION
        
        -- Return success message
        SET @ResultMessage = N'Checkout thành công. Bill ID: ' + CAST(@BillId AS VARCHAR(36)) + 
                           N', Enrollments: ' + CAST(@EnrollmentCount AS VARCHAR(10)) + 
                           N', Skipped: ' + CAST(@SkippedCount AS VARCHAR(10))
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
            
        SET @ResultMessage = N'Lỗi: ' + ERROR_MESSAGE()
        RAISERROR(@ResultMessage, 16, 1)
    END CATCH
END
GO

PRINT '=== ProcessCartCheckout Updated Successfully ==='
PRINT 'Now supports: COD, VNPay Online, VietQR Banking, and other payment methods'
GO
