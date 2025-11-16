#!/bin/bash
# Security Configuration Checker Script
# Giúp kiểm tra xem tất cả cấu hình bảo mật đã được thiết lập đúng chưa

echo "🔍 Kiểm tra cấu hình bảo mật..."
echo "=================================="

# Kiểm tra file env.properties
if [ -f "src/conf/env.properties" ]; then
    echo "✅ File env.properties tồn tại"
    
    # Kiểm tra các biến cần thiết
    if grep -q "DB_URL=" src/conf/env.properties && grep -q "DB_USER=" src/conf/env.properties && grep -q "DB_PASSWORD=" src/conf/env.properties; then
        echo "✅ Cấu hình database đã có"
    else
        echo "❌ Thiếu cấu hình database trong env.properties"
    fi
    
    if grep -q "GOOGLE_CLIENT_ID=" src/conf/env.properties && grep -q "GOOGLE_CLIENT_SECRET=" src/conf/env.properties; then
        echo "✅ Cấu hình Google OAuth đã có"
    else
        echo "⚠️  Cấu hình Google OAuth chưa có (nếu không dùng Google login thì bỏ qua)"
    fi
    
    # Kiểm tra placeholder values
    if grep -q "your_username\|your_password\|your_google_client" src/conf/env.properties; then
        echo "❌ Vẫn còn placeholder values trong env.properties"
        echo "   Vui lòng cập nhật với thông tin thật"
    else
        echo "✅ Không còn placeholder values"
    fi
    
else
    echo "❌ File env.properties không tồn tại"
    echo "   Chạy: cp src/conf/env.properties.example src/conf/env.properties"
fi

# Kiểm tra .gitignore
if [ -f ".gitignore" ]; then
    if grep -q "env.properties" .gitignore; then
        echo "✅ File env.properties đã được gitignore"
    else
        echo "❌ File env.properties chưa được gitignore"
    fi
else
    echo "❌ File .gitignore không tồn tại"
fi

# Kiểm tra xem có file nhạy cảm nào trong git không
echo ""
echo "🔍 Kiểm tra file nhạy cảm trong git..."
if git ls-files | grep -E "\.(properties|env)$" | grep -v "\.example$"; then
    echo "⚠️  Tìm thấy file properties trong git:"
    git ls-files | grep -E "\.(properties|env)$" | grep -v "\.example$"
    echo "   Kiểm tra xem có chứa thông tin nhạy cảm không"
else
    echo "✅ Không tìm thấy file properties nhạy cảm trong git"
fi

echo ""
echo "📋 Tóm tắt:"
echo "- Đảm bảo env.properties đã được cấu hình với thông tin thật"
echo "- Không bao giờ commit file env.properties"
echo "- Chỉ commit file env.properties.example (template)"
echo "- Kiểm tra .gitignore đã bao gồm các file nhạy cảm"

echo ""
echo "🔗 Để setup Google OAuth:"
echo "1. Vào https://console.cloud.google.com/"
echo "2. Tạo OAuth 2.0 Client ID"
echo "3. Cập nhật GOOGLE_CLIENT_ID và GOOGLE_CLIENT_SECRET trong env.properties"