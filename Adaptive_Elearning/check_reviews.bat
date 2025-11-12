@echo off
echo ========================================
echo CHECK COURSEREVIEW RECORDS IN DATABASE
echo ========================================
echo.

sqlcmd -S localhost -U sa -P 1234 -d CourseHubDB -Q "SELECT COUNT(*) as TotalReviews FROM CourseReviews"
echo.

echo Recent Reviews:
echo ---------------
sqlcmd -S localhost -U sa -P 1234 -d CourseHubDB -Q "SELECT TOP 5 cr.Id, cr.Content, cr.Rating, u.UserName, c.Title as CourseName, cr.CreationTime FROM CourseReviews cr INNER JOIN Users u ON cr.CreatorId = u.Id INNER JOIN Courses c ON cr.CourseId = c.Id ORDER BY cr.CreationTime DESC"

echo.
echo Press any key to exit...
pause > nul
