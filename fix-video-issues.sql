-- ===================================================================
-- FIX: Nếu phát hiện vấn đề từ debug script
-- ===================================================================

USE CourseHubDB;
GO

DECLARE @CourseId NVARCHAR(50) = 'BA0BD425-5914-4AE5-97E0-C779C15F2B2A';

-- FIX 1: Xóa duplicate sections (giữ lại section cũ nhất)
PRINT '=== FIX 1: Clean duplicate sections ===';

-- Update Lectures để trỏ về section gốc
UPDATE L
SET L.SectionId = Keep.OriginalId
FROM Lectures L
INNER JOIN (
    SELECT 
        S.Id AS DuplicateId,
        FIRST_VALUE(S.Id) OVER (
            PARTITION BY S.CourseId, S.Title 
            ORDER BY S.CreationTime ASC
        ) AS OriginalId
    FROM Sections S
    WHERE S.CourseId = @CourseId
) Keep ON L.SectionId = Keep.DuplicateId
WHERE Keep.DuplicateId != Keep.OriginalId;

PRINT 'Updated lectures to point to original sections';

-- Xóa duplicate sections
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
        WHERE CourseId = @CourseId
    ) AS Duplicates
    WHERE RowNum > 1
);

PRINT 'Deleted duplicate sections';

-- FIX 2: Nếu có lectures không có materials
PRINT '';
PRINT '=== FIX 2: Check lectures without materials ===';
SELECT 
    L.Id AS LectureId,
    L.Title AS LectureTitle,
    S.Title AS SectionTitle,
    'Missing material - needs manual fix' AS Issue
FROM Lectures L
INNER JOIN Sections S ON L.SectionId = S.Id
LEFT JOIN LectureMaterial LM ON L.Id = LM.LectureId
WHERE S.CourseId = @CourseId
  AND LM.Id IS NULL;

-- FIX 3: Fix URLs không đúng format (nếu cần)
PRINT '';
PRINT '=== FIX 3: Fix Google Drive URLs to preview format ===';

UPDATE LM
SET LM.Url = 
    CASE 
        -- Nếu chưa có /preview thì thêm vào
        WHEN LM.Url LIKE '%drive.google.com/file/d/%' 
         AND LM.Url NOT LIKE '%/preview%' THEN
            STUFF(LM.Url, 
                  CHARINDEX('/file/d/', LM.Url) + LEN('/file/d/') + 
                  CHARINDEX('/', SUBSTRING(LM.Url, CHARINDEX('/file/d/', LM.Url) + LEN('/file/d/'), LEN(LM.Url))),
                  0, 
                  '/preview')
        ELSE LM.Url
    END
FROM LectureMaterial LM
INNER JOIN Lectures L ON LM.LectureId = L.Id
INNER JOIN Sections S ON L.SectionId = S.Id
WHERE S.CourseId = @CourseId
  AND LM.Url LIKE '%drive.google.com%';

PRINT 'Fixed Google Drive URLs to include /preview';

-- Verify sau khi fix
PRINT '';
PRINT '=== VERIFY AFTER FIX ===';
SELECT 
    S.Title AS Section,
    COUNT(DISTINCT L.Id) AS LectureCount,
    COUNT(LM.Id) AS MaterialCount
FROM Sections S
LEFT JOIN Lectures L ON S.Id = L.SectionId
LEFT JOIN LectureMaterial LM ON L.Id = LM.LectureId
WHERE S.CourseId = @CourseId
GROUP BY S.Title
ORDER BY S.Title;

GO
