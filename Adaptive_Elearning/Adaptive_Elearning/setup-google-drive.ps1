# ========================================
# 🔧 Script cấu hình Google Drive API
# ========================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Google Drive API Setup Tool" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if server is running
Write-Host "📌 Bước 1: Kiểm tra server..." -ForegroundColor Green

try {
    $response = Invoke-WebRequest -Uri "http://localhost:9999/Adaptive_Elearning/" -UseBasicParsing -TimeoutSec 3 -ErrorAction Stop
    Write-Host "✅ Server đang chạy!" -ForegroundColor Green
} catch {
    Write-Host "❌ Server chưa chạy! Vui lòng khởi động server trước." -ForegroundColor Red
    Write-Host "   Chạy lệnh: .\run-tomcat.bat" -ForegroundColor Yellow
    Read-Host -Prompt "Nhấn Enter để thoát"
    exit 1
}

Write-Host ""
Write-Host "📌 Bước 2: Lấy Refresh Token" -ForegroundColor Green
Write-Host "Mở trình duyệt và truy cập:" -ForegroundColor Yellow
Write-Host "   http://localhost:9999/Adaptive_Elearning/auth/drive" -ForegroundColor Cyan
Write-Host ""

# Open browser automatically
Start-Process "http://localhost:9999/Adaptive_Elearning/auth/drive"

Write-Host "⏳ Đang chờ bạn ủy quyền Google Drive..." -ForegroundColor Yellow
Write-Host ""

# Wait for user to complete authorization
Write-Host "Sau khi ủy quyền thành công, copy Refresh Token và paste vào đây:" -ForegroundColor Green
$refreshToken = Read-Host -Prompt "Refresh Token"

if ([string]::IsNullOrWhiteSpace($refreshToken)) {
    Write-Host "❌ Token không được để trống!" -ForegroundColor Red
    Read-Host -Prompt "Nhấn Enter để thoát"
    exit 1
}

Write-Host ""
Write-Host "📌 Bước 3: Cập nhật cấu hình" -ForegroundColor Green

# Update env.properties file
$envFile = "src\conf\env.properties"

if (Test-Path $envFile) {
    # Read file content
    $content = Get-Content $envFile -Raw
    
    # Check if token already exists
    if ($content -match "GOOGLE_DRIVE_REFRESH_TOKEN=.*") {
        # Replace existing token
        $content = $content -replace "GOOGLE_DRIVE_REFRESH_TOKEN=.*", "GOOGLE_DRIVE_REFRESH_TOKEN=$refreshToken"
        Write-Host "✅ Đã cập nhật token trong env.properties" -ForegroundColor Green
    } else {
        # Add new token
        $content += "`nGOOGLE_DRIVE_REFRESH_TOKEN=$refreshToken"
        Write-Host "✅ Đã thêm token vào env.properties" -ForegroundColor Green
    }
    
    # Save file
    Set-Content -Path $envFile -Value $content -NoNewline
    
} else {
    Write-Host "⚠️  Không tìm thấy file env.properties" -ForegroundColor Yellow
    Write-Host "   Tạo file thủ công tại: src\conf\env.properties" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ✅ CẤU HÌNH HOÀN TẤT!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "⚠️  LƯU Ý: Bạn cần RESTART server để áp dụng thay đổi!" -ForegroundColor Yellow
Write-Host ""
Write-Host "📝 Các bước tiếp theo:" -ForegroundColor Cyan
Write-Host "   1. Dừng server hiện tại (Ctrl+C trong terminal đang chạy)" -ForegroundColor White
Write-Host "   2. Khởi động lại: .\run-tomcat.bat" -ForegroundColor White
Write-Host "   3. Thử upload video tại: http://localhost:9999/Adaptive_Elearning/instructor/upload-video" -ForegroundColor White
Write-Host ""

Read-Host -Prompt "Nhấn Enter để thoát"
