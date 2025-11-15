package controller;

import com.google.api.client.auth.oauth2.Credential;
import jakarta.servlet.ServletException;
import utils.CredentialManager;
import utils.DriveService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/lecture/view")
public class ViewLectureServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
                        throws IOException, ServletException {
        
        String lectureId = request.getParameter("lectureId");
        
        // ⚠️ BƯỚC 1: KIỂM TRA QUYỀN (Logic của bạn) ⚠️
        boolean hasPurchased = true; // GIẢ ĐỊNH CHO DEMO
        
        String embedUrl = null;
        String errorMsg = null;
        
        if (hasPurchased) { 
            // ⚠️ BƯỚC 2: LẤY FILE ID TỪ DB ⚠️
            // Lấy giá trị cột Url từ bảng LectureMaterial
            // String fileId = lectureMaterialDAO.getFileId(lectureId, "Video"); 
            String fileId = "FILE_ID_TU_DB_Vd_1aBcXyZ"; // Thay bằng logic lấy từ DB
            
            try {
                Credential credential = CredentialManager.getAdminCredential();
                
                // BƯỚC 3: Cấp quyền xem công khai (Bắt buộc)
                DriveService.setFilePublic(fileId, credential);
                
                // BƯỚC 4: Tạo URL nhúng
                embedUrl = DriveService.getEmbedUrl(fileId);
                
            } catch (IOException e) {
                errorMsg = "Lỗi xác thực: Vui lòng kiểm tra Refresh Token hoặc Cấu hình API.";
            } catch (Exception e) {
                errorMsg = "Lỗi truy cập video: Lỗi API Drive.";
            }
        } else {
            errorMsg = "Vui lòng mua khóa học để xem bài giảng này.";
        }
        
        request.setAttribute("videoEmbedUrl", embedUrl);
        request.setAttribute("error", errorMsg);
        request.getRequestDispatcher("/views/lecture_view.jsp").forward(request, response);
    }
}