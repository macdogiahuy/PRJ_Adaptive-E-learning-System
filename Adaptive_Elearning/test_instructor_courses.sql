-- Test Script for Instructor Course Management Feature
-- Run this script to test the course management functionality

USE [CourseHubDB]
GO

-- ============================================
-- CLEAN UP EXISTING TEST DATA FIRST
-- ============================================
PRINT 'Cleaning up existing test data...'

-- Delete test courses and sections
DELETE FROM Sections WHERE CourseId IN (
    SELECT c.Id FROM Courses c
    INNER JOIN Users u ON c.InstructorId = u.Id
    WHERE u.Email = 'instructor.test@example.com'
)

DELETE FROM Courses WHERE InstructorId IN (
    SELECT Id FROM Users WHERE Email = 'instructor.test@example.com'
)

-- Delete test instructor
DELETE FROM Instructors WHERE Id IN (
    SELECT Id FROM Users WHERE Email = 'instructor.test@example.com'
)

-- Delete test user
DELETE FROM Users WHERE Email = 'instructor.test@example.com'

PRINT 'Cleanup completed!'
GO

-- ============================================
-- CREATE NEW TEST DATA
-- ============================================
PRINT 'Creating new test data...'

DECLARE @TestUserId UNIQUEIDENTIFIER = NEWID()
DECLARE @TestInstructorId UNIQUEIDENTIFIER = @TestUserId  -- Same ID for User and Instructor
DECLARE @RandomPhone VARCHAR(45) = '09' + CAST(CAST(RAND() * 100000000 AS INT) AS VARCHAR(10))

PRINT 'Generated Phone: ' + @RandomPhone
PRINT 'User ID: ' + CAST(@TestUserId AS VARCHAR(50))

-- Insert test user (Phone can be NULL to avoid duplicate)
INSERT INTO Users (
    Id, UserName, [Password], Email, FullName, MetaFullName, 
    AvatarUrl, Role, Token, RefreshToken, IsVerified, IsApproved, 
    AccessFailedCount, Bio, Phone, EnrollmentCount, InstructorId,
    CreationTime, LastModificationTime, SystemBalance
)
VALUES (
    @TestUserId,
    'Test Instructor',
    '123456', -- Change this in production
    'instructor.test@example.com',
    N'Instructor Test Account',
    'instructor-test-account',
    'https://via.placeholder.com/150',
    N'Instructor',
    '',
    '',
    1, -- IsVerified
    1, -- IsApproved
    0, -- AccessFailedCount
    N'Experienced instructor with 10+ years in teaching',
    @RandomPhone,  -- Random phone to avoid duplicate
    0, -- EnrollmentCount
    @TestInstructorId,
    GETDATE(),
    GETDATE(),
    0 -- SystemBalance
)

PRINT '✅ User created successfully!'

-- Insert instructor profile (CreatorId must reference existing User)
INSERT INTO Instructors (Id, Intro, Experience, CreatorId, CreationTime, LastModificationTime, Balance, CourseCount)
VALUES (
    @TestInstructorId,
    N'Experienced instructor with 10+ years in teaching',
    N'Senior Developer',
    @TestUserId,  -- CreatorId = User who created this instructor profile
    GETDATE(),
    GETDATE(),
    0,
    0
)

PRINT '✅ Instructor profile created successfully!'
PRINT ''
PRINT '=========================================='
PRINT 'TEST ACCOUNT CREDENTIALS:'
PRINT '=========================================='
PRINT 'Email: instructor.test@example.com'
PRINT 'Password: 123456'
PRINT 'Phone: ' + @RandomPhone
PRINT '=========================================='
GO

GO

-- ============================================
-- VERIFY TEST DATA
-- ============================================
PRINT ''
PRINT '=========================================='
PRINT 'VERIFICATION'
PRINT '=========================================='

-- 2. Verify Categories exist
PRINT ''
PRINT 'Total Categories:'
SELECT COUNT(*) as TotalCategories FROM Categories WHERE IsLeaf = 1

PRINT ''
PRINT 'Test Instructor Details:'
SELECT 
    u.Id as UserId,
    u.UserName,
    u.Email,
    u.Role,
    i.Id as InstructorId,
    i.Experience,
    i.CourseCount
FROM Users u
LEFT JOIN Instructors i ON u.Id = i.Id
WHERE u.Email = 'instructor.test@example.com'
GO

-- 3. Test Query: Get all courses by instructor
-- Replace {InstructorId} with actual instructor ID
/*
SELECT c.*, cat.Title as CategoryTitle
FROM Courses c
LEFT JOIN Categories cat ON c.LeafCategoryId = cat.Id
WHERE c.InstructorId = '{InstructorId}'
ORDER BY c.CreationTime DESC
*/

-- 4. Test Query: Get course with sections
/*
SELECT 
    c.Id as CourseId,
    c.Title as CourseTitle,
    s.Id as SectionId,
    s.Title as SectionTitle,
    s.[Index] as SectionIndex
FROM Courses c
LEFT JOIN Sections s ON s.CourseId = c.Id
WHERE c.Id = '{CourseId}'
ORDER BY s.[Index]
*/

-- 5. Test Query: Get course statistics for instructor
/*
SELECT 
    COUNT(*) as TotalCourses,
    SUM(LearnerCount) as TotalStudents,
    AVG(CAST(TotalRating as FLOAT) / NULLIF(RatingCount, 0)) as AverageRating
FROM Courses
WHERE InstructorId = '{InstructorId}'
*/

-- 6. Sample data for testing (optional)
-- Uncomment below to insert sample course
/*
DECLARE @SampleCourseId UNIQUEIDENTIFIER = NEWID()
DECLARE @SampleCategoryId UNIQUEIDENTIFIER

-- Get first category
SELECT TOP 1 @SampleCategoryId = Id FROM Categories WHERE IsLeaf = 1

INSERT INTO Courses (
    Id, Title, MetaTitle, ThumbUrl, Intro, Description,
    Status, Price, Discount, DiscountExpiry, Level,
    Outcomes, Requirements, LectureCount, LearnerCount,
    RatingCount, TotalRating, CreationTime, LastModificationTime,
    LastModifierId, LeafCategoryId, InstructorId, CreatorId
)
VALUES (
    @SampleCourseId,
    'Sample Course for Testing',
    'sample-course-for-testing',
    'https://via.placeholder.com/800x450',
    'This is a sample course created for testing the course management feature.',
    'Detailed description of the sample course. This course covers various topics and is designed to test all features of the course management system.',
    'Ongoing',
    500000,
    10,
    DATEADD(YEAR, 1, GETDATE()),
    'Beginner',
    'Learn basic concepts
Master fundamental skills
Build real projects',
    'Basic computer skills
Internet connection
Willingness to learn',
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

-- Insert sample sections
INSERT INTO Sections (Id, CourseId, [Index], Title, LectureCount, CreationTime, LastModificationTime)
VALUES 
    (NEWID(), @SampleCourseId, 1, 'Introduction', 0, GETDATE(), GETDATE()),
    (NEWID(), @SampleCourseId, 2, 'Getting Started', 0, GETDATE(), GETDATE()),
    (NEWID(), @SampleCourseId, 3, 'Advanced Topics', 0, GETDATE(), GETDATE())

PRINT 'Sample course created successfully with 3 sections'
*/

-- 7. Verify instructor courses
SELECT 
    u.UserName as InstructorName,
    u.Email,
    i.Id as InstructorId,
    COUNT(c.Id) as TotalCourses
FROM Users u
INNER JOIN Instructors i ON u.Id = i.Id
LEFT JOIN Courses c ON c.InstructorId = i.Id
WHERE u.Role = 'Instructor'
GROUP BY u.UserName, u.Email, i.Id

-- 8. Check all courses with details
SELECT 
    c.Title,
    c.Status,
    c.Price,
    c.Discount,
    c.Level,
    c.LearnerCount,
    cat.Title as Category,
    u.UserName as Instructor,
    (SELECT COUNT(*) FROM Sections WHERE CourseId = c.Id) as SectionCount
FROM Courses c
LEFT JOIN Categories cat ON c.LeafCategoryId = cat.Id
LEFT JOIN Instructors i ON c.InstructorId = i.Id
LEFT JOIN Users u ON i.Id = u.Id
ORDER BY c.CreationTime DESC

-- 9. Clean up test data (optional - use with caution!)
/*
-- Delete test courses
DELETE FROM Sections WHERE CourseId IN (
    SELECT Id FROM Courses WHERE InstructorId = (
        SELECT Id FROM Users WHERE Email = 'instructor.test@example.com'
    )
)

DELETE FROM Courses WHERE InstructorId = (
    SELECT Id FROM Users WHERE Email = 'instructor.test@example.com'
)

-- Delete test instructor
DELETE FROM Instructors WHERE Id = (
    SELECT Id FROM Users WHERE Email = 'instructor.test@example.com'
)

DELETE FROM Users WHERE Email = 'instructor.test@example.com'

PRINT 'Test data cleaned up'
*/

PRINT '=========================================='
PRINT 'Test script completed!'
PRINT '=========================================='
