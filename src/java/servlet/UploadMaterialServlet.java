package servlet;

import java.io.IOException;
import java.io.InputStream;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.LectureMaterial;
import model.Users;
import utils.CredentialManager;
import utils.DriveService;
import com.google.api.client.auth.oauth2.Credential;

@WebServlet(urlPatterns = "/instructor/uploadMaterial")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 200, // 200MB
        maxRequestSize = 1024 * 1024 * 500) // 500MB
public class UploadMaterialServlet extends HttpServlet {

    private static final String PERSISTENCE_UNIT = "Adaptive_ElearningPU";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        // Check session and role
        Users user = (Users) req.getSession().getAttribute("account");
        if (user == null || user.getRole() == null || !"Instructor".equalsIgnoreCase(user.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Only instructors can upload materials.");
            return;
        }

        Part filePart = req.getPart("file");
        if (filePart == null || filePart.getSize() == 0) {
            req.setAttribute("alertMessage", "Please choose a file to upload.");
            req.getRequestDispatcher("/instructor/upload-form.jsp").forward(req, resp);
            return;
        }

        String submittedFileName = filePart.getSubmittedFileName();
        String contentType = filePart.getContentType();

        // Optional: courseId parameter
        String courseIdParam = req.getParameter("courseId");
        Long courseId = null;
        try {
            if (courseIdParam != null && !courseIdParam.isBlank()) {
                courseId = Long.parseLong(courseIdParam);
            }
        } catch (NumberFormatException ex) {
            // ignore - leave courseId null
        }

        // Upload to Google Drive using existing helper classes
        String driveFileId = null;
        String driveLink = null;
        try (InputStream is = filePart.getInputStream()) {
            Credential credential = CredentialManager.getAdminCredential();
            driveFileId = DriveService.uploadFile(is, contentType, credential);
            // make public
            DriveService.setFilePublic(driveFileId, credential);
            driveLink = DriveService.getEmbedUrl(driveFileId);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to upload to Google Drive: " + e.getMessage());
            return;
        }

        // Persist LectureMaterial via JPA
        EntityManagerFactory emf = null;
        EntityManager em = null;
        try {
            emf = Persistence.createEntityManagerFactory(PERSISTENCE_UNIT);
            em = emf.createEntityManager();

            LectureMaterial material = new LectureMaterial();
            material.setFileName(submittedFileName);
            material.setFileType(contentType);
            material.setDriveLink(driveLink);

            // instructorId is stored as String in Users.instructorId; try to convert if possible
            try {
                String instr = user.getInstructorId();
                if (instr != null && !instr.isBlank()) {
                    material.setInstructorId(Long.parseLong(instr));
                }
            } catch (NumberFormatException ex) {
                // leave instructorId null
            }

            material.setCourseId(courseId);

            em.getTransaction().begin();
            em.persist(material);
            em.getTransaction().commit();

        } catch (Exception ex) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            ex.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to save LectureMaterial: " + ex.getMessage());
            return;
        } finally {
            if (em != null) {
                em.close();
            }
            if (emf != null) {
                emf.close();
            }
        }

        // Success - redirect to a page (could be course page)
        req.setAttribute("alertMessage", "Upload successful.");
        req.setAttribute("alertStatus", true);
        req.getRequestDispatcher("/instructor/upload-form.jsp").forward(req, resp);
    }

}
