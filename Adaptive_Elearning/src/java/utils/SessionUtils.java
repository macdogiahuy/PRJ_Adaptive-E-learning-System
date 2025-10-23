package utils;

import jakarta.servlet.http.HttpSession;
import model.Users;

/**
 * Utility class for session management and user information
 */
public class SessionUtils {
    
    /**
     * Get current logged in user from session
     * @param session HttpSession object
     * @return Users object or null if not logged in
     */
    public static Users getCurrentUser(HttpSession session) {
        if (session == null) {
            return null;
        }
        return (Users) session.getAttribute("user");
    }
    
    /**
     * Get current user's username
     * @param session HttpSession object
     * @return username or "Guest" if not logged in
     */
    public static String getCurrentUsername(HttpSession session) {
        Users user = getCurrentUser(session);
        return user != null ? user.getUserName() : "Guest";
    }
    
    /**
     * Get current user's full name
     * @param session HttpSession object
     * @return full name or "Guest" if not logged in
     */
    public static String getCurrentUserFullName(HttpSession session) {
        Users user = getCurrentUser(session);
        return user != null ? user.getFullName() : "Guest";
    }
    
    /**
     * Get current user's role
     * @param session HttpSession object
     * @return role as string or "Guest" if not logged in
     */
    public static String getCurrentUserRole(HttpSession session) {
        if (session == null) {
            return "Guest";
        }
        String role = (String) session.getAttribute("userRole");
        return role != null ? role : "Guest";
    }
    
    /**
     * Check if current user is admin
     * @param session HttpSession object
     * @return true if user is admin, false otherwise
     */
    public static boolean isAdmin(HttpSession session) {
        return "Admin".equals(getCurrentUserRole(session));
    }
    
    /**
     * Check if current user is instructor
     * @param session HttpSession object
     * @return true if user is instructor, false otherwise
     */
    public static boolean isInstructor(HttpSession session) {
        return "Instructor".equals(getCurrentUserRole(session));
    }
    
    /**
     * Check if current user is student
     * @param session HttpSession object
     * @return true if user is student, false otherwise
     */
    public static boolean isStudent(HttpSession session) {
        return "Student".equals(getCurrentUserRole(session));
    }
    
    /**
     * Check if user is logged in
     * @param session HttpSession object
     * @return true if user is logged in, false otherwise
     */
    public static boolean isLoggedIn(HttpSession session) {
        return getCurrentUser(session) != null;
    }
    
    /**
     * Get user display name (username with full name)
     * @param session HttpSession object
     * @return formatted display name
     */
    public static String getUserDisplayName(HttpSession session) {
        Users user = getCurrentUser(session);
        if (user != null) {
            return user.getFullName() + " (@" + user.getUserName() + ")";
        }
        return "Guest";
    }
}