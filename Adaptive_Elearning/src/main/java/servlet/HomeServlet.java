package servlet;

import model.Courses;
import jakarta.persistence.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet for Home page - displays featured courses
 */
@WebServlet(name = "HomeServlet", urlPatterns = {"/home", "/"})
public class HomeServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(HomeServlet.class.getName());
    private EntityManagerFactory emf;
    
    @Override
    public void init() throws ServletException {
        super.init();
        this.emf = Persistence.createEntityManagerFactory("Adaptive_ElearningPU");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Kiểm tra parameter logout
            String logoutParam = request.getParameter("logout");
            if ("success".equals(logoutParam)) {
                request.setAttribute("showLogoutMessage", true);
                request.setAttribute("logoutMessage", "Đăng xuất thành công! Cảm ơn bạn đã sử dụng FlyUp.");
            }
            
            // Kiểm tra parameter login  
            String loginParam = request.getParameter("login");
            if ("success".equals(loginParam)) {
                request.setAttribute("showLoginMessage", true);
                request.setAttribute("loginMessage", "Đăng nhập thành công! Chào mừng bạn trở lại FlyUp.");
            }
            
            // Get featured courses (published courses with high ratings or recent)
            List<Courses> featuredCourses = getFeaturedCourses();
            
            // Set attributes for JSP
            request.setAttribute("featuredCourses", featuredCourses);
            
            // Forward to home page
            request.getRequestDispatcher("/home.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading home page", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Có lỗi xảy ra khi tải trang chủ");
        }
    }
    
    /**
     * Get featured courses for home page
     */
    private List<Courses> getFeaturedCourses() {
        EntityManager em = emf.createEntityManager();
        try {
            // Get approved courses (status = 'ongoing' AND approvalStatus = 'approved')
            Query query = em.createQuery(
                "SELECT c FROM Courses c " +
                "WHERE LOWER(c.status) = 'ongoing' AND LOWER(c.approvalStatus) = 'approved' " +
                "ORDER BY c.learnerCount DESC, c.totalRating DESC, c.creationTime DESC"
            );
            query.setMaxResults(8); // Limit to 8 featured courses
            
            @SuppressWarnings("unchecked")
            List<Courses> courses = query.getResultList();
            
            return courses;
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting featured courses", e);
            return List.of(); // Return empty list on error
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }
    
    @Override
    public void destroy() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
        super.destroy();
    }
}