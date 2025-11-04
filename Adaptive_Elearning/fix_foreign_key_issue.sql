-- ===================================================================
-- Fix Foreign Key Issue in CourseNotifications
-- ===================================================================

USE [CourseHubDB]
GO

PRINT '================================================';
PRINT 'BƯỚC 1: Kiểm tra foreign key hiện tại';
PRINT '================================================';

SELECT 
    fk.name AS ForeignKeyName,
    OBJECT_NAME(fk.parent_object_id) AS TableName,
    COL_NAME(fkc.parent_object_id, fkc.parent_column_id) AS ColumnName,
    OBJECT_NAME(fk.referenced_object_id) AS ReferencedTable,
    COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id) AS ReferencedColumn
FROM sys.foreign_keys AS fk
INNER JOIN sys.foreign_key_columns AS fkc 
    ON fk.object_id = fkc.constraint_object_id
WHERE OBJECT_NAME(fk.parent_object_id) = 'CourseNotifications';
GO

PRINT '================================================';
PRINT 'BƯỚC 2: Kiểm tra dữ liệu Users vs Instructors';
PRINT '================================================';

-- Check if InstructorId exists in Users table
SELECT 
    u.Id AS UserId,
    u.UserName,
    u.InstructorId,
    CASE 
        WHEN i.Id IS NOT NULL THEN 'Exists in Instructors'
        ELSE 'NOT in Instructors'
    END AS InstructorStatus
FROM Users u
LEFT JOIN Instructors i ON u.InstructorId = i.Id
WHERE u.Role = 'Instructor'
AND u.UserName = 'HuynhGiang59';
GO

PRINT '================================================';
PRINT 'BƯỚC 3: Fix - InstructorId nên trỏ đến Users.Id';
PRINT '================================================';

-- Drop old foreign key
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_CourseNotifications_Instructor')
BEGIN
    ALTER TABLE [dbo].[CourseNotifications]
    DROP CONSTRAINT [FK_CourseNotifications_Instructor];
    PRINT 'Dropped old FK_CourseNotifications_Instructor';
END
GO

-- Rename column to UserId for clarity (optional but recommended)
-- InstructorId in CourseNotifications should actually be UserId from Users table
PRINT '================================================';
PRINT 'GIẢI PHÁP: InstructorId trong CourseNotifications';
PRINT 'cần là Users.Id (không phải Instructors.Id)';
PRINT '================================================';
PRINT 'Foreign key đã được xóa. Bây giờ có 2 options:';
PRINT '1. Truyền user.getId() thay vì user.getInstructorId() vào createNotification';
PRINT '2. Hoặc tạo lại FK trỏ đến Instructors.Id (phức tạp hơn)';
PRINT '================================================';
PRINT 'Recommendation: Sửa code InstructorCoursesServlet line 313-317';
PRINT '================================================';
