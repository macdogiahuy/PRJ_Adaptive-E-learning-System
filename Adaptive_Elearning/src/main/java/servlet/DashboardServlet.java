package servlet;





import controller.DashboardController;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.Map;

@WebServlet(urlPatterns = {"/api/dashboard", "/admin/dashboard"})
public class DashboardServlet extends HttpServlet {
    
    private DashboardController dashboardController;

    @Override
    public void init() throws ServletException {
        super.init();
        dashboardController = new DashboardController();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String requestURI = request.getRequestURI();
        
        if (requestURI.endsWith("/admin/dashboard")) {
            // Forward to dashboard JSP page
            handleDashboardPage(request, response);
        } else if (requestURI.endsWith("/api/dashboard")) {
            // Return JSON API response
            handleDashboardAPI(request, response);
        }
    }
    
    private void handleDashboardPage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Get overview data
            Map<String, Object> overviewData = dashboardController.getOverviewData();
            request.setAttribute("overviewData", overviewData);
            
            // Get monthly enrollments data
            Map<String, Object> monthlyData = dashboardController.getMonthlyEnrollments();
            request.setAttribute("monthlyData", monthlyData);
            
            // Get top courses
            Map<String, Object> topCoursesData = dashboardController.getTopCourses();
            request.setAttribute("topCoursesData", topCoursesData);
            
            // Get recent activities
            Map<String, Object> activitiesData = dashboardController.getRecentActivities();
            request.setAttribute("activitiesData", activitiesData);
            
            // Forward to dashboard JSP
            request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp")
                   .forward(request, response);
                   
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Có lỗi xảy ra khi tải dữ liệu dashboard: " + e.getMessage());
        }
    }
    
    private void handleDashboardAPI(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        try {
            DashboardController controller = new DashboardController();
            
            if (!controller.testDatabaseConnection()) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"error\": \"Database connection failed\"}");
                return;
            }
            
            Map<String, Object> data = controller.getOverviewData();
            
            // Simple JSON response without Gson
            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"totalUsers\":").append(data.get("totalUsers")).append(",");
            json.append("\"totalCourses\":").append(data.get("totalCourses")).append(",");
            json.append("\"totalEnrollments\":").append(data.get("totalEnrollments")).append(",");
            json.append("\"totalNotifications\":").append(data.get("totalNotifications"));
            json.append("}");
            
            out.print(json.toString());
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"" + e.getMessage() + "\"}");
            e.printStackTrace();
        } finally {
            out.flush();
            out.close();
        }
    }
}
