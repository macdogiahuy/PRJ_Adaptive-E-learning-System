## 🧩 Import JSON vào Assignment — hướng dẫn chạy `JsonAssignmentImporter`

File `JsonAssignmentImporter` đã được thêm vào repository tại `src/main/java/com/coursehub/tools/JsonAssignmentImporter.java`.
Nó làm 2 việc chính: đọc file JSON định dạng MCQ, chèn vào `dbo.McqQuestions`/`dbo.McqChoices`, và lưu đường dẫn file vào cột `Assignments.JsonFileUrl` (nếu cột chưa có thì tool sẽ tự ALTER TABLE để thêm).

Hướng dẫn chạy (PowerShell, Windows):

1) Build project (từ thư mục project):

```powershell
cd 'C:\Users\datdi\Downloads\Adaptive_Elearning\Adaptive_Elearning'
mvn -DskipTests package
```

2) Chạy importer bằng Maven Exec (tùy cấu hình Maven; đây là cách tiện lợi vì tự xử lý classpath):

```powershell
mvn -Dexec.mainClass="com.coursehub.tools.JsonAssignmentImporter" -Dexec.args="6965B04A-E57A-4CC0-AC98-C19C61EAA497 'C:\Users\datdi\Downloads\SQL___MySQL_for_Data_Analytics_and_Business_Intelligence_150_questions.json'" exec:java -Dexec.cleanupDaemonThreads=false
```

3) Hoặc chạy trực tiếp bằng `java -cp` (bạn cần build một fat-jar hoặc thêm tất cả dependency vào classpath). Ví dụ tạo jar bằng plugin maven-shade rồi:

```powershell
# mvn package shade:shade
# java -cp target\your-fat-jar.jar com.coursehub.tools.JsonAssignmentImporter 6965B04A-E57A-4CC0-AC98-C19C61EAA497 "C:\Users\datdi\Downloads\SQL___MySQL_for_Data_Analytics_and_Business_Intelligence_150_questions.json"
```

4) Kiểm tra kết quả:
- Trong SQL Server Management Studio hoặc công cụ DB: chạy
	- SELECT TOP 20 * FROM dbo.McqQuestions WHERE AssignmentId = '6965B04A-E57A-4CC0-AC98-C19C61EAA497'
	- SELECT * FROM dbo.McqChoices WHERE McqQuestionId IN (SELECT Id FROM dbo.McqQuestions WHERE AssignmentId = '...')
	- SELECT JsonFileUrl, QuestionCount FROM dbo.Assignments WHERE Id = '6965B04A-E57A-4CC0-AC98-C19C61EAA497'

Lưu ý bảo mật: tool này sẽ ALTER TABLE để thêm cột `JsonFileUrl` nếu chưa có; nếu bạn không muốn tự động thay đổi schema, hãy sao chép SQL ALTER TABLE và chạy thủ công trong môi trường an toàn trước khi chạy importer.

Nếu bạn muốn, tôi có thể tạo sẵn `DriveStreamServlet` mẫu (kèm Range support) và chỉnh `course-player.jsp` trong repo để sử dụng flow này — chọn 1 trong 2 và tôi sẽ thực hiện.
# Adaptive Elearning Dashboard

Đây là dự án dashboard cho hệ thống học tập thích ứng được xây dựng bằng JSP/Servlet.

## 🚀 Tính năng

- **Dashboard hiện đại** với giao diện responsive
- **Sidebar navigation** với menu đầy đủ
- **Card widgets** hiển thị thống kê (Users, Notifications, Courses, Learning Groups)
- **Chart section** với biểu đồ thống kê
- **Responsive design** tương thích với mobile và desktop

## 📁 Cấu trúc dự án

```
Adaptive_Elearning/
├── src/java/
│   ├── controller/
│   │   └── DashboardServlet.java      # Servlet xử lý dashboard
│   └── model/
│       └── DashboardData.java         # Model chứa dữ liệu dashboard
├── web/
│   ├── index.jsp                      # Trang chủ (login)
│   ├── WEB-INF/
│   │   ├── web.xml                    # Cấu hình servlet
│   │   └── views/
│   │       └── dashboard.jsp          # Giao diện dashboard chính
│   └── assets/
│       ├── css/
│       │   └── dashboard.css          # Styling cho dashboard
│       └── js/
│           └── dashboard.js           # JavaScript tương tác
```

1. Mở NetBeans IDE
2. Chọn **File > Open Project**
3. Chọn thư mục `Adaptive_Elearning`
4. Project sẽ được import tự động

### 2. Thêm Servlet Libraries
1. Right-click vào project **Adaptive_Elearning**
2. Chọn **Properties**
3. Vào tab **Libraries**
4. Click **Add Library**
5. Chọn **Java EE Web 8** hoặc **Jakarta EE Web**
6. Click **Add Library**

### 3. Deploy và Run
1. Right-click vào project
2. Chọn **Run**
3. Project sẽ được build và deploy lên Tomcat
4. Truy cập: `http://localhost:8080/Adaptive_Elearning/`

## 🌐 Truy cập

- **Trang chủ**: `http://localhost:8080/Adaptive_Elearning/`
- **Dashboard**: `http://localhost:8080/Adaptive_Elearning/dashboard`

## 📱 Demo Mode

Project chạy ở chế độ demo với:
- User: `demo_user`
- Role: `admin`
- Dữ liệu mẫu được tạo tự động

## 🎨 Tính năng giao diện

### Sidebar Menu
- Dashboard (active)
- Users
- Notifications
- Create Admin
- Courses
- Learning Groups
- Statistical Chart
- Data Values
- Users
- Learner View
- Sign Out

### Dashboard Widgets
- **Users Card**: Hiển thị tổng số người dùng
- **Notifications Card**: Hiển thị số thông báo
- **Create Admin Card**: Chức năng tạo admin
- **Courses Card**: Hiển thị số khóa học
- **Learning Groups Card**: Hiển thị số nhóm học tập
- **Statistical Chart**: Biểu đồ thống kê

### Responsive Design
- Tương thích với desktop, tablet, mobile
- Menu responsive khi thu nhỏ màn hình
- Layout tự động điều chỉnh

## 🛠️ Công nghệ sử dụng

- **Backend**: JSP/Servlet
- **Frontend**: HTML5, CSS3, JavaScript
- **Icons**: Font Awesome 6
- **Server**: Apache Tomcat
- **IDE**: NetBeans

## 📝 Ghi chú

- Project cần servlet libraries để compile
- Chạy trên Tomcat server
- Tương thích với Java EE 8 hoặc Jakarta EE

## 🔧 Troubleshooting

3. Thêm Java EE Web library
4. Clean và Build lại project
1. Kiểm tra web.xml có servlet mapping không
2. Đảm bảo DashboardServlet được compile

Nếu gặp vấn đề khi setup hoặc chạy project, hãy kiểm tra:
3. Port 8080 không bị chiếm dụng
 
## 📌 LectureMaterial -> Course Player flow (tích hợp video từ DB lên trang phát)

Phần này mô tả chi tiết cách hệ thống lấy các bản ghi trong bảng `dbo.LectureMaterial` và hiển thị video/tài liệu trên trang `course-player`.

1) Mô tả ngắn
- Bảng nguồn: `dbo.LectureMaterial` (các cột quan trọng: `LectureId`, `Id`, `Type`, `Url`, `FileName`).
- Backend (Servlet): truy vấn các material theo `LectureId`, chuẩn hóa `Url` (lấy Drive fileId nếu cần) và forward list sang view.
- Frontend (`course-player.jsp`): với `Type == "Video"` render HTML5 `<video>` dùng proxy stream (ví dụ `/drive/stream?fileId=...`); với PDF/DOCX hiển thị link/iframe.

2) SQL truy vấn mẫu

```sql
SELECT Id, Type, Url, FileName
FROM dbo.LectureMaterial
WHERE LectureId = ?
ORDER BY Id;
```

3) Servlet / JDBC - ví dụ (rút gọn)

```java
// model nhỏ dùng cho view
public static class Material {
	public String id; public String type; public String url; public String fileName;
	public Material(String id, String type, String url, String fileName) { this.id=id;this.type=type;this.url=url;this.fileName=fileName; }
}

// trong servlet
String lectureId = request.getParameter("lectureId");
List<Material> materials = new ArrayList<>();
String sql = "SELECT Id, Type, Url, FileName FROM dbo.LectureMaterial WHERE LectureId = ?";
try (Connection conn = dao.DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
	ps.setString(1, lectureId);
	try (ResultSet rs = ps.executeQuery()) {
		while (rs.next()) {
			materials.add(new Material(rs.getString("Id"), rs.getString("Type"), rs.getString("Url"), rs.getString("FileName")));
		}
	}
}
// normalize URL -> stream path if Drive file
for (Material m : materials) m.url = normalizeToStreamUrl(m.url);
request.setAttribute("lectureMaterials", materials);
request.getRequestDispatcher("/WEB-INF/views/course-player.jsp").forward(request, response);
```

Helper nhỏ để extract Drive fileId (ví dụ dùng regex) và tạo đường dẫn proxy:

```java
private String extractDriveFileId(String url) {
	if (url == null) return null;
	Pattern p = Pattern.compile("/d/([a-zA-Z0-9_-]+)");
	Matcher m = p.matcher(url);
	if (m.find()) return m.group(1);
	try { URL u = new URL(url); String q = u.getQuery(); if (q!=null) for(String part:q.split("&")) if (part.startsWith("id=")) return part.substring(3); } catch(Exception ignored){}
	return null;
}

private String normalizeToStreamUrl(String dbUrl) {
	String fileId = extractDriveFileId(dbUrl);
	if (fileId != null) return "/drive/stream?fileId=" + fileId; // proxy endpoint
	return dbUrl; // fallback
}
```

4) JSP hiển thị (mẫu)

```jsp
<c:forEach var="mat" items="${lectureMaterials}">
	<c:choose>
		<c:when test="${fn:toLowerCase(mat.type) == 'video'}">
			<video controls preload="metadata" width="100%">
				<source src="${pageContext.request.contextPath}${mat.url}" type="video/mp4" />
				Trình duyệt không hỗ trợ video.
			</video>
		</c:when>
		<c:otherwise>
			<a href="${pageContext.request.contextPath}${mat.url}" target="_blank">${mat.fileName}</a>
		</c:otherwise>
	</c:choose>
</c:forEach>
```

5) Drive proxy / DriveStreamServlet (lý do và yêu cầu)
- Nếu file Google Drive là private hoặc bạn muốn tránh CSP/embed issues, implement servlet `/drive/stream?fileId=...` để server fetch file từ Drive API và stream tới client.
- Yêu cầu quan trọng: hỗ trợ HTTP Range header (seek) để `<video>` có thể băng thông hiệu quả và seek.
- Set headers: `Accept-Ranges: bytes`, `Content-Type` theo file, `Cache-Control`, trả `206 Partial Content` khi có Range.

6) Quyền truy cập
- Trước khi trả danh sách material, kiểm tra user có quyền xem (enrolled, instructor, preview flag).
- Drive stream servlet cũng nên kiểm tra session và quyền.

7) Kiểm thử nhanh
- Upload video qua form hiện tại, kiểm tra `LectureMaterial.Url` lưu đúng (embed hoặc chứa fileId).
- Mở `course-player` cho lecture đó, kiểm tra video xuất hiện và seek hoạt động.
- Test file PDF/DOCX: link/download được mở.

8) Gợi ý tối ưu
- Lưu `FileName` và thumbnail để dùng `poster` attribute trên `<video>`.
- Nếu muốn bảo mật, để Drive private và dùng proxy + server credential.

Nếu bạn muốn, tôi có thể tạo sẵn `DriveStreamServlet` mẫu (kèm Range support) và chỉnh `course-player.jsp` trong repo để sử dụng flow này — chọn 1 trong 2 và tôi sẽ thực hiện.
 