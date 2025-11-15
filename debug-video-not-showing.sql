-- ===================================================================
-- DEBUG: Tại sao video không hiển thị
-- ===================================================================

USE CourseHubDB;
GO

-- 1. Kiểm tra Course ID
DECLARE @CourseId NVARCHAR(50) = 'BA0BD425-5914-4AE5-97E0-C779C15F2B2A';

PRINT '=== 1. COURSE INFO ===';
SELECT Id, Title, Description
FROM Courses
WHERE Id = @CourseId;

PRINT '';
PRINT '=== 2. SECTIONS (có bị duplicate không?) ===';
SELECT 
    Id,
    Title,
    CreationTime,
    ROW_NUMBER() OVER (PARTITION BY Title ORDER BY CreationTime) AS RowNum
FROM Sections
WHERE CourseId = @CourseId
ORDER BY CreationTime;

PRINT '';
PRINT '=== 3. LECTURES trong các sections ===';
SELECT 
    S.Title AS SectionTitle,
    L.Id AS LectureId,
    L.Title AS LectureTitle,
    L.CreationTime AS LectureCreated,
    (SELECT COUNT(*) FROM LectureMaterial WHERE LectureId = L.Id) AS MaterialCount
FROM Sections S
INNER JOIN Lectures L ON S.Id = L.SectionId
WHERE S.CourseId = @CourseId
ORDER BY S.CreationTime, L.CreationTime;

PRINT '';
PRINT '=== 4. LECTURE MATERIALS (URLs) ===';
SELECT 
    S.Title AS SectionTitle,
    L.Title AS LectureTitle,
    LM.Id AS MaterialId,
    LM.Type,
    LM.Url
FROM Sections S
INNER JOIN Lectures L ON S.Id = L.SectionId
LEFT JOIN LectureMaterial LM ON L.Id = LM.LectureId
WHERE S.CourseId = @CourseId
ORDER BY S.CreationTime, L.CreationTime, LM.Id;

PRINT '';
PRINT '=== 5. Kiểm tra URLs có đúng format Google Drive không? ===';
SELECT 
    L.Title AS LectureTitle,
    LM.Url,
    CASE 
        WHEN LM.Url LIKE '%drive.google.com%' THEN 'Google Drive ✓'
        WHEN LM.Url LIKE 'http%' THEN 'Other URL'
        ELSE 'Invalid URL ✗'
    END AS UrlType,
    CASE 
        WHEN LM.Url LIKE '%/file/d/%/preview' THEN 'Preview format ✓'
        WHEN LM.Url LIKE '%/file/d/%' THEN 'File ID format (needs /preview)'
        ELSE 'Unknown format'
    END AS UrlFormat
FROM Lectures L
INNER JOIN Sections S ON L.SectionId = S.Id
LEFT JOIN LectureMaterial LM ON L.Id = LM.LectureId
WHERE S.CourseId = @CourseId
ORDER BY L.CreationTime;

PRINT '';
PRINT '=== 6. Count summary ===';
SELECT 
    (SELECT COUNT(*) FROM Sections WHERE CourseId = @CourseId) AS TotalSections,
    (SELECT COUNT(*) FROM Lectures WHERE SectionId IN (SELECT Id FROM Sections WHERE CourseId = @CourseId)) AS TotalLectures,
    (SELECT COUNT(*) FROM LectureMaterial WHERE LectureId IN (SELECT L.Id FROM Lectures L INNER JOIN Sections S ON L.SectionId = S.Id WHERE S.CourseId = @CourseId)) AS TotalMaterials;

GO
