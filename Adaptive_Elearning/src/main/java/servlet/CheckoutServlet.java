package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;
import model.CartItem;
import services.VNPayService;
import services.VietQRService;
import services.CartCheckoutService;
import services.EmailService;
import java.io.IOException;
import java.util.List;
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
        
        // Lấy thông tin giỏ hàng từ session
        Double totalAmountObj = (Double) session.getAttribute("totalAmount");
        @SuppressWarnings("unchecked")
        List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cartItems");
        
        if (totalAmountObj == null || cartItems == null || cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart?error=empty");
            return;
        }
        
        double totalAmount = totalAmountObj;
        
        // VietQR payment
        if ("vietqr".equals(method)) {
            String orderId = UUID.randomUUID().toString();
            VietQRService vietQR = new VietQRService();
            String qrUrl = vietQR.generateQRUrl(totalAmount, orderId, "Thanh toan khoa hoc");
            request.setAttribute("qrUrl", qrUrl);
            request.setAttribute("orderId", orderId);
            request.setAttribute("totalAmount", totalAmount);
            request.getRequestDispatcher("/online_payment.jsp").forward(request, response);
            return;
        }
        
        // VNPay payment
        if ("vnpay".equals(method)) {
            try {
                System.out.println("=== REDIRECTING TO VNPAY ===");
                System.out.println("User: " + user.getUserName());
                System.out.println("Amount: " + totalAmount);
                
                // Generate transaction reference
                String txnRef = utils.VNPayConfig.getRandomNumber(8);
                session.setAttribute("vnpTxnRef", txnRef);
                
                // Get client IP
                String ipAddress = getClientIP(request);
                System.out.println("IP Address: " + ipAddress);
                
                // Create payment URL
                VNPayService vnpayService = new VNPayService();
                String orderInfo = "Thanh toan khoa hoc - " + user.getUserName();
                String paymentUrl = vnpayService.createPaymentUrl(
                    (long) totalAmount, 
                    orderInfo, 
                    txnRef, 
                    ipAddress
                );
                
                System.out.println("Redirecting to: " + paymentUrl);
                
                // Redirect to VNPay
                response.sendRedirect(paymentUrl);
                return;
                
            } catch (Exception e) {
                System.err.println("Error creating VNPay URL: " + e.getMessage());
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/cart?error=vnpay_error");
                return;
            }
        }
        
        // Default: redirect to cart
        response.sendRedirect(request.getContextPath() + "/cart");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle VietQR callback
        String orderId = request.getParameter("orderId");
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("account");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        Double totalAmountObj = (Double) session.getAttribute("totalAmount");
        @SuppressWarnings("unchecked")
        List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cartItems");
        
        if (totalAmountObj == null || cartItems == null || cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart?error=empty");
            return;
        }
        
        double totalAmount = totalAmountObj;
        
        // Process checkout with stored procedure
        processCheckoutWithStoredProcedure(user, cartItems, totalAmount, "VietQR Banking", orderId, request, response);
    }
    
    /**
     * Get client IP address
     */
    private String getClientIP(HttpServletRequest request) {
        String ipAddress = request.getHeader("X-FORWARDED-FOR");
        if (ipAddress == null || ipAddress.isEmpty()) {
            ipAddress = request.getRemoteAddr();
        }
        // Convert IPv6 localhost to IPv4
        if ("0:0:0:0:0:0:0:1".equals(ipAddress)) {
            ipAddress = "127.0.0.1";
        }
        return ipAddress;
    }
    
    /**
     * Process checkout with stored procedure
     */
    private void processCheckoutWithStoredProcedure(Users user, List<CartItem> cartItems, double totalAmount, 
                                                  String paymentMethod, String sessionId, 
                                                  HttpServletRequest request, HttpServletResponse response) 
                                                  throws IOException {
        try {
            System.out.println("=== PROCESSING CHECKOUT ===");
            System.out.println("User: " + user.getUserName());
            System.out.println("Payment Method: " + paymentMethod);
            System.out.println("Total Amount: " + totalAmount);
            
            CartCheckoutService checkoutService = new CartCheckoutService();
            CartCheckoutService.CheckoutResult result = checkoutService.processCheckout(
                user, cartItems, totalAmount, paymentMethod, sessionId
            );
            
            if (result.isSuccess()) {
                System.out.println("=== CHECKOUT SUCCESSFUL ===");
                System.out.println("Bill ID: " + result.getBillId());
                
                // Send email
                try {
                    EmailService emailService = new EmailService();
                    emailService.sendOrderConfirmationEmail(user, result.getBillId(), totalAmount, paymentMethod);
                } catch (Exception e) {
                    System.err.println("Email error: " + e.getMessage());
                }
                
                // Save to session
                HttpSession session = request.getSession();
                session.setAttribute("checkoutSuccess", true);
                session.setAttribute("checkoutBillId", result.getBillId());
                session.setAttribute("checkoutAmount", totalAmount);
                session.setAttribute("checkoutMethod", paymentMethod);
                session.setAttribute("checkoutMessage", result.getMessage());
                
                // Clear cart
                session.removeAttribute("cartItems");
                session.removeAttribute("cart");
                session.removeAttribute("totalAmount");
                
                // Redirect to success page
                response.sendRedirect(request.getContextPath() + "/checkout-success.jsp");
                
            } else {
                System.err.println("Checkout failed: " + result.getMessage());
                response.sendRedirect(request.getContextPath() + "/cart?error=checkout_failed");
            }
            
        } catch (Exception e) {
            System.err.println("Checkout exception: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/cart?error=system_error");
        }
    }
}
