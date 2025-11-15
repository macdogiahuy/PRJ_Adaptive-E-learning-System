-- Kiểm tra lecture có material hay không
SELECT TOP 20
    L.Id AS LectureId,
    L.Title AS LectureTitle,
    L.CreationTime,
    S.Title AS SectionTitle,
    C.Title AS CourseTitle,
    COUNT(LM.Id) AS MaterialCount
FROM [CourseHubDB11].[dbo].[Lectures] L
LEFT JOIN [CourseHubDB11].[dbo].[Sections] S ON L.SectionId = S.Id
LEFT JOIN [CourseHubDB11].[dbo].[Courses] C ON S.CourseId = C.Id
LEFT JOIN [CourseHubDB11].[dbo].[LectureMaterial] LM ON L.Id = LM.LectureId
GROUP BY L.Id, L.Title, L.CreationTime, S.Title, C.Title
ORDER BY L.CreationTime DESC;

-- Kiểm tra material mới nhất
SELECT TOP 10 * FROM [CourseHubDB11].[dbo].[LectureMaterial]
ORDER BY Id DESC;
