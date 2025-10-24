package servlet;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;
import services.CartService;
import model.CartItem;

/**
 * Servlet để xử lý trang giỏ hàng
 */
@WebServlet(name = "CartPageServlet", urlPatterns = {"/cart-page"})
public class CartPageServlet extends HttpServlet {
    
    private CartService cartService;
    
    @Override
    public void init() throws ServletException {
        cartService = new CartService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("account");
        
        // Kiểm tra đăng nhập
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // Add sample data for testing if cart is empty
            cartService.addSampleData(session);
            
            // Lấy giỏ hàng của user
            List<CartItem> cartItems = cartService.getCartItems(session);
            
            // Tính tổng tiền
            double totalAmount = cartService.getTotalAmount(cartItems);
            double totalDiscount = cartService.getTotalDiscount(cartItems);
            double finalAmount = totalAmount - totalDiscount;
            
            // Set attributes cho JSP
            request.setAttribute("cartItems", cartItems);
            request.setAttribute("totalAmount", totalAmount);
            request.setAttribute("totalDiscount", totalDiscount);
            request.setAttribute("finalAmount", finalAmount);
            request.setAttribute("itemCount", cartItems.size());
            
            // Kiểm tra giỏ hàng trống
            if (cartItems.isEmpty()) {
                request.setAttribute("emptyCart", true);
            }
            
        // Forward to cart page
        request.getRequestDispatcher("/WEB-INF/views/Pages/cart_new.jsp").forward(request, response);        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tải giỏ hàng: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/Pages/cart.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("account");
        
        // Kiểm tra đăng nhập
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            switch (action) {
                case "update":
                    handleUpdateQuantity(request, session);
                    break;
                case "remove":
                    handleRemoveItem(request, session);
                    break;
                case "clear":
                    handleClearCart(session);
                    break;
                default:
                    break;
            }
            
            // Redirect về trang cart để refresh
            response.sendRedirect(request.getContextPath() + "/cart-page");
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            doGet(request, response);
        }
    }
    
    /**
     * Xử lý cập nhật số lượng sản phẩm
     */
    private void handleUpdateQuantity(HttpServletRequest request, HttpSession session) {
        String courseId = request.getParameter("courseId");
        String quantityStr = request.getParameter("quantity");
        
        if (courseId != null && quantityStr != null) {
            try {
                int quantity = Integer.parseInt(quantityStr);
                if (quantity > 0) {
                    cartService.updateCartItem(session, courseId, quantity);
                } else {
                    cartService.removeFromCart(session, courseId);
                }
            } catch (NumberFormatException e) {
                // Ignore invalid quantity
            }
        }
    }
    
    /**
     * Xử lý xóa sản phẩm khỏi giỏ hàng
     */
    private void handleRemoveItem(HttpServletRequest request, HttpSession session) {
        String courseId = request.getParameter("courseId");
        if (courseId != null) {
            cartService.removeFromCart(session, courseId);
        }
    }
    
    /**
     * Xử lý xóa toàn bộ giỏ hàng
     */
    private void handleClearCart(HttpSession session) {
        cartService.clearCart(session);
    }
    
    @Override
    public String getServletInfo() {
        return "Cart Page Servlet - Handles cart page display and operations";
    }
}