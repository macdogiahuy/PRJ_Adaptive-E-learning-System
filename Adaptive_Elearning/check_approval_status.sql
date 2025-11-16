    -- ===================================================================
    -- Check ApprovalStatus của các courses
    -- ===================================================================
    USE [CourseHubDB]
    GO

    SELECT 
        c.Id,
        c.Title,
        c.Status,
        c.ApprovalStatus,
        c.RejectionReason,
        c.CreationTime,
        i.FullName AS InstructorName
    FROM [dbo].[Courses] c
    LEFT JOIN [dbo].[Users] i ON c.InstructorId = i.Id
    ORDER BY c.CreationTime DESC;

    -- Thống kê
    SELECT 
        ApprovalStatus,
        COUNT(*) AS Count
    FROM [dbo].[Courses]
    GROUP BY ApprovalStatus;
