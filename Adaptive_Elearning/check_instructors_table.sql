-- ===================================================================
-- Check structure of Instructors table
-- ===================================================================
USE [CourseHubDB]
GO

SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Instructors'
ORDER BY ORDINAL_POSITION;
