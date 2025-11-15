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
import services.CartCheckoutService;
import services.EmailService;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * VNPay Return Servlet - Handle payment callback from VNPay
 * Author: AI Assistant
 * Date: November 1, 2025
 */
@WebServlet(name = "VNPayReturnServlet", urlPatterns = {"/vnpay-return"})
public class VNPayReturnServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== VNPAY RETURN CALLBACK ===");
        
        // Get all parameters from VNPay - URL encode với US_ASCII như VNPay sample
        Map<String, String> vnpParams = new HashMap<>();
        Map<String, String[]> requestParams = request.getParameterMap();
        
        for (String paramName : requestParams.keySet()) {
            String paramValue = request.getParameter(paramName);
            // URL encode với US_ASCII theo VNPay sample code
            String encodedName = URLEncoder.encode(paramName, StandardCharsets.US_ASCII.toString());
            String encodedValue = URLEncoder.encode(paramValue, StandardCharsets.US_ASCII.toString());
            vnpParams.put(encodedName, encodedValue);
            System.out.println(paramName + " = " + paramValue);
        }
        
        // Get important parameters
        String vnpResponseCode = request.getParameter("vnp_ResponseCode");
        String vnpTransactionNo = request.getParameter("vnp_TransactionNo");
        String vnpTxnRef = request.getParameter("vnp_TxnRef");
        String vnpAmount = request.getParameter("vnp_Amount");
        
        // Verify signature
        VNPayService vnpayService = new VNPayService();
        boolean isValidSignature = vnpayService.verifyReturnSignature(vnpParams);
        
        System.out.println("Response Code: " + vnpResponseCode);
        System.out.println("Transaction No: " + vnpTransactionNo);
        System.out.println("TxnRef: " + vnpTxnRef);
        System.out.println("Amount: " + vnpAmount);
        System.out.println("Valid Signature: " + isValidSignature);
        
        HttpSession session = request.getSession();
        
        if (!isValidSignature) {
            System.err.println("Invalid VNPay signature!");
            session.setAttribute("paymentError", "Chữ ký không hợp lệ. Giao dịch có thể bị giả mạo!");
            response.sendRedirect(request.getContextPath() + "/cart?error=invalid_signature");
            return;
        }
        
        // Check if payment is successful
        if ("00".equals(vnpResponseCode)) {
            // Payment successful - Process checkout
            System.out.println("=== PAYMENT SUCCESSFUL - PROCESSING CHECKOUT ===");
            
            Users user = (Users) session.getAttribute("account");
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            // Get cart info from session
            Double totalAmountObj = (Double) session.getAttribute("totalAmount");
            @SuppressWarnings("unchecked")
            List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cartItems");
            
            if (totalAmountObj == null || cartItems == null || cartItems.isEmpty()) {
                session.setAttribute("paymentError", "Giỏ hàng trống hoặc đã hết hạn!");
                response.sendRedirect(request.getContextPath() + "/cart?error=empty");
                return;
            }
            
            double totalAmount = totalAmountObj;
            
            // Process checkout with stored procedure
            try {
                CartCheckoutService checkoutService = new CartCheckoutService();
                CartCheckoutService.CheckoutResult result = checkoutService.processCheckout(
                    user, cartItems, totalAmount, "VNPay Online", vnpTxnRef
                );
                
                if (result.isSuccess()) {
                    System.out.println("=== CHECKOUT SUCCESSFUL ===");
                    System.out.println("Bill ID: " + result.getBillId());
                    System.out.println("VNPay Transaction: " + vnpTransactionNo);
                    
                    // Send confirmation email
                    try {
                        EmailService emailService = new EmailService();
                        emailService.sendOrderConfirmationEmail(user, result.getBillId(), totalAmount, "VNPay Online");
                        System.out.println("Confirmation email sent");
                    } catch (Exception e) {
                        System.err.println("Email error: " + e.getMessage());
                    }
                    
                    // Save to session
                    session.setAttribute("checkoutSuccess", true);
                    session.setAttribute("checkoutBillId", result.getBillId());
                    session.setAttribute("checkoutAmount", totalAmount);
                    session.setAttribute("checkoutMethod", "VNPay Online");
                    session.setAttribute("checkoutTransactionNo", vnpTransactionNo);
                    session.setAttribute("checkoutMessage", result.getMessage());
                    
                    // Clear cart
                    session.removeAttribute("cartItems");
                    session.removeAttribute("cart");
                    session.removeAttribute("totalAmount");
                    
                    System.out.println("=== CART CLEARED ===");
                    
                    // Redirect to success page
                    response.sendRedirect(request.getContextPath() + "/checkout-success.jsp");
                    
                } else {
                    System.err.println("Checkout failed: " + result.getMessage());
                    session.setAttribute("paymentError", "Lỗi xử lý đơn hàng: " + result.getMessage());
                    response.sendRedirect(request.getContextPath() + "/cart?error=checkout_failed");
                }
                
            } catch (Exception e) {
                System.err.println("Checkout exception: " + e.getMessage());
                e.printStackTrace();
                session.setAttribute("paymentError", "Lỗi hệ thống: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/cart?error=system_error");
            }
            
        } else {
            // Payment failed
            String statusMessage = vnpayService.getTransactionStatus(vnpResponseCode);
            System.err.println("Payment failed: " + statusMessage);
            
            session.setAttribute("paymentError", statusMessage);
            response.sendRedirect(request.getContextPath() + "/cart?error=payment_failed&code=" + vnpResponseCode);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
