# Debug Course Player Materials
Write-Host "🔍 DEBUGGING COURSE PLAYER MATERIALS..." -ForegroundColor Green

$CourseId = "69746C85-6109-4370-9334-1490CD2334B0"

Write-Host ""
Write-Host "📋 DEBUG STEPS:" -ForegroundColor Cyan
Write-Host "1. Run java-course-mapping.sql in SSMS" -ForegroundColor White
Write-Host "2. Test Course Player: http://localhost:8080/Adaptive_Elearning/course-player?id=$CourseId" -ForegroundColor White
Write-Host "3. Click on a lecture in sidebar" -ForegroundColor White
Write-Host "4. Check browser console (F12) for errors" -ForegroundColor White
Write-Host "5. Test API directly: http://localhost:8080/Adaptive_Elearning/api/get-lecture-materials?lectureId=LECTURE_ID" -ForegroundColor White

Write-Host ""
Write-Host "🎯 EXPECTED RESULT:" -ForegroundColor Cyan
Write-Host "✅ Video should play in left panel when clicking lecture" -ForegroundColor White
Write-Host "✅ Google Drive video URLs should load in Plyr player" -ForegroundColor White
Write-Host "✅ Sidebar should show sections and lectures with material badges" -ForegroundColor White

Write-Host ""
Write-Host "🔍 IF ISSUES:" -ForegroundColor Cyan
Write-Host "❌ No sections: Run the SQL script to create sample data" -ForegroundColor White
Write-Host "❌ API error: Check GetLectureMaterialsServlet logs" -ForegroundColor White  
Write-Host "❌ Video not playing: Check Google Drive URL format" -ForegroundColor White
Write-Host "❌ JavaScript error: Check browser console for fetch errors" -ForegroundColor White

Write-Host ""
Write-Host "📁 GOOGLE DRIVE MAPPING:" -ForegroundColor Cyan
Write-Host "Folder: https://drive.google.com/drive/u/0/folders/1WI2-xgFbjW0AJw79eTI1JvXcQtwFLdMN" -ForegroundColor White
Write-Host "Files: 1761992658586_course_video, 1761992753991_course_video" -ForegroundColor White
Write-Host "Format: https://drive.google.com/file/d/FILE_ID/view?usp=sharing" -ForegroundColor White

Write-Host ""
Write-Host "✅ DEBUG GUIDE READY!" -ForegroundColor Green