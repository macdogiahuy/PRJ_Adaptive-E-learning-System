-- ================================================
-- SQL Script: Course Approval System
-- Mục đích: Thêm chức năng phê duyệt khóa học từ Admin
-- ================================================

USE [Adaptive_Elearning]
GO

-- Bước 1: Thêm cột RejectionReason và ApprovalStatus vào bảng Courses
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Courses]') AND name = 'RejectionReason')
BEGIN
    ALTER TABLE [dbo].[Courses]
    ADD [RejectionReason] NVARCHAR(1000) NULL;
    PRINT 'Đã thêm cột RejectionReason vào bảng Courses';
END
ELSE
BEGIN
    PRINT 'Cột RejectionReason đã tồn tại trong bảng Courses';
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Courses]') AND name = 'ApprovalStatus')
BEGIN
    ALTER TABLE [dbo].[Courses]
    ADD [ApprovalStatus] NVARCHAR(50) NOT NULL DEFAULT 'pending';
    PRINT 'Đã thêm cột ApprovalStatus vào bảng Courses';
END
ELSE
BEGIN
    PRINT 'Cột ApprovalStatus đã tồn tại trong bảng Courses';
END
GO

-- Bước 2: Cập nhật các khóa học hiện tại thành 'approved' nếu Status = 'ongoing'
UPDATE [dbo].[Courses]
SET [ApprovalStatus] = 'approved'
WHERE [Status] = 'ongoing' AND ([ApprovalStatus] IS NULL OR [ApprovalStatus] = 'pending');
PRINT 'Đã cập nhật ApprovalStatus cho các khóa học hiện tại';
GO

-- Bước 3: Tạo bảng CourseNotifications để lưu thông báo phê duyệt khóa học
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CourseNotifications]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[CourseNotifications](
        [Id] [uniqueidentifier] NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [CourseId] [uniqueidentifier] NOT NULL,
        [InstructorId] [uniqueidentifier] NOT NULL,
        [InstructorName] [nvarchar](255) NOT NULL,
        [CourseTitle] [nvarchar](255) NOT NULL,
        [CoursePrice] [float] NOT NULL,
        [NotificationType] [nvarchar](50) NOT NULL DEFAULT 'course_pending',
        [Status] [nvarchar](50) NOT NULL DEFAULT 'pending',
        [RejectionReason] [nvarchar](1000) NULL,
        [CreationTime] [datetime2](7) NOT NULL DEFAULT GETDATE(),
        [ProcessedTime] [datetime2](7) NULL,
        [ProcessedBy] [uniqueidentifier] NULL,
        
        CONSTRAINT [FK_CourseNotifications_Courses] FOREIGN KEY ([CourseId])
            REFERENCES [dbo].[Courses] ([Id]) ON DELETE CASCADE,
        
        CONSTRAINT [FK_CourseNotifications_Instructor] FOREIGN KEY ([InstructorId])
            REFERENCES [dbo].[Users] ([Id]),
            
        CONSTRAINT [FK_CourseNotifications_ProcessedBy] FOREIGN KEY ([ProcessedBy])
            REFERENCES [dbo].[Users] ([Id])
    );
    
    CREATE INDEX [IX_CourseNotifications_Status] ON [dbo].[CourseNotifications]([Status]);
    CREATE INDEX [IX_CourseNotifications_CreationTime] ON [dbo].[CourseNotifications]([CreationTime] DESC);
    
    PRINT 'Đã tạo bảng CourseNotifications';
END
ELSE
BEGIN
    PRINT 'Bảng CourseNotifications đã tồn tại';
END
GO

-- Bước 4: Tạo stored procedure để lấy danh sách thông báo khóa học pending
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetPendingCourseNotifications]') AND type in (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[sp_GetPendingCourseNotifications];
END
GO

CREATE PROCEDURE [dbo].[sp_GetPendingCourseNotifications]
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        cn.[Id],
        cn.[CourseId],
        cn.[InstructorId],
        cn.[InstructorName],
        cn.[CourseTitle],
        cn.[CoursePrice],
        cn.[NotificationType],
        cn.[Status],
        cn.[RejectionReason],
        cn.[CreationTime],
        cn.[ProcessedTime],
        cn.[ProcessedBy],
        c.[ThumbUrl],
        c.[Level],
        c.[Description]
    FROM [dbo].[CourseNotifications] cn
    INNER JOIN [dbo].[Courses] c ON cn.[CourseId] = c.[Id]
    WHERE cn.[Status] = 'pending'
    ORDER BY cn.[CreationTime] DESC;
END
GO

-- Bước 5: Tạo stored procedure để approve khóa học
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
            -- Cập nhật status của khóa học thành 'ongoing' và ApprovalStatus = 'approved'
            UPDATE [dbo].[Courses]
            SET [Status] = 'ongoing',
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

-- Bước 6: Tạo stored procedure để reject khóa học
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_RejectCourse]') AND type in (N'P', N'PC'))
BEGIN
    DROP PROCEDURE [dbo].[sp_RejectCourse];
END
GO

CREATE PROCEDURE [dbo].[sp_RejectCourse]
    @NotificationId UNIQUEIDENTIFIER,
    @ProcessedBy UNIQUEIDENTIFIER,
    @RejectionReason NVARCHAR(1000)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @CourseId UNIQUEIDENTIFIER;
        DECLARE @InstructorId UNIQUEIDENTIFIER;
        
        -- Lấy CourseId và InstructorId từ notification
        SELECT @CourseId = [CourseId], @InstructorId = [InstructorId]
        FROM [dbo].[CourseNotifications]
        WHERE [Id] = @NotificationId;
        
        IF @CourseId IS NOT NULL
        BEGIN
            -- Cập nhật status của khóa học thành 'off' và ApprovalStatus = 'rejected'
            UPDATE [dbo].[Courses]
            SET [Status] = 'off',
                [ApprovalStatus] = 'rejected',
                [RejectionReason] = @RejectionReason,
                [LastModificationTime] = GETDATE(),
                [LastModifierId] = @ProcessedBy
            WHERE [Id] = @CourseId;
            
            -- Cập nhật notification status thành 'rejected'
            UPDATE [dbo].[CourseNotifications]
            SET [Status] = 'rejected',
                [RejectionReason] = @RejectionReason,
                [ProcessedTime] = GETDATE(),
                [ProcessedBy] = @ProcessedBy
            WHERE [Id] = @NotificationId;
            
            -- Tạo thông báo cho instructor về việc khóa học bị từ chối
            INSERT INTO [dbo].[Notifications] ([Id], [Message], [Type], [Status], [ReceiverId], [CreationTime], [CreatorId])
            VALUES (
                NEWID(),
                N'Khóa học của bạn đã bị từ chối. Lý do: ' + @RejectionReason,
                'course_rejected',
                'unread',
                @InstructorId,
                GETDATE(),
                @ProcessedBy
            );
            
            COMMIT TRANSACTION;
            SELECT 1 AS Success, 'Course rejected successfully' AS Message;
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

PRINT '================================================';
PRINT 'Hoàn thành cập nhật database cho hệ thống phê duyệt khóa học!';
PRINT '================================================';
