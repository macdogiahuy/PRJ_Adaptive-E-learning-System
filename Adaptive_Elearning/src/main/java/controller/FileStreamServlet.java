package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@WebServlet(name = "FileStreamServlet", urlPatterns = {"/stream-file"})
public class FileStreamServlet extends HttpServlet {

   private static final String UPLOAD_DIRECTORY = "C:\\Users\\ADMIN\\Downloads\\course-uploads";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fileName = request.getParameter("name");
        
        if (fileName != null) {
            String prefix = "?name=";
            int prefixIndex = fileName.indexOf(prefix);
            if (prefixIndex != -1) {
                fileName = fileName.substring(prefixIndex + prefix.length());
            }
        }

        if (fileName == null || fileName.isEmpty() || fileName.contains("..")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Tên file không hợp lệ.");
            return;
        }

        Path filePath = Paths.get(UPLOAD_DIRECTORY, fileName);

        if (!Files.exists(filePath) || Files.isDirectory(filePath)) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy file.");
            return;
        }

        String contentType = getServletContext().getMimeType(fileName);
        if (contentType == null) {
            contentType = "application/octet-stream";
        }
        response.setContentType(contentType);

        response.setContentLengthLong(Files.size(filePath));
        response.setHeader("Accept-Ranges", "bytes");
        
        response.setHeader("Access-Control-Allow-Origin", "*");

        try (InputStream in = Files.newInputStream(filePath);
             OutputStream out = response.getOutputStream()) {
            
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        } catch (IOException e) {
            System.err.println("Lỗi stream file: " + e.getMessage());
        }
    }
}