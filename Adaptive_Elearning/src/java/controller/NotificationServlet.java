package controller;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import model.Notifications;
import model.Users;
import controller.NotificationsJpaController;

@WebServlet(name = "NotificationCourseServlet", urlPatterns = {"/notification"})
public class NotificationServlet extends HttpServlet {

    private NotificationsJpaController notificationsController;
    private SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy hh:mm:ss a");

    @Override
    public void init() throws ServletException {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("WebApplication3PU");
        notificationsController = new NotificationsJpaController(emf);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get search parameter
            String searchTerm = request.getParameter("search");
            String sortBy = request.getParameter("sortBy");
            String sortOrder = request.getParameter("sortOrder");

            // Get all notifications from database
            List<Notifications> allNotifications = notificationsController.findNotificationsEntities();

            // Convert to map format for JSP
            List<Map<String, Object>> reportedGroups = new ArrayList<>();

            for (Notifications notification : allNotifications) {
                Map<String, Object> group = new HashMap<>();
                group.put("id", notification.getId());
                group.put("type", notification.getType());
                group.put("creatorId", notification.getCreatorId().getId());
                group.put("creatorName", notification.getCreatorId().getFullName());
                group.put("creationTime", dateFormat.format(notification.getCreationTime()));
                group.put("status", notification.getStatus());
                group.put("message", notification.getMessage());
                reportedGroups.add(group);
            }

            // Filter data based on search term
            List<Map<String, Object>> filteredGroups = new ArrayList<>(reportedGroups);

            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                String searchLower = searchTerm.toLowerCase();
                filteredGroups.removeIf(group ->
                    !group.get("type").toString().toLowerCase().contains(searchLower) &&
                    !group.get("creatorId").toString().toLowerCase().contains(searchLower) &&
                    !group.get("status").toString().toLowerCase().contains(searchLower) &&
                    !group.get("creatorName").toString().toLowerCase().contains(searchLower)
                );
            }

            // Sort data if requested
            if (sortBy != null && !sortBy.isEmpty()) {
                filteredGroups.sort((a, b) -> {
                    Object valueA = a.get(sortBy);
                    Object valueB = b.get(sortBy);

                    int comparison = 0;
                    if (valueA instanceof String && valueB instanceof String) {
                        comparison = ((String) valueA).compareToIgnoreCase((String) valueB);
                    } else if (valueA instanceof Comparable && valueB instanceof Comparable) {
                        comparison = ((Comparable) valueA).compareTo(valueB);
                    }

                    return "desc".equalsIgnoreCase(sortOrder) ? -comparison : comparison;
                });
            }

            // Pagination parameters
            int itemsPerPage = 20; // Show 20 items per page to display all notifications
            int currentPage = 1;

            // Get page parameter from request
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                } catch (NumberFormatException e) {
                    currentPage = 1; // Default to page 1 if invalid
                }
            }

            // Calculate pagination values
            int totalItems = filteredGroups.size();
            int totalPages = (int) Math.ceil((double) totalItems / itemsPerPage);
            int startIndex = (currentPage - 1) * itemsPerPage;
            int endIndex = Math.min(startIndex + itemsPerPage, totalItems);

            // Ensure current page is within valid range
            if (currentPage < 1) {
                currentPage = 1;
                startIndex = 0;
                endIndex = Math.min(itemsPerPage, totalItems);
            } else if (currentPage > totalPages && totalPages > 0) {
                currentPage = totalPages;
                startIndex = (currentPage - 1) * itemsPerPage;
                endIndex = totalItems;
            }

            // Get paginated list
            List<Map<String, Object>> paginatedGroups = new ArrayList<>();
            if (startIndex < totalItems) {
                for (int i = startIndex; i < endIndex; i++) {
                    paginatedGroups.add(filteredGroups.get(i));
                }
            }

            // Set attributes for JSP
            request.setAttribute("reportedGroups", paginatedGroups);
            request.setAttribute("totalCount", totalItems);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("itemsPerPage", itemsPerPage);
            request.setAttribute("searchTerm", searchTerm != null ? searchTerm : "");

            // Forward to JSP page
            request.getRequestDispatcher("/WEB-INF/views/admin/notification.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading reported groups: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/notification.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String groupId = request.getParameter("groupId");

        if (action != null && groupId != null) {
            switch (action) {
                case "approve":
                    // Handle approve action
                    handleApproveRequest(groupId, request);
                    break;
                case "dismiss":
                    // Handle dismiss action
                    handleDismissRequest(groupId, request);
                    break;
                case "view":
                    // Handle view action
                    handleViewRequest(groupId, request);
                    break;
            }
        }

        // Redirect back to the page
        response.sendRedirect(request.getContextPath() + "/notification");
    }

    private void handleApproveRequest(String groupId, HttpServletRequest request) {
        // In a real application, you would update the database here
        // For now, we'll just log the action
        System.out.println("Approving request with ID: " + groupId);

        // Set success message
        request.getSession().setAttribute("successMessage", "Request approved successfully!");
    }

    private void handleDismissRequest(String groupId, HttpServletRequest request) {
        // In a real application, you would update the database here
        // For now, we'll just log the action
        System.out.println("Dismissing request with ID: " + groupId);

        // Set success message
        request.getSession().setAttribute("successMessage", "Request dismissed successfully!");
    }

    private void handleViewRequest(String groupId, HttpServletRequest request) {
        // In a real application, you would fetch detailed information
        // For now, we'll just log the action
        System.out.println("Viewing details for request ID: " + groupId);

        // Set info message
        request.getSession().setAttribute("infoMessage", "Viewing details for request: " + groupId);
    }
}
