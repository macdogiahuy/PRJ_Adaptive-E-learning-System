package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet for handling Contact page requests and form submissions
 */
@WebServlet("/contact")
public class ContactServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Set page title and meta information
        request.setAttribute("pageTitle", "Liên hệ - EduHub");
        request.setAttribute("pageDescription", "Liên hệ với EduHub để được hỗ trợ và giải đáp thắc mắc");
        
        // Forward to contact page
        request.getRequestDispatcher("/WEB-INF/views/Pages/contact.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Set UTF-8 encoding for Vietnamese text
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        try {
            // Get form data
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String subject = request.getParameter("subject");
            String message = request.getParameter("message");
            
            // Validate required fields
            if (name == null || name.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                subject == null || subject.trim().isEmpty() ||
                message == null || message.trim().isEmpty()) {
                
                request.setAttribute("message", "Vui lòng điền đầy đủ các trường bắt buộc!");
                request.setAttribute("messageType", "error");
                request.getRequestDispatcher("/WEB-INF/views/Pages/contact.jsp").forward(request, response);
                return;
            }
            
            // Validate email format
            if (!isValidEmail(email)) {
                request.setAttribute("message", "Định dạng email không hợp lệ!");
                request.setAttribute("messageType", "error");
                request.getRequestDispatcher("/WEB-INF/views/Pages/contact.jsp").forward(request, response);
                return;
            }
            
            // TODO: Here you would typically:
            // 1. Save to database
            // 2. Send email notification
            // 3. Log the contact request
            
            // For now, we'll just simulate successful submission
            boolean success = processContactForm(name, email, phone, subject, message);
            
            if (success) {
                request.setAttribute("message", 
                    "Cảm ơn bạn đã liên hệ! Chúng tôi sẽ phản hồi trong vòng 24 giờ.");
                request.setAttribute("messageType", "success");
            } else {
                request.setAttribute("message", 
                    "Đã xảy ra lỗi khi gửi tin nhắn. Vui lòng thử lại sau!");
                request.setAttribute("messageType", "error");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", 
                "Đã xảy ra lỗi hệ thống. Vui lòng thử lại sau!");
            request.setAttribute("messageType", "error");
        }
        
        // Forward back to contact page with message
        request.getRequestDispatcher("/WEB-INF/views/Pages/contact.jsp").forward(request, response);
    }
    
    /**
     * Validate email format
     */
    private boolean isValidEmail(String email) {
        String emailRegex = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@" +
                           "(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
        return email != null && email.matches(emailRegex);
    }
    
    /**
     * Process contact form (placeholder for actual implementation)
     */
    private boolean processContactForm(String name, String email, String phone, 
                                     String subject, String message) {
        try {
            // TODO: Implement actual contact form processing
            // Examples:
            // 1. Save to database
            // 2. Send email to admin
            // 3. Send confirmation email to user
            // 4. Log the contact request
            
            // For demonstration, we'll just log the contact
            System.out.println("=== NEW CONTACT FORM SUBMISSION ===");
            System.out.println("Name: " + name);
            System.out.println("Email: " + email);
            System.out.println("Phone: " + (phone != null ? phone : "Not provided"));
            System.out.println("Subject: " + subject);
            System.out.println("Message: " + message);
            System.out.println("Timestamp: " + new java.util.Date());
            System.out.println("===================================");
            
            // Simulate processing time
            Thread.sleep(100);
            
            return true;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}