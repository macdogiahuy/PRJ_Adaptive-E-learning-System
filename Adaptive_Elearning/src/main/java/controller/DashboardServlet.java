package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.DashboardData;

public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Demo mode: Create a demo user if no user is logged in
        if (session.getAttribute("user") == null) {
            session.setAttribute("user", "demo_user");
            session.setAttribute("userRole", "admin");
        }

        // Get dashboard data
        DashboardData dashboardData = new DashboardData();
        dashboardData.setTotalUsers(1250);
        dashboardData.setTotalNotifications(45);
        dashboardData.setTotalCourses(28);
        dashboardData.setTotalLearningGroups(12);

        // Set data as request attributes
        request.setAttribute("totalUsers", dashboardData.getTotalUsers());
        request.setAttribute("totalNotifications", dashboardData.getTotalNotifications());
        request.setAttribute("totalCourses", dashboardData.getTotalCourses());
        request.setAttribute("totalLearningGroups", dashboardData.getTotalLearningGroups());

        // Forward to dashboard JSP
        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
