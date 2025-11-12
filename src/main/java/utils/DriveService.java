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

    private static final int MAX_DRIVE_NAME_LENGTH = 200;
    private static final String DEFAULT_FILE_PREFIX = "course_video";

    static {
        try {
            HTTP_TRANSPORT = GoogleNetHttpTransport.newTrustedTransport();
        } catch (GeneralSecurityException | IOException e) {
            e.printStackTrace();
            System.exit(1);
        }
    }

    public static Drive getDriveService(Credential credential) {
        return new Drive.Builder(HTTP_TRANSPORT, JSON_FACTORY, credential)
                .setApplicationName(APPLICATION_NAME)
                .build();
    }

    public static String uploadFile(InputStream stream, String mimeType, Credential credential)
            throws IOException {

        com.google.api.services.drive.model.File metadata =
                new com.google.api.services.drive.model.File();

        String fallbackName = DEFAULT_FILE_PREFIX + "_" + System.currentTimeMillis();
        metadata.setName(fallbackName + ".mp4");
        metadata.setParents(Collections.singletonList(COURSE_VIDEO_FOLDER_ID));

        com.google.api.client.http.InputStreamContent content =
                new com.google.api.client.http.InputStreamContent(mimeType, stream);

        Drive drive = getDriveService(credential);

        com.google.api.services.drive.model.File file =
                drive.files().create(metadata, content)
                        .setFields("id")
                        .execute();

        return file.getId();
    }

    public static void setFilePublic(String fileId, Credential credential) throws IOException {
        Drive drive = getDriveService(credential);

        com.google.api.services.drive.model.Permission permission =
                new com.google.api.services.drive.model.Permission()
                        .setType("anyone")
                        .setRole("reader");

        try {
            com.google.api.services.drive.model.Permission p =
                    drive.permissions()
                            .create(fileId, permission)
                            .setFields("id")
                            .execute();

            System.out.println("✅ Public permission applied: " + p.getId());

        } catch (Exception e) {
            System.err.println("❌ FAILED set public permission — fileId = " + fileId);
            e.printStackTrace();
            throw e;
        }
    }

    public static String getEmbedUrl(String fileId) {
        return "https://drive.google.com/file/d/" + fileId + "/preview";
    }

    public static String ensureCourseFolderHierarchy(Credential credential,
                                                     String courseName,
                                                     String sectionName,
                                                     String lectureName) throws IOException {

        String courseFolder = sanitizeFolderName(courseName, "Course");
        String sectionFolder = sanitizeFolderName(sectionName, "Section");
        String lectureFolder = sanitizeFolderName(lectureName, "Lecture");

        String parentId = getOrCreateFolder(COURSE_VIDEO_FOLDER_ID, courseFolder, credential);
        parentId = getOrCreateFolder(parentId, sectionFolder, credential);
        parentId = getOrCreateFolder(parentId, lectureFolder, credential);

        return parentId;
    }

    public static String getOrCreateFolder(String parentId, String folderName, Credential credential)
            throws IOException {

        Drive drive = getDriveService(credential);

        String safeName = sanitizeFolderName(folderName, "Folder");

        String q = "mimeType='application/vnd.google-apps.folder' " +
                "and name='" + escapeSingleQuotes(safeName) + "' " +
                "and '" + parentId + "' in parents and trashed=false";

        com.google.api.services.drive.Drive.Files.List req =
                drive.files().list().setQ(q).setFields("files(id,name)");

        com.google.api.services.drive.model.FileList result = req.execute();

        if (result.getFiles() != null && !result.getFiles().isEmpty()) {
            return result.getFiles().get(0).getId();
        }

        com.google.api.services.drive.model.File metadata =
                new com.google.api.services.drive.model.File();

        metadata.setName(safeName);
        metadata.setMimeType("application/vnd.google-apps.folder");
        metadata.setParents(Collections.singletonList(parentId));

        com.google.api.services.drive.model.File folder =
                drive.files().create(metadata).setFields("id").execute();

        return folder.getId();
    }

    public static String uploadFile(InputStream stream,
                                    String mimeType,
                                    Credential credential,
                                    String parentFolderId,
                                    String desiredName) throws IOException {

        String fallback = DEFAULT_FILE_PREFIX + "_" + System.currentTimeMillis() + ".mp4";
        String safeName = sanitizeFileName(desiredName, fallback);

        com.google.api.services.drive.model.File metadata =
                new com.google.api.services.drive.model.File();

        metadata.setName(safeName);
        metadata.setParents(Collections.singletonList(parentFolderId));

        com.google.api.client.http.InputStreamContent content =
                new com.google.api.client.http.InputStreamContent(mimeType, stream);

        Drive drive = getDriveService(credential);

        com.google.api.services.drive.model.File file =
                drive.files().create(metadata, content)
                        .setFields("id")
                        .execute();

        return file.getId();
    }

    private static String sanitizeFolderName(String name, String fallback) {
        String n = (name == null ? "" : name.trim());
        if (n.isEmpty()) n = fallback;
        n = n.replaceAll("[\\\\/:*?\"<>|]+", " ");
        n = n.replaceAll("\\s+", " ").trim();
        return (n.length() > MAX_DRIVE_NAME_LENGTH)
                ? n.substring(0, MAX_DRIVE_NAME_LENGTH)
                : n;
    }

    private static String sanitizeFileName(String name, String fallback) {
        String n = (name == null ? "" : name.trim());
        if (n.isEmpty()) n = fallback;
        n = n.replaceAll("[\\\\/:*?\"<>|]+", " ");
        n = n.replaceAll("\\s+", " ").trim();
        return (n.length() > MAX_DRIVE_NAME_LENGTH)
                ? n.substring(0, MAX_DRIVE_NAME_LENGTH)
                : n;
    }

    private static String escapeSingleQuotes(String value) {
        return value.replace("'", "\\'");
    }
}
