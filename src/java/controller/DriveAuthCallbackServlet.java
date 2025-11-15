package controller;

import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.googleapis.auth.oauth2.GoogleTokenResponse;
import utils.DriveService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/oauth2drivecallback")
public class DriveAuthCallbackServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
                        throws IOException {
        
        String code = request.getParameter("code");

        if (code != null) {
            
            GoogleAuthorizationCodeFlow flow = new GoogleAuthorizationCodeFlow.Builder(
                DriveService.HTTP_TRANSPORT, DriveService.JSON_FACTORY, 
                DriveService.CLIENT_ID, DriveService.CLIENT_SECRET, 
                DriveService.SCOPES
            ).build();

            GoogleTokenResponse tokenResponse = flow.newTokenRequest(code)
                    .setRedirectUri(DriveService.REDIRECT_URI)
                    .execute();
            
            String refreshToken = tokenResponse.getRefreshToken();
            
            response.setContentType("text/html; charset=UTF-8");
            
            if (refreshToken != null) {
                String html = "<!DOCTYPE html>"
                    + "<html><head><meta charset='UTF-8'>"
                    + "<style>"
                    + "body { font-family: Arial, sans-serif; padding: 40px; background: #f5f5f5; }"
                    + ".container { max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }"
                    + "h1 { color: #4CAF50; }"
                    + ".token-box { background: #f9f9f9; padding: 20px; border-radius: 5px; border: 2px solid #4CAF50; margin: 20px 0; word-break: break-all; }"
                    + ".instructions { background: #fff3cd; padding: 15px; border-radius: 5px; border-left: 4px solid #ffc107; margin: 20px 0; }"
                    + "code { background: #e8e8e8; padding: 2px 6px; border-radius: 3px; }"
                    + ".copy-btn { background: #4CAF50; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; margin-top: 10px; }"
                    + ".copy-btn:hover { background: #45a049; }"
                    + "</style>"
                    + "</head><body>"
                    + "<div class='container'>"
                    + "<h1>✅ ỦY QUYỀN THÀNH CÔNG!</h1>"
                    + "<p>Refresh Token của bạn đã được tạo. Vui lòng làm theo các bước sau:</p>"
                    + "<div class='token-box'>"
                    + "<strong>Refresh Token:</strong><br>"
                    + "<span id='token'>" + refreshToken + "</span><br>"
                    + "<button class='copy-btn' onclick='copyToken()'>📋 Copy Token</button>"
                    + "</div>"
                    + "<div class='instructions'>"
                    + "<h3>📝 Hướng dẫn cấu hình:</h3>"
                    + "<p><strong>Cách 1:</strong> Cập nhật vào file <code>src/conf/env.properties</code></p>"
                    + "<pre>GOOGLE_DRIVE_REFRESH_TOKEN=REDACTED
                    + "<p><strong>Cách 2:</strong> Hoặc thêm vào biến môi trường hệ thống:</p>"
                    + "<pre>GOOGLE_DRIVE_REFRESH_TOKEN=REDACTED
                    + "<p><strong>⚠️ Lưu ý:</strong> Sau khi cập nhật, cần restart server để áp dụng thay đổi.</p>"
                    + "</div>"
                    + "</div>"
                    + "<script>"
                    + "function copyToken() {"
                    + "  const token = document.getElementById('token').textContent;"
                    + "  navigator.clipboard.writeText(token).then(() => {"
                    + "    alert('✅ Đã copy token vào clipboard!');"
                    + "  });"
                    + "}"
                    + "</script>"
                    + "</body></html>";
                
                response.getWriter().write(html);
            } else {
                String html = "<!DOCTYPE html>"
                    + "<html><head><meta charset='UTF-8'>"
                    + "<style>body { font-family: Arial; padding: 40px; background: #f5f5f5; }"
                    + ".error { max-width: 600px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; border-left: 4px solid #f44336; }</style>"
                    + "</head><body>"
                    + "<div class='error'>"
                    + "<h1 style='color: #f44336;'>❌ LỖI</h1>"
                    + "<p>Refresh Token KHÔNG được cung cấp.</p>"
                    + "<p>Vui lòng thử lại: <a href='/Adaptive_Elearning/auth/drive'>Ủy quyền lại</a></p>"
                    + "<p><strong>Lưu ý:</strong> Nếu bạn đã ủy quyền trước đó, hãy thu hồi quyền truy cập tại "
                    + "<a href='https://myaccount.google.com/permissions' target='_blank'>Google Permissions</a> "
                    + "rồi thử lại.</p>"
                    + "</div>"
                    + "</body></html>";
                
                response.getWriter().write(html);
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu mã ủy quyền.");
        }
    }
}