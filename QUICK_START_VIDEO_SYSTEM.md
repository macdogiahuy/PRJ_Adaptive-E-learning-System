# 🎬 Hướng Dẫn Sử Dụng Hệ Thống Video CourseHub

## 🚀 Quy Trình Upload Video Tự Động

### 1. **Instructor Upload Video**
```
/instructor/upload-form.jsp → Google Drive structure
```
- Upload video qua form instructor
- Video tự động được đẩy lên Drive theo cấu trúc:
  ```
  CourseHubVideo/
  ├── [Course Name]/
  │   ├── [Section Name]/
  │   │   ├── [Lecture Name]/
  │   │   │   └── video.mp4
  ```

### 2. **Admin Chạy Auto-Sync**
```
/admin/auto-sync-drive → Database sync
```
- Truy cập: `http://localhost:8080/your-app/admin/auto-sync-drive`
- Nhấn "Bắt đầu đồng bộ"
- Hệ thống tự động:
  - Quét Google Drive
  - Tạo Section/Lecture nếu chưa có
  - Thêm video vào `LectureMaterial`
  - Đặt quyền public

### 3. **Learner Xem Video**
```
/course-player → Video hiển thị
```
- Video xuất hiện ngay lập tức
- Hỗ trợ Google Drive iframe embed
- Responsive design

## 🔧 Troubleshooting

### Lỗi: "Chưa có nội dung cho bài giảng này"
**Nguyên nhân:**
- Video chưa được upload
- Auto-sync chưa chạy
- Tên thư mục Drive không khớp

**Giải pháp:**
1. Kiểm tra video đã upload lên Drive chưa
2. Chạy auto-sync: `/admin/auto-sync-drive`
3. Kiểm tra console log trong course player

### Debug Console Logs
Mở Developer Tools (F12) để xem:
```
🎬 Lecture clicked: [lecture info]
✅ Parsed materials: [materials array]
🎞️ Resolved video material: [video object]
📼 Google Drive embed URL: [final URL]
```

## 📁 Cấu Trúc Thư Mục Drive Chuẩn

```
CourseHubVideo/
├── The Complete 2023 Web Development Bootcamp/
│   ├── Section 1: Front-End Web Development/
│   │   ├── Title 1/
│   │   │   ├── intro.mp4
│   │   │   └── demo.mp4
│   │   └── Title 2/
│   │       └── lesson.mp4
│   └── Section 2: Introduction to HTML/
│       └── HTML Basics/
│           └── html-intro.mp4
└── Java Course/
    └── Introduction/
        └── Getting Started/
            └── setup.mp4
```

## ⚙️ Configuration

### Servlet Mappings (web.xml)
```xml
<!-- Auto Sync Drive Servlet -->
<servlet-mapping>
    <servlet-name>AutoSyncDriveServlet</servlet-name>
    <url-pattern>/admin/auto-sync-drive</url-pattern>
</servlet-mapping>

<!-- Course Player Servlet -->
<servlet-mapping>
    <servlet-name>CoursePlayerServlet</servlet-name>
    <url-pattern>/course-player</url-pattern>
</servlet-mapping>
```

### Database Schema
```sql
-- LectureMaterial table
- LectureId (FK)
- Type ('Video', 'Document', etc.)
- Url (Google Drive URL)
- FileName (optional)
```

## 🎯 Testing Checklist

- [ ] Upload video via instructor form
- [ ] Check video appears in Google Drive
- [ ] Run auto-sync from admin panel
- [ ] Verify database has new LectureMaterial entry
- [ ] Test course player shows video
- [ ] Verify console logs show proper flow

## 🔗 Key URLs

| Function | URL | Purpose |
|----------|-----|---------|
| Upload Form | `/instructor/upload-form.jsp` | Instructor video upload |
| Auto-Sync | `/admin/auto-sync-drive` | Admin sync Drive→DB |
| Course Player | `/course-player?courseId=X` | Learner video viewing |

## 📞 Support

Nếu gặp lỗi, kiểm tra:
1. Console browser logs
2. Server logs
3. Database connection
4. Google Drive API credentials
5. Servlet mappings trong web.xml

**Lưu ý:** Hệ thống đã hoàn chỉnh và sẵn sàng sử dụng!