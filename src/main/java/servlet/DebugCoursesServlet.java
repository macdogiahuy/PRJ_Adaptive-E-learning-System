package servlet;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * Debug servlet để kiểm tra tại sao course dropdown không hiển thị
 */
@WebServlet(name = "DebugCoursesServlet", urlPatterns = {"/debug/courses"})
public class DebugCoursesServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html><head><title>Debug Courses</title></head><body>");
        out.println("<h2>🔍 Debug Course Dropdown</h2>");
        
        try {
            // Get current user
            HttpSession session = request.getSession();
            Users currentUser = (Users) session.getAttribute("account");
            
            out.println("<h3>👤 Current User:</h3>");
            if (currentUser != null) {
                out.println("<p><strong>ID:</strong> " + currentUser.getId() + "</p>");
                out.println("<p><strong>UserName:</strong> " + currentUser.getUserName() + "</p>");
                out.println("<p><strong>FullName:</strong> " + currentUser.getFullName() + "</p>");
                out.println("<p><strong>Role:</strong> " + currentUser.getRole() + "</p>");
                out.println("<p><strong>InstructorId:</strong> " + currentUser.getInstructorId() + "</p>");
                
                if (currentUser.getInstructorId() == null) {
                    out.println("<p style='color: red;'>❌ <strong>InstructorId is NULL</strong> - User is NOT an instructor!</p>");
                } else {
                    out.println("<p style='color: green;'>✅ <strong>InstructorId found</strong> - User IS an instructor</p>");
                }
            } else {
                out.println("<p style='color: red;'>❌ No user in session!</p>");
            }
            
            out.println("<h3>📚 Courses Query Test:</h3>");
            
            if (currentUser != null && currentUser.getId() != null) {
                try {
                    // Test getCoursesByInstructor
                    List<com.coursehub.tools.DBSectionInserter.CourseItem> courses = 
                        com.coursehub.tools.DBSectionInserter.getCoursesByInstructor(currentUser.getId());
                    
                    out.println("<h4>getCoursesByInstructor(userId) results:</h4>");
                    out.println("<p><strong>Query:</strong> <code>SELECT Id, Title FROM dbo.Courses WHERE InstructorId = '" + currentUser.getId() + "'</code></p>");
                    out.println("<p><strong>Results count:</strong> " + courses.size() + "</p>");
                    
                    if (courses.isEmpty()) {
                        out.println("<p style='color: orange;'>⚠️ No courses found with this query!</p>");
                    } else {
                        out.println("<ul>");
                        for (com.coursehub.tools.DBSectionInserter.CourseItem course : courses) {
                            out.println("<li>" + course.id + " - " + course.title + "</li>");
                        }
                        out.println("</ul>");
                    }
                    
                } catch (Exception e) {
                    out.println("<p style='color: red;'>❌ Error calling getCoursesByInstructor: " + e.getMessage() + "</p>");
                    e.printStackTrace();
                }
                
                // Test alternative query with InstructorId
                if (currentUser.getInstructorId() != null) {
                    try {
                        List<com.coursehub.tools.DBSectionInserter.CourseItem> coursesAlt = 
                            com.coursehub.tools.DBSectionInserter.getCoursesByInstructor(currentUser.getInstructorId());
                        
                        out.println("<h4>getCoursesByInstructor(instructorId) results:</h4>");
                        out.println("<p><strong>Query:</strong> <code>SELECT Id, Title FROM dbo.Courses WHERE InstructorId = '" + currentUser.getInstructorId() + "'</code></p>");
                        out.println("<p><strong>Results count:</strong> " + coursesAlt.size() + "</p>");
                        
                        if (!coursesAlt.isEmpty()) {
                            out.println("<ul>");
                            for (com.coursehub.tools.DBSectionInserter.CourseItem course : coursesAlt) {
                                out.println("<li>" + course.id + " - " + course.title + "</li>");
                            }
                            out.println("</ul>");
                        }
                        
                    } catch (Exception e) {
                        out.println("<p style='color: red;'>❌ Error with InstructorId query: " + e.getMessage() + "</p>");
                    }
                }
                
                // Test getCourses (all courses)
                try {
                    List<com.coursehub.tools.DBSectionInserter.CourseItem> allCourses = 
                        com.coursehub.tools.DBSectionInserter.getCourses();
                    
                    out.println("<h4>getCourses() (all courses) results:</h4>");
                    out.println("<p><strong>Results count:</strong> " + allCourses.size() + "</p>");
                    
                    if (!allCourses.isEmpty()) {
                        out.println("<ul>");
                        for (com.coursehub.tools.DBSectionInserter.CourseItem course : allCourses) {
                            out.println("<li>" + course.id + " - " + course.title + "</li>");
                        }
                        out.println("</ul>");
                    }
                    
                } catch (Exception e) {
                    out.println("<p style='color: red;'>❌ Error calling getCourses: " + e.getMessage() + "</p>");
                }
            }
            
            out.println("<h3>💡 Recommendations:</h3>");
            out.println("<ul>");
            out.println("<li>Run <code>debug-course-dropdown.sql</code> in SSMS to check database</li>");
            out.println("<li>If InstructorId is NULL, user needs to be assigned an instructor role</li>");
            out.println("<li>Check if course filtering logic should use <code>CreatorId</code> instead of <code>InstructorId</code></li>");
            out.println("</ul>");
            
        } catch (Exception e) {
            out.println("<p style='color: red;'>❌ Servlet Error: " + e.getMessage() + "</p>");
            e.printStackTrace(out);
        }
        
        out.println("</body></html>");
    }
}