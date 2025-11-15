package servlet;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.persistence.*;
import model.*;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * API Servlet để lấy danh sách LectureMaterial cho một Lecture
 * Response: JSON array của materials
 */
@WebServlet(name = "GetLectureMaterialsServlet", urlPatterns = {"/api/get-lecture-materials"})
public class GetLectureMaterialsServlet extends HttpServlet {
    
    private static final Logger logger = Logger.getLogger(GetLectureMaterialsServlet.class.getName());
    private EntityManagerFactory emf;
    private Gson gson = new Gson();
    
    @Override
    public void init() throws ServletException {
        try {
            // Reuse the central EclipseLink configuration so we honor the dev SQL Server settings
            emf = utils.EclipseLinkConfig.getEntityManagerFactory();
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error initializing GetLectureMaterialsServlet", e);
            throw new ServletException("Failed to initialize servlet", e);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Access-Control-Allow-Origin", "*");
        PrintWriter out = response.getWriter();
        
        try {
            // Lấy thông tin user từ session
            HttpSession session = request.getSession();
            Users currentUser = (Users) session.getAttribute("account");
            
            if (currentUser == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.print("{\"error\": \"Unauthorized\"}");
                return;
            }
            
            // Lấy lectureId từ query parameter
            String lectureId = request.getParameter("lectureId");
            if (lectureId == null || lectureId.isBlank()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\": \"Lecture ID is required\"}");
                return;
            }
            
            // Lấy LectureMaterial từ Database
            List<LectureMaterialDTO> materials = getLectureMaterials(lectureId);
            
            // Return JSON
            out.print(gson.toJson(materials));
            
            logger.info("Retrieved " + materials.size() + " materials for lecture: " + lectureId);
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in doGet", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
    
    /**
     * Lấy danh sách LectureMaterial của một Lecture
     */
    private List<LectureMaterialDTO> getLectureMaterials(String lectureId) {
        EntityManager em = null;
        List<LectureMaterialDTO> dtos = new ArrayList<>();
        
        try {
            em = emf.createEntityManager();
            String jpql = "SELECT m FROM LectureMaterial m WHERE m.lectureId = :lectureId ORDER BY m.id ASC";
            Query query = em.createQuery(jpql);
            query.setParameter("lectureId", lectureId);
            
            @SuppressWarnings("unchecked")
            List<LectureMaterial> materials = query.getResultList();
            
            for (LectureMaterial material : materials) {
                LectureMaterialDTO dto = new LectureMaterialDTO();
                dto.setId(material.getId().intValue());
                dto.setType(material.getFileType()); // fileType column
                dto.setUrl(material.getDriveLink());  // driveLink column
                dto.setFileName(material.getFileName());
                dtos.add(dto);
            }
            
        } catch (Exception e) {
            logger.log(Level.WARNING, "Error getting lecture materials", e);
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
        
        return dtos;
    }
    
    @Override
    public void destroy() {
        // EntityManagerFactory is managed globally via EclipseLinkConfig; nothing to close here.
    }
    
    /**
     * DTO class để trả về JSON
     */
    public static class LectureMaterialDTO {
        private int id;
        private String type;
        private String url;
        private String fileName;
        
        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        
        public String getType() { return type; }
        public void setType(String type) { this.type = type; }
        
        public String getUrl() { return url; }
        public void setUrl(String url) { this.url = url; }
        
        public String getFileName() { return fileName; }
        public void setFileName(String fileName) { this.fileName = fileName; }
    }
}
