-- ===================================================================
-- CLEAN DUPLICATE SECTIONS
-- Giữ lại section cũ nhất (CreationTime sớm nhất), xóa các bản trùng
-- ===================================================================

USE CourseHubDB;
GO

-- Step 1: Tìm các section bị trùng lặp (cùng CourseId và Title)
WITH DuplicateSections AS (
    SELECT 
        Id,
        CourseId,
        Title,
        CreationTime,
        ROW_NUMBER() OVER (
            PARTITION BY CourseId, Title 
            ORDER BY CreationTime ASC
        ) AS RowNum
    FROM Sections
)
SELECT 
    'Total duplicate sections to delete: ' + CAST(COUNT(*) AS VARCHAR) AS Info
FROM DuplicateSections
WHERE RowNum > 1;

-- Step 2: Update Lectures để trỏ về section gốc (RowNum = 1)
UPDATE L
SET L.SectionId = Keep.Id
FROM Lectures L
INNER JOIN (
    SELECT 
        Id AS DuplicateId,
        FIRST_VALUE(Id) OVER (
            PARTITION BY CourseId, Title 
            ORDER BY CreationTime ASC
        ) AS OriginalId
    FROM Sections
) Mapping ON L.SectionId = Mapping.DuplicateId
INNER JOIN Sections Keep ON Keep.Id = Mapping.OriginalId
WHERE Mapping.DuplicateId != Mapping.OriginalId;

PRINT 'Updated lectures to point to original sections';

-- Step 3: Delete duplicate sections
DELETE FROM Sections
WHERE Id IN (
    SELECT Id
    FROM (
        SELECT 
            Id,
            ROW_NUMBER() OVER (
                PARTITION BY CourseId, Title 
                ORDER BY CreationTime ASC
            ) AS RowNum
        FROM Sections
    ) AS Duplicates
    WHERE RowNum > 1
);

PRINT 'Deleted duplicate sections';

-- Step 4: Verify kết quả
SELECT 
    CourseId,
    Title,
    COUNT(*) AS SectionCount,
    MIN(CreationTime) AS FirstCreated,
    MAX(CreationTime) AS LastCreated
FROM Sections
GROUP BY CourseId, Title
HAVING COUNT(*) > 1;

PRINT 'If no rows returned above, all duplicates have been cleaned!';
GO
