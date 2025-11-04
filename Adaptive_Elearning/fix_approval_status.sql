-- ===================================================================
-- Fix Stored Procedures: Ensure Status = 'Ongoing' (capital O)
-- ===================================================================

USE [CourseHubDB]
GO

-- Fix sp_ApproveCourse to use 'Ongoing' with capital O
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_ApproveCourse]') AND type in (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[sp_ApproveCourse];
END
GO

CREATE PROCEDURE [dbo].[sp_ApproveCourse]
    @NotificationId UNIQUEIDENTIFIER,
    @ProcessedBy UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @CourseId UNIQUEIDENTIFIER;
        
        -- Lấy CourseId từ notification
        SELECT @CourseId = [CourseId]
        FROM [dbo].[CourseNotifications]
        WHERE [Id] = @NotificationId;
        
        IF @CourseId IS NOT NULL
        BEGIN
            -- Cập nhật status của khóa học thành 'Ongoing' (capital O) và ApprovalStatus = 'approved'
            UPDATE [dbo].[Courses]
            SET [Status] = 'Ongoing',
                [ApprovalStatus] = 'approved',
                [LastModificationTime] = GETDATE(),
                [LastModifierId] = @ProcessedBy
            WHERE [Id] = @CourseId;
            
            -- Cập nhật notification status thành 'approved'
            UPDATE [dbo].[CourseNotifications]
            SET [Status] = 'approved',
                [ProcessedTime] = GETDATE(),
                [ProcessedBy] = @ProcessedBy
            WHERE [Id] = @NotificationId;
            
            COMMIT TRANSACTION;
            SELECT 1 AS Success, 'Course approved successfully' AS Message;
        END
        ELSE
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 0 AS Success, 'Course not found' AS Message;
        END
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 0 AS Success, ERROR_MESSAGE() AS Message;
    END CATCH
END
GO

PRINT '✅ sp_ApproveCourse updated - Status will be set to "Ongoing"';
PRINT '✅ sp_RejectCourse unchanged - Status will be set to "off"';
PRINT '================================================';
