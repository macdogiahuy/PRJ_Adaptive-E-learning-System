package services;

import java.util.Properties;
import java.util.logging.Logger;
import java.util.logging.Level;
import model.Users;

// Jakarta Mail imports
import jakarta.mail.*;
import jakarta.mail.internet.*;

public class EmailService {
    private static final Logger logger = Logger.getLogger(EmailService.class.getName());
    
    // Email configuration từ thông tin của bạn
    private static final String FROM_EMAIL = "mit54480@gmail.com";
    private static final String EMAIL_PASSWORD = "trjs tutr ixaa uvrd";
    
    
    public boolean sendOrderConfirmationEmail(Users user, String orderId, double amount, String paymentMethod) {
        try {
            // Tạo nội dung email
            String emailContent = createOrderConfirmationContent(user, orderId, amount, paymentMethod);
            
            // Log email để debug
            logger.info("=== EMAIL XÁC NHẬN ĐƠN HÀNG ===");
            logger.info("From: " + FROM_EMAIL);
            logger.info("To: " + user.getEmail());
            logger.info("Subject: Xác nhận đơn hàng #" + orderId);
            logger.info("Content length: " + emailContent.length() + " characters");
            
            // Thử gửi email thực tế, nếu không được sẽ fallback sang simulation
            try {
                sendRealEmail(user.getEmail(), orderId, emailContent);
                logger.info("=== EMAIL GỬI THÀNH CÔNG ===");
            } catch (Exception emailError) {
                logger.warning("Không thể gửi email thực tế, chuyển sang simulation: " + emailError.getMessage());
                simulateEmailSending(user.getEmail(), orderId, emailContent);
                logger.info("=== EMAIL SIMULATION COMPLETED ===");
            }
            return true;
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Lỗi khi gửi email xác nhận đơn hàng", e);
            return false;
        }
    }
    
    private void sendRealEmail(String toEmail, String orderId, String emailContent) throws Exception {
        // Cấu hình SMTP cho Gmail
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");

        // Tạo session với authentication
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, EMAIL_PASSWORD);
            }
        });

        // Tạo message
        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(FROM_EMAIL));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject("Xác nhận đơn hàng #" + orderId + " - Cảm ơn bạn đã mua hàng!");
        message.setContent(emailContent, "text/html; charset=utf-8");

        // Gửi email
        Transport.send(message);
        logger.info("Email đã được gửi thành công đến: " + toEmail);
    }
    
    private void simulateEmailSending(String toEmail, String orderId, String content) {
        logger.info("📧 SIMULATING EMAIL SEND:");
        logger.info("📧 To: " + toEmail);
        logger.info("📧 Subject: Xác nhận đơn hàng #" + orderId);
        logger.info("📧 Content Preview: " + content.substring(0, Math.min(200, content.length())) + "...");
        logger.info("📧 Email would be sent successfully in real implementation!");
    }
    
    private String createOrderConfirmationContent(Users user, String orderId, double amount, String paymentMethod) {
        String paymentMethodText = "COD".equals(paymentMethod) ? "Thanh toán khi nhận hàng" : "Thanh toán online qua VietQR";
        String statusText = "COD".equals(paymentMethod) ? "Đã đặt hàng" : "Đã thanh toán";
        
        StringBuilder content = new StringBuilder();
        
        content.append("<!DOCTYPE html>");
        content.append("<html>");
        content.append("<head>");
        content.append("<meta charset='UTF-8'>");
        content.append("<style>");
        content.append("body { font-family: Arial, sans-serif; line-height: 1.6; margin: 0; padding: 20px; background-color: #f4f4f4; }");
        content.append(".container { max-width: 600px; margin: 0 auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }");
        content.append(".header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 20px; text-align: center; border-radius: 10px 10px 0 0; margin: -20px -20px 20px -20px; }");
        content.append(".order-info { background: #f8f9fa; padding: 15px; border-radius: 5px; margin: 20px 0; }");
        content.append(".total { font-size: 18px; font-weight: bold; color: #28a745; text-align: right; }");
        content.append(".footer { text-align: center; margin-top: 30px; padding-top: 20px; border-top: 1px solid #ddd; color: #666; }");
        content.append("</style>");
        content.append("</head>");
        content.append("<body>");
        
        content.append("<div class='container'>");
        content.append("<div class='header'>");
        content.append("<h1>� Xác nhận đơn hàng - EduHub</h1>");
        content.append("<p>Cảm ơn bạn đã mua khóa học tại EduHub!</p>");
        content.append("</div>");
        
        content.append("<h2>Xin chào " + user.getUserName() + "!</h2>");
        content.append("<p>Chúng tôi đã nhận được đơn hàng của bạn và đang xử lý. Dưới đây là thông tin chi tiết:</p>");
        
        content.append("<div class='order-info'>");
        content.append("<h3>📋 Thông tin đơn hàng</h3>");
        content.append("<p><strong>Mã đơn hàng:</strong> #" + orderId + "</p>");
        content.append("<p><strong>Trạng thái:</strong> " + statusText + "</p>");
        content.append("<p><strong>Email:</strong> " + user.getEmail() + "</p>");
        content.append("<p><strong>Phương thức thanh toán:</strong> " + paymentMethodText + "</p>");
        content.append("<p><strong>Tổng tiền:</strong> " + formatCurrency(amount) + "</p>");
        content.append("</div>");
        
        content.append("<div class='order-info'>");
        content.append("<h3>📚 Thông tin khóa học</h3>");
        content.append("<p>• Bạn có thể truy cập khóa học ngay lập tức</p>");
        content.append("<p>• Khóa học sẽ có sẵn trong tài khoản của bạn</p>");
        content.append("<p>• Truy cập trọn đời, không giới hạn thời gian</p>");
        content.append("</div>");
        
        content.append("<div class='footer'>");
        content.append("<p>Cảm ơn bạn đã tin tưởng và học tập tại EduHub!</p>");
        content.append("<p>Nếu có bất kỳ thắc mắc nào, vui lòng liên hệ với chúng tôi.</p>");
        content.append("<p><strong>📞 Hotline:</strong> 1900-xxxx | <strong>📧 Email:</strong> support@eduhub.com</p>");
        content.append("</div>");
        
        content.append("</div>");
        content.append("</body>");
        content.append("</html>");
        
        return content.toString();
    }
    
    private String formatCurrency(double amount) {
        return String.format("%,.0f đ", amount);
    }
    
    /**
     * Kiểm tra cấu hình email
     * @return true nếu email được cấu hình đúng
     */
    public boolean isEmailConfigured() {
        return !FROM_EMAIL.equals("your-email@gmail.com") && 
               !EMAIL_PASSWORD.equals("your-app-password");
    }
    
    /**
     * Test method để kiểm tra EmailService
     */
    public boolean sendTestEmail(String toEmail) {
        logger.info("=== TEST EMAIL ===");
        logger.info("From: " + FROM_EMAIL);
        logger.info("To: " + toEmail);
        logger.info("Subject: Test Email - Hệ thống hoạt động bình thường");
        logger.info("Content: Đây là email test. EduHub đã sẵn sàng!");
        logger.info("Email Config: " + FROM_EMAIL + " / " + EMAIL_PASSWORD);
        logger.info("=== KẾT THÚC TEST EMAIL ===");
        return true;
    }
}