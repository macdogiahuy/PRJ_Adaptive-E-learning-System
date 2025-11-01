-- CREATE SAMPLE COURSE FOR CURRENT INSTRUCTOR
-- This will create a course for the currently logged in instructor

USE [CourseHubDB]
GO

PRINT '=========================================='
PRINT 'CREATING SAMPLE COURSE FOR HUYNH GIANG'
PRINT '=========================================='

-- Use the exact InstructorId from the log
DECLARE @InstructorId UNIQUEIDENTIFIER = '8C3D6D81-2D70-4B5D-87BD-0A9B2D4DA4ED'
DECLARE @UserId UNIQUEIDENTIFIER
DECLARE @SampleCourseId UNIQUEIDENTIFIER = NEWID()
DECLARE @SampleCategoryId UNIQUEIDENTIFIER

-- Get User ID
SELECT @UserId = Id 
FROM Users 
WHERE InstructorId = @InstructorId OR Id = @InstructorId

IF @UserId IS NULL
BEGIN
    PRINT '❌ Error: User not found for InstructorId: ' + CAST(@InstructorId AS VARCHAR(50))
    RETURN
END

PRINT 'User ID: ' + CAST(@UserId AS VARCHAR(50))
PRINT 'Instructor ID: ' + CAST(@InstructorId AS VARCHAR(50))

-- Get first category
SELECT TOP 1 @SampleCategoryId = Id FROM Categories WHERE IsLeaf = 1

PRINT 'Category ID: ' + CAST(@SampleCategoryId AS VARCHAR(50))
PRINT ''

-- Create sample course 1
INSERT INTO Courses (
    Id, Title, MetaTitle, ThumbUrl, Intro, Description,
    Status, Price, Discount, DiscountExpiry, Level,
    Outcomes, Requirements, LectureCount, LearnerCount,
    RatingCount, TotalRating, CreationTime, LastModificationTime,
    LastModifierId, LeafCategoryId, InstructorId, CreatorId
)
VALUES (
    @SampleCourseId,
    N'Khóa học Lập trình Java Spring Boot từ A-Z',
    'khoa-hoc-lap-trinh-java-spring-boot-tu-a-z',
    'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=800&h=450&fit=crop',
    N'Học Spring Boot từ cơ bản đến nâng cao, xây dựng REST API và ứng dụng web hoàn chỉnh',
    N'Khóa học này sẽ dạy bạn cách xây dựng ứng dụng web với Spring Boot, từ thiết kế database, REST API, security cho đến deployment. Bạn sẽ làm được các dự án thực tế như e-commerce, blog, quản lý học viên.',
    'Ongoing',
    899000,
    25,
    DATEADD(YEAR, 1, GETDATE()),
    'Intermediate',
    N'Thành thạo Spring Boot Framework
Xây dựng REST API chuẩn RESTful
Làm việc với Spring Data JPA
Implement Spring Security
Deploy ứng dụng lên cloud
Xây dựng dự án thực tế hoàn chỉnh',
    N'Đã có kiến thức Java cơ bản
Hiểu về OOP và Collections
Biết SQL cơ bản
Có laptop cài sẵn JDK và IDE',
    0,
    0,
    0,
    0,
    GETDATE(),
    GETDATE(),
    @UserId,
    @SampleCategoryId,
    @InstructorId,
    @UserId
)

PRINT '✅ Course 1 created: ' + CAST(@SampleCourseId AS VARCHAR(50))

-- Create sections for course 1
INSERT INTO Sections (Id, CourseId, [Index], Title, LectureCount, CreationTime, LastModificationTime)
VALUES 
    (NEWID(), @SampleCourseId, 1, N'Giới thiệu về Spring Boot', 0, GETDATE(), GETDATE()),
    (NEWID(), @SampleCourseId, 2, N'Spring Boot Basics', 0, GETDATE(), GETDATE()),
    (NEWID(), @SampleCourseId, 3, N'Spring Data JPA', 0, GETDATE(), GETDATE()),
    (NEWID(), @SampleCourseId, 4, N'REST API Development', 0, GETDATE(), GETDATE()),
    (NEWID(), @SampleCourseId, 5, N'Spring Security', 0, GETDATE(), GETDATE())

PRINT '✅ Created 5 sections for Course 1'
PRINT ''

-- Create sample course 2
DECLARE @SampleCourseId2 UNIQUEIDENTIFIER = NEWID()

INSERT INTO Courses (
    Id, Title, MetaTitle, ThumbUrl, Intro, Description,
    Status, Price, Discount, DiscountExpiry, Level,
    Outcomes, Requirements, LectureCount, LearnerCount,
    RatingCount, TotalRating, CreationTime, LastModificationTime,
    LastModifierId, LeafCategoryId, InstructorId, CreatorId
)
VALUES (
    @SampleCourseId2,
    N'Full-Stack Web Development với React và Node.js',
    'full-stack-web-development-voi-react-va-nodejs',
    'https://images.unsplash.com/photo-1633356122544-f134324a6cee?w=800&h=450&fit=crop',
    N'Trở thành Full-Stack Developer với React, Node.js, Express và MongoDB',
    N'Khóa học toàn diện về phát triển web Full-Stack. Bạn sẽ học cách xây dựng giao diện với React, backend API với Node.js/Express, và quản lý database với MongoDB. Bao gồm authentication, real-time features, và deployment.',
    'Ongoing',
    1200000,
    30,
    DATEADD(YEAR, 1, GETDATE()),
    'Advanced',
    N'Xây dựng ứng dụng Full-Stack hoàn chỉnh
Thành thạo React Hooks và Redux
Phát triển REST API với Node.js/Express
Làm việc với MongoDB và Mongoose
Implement Authentication & Authorization
Deploy lên Heroku/AWS',
    N'Biết HTML, CSS, JavaScript cơ bản
Có kinh nghiệm lập trình
Hiểu về HTTP và REST API
Laptop cài Node.js và VS Code',
    0,
    0,
    0,
    0,
    GETDATE(),
    GETDATE(),
    @UserId,
    @SampleCategoryId,
    @InstructorId,
    @UserId
)

PRINT '✅ Course 2 created: ' + CAST(@SampleCourseId2 AS VARCHAR(50))

-- Create sections for course 2
INSERT INTO Sections (Id, CourseId, [Index], Title, LectureCount, CreationTime, LastModificationTime)
VALUES 
    (NEWID(), @SampleCourseId2, 1, N'Introduction to Full-Stack', 0, GETDATE(), GETDATE()),
    (NEWID(), @SampleCourseId2, 2, N'React Fundamentals', 0, GETDATE(), GETDATE()),
    (NEWID(), @SampleCourseId2, 3, N'Node.js & Express', 0, GETDATE(), GETDATE()),
    (NEWID(), @SampleCourseId2, 4, N'MongoDB Database', 0, GETDATE(), GETDATE())

PRINT '✅ Created 4 sections for Course 2'
PRINT ''

-- Create sample course 3
DECLARE @SampleCourseId3 UNIQUEIDENTIFIER = NEWID()

INSERT INTO Courses (
    Id, Title, MetaTitle, ThumbUrl, Intro, Description,
    Status, Price, Discount, DiscountExpiry, Level,
    Outcomes, Requirements, LectureCount, LearnerCount,
    RatingCount, TotalRating, CreationTime, LastModificationTime,
    LastModifierId, LeafCategoryId, InstructorId, CreatorId
)
VALUES (
    @SampleCourseId3,
    N'Python cho Data Science và Machine Learning',
    'python-cho-data-science-va-machine-learning',
    'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=800&h=450&fit=crop',
    N'Học Python, Data Analysis, Machine Learning với các dự án thực tế',
    N'Khóa học này sẽ giúp bạn bắt đầu với Python, làm việc với NumPy, Pandas, Matplotlib, và các thuật toán Machine Learning cơ bản. Bao gồm các dự án phân tích dữ liệu và xây dựng mô hình ML thực tế.',
    'Completed',
    750000,
    15,
    DATEADD(YEAR, 1, GETDATE()),
    'Beginner',
    N'Thành thạo Python cơ bản
Phân tích dữ liệu với Pandas
Visualize data với Matplotlib/Seaborn
Hiểu các thuật toán ML cơ bản
Xây dựng mô hình ML đơn giản
Làm các dự án thực tế',
    N'Kiến thức toán cơ bản
Laptop cài Python
Có laptop và internet
Tinh thần học hỏi',
    0,
    25,
    5,
    23,
    DATEADD(DAY, -30, GETDATE()),
    GETDATE(),
    @UserId,
    @SampleCategoryId,
    @InstructorId,
    @UserId
)

PRINT '✅ Course 3 created: ' + CAST(@SampleCourseId3 AS VARCHAR(50))

-- Create sections for course 3
INSERT INTO Sections (Id, CourseId, [Index], Title, LectureCount, CreationTime, LastModificationTime)
VALUES 
    (NEWID(), @SampleCourseId3, 1, N'Python Basics', 0, GETDATE(), GETDATE()),
    (NEWID(), @SampleCourseId3, 2, N'NumPy & Pandas', 0, GETDATE(), GETDATE()),
    (NEWID(), @SampleCourseId3, 3, N'Data Visualization', 0, GETDATE(), GETDATE()),
    (NEWID(), @SampleCourseId3, 4, N'Machine Learning Basics', 0, GETDATE(), GETDATE()),
    (NEWID(), @SampleCourseId3, 5, N'Real Projects', 0, GETDATE(), GETDATE())

PRINT '✅ Created 5 sections for Course 3'
PRINT ''

-- Verify the courses were created
PRINT '=========================================='
PRINT 'VERIFICATION'
PRINT '=========================================='

SELECT 
    c.Title,
    c.Status,
    c.Price,
    c.Discount,
    c.Level,
    c.LearnerCount,
    cat.Title as Category,
    (SELECT COUNT(*) FROM Sections WHERE CourseId = c.Id) as SectionCount
FROM Courses c
LEFT JOIN Categories cat ON c.LeafCategoryId = cat.Id
WHERE c.InstructorId = @InstructorId
ORDER BY c.CreationTime DESC

PRINT ''
PRINT '✅ 3 Sample courses created successfully!'
PRINT '=========================================='
PRINT 'Refresh the page: /instructor-courses'
PRINT 'You should now see 3 courses!'
PRINT '=========================================='

GO
