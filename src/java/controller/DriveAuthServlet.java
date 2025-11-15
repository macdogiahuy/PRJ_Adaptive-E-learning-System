package controller;

import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeRequestUrl;
import utils.DriveService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/auth/drive")
public class DriveAuthServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
                        throws IOException {

        // Tạo URL ủy quyền với access_type=offline để lấy Refresh Token
        String authUrl = new GoogleAuthorizationCodeRequestUrl(
            DriveService.CLIENT_ID, 
            DriveService.REDIRECT_URI, 
            DriveService.SCOPES
        )
        .setAccessType("offline") 
        .setApprovalPrompt("force") 
        .build();

        response.sendRedirect(authUrl);
    }
}