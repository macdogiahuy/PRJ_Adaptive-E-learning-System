# 🔧 HƯỚNG DẪN DEPLOY THỦ CÔNG

## Bước 1: Stop Tomcat
- Mở Services (Win + R → services.msc)
- Tìm "Apache Tomcat 10.1 Tomcat10"
- Right-click → Stop

## Bước 2: Xóa deployment cũ
Mở File Explorer, xóa folder:
```
C:\Program Files\Apache Software Foundation\Tomcat 10.1\webapps\Adaptive_Elearning
```

Xóa file:
```
C:\Program Files\Apache Software Foundation\Tomcat 10.1\webapps\Adaptive_Elearning.war
```

## Bước 3: Copy WAR mới
Copy file từ:
```
C:\Users\LP\Desktop\New folder (3)\PRJ_Adaptive-E-learning-System\Adaptive_Elearning\target\Adaptive_Elearning.war
```

Đến:
```
C:\Program Files\Apache Software Foundation\Tomcat 10.1\webapps\
```

## Bước 4: Start Tomcat
- Mở Services
- Tìm "Apache Tomcat 10.1 Tomcat10"
- Right-click → Start

## Bước 5: Đợi 30 giây để Tomcat deploy WAR

## ✅ TEST FIX

1. Mở: http://localhost:8080/Adaptive_Elearning
2. Login: Snow1234
3. Tìm course "123"
4. Click "Thêm vào giỏ hàng"
5. **Kết quả mong đợi:** Hiện thông báo "Bạn đã sở hữu khóa học này rồi!"

## 🎯 FIX ĐÃ HOẠT ĐỘNG KHI:
✅ Không thể thêm course đã sở hữu vào giỏ
✅ Có thông báo rõ ràng
✅ Mua 2 courses mới → cả 2 hiện trong My Courses
