package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;
import model.CartItem;
import services.VietQRService;
import services.EmailService;
import services.CartCheckoutService;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.util.UUID;

@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout"})
public class CheckoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String method = request.getParameter("method");
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("account");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Lấy thông tin giỏ hàng và totalAmount từ session
        Double totalAmountObj = (Double) session.getAttribute("totalAmount");
        @SuppressWarnings("unchecked")
        List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cartItems");
        
        if (totalAmountObj == null || cartItems == null || cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart?error=empty");
            return;
        }
        
        double totalAmount = totalAmountObj;
        String orderId = UUID.randomUUID().toString();
        
        if ("online".equals(method)) {
            // Thanh toán online - hiển thị VietQR
            VietQRService vietQR = new VietQRService();
            String qrUrl = vietQR.generateQRUrl(totalAmount, orderId, "Thanh toán khóa học");
            request.setAttribute("qrUrl", qrUrl);
            request.setAttribute("orderId", orderId);
            request.setAttribute("totalAmount", totalAmount);
            request.getRequestDispatcher("/online_payment.jsp").forward(request, response);
            return;
        }
        
        // COD: Xử lý checkout sử dụng stored procedure
        processCheckoutWithStoredProcedure(user, cartItems, totalAmount, "COD", session.getId(), request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Xử lý callback sau khi thanh toán online thành công
        String orderId = request.getParameter("orderId");
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("account");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Lấy thông tin từ session
        Double totalAmountObj = (Double) session.getAttribute("totalAmount");
        @SuppressWarnings("unchecked")
        List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cartItems");
        
        if (totalAmountObj == null || cartItems == null || cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart?error=empty");
            return;
        }
        
        double totalAmount = totalAmountObj;
        
        // Online: Xử lý checkout sử dụng stored procedure
        processCheckoutWithStoredProcedure(user, cartItems, totalAmount, "Online", session.getId(), request, response);
    }
    
    /**
     * Xử lý checkout sử dụng stored procedure và trigger
     */
    private void processCheckoutWithStoredProcedure(Users user, List<CartItem> cartItems, double totalAmount, 
                                                  String paymentMethod, String sessionId, 
                                                  HttpServletRequest request, HttpServletResponse response) 
                                                  throws IOException {
        try {
            System.out.println("=== PROCESSING CHECKOUT WITH STORED PROCEDURE ===");
            System.out.println("User: " + user.getUserName());
            System.out.println("Payment Method: " + paymentMethod);
            System.out.println("Total Amount: " + totalAmount);
            System.out.println("Cart Items: " + cartItems.size());
            
            // Sử dụng CartCheckoutService để xử lý với stored procedure
            CartCheckoutService checkoutService = new CartCheckoutService();
            CartCheckoutService.CheckoutResult result = checkoutService.processCheckout(
                user, cartItems, totalAmount, paymentMethod, sessionId
            );
            
            if (result.isSuccess()) {
                System.out.println("=== CHECKOUT SUCCESSFUL ===");
                System.out.println("Bill ID: " + result.getBillId());
                System.out.println("Checkout ID: " + result.getCheckoutId());
                System.out.println("Message: " + result.getMessage());
                
                // Gửi email xác nhận
                try {
                    EmailService emailService = new EmailService();
                    emailService.sendOrderConfirmationEmail(user, result.getBillId(), totalAmount, paymentMethod);
                    System.out.println("Confirmation email sent successfully");
                } catch (Exception emailError) {
                    System.err.println("Email sending failed: " + emailError.getMessage());
                }
                
                // Lưu thông tin checkout thành công vào session
                HttpSession session = request.getSession();
                session.setAttribute("checkoutSuccess", true);
                session.setAttribute("checkoutBillId", result.getBillId());
                session.setAttribute("checkoutAmount", totalAmount);
                session.setAttribute("checkoutMethod", paymentMethod);
                session.setAttribute("checkoutMessage", result.getMessage());
                
                // XÓA TẤT CẢ CÁC LOẠI CART khỏi session sau khi checkout thành công
                session.removeAttribute("cartItems");  // List cart cho checkout
                session.removeAttribute("cart");       // Map cart cho badge
                session.removeAttribute("totalAmount");
                
                System.out.println("=== CART CLEARED FROM SESSION ===");
                
                // Chuyển hướng đến trang "Thanh toán thành công"
                response.sendRedirect(request.getContextPath() + "/checkout-success.jsp");
                
            } else {
                System.err.println("=== CHECKOUT FAILED ===");
                System.err.println("Error: " + result.getMessage());
                response.sendRedirect(request.getContextPath() + "/checkout.jsp?method=error&message=" + 
                                    java.net.URLEncoder.encode(result.getMessage(), "UTF-8"));
            }
            
        } catch (Exception e) {
            System.err.println("=== CHECKOUT EXCEPTION ===");
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/checkout.jsp?method=error&message=" + 
                                java.net.URLEncoder.encode("Lỗi xử lý checkout: " + e.getMessage(), "UTF-8"));
        }
    }
}
