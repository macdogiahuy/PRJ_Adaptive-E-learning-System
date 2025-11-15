package utils;

import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.googleapis.auth.oauth2.GoogleClientSecrets;
import com.google.api.client.googleapis.auth.oauth2.GoogleCredential;
import java.io.IOException;

public class CredentialManager {

    // ⚠️ Lấy refresh token từ env.properties hoặc hardcode nếu cần
    private static String getRefreshToken() {
        // Ưu tiên lấy từ environment variable
        String envToken = System.getenv("GOOGLE_DRIVE_REFRESH_TOKEN");
        if (envToken != null && !envToken.isBlank()) {
            return envToken;
        }
        
        // Lấy từ env.properties
        try {
            String propToken = EnvConfig.get("GOOGLE_DRIVE_REFRESH_TOKEN");
            if (propToken != null && !propToken.isBlank()) {
                return propToken;
            }
        } catch (Exception e) {
            // Ignore if property not found
        }
        
        // Fallback: Hardcode (cần thay thế bằng token thật)
        return "YOUR_NEW_REFRESH_TOKEN_HERE";
    }

    public static Credential getAdminCredential() throws IOException {
        
        String ADMIN_REFRESH_TOKEN = getRefreshToken();
        
        if (ADMIN_REFRESH_TOKEN == null || ADMIN_REFRESH_TOKEN.isBlank() 
                || "YOUR_NEW_REFRESH_TOKEN_HERE".equals(ADMIN_REFRESH_TOKEN)) {
            throw new IOException("⚠️ Refresh Token chưa được cấu hình. Vui lòng truy cập: http://localhost:9999/Adaptive_Elearning/auth/drive");
        }

        GoogleClientSecrets.Details webDetails = new GoogleClientSecrets.Details();
        webDetails.setClientId(DriveService.CLIENT_ID);
        webDetails.setClientSecret(DriveService.CLIENT_SECRET);

        GoogleClientSecrets clientSecrets = new GoogleClientSecrets();
        clientSecrets.setWeb(webDetails);

        GoogleCredential credential = new GoogleCredential.Builder()
                .setTransport(DriveService.HTTP_TRANSPORT)
                .setJsonFactory(DriveService.JSON_FACTORY)
                .setClientSecrets(clientSecrets)
                .build()
                .setRefreshToken(ADMIN_REFRESH_TOKEN);

        // ✅ Yêu cầu Google cấp Access Token mới từ Refresh Token
        boolean refreshed = credential.refreshToken();

        // ✅ In token ra console Tomcat
        System.out.println("=== 🔑 REFRESH TOKEN TEST ===");
        System.out.println("Refreshed: " + refreshed);
        System.out.println("Access Token: " + credential.getAccessToken());
        System.out.println("==============================");

        return credential;
    }
}