-- SQL Query để tìm Java Course và lecture materials
-- Chạy để lấy chính xác course ID và lecture materials

USE CourseHubDB;

-- 1. Tìm Java Course
SELECT Id, Title, Description, CreatorId 
FROM dbo.Courses 
WHERE Title LIKE '%Java%' OR Title LIKE '%Complete%' OR Title LIKE '%Development%'
ORDER BY CreatedAt DESC;

-- 2. Lấy course ID cụ thể (course bạn đang test)
DECLARE @CourseId UNIQUEIDENTIFIER = '69746C85-6109-4370-9334-1490CD2334B0';

-- 3. Kiểm tra sections của course này
SELECT 
    s.Id as SectionId,
    s.Title as SectionTitle,
    s.[Index] as SectionIndex,
    s.CourseId
FROM dbo.Sections s
WHERE s.CourseId = @CourseId
ORDER BY s.[Index];

-- 4. Kiểm tra lectures của course này
SELECT 
    l.Id as LectureId,
    l.Title as LectureTitle,
    l.Content,
    l.SectionId,
    s.Title as SectionTitle
FROM dbo.Lectures l
INNER JOIN dbo.Sections s ON l.SectionId = s.Id
WHERE s.CourseId = @CourseId
ORDER BY s.[Index], l.Id;

-- 5. Kiểm tra lecture materials (Google Drive links)
SELECT 
    lm.Id,
    lm.LectureId,
    lm.FileName,
    lm.FileType,
    lm.DriveLink,
    l.Title as LectureTitle,
    s.Title as SectionTitle
FROM dbo.LectureMaterial lm
INNER JOIN dbo.Lectures l ON lm.LectureId = l.Id
INNER JOIN dbo.Sections s ON l.SectionId = s.Id
WHERE s.CourseId = @CourseId
ORDER BY s.[Index], l.Id, lm.Id;

-- 6. Nếu không có data, tạo sample data cho Java Course
IF NOT EXISTS (SELECT 1 FROM dbo.Sections WHERE CourseId = @CourseId)
BEGIN
    PRINT 'Creating sample sections and lectures for Java Course...';
    
    -- Tạo Section
    DECLARE @SectionId UNIQUEIDENTIFIER = NEWID();
    INSERT INTO dbo.Sections (Id, CourseId, Title, [Index])
    VALUES (@SectionId, @CourseId, 'Java Fundamentals', 1);
    
    -- Tạo Lectures
    DECLARE @Lecture1Id UNIQUEIDENTIFIER = NEWID();
    DECLARE @Lecture2Id UNIQUEIDENTIFIER = NEWID();
    
    INSERT INTO dbo.Lectures (Id, SectionId, Title, Content)
    VALUES 
        (@Lecture1Id, @SectionId, 'Introduction to Java', 'Learn Java basics and syntax'),
        (@Lecture2Id, @SectionId, 'Java Object-Oriented Programming', 'Understanding OOP concepts in Java');
    
    -- Tạo LectureMaterials với Google Drive links
    INSERT INTO dbo.LectureMaterial (LectureId, FileName, FileType, DriveLink)
    VALUES 
        (@Lecture1Id, '1761992658586_course_video', 'video', 'https://drive.google.com/file/d/1X6XeOuW630XVU-SZn2h/view?usp=sharing'),
        (@Lecture1Id, 'Java_Basics_Slides', 'pdf', 'https://drive.google.com/file/d/SAMPLE_PDF_ID/view?usp=sharing'),
        (@Lecture2Id, '1761992753991_course_video', 'video', 'https://drive.google.com/file/d/1B-XYjOAH2Qh-LDCn/view?usp=sharing'),
        (@Lecture2Id, 'OOP_Examples', 'pdf', 'https://drive.google.com/file/d/SAMPLE_OOP_PDF/view?usp=sharing');
    
    PRINT 'Sample data created successfully!';
END

-- 7. Final result - show complete course structure
SELECT 
    'COURSE_STRUCTURE' as Type,
    c.Title as CourseTitle,
    s.Title as SectionTitle,
    l.Title as LectureTitle,
    lm.FileName,
    lm.FileType,
    lm.DriveLink,
    'http://localhost:8080/Adaptive_Elearning/course-player?id=' + CAST(c.Id AS VARCHAR(50)) as TestURL
FROM dbo.Courses c
LEFT JOIN dbo.Sections s ON c.Id = s.CourseId
LEFT JOIN dbo.Lectures l ON s.Id = l.SectionId
LEFT JOIN dbo.LectureMaterial lm ON l.Id = lm.LectureId
WHERE c.Id = @CourseId
ORDER BY s.[Index], l.Id, lm.Id;