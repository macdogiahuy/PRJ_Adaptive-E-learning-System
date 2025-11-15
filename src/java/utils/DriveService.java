package utils;

import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.gson.GsonFactory;
import com.google.api.services.drive.Drive;
import com.google.api.client.auth.oauth2.Credential;
import java.io.IOException;
import java.io.InputStream;
import java.security.GeneralSecurityException;
import java.util.Collections;
import java.util.List;

public class DriveService {

    // ✅ OAuth Client (lấy từ JSON)
    public static final String CLIENT_ID =
            "REDACTED_GOOGLE_CLIENT_ID_DRIVESERVICE";

    public static final String CLIENT_SECRET =
            "REDACTED_GOOGLE_CLIENT_SECRET_DRIVESERVICE";

    public static final String REDIRECT_URI =
            "http://localhost:9999/Adaptive_Elearning/oauth2drivecallback";

    // ✅ FULL DRIVE quyền ghi + share
    public static final List<String> SCOPES = Collections.singletonList(
            com.google.api.services.drive.DriveScopes.DRIVE
    );

    // ✅ Folder gốc chứa toàn bộ course
    public static final String COURSE_VIDEO_FOLDER_ID = "1WI2-xgFbjW0AJw79eTI1JvXcQtwFLdMN"; 

    public static final String APPLICATION_NAME = "AdaptiveELearning";
    public static final JsonFactory JSON_FACTORY = GsonFactory.getDefaultInstance();
    public static HttpTransport HTTP_TRANSPORT;

    static {
        try {
            HTTP_TRANSPORT = GoogleNetHttpTransport.newTrustedTransport();
        } catch (GeneralSecurityException | IOException e) {
            e.printStackTrace();
            System.exit(1);
        }
    }

    public static Drive getDriveService(Credential credential) throws IOException {
        return new Drive.Builder(HTTP_TRANSPORT, JSON_FACTORY, credential)
                .setApplicationName(APPLICATION_NAME)
                .build();
    }

    // --- CHỨC NĂNG TẢI LÊN ---
    public static String uploadFile(InputStream stream, String mimeType, Credential credential)
            throws IOException {

        // Metadata: Sử dụng tên đầy đủ để tránh xung đột
        com.google.api.services.drive.model.File fileMetadata
                = new com.google.api.services.drive.model.File();

        fileMetadata.setName(System.currentTimeMillis() + "_course_video");
        fileMetadata.setParents(Collections.singletonList(COURSE_VIDEO_FOLDER_ID));

        // Content
        com.google.api.client.http.InputStreamContent content
                = new com.google.api.client.http.InputStreamContent(mimeType, stream);

        Drive drive = getDriveService(credential);

        // Lần sử dụng File thứ hai cũng dùng tên đầy đủ để khắc phục lỗi biên dịch
        com.google.api.services.drive.model.File file = drive.files().create(fileMetadata, content)
                .setFields("id")
                .execute();

        return file.getId(); // Trả về File ID
    }

    // --- CHỨC NĂNG CẤP QUYỀN ---
    public static void setFilePublic(String fileId, Credential credential) throws IOException {
        Drive drive = getDriveService(credential);

        // ❌ Dòng code Gây lỗi: Permission permission = new Permission()
        // ✅ KHẮC PHỤC: Sử dụng constructor mặc định (cần đảm bảo lớp không thực sự là abstract trong JAR của bạn)
        // Nếu lỗi vẫn còn, điều này chỉ ra rằng lớp Permission trong JAR của bạn KHÔNG có constructor công cộng mặc định.
        // Hầu hết các phiên bản API hoạt động với cú pháp này:
        com.google.api.services.drive.model.Permission permission
                = new com.google.api.services.drive.model.Permission()
                        .setType("anyone")
                        .setRole("reader");

        try {
            // Cấp quyền
            drive.permissions().create(fileId, permission).execute();

        } catch (com.google.api.client.googleapis.json.GoogleJsonResponseException e) {
            // Bắt ngoại lệ nếu quyền đã tồn tại
            if (!e.getMessage().contains("File already exists") && e.getStatusCode() != 400 && e.getStatusCode() != 403) {
                throw e;
            }
        }
    }
    
    public static String getEmbedUrl(String fileId) {
     return "https://drive.google.com/file/d/" + fileId + "/preview";
}
}