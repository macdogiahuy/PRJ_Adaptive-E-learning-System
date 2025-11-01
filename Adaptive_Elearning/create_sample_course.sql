-- CREATE SAMPLE COURSE FOR TESTING
-- Run this after test_instructor_courses.sql to create a sample course

USE [CourseHubDB]
GO

PRINT '=========================================='
PRINT 'CREATING SAMPLE COURSE'
PRINT '=========================================='

-- Get the test instructor ID
DECLARE @TestInstructorId UNIQUEIDENTIFIER
DECLARE @TestUserId UNIQUEIDENTIFIER
DECLARE @SampleCourseId UNIQUEIDENTIFIER = NEWID()
DECLARE @SampleCategoryId UNIQUEIDENTIFIER

SELECT TOP 1 
    @TestUserId = u.Id,
    @TestInstructorId = u.InstructorId
FROM Users u
WHERE u.Email = 'instructor.test@example.com'

IF @TestInstructorId IS NULL
BEGIN
    PRINT '❌ Error: Test instructor not found!'
    PRINT 'Please run test_instructor_courses.sql first'
    RETURN
END

PRINT 'Test User ID: ' + CAST(@TestUserId AS VARCHAR(50))
PRINT 'Test Instructor ID: ' + CAST(@TestInstructorId AS VARCHAR(50))

-- Get first category
SELECT TOP 1 @SampleCategoryId = Id FROM Categories WHERE IsLeaf = 1

PRINT 'Category ID: ' + CAST(@SampleCategoryId AS VARCHAR(50))

-- Create sample course
INSERT INTO Courses (
    Id, Title, MetaTitle, ThumbUrl, Intro, Description,
    Status, Price, Discount, DiscountExpiry, Level,
    Outcomes, Requirements, LectureCount, LearnerCount,
    RatingCount, TotalRating, CreationTime, LastModificationTime,
    LastModifierId, LeafCategoryId, InstructorId, CreatorId
)
VALUES (
    @SampleCourseId,
    N'Khóa học Lập trình Java cho Beginners',
    'khoa-hoc-lap-trinh-java-cho-beginners',
    'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=800&h=450&fit=crop',
    N'Học lập trình Java từ cơ bản đến nâng cao với các dự án thực tế',
    N'Khóa học này sẽ giúp bạn nắm vững các kiến thức cơ bản về Java, từ cú pháp, OOP, collections, đến xây dựng ứng dụng thực tế. Phù hợp cho người mới bắt đầu muốn trở thành Java Developer.',
    'Ongoing',
    500000,
    20,
    DATEADD(YEAR, 1, GETDATE()),
    'Beginner',
    N'Hiểu rõ cú pháp Java cơ bản
Thành thạo lập trình hướng đối tượng (OOP)
Làm việc với Collections và Exception Handling
Xây dựng ứng dụng console hoàn chỉnh
Kết nối và thao tác với Database',
    N'Máy tính có cấu hình trung bình
Đã cài đặt JDK
Có tinh thần học hỏi và kiên trì',
    0,
    0,
    0,
    0,
    GETDATE(),
    GETDATE(),
    @TestUserId,
    @SampleCategoryId,
    @TestInstructorId,
    @TestUserId
)

PRINT '✅ Course created: ' + CAST(@SampleCourseId AS VARCHAR(50))

-- Create sample sections
DECLARE @Section1Id UNIQUEIDENTIFIER = NEWID()
DECLARE @Section2Id UNIQUEIDENTIFIER = NEWID()
DECLARE @Section3Id UNIQUEIDENTIFIER = NEWID()
DECLARE @Section4Id UNIQUEIDENTIFIER = NEWID()

INSERT INTO Sections (Id, CourseId, [Index], Title, LectureCount, CreationTime, LastModificationTime)
VALUES 
    (@Section1Id, @SampleCourseId, 1, N'Giới thiệu về Java', 0, GETDATE(), GETDATE()),
    (@Section2Id, @SampleCourseId, 2, N'Cú pháp cơ bản', 0, GETDATE(), GETDATE()),
    (@Section3Id, @SampleCourseId, 3, N'Lập trình hướng đối tượng', 0, GETDATE(), GETDATE()),
    (@Section4Id, @SampleCourseId, 4, N'Collections và Exception Handling', 0, GETDATE(), GETDATE())

PRINT '✅ Created 4 sections'

-- Verify the course was created
PRINT ''
PRINT '=========================================='
PRINT 'VERIFICATION'
PRINT '=========================================='

SELECT 
    c.Id,
    c.Title,
    c.Status,
    c.Price,
    c.Discount,
    c.Level,
    cat.Title as Category,
    u.UserName as Instructor,
    (SELECT COUNT(*) FROM Sections WHERE CourseId = c.Id) as SectionCount
FROM Courses c
LEFT JOIN Categories cat ON c.LeafCategoryId = cat.Id
LEFT JOIN Users u ON c.InstructorId = u.InstructorId
WHERE c.Id = @SampleCourseId

PRINT ''
PRINT '✅ Sample course created successfully!'
PRINT '=========================================='
PRINT 'Course Title: Khóa học Lập trình Java cho Beginners'
PRINT 'Price: 500,000 VNĐ (20% discount)'
PRINT 'Level: Beginner'
PRINT 'Sections: 4'
PRINT '=========================================='
PRINT ''
PRINT 'Now login as: instructor.test@example.com / 123456'
PRINT 'Then go to: /instructor-courses'

GO
