package controller;

import com.google.api.client.auth.oauth2.Credential;
import com.google.api.services.drive.Drive;
import com.google.api.services.drive.model.File;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.CredentialManager;
import utils.DriveService;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

/**
 * Stream Google Drive video content through our domain to avoid
 * CSP frame-ancestors and 3rd‑party cookie issues when embedding via iframe.
 * Usage: /drive-stream?fileId=XXXX  (fileId is the Google Drive file id)
 *
 * This is a SIMPLE implementation (reads whole stream sequentially).
 * Future enhancement: implement HTTP Range support for better seeking.
 */
@WebServlet("/drive-stream")
public class DriveStreamServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String fileId = req.getParameter("fileId");
        if (fileId == null || fileId.isBlank()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing fileId");
            return;
        }

        Credential credential;
        try {
            credential = CredentialManager.getAdminCredential();
            if (credential == null) {
                resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Drive credential unavailable");
                return;
            }
        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Auth error: " + e.getMessage());
            return;
        }

        try {
            Drive drive = DriveService.getDriveService(credential);
            // Get metadata (mimeType & name)
            File metadata = drive.files().get(fileId).setFields("mimeType,name,size").execute();
            String mime = metadata.getMimeType();
            if (mime == null || mime.isBlank()) {
                mime = "application/octet-stream";
            }
            resp.setContentType(mime);
            // Basic caching headers (tune as needed)
            resp.setHeader("Cache-Control", "public, max-age=3600");
            resp.setHeader("X-Accel-Buffering", "no");

            // Stream the file
            try (InputStream in = drive.files().get(fileId).executeMediaAsInputStream();
                 OutputStream out = resp.getOutputStream()) {
                byte[] buffer = new byte[8192];
                int len;
                while ((len = in.read(buffer)) != -1) {
                    out.write(buffer, 0, len);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (!resp.isCommitted()) {
                resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Stream error: " + e.getMessage());
            }
        }
    }
}
