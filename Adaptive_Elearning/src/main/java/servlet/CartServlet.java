package servlet;

import model.Cart;
import model.Users;
import services.CartService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Servlet for handling shopping cart operations
 * Supports both AJAX requests and regular form submissions
 */
@WebServlet(name = "CartServlet", urlPatterns = {
    "/cart", 
    "/add-to-cart", 
    "/remove-from-cart", 
    "/update-cart", 
    "/clear-cart",
    "/cart-count"
})
public class CartServlet extends HttpServlet {
    
    private CartService cartService;
    
    @Override
    public void init() throws ServletException {
        cartService = new CartService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        
        switch (path) {
            case "/cart":
                showCart(request, response);
                break;
            case "/cart-count":
                getCartCount(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        
        switch (path) {
            case "/add-to-cart":
                addToCart(request, response);
                break;
            case "/remove-from-cart":
                removeFromCart(request, response);
                break;
            case "/update-cart":
                updateCart(request, response);
                break;
            case "/clear-cart":
                clearCart(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    /**
     * Show cart page
     */
    private void showCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String userId = getUserId(session);
        
        if (userId == null) {
            // Redirect to login if not authenticated
            response.sendRedirect("login.jsp?redirect=cart");
            return;
        }
        
        Cart cart = cartService.getCartFromSession(session, userId);
        request.setAttribute("cart", cart);
        request.setAttribute("cartItems", cart.getItems());
        request.setAttribute("totalPrice", cart.getTotalPrice());
        request.setAttribute("totalItems", cart.getTotalItems());
        request.setAttribute("discountAmount", cart.getTotalDiscountAmount());
        
        request.getRequestDispatcher("/WEB-INF/views/Pages/cart.jsp")
               .forward(request, response);
    }
    
    /**
     * Add course to cart
     */
    private void addToCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String courseId = request.getParameter("courseId");
        HttpSession session = request.getSession();
        String userId = getUserId(session);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            if (userId == null) {
                out.print("{\"success\":false,\"message\":\"Vui lòng đăng nhập để thêm khóa học vào giỏ hàng\",\"redirectLogin\":true}");
            } else if (courseId == null || courseId.trim().isEmpty()) {
                out.print("{\"success\":false,\"message\":\"ID khóa học không hợp lệ\"}");
            } else {
                boolean added = cartService.addCourseToCart(session, userId, courseId);
                
                if (added) {
                    int cartCount = cartService.getCartItemCount(session, userId);
                    out.print("{\"success\":true,\"message\":\"Đã thêm khóa học vào giỏ hàng!\",\"cartCount\":" + cartCount + "}");
                } else {
                    out.print("{\"success\":false,\"message\":\"Khóa học đã có trong giỏ hàng hoặc không tồn tại\"}");
                }
            }
        }
    }
    
    /**
     * Remove course from cart
     */
    private void removeFromCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String courseId = request.getParameter("courseId");
        HttpSession session = request.getSession();
        String userId = getUserId(session);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            if (userId == null) {
                out.print("{\"success\":false,\"message\":\"Phiên đăng nhập không hợp lệ\"}");
            } else if (courseId == null || courseId.trim().isEmpty()) {
                out.print("{\"success\":false,\"message\":\"ID khóa học không hợp lệ\"}");
            } else {
                boolean removed = cartService.removeCourseFromCart(session, userId, courseId);
                
                if (removed) {
                    Cart cart = cartService.getCartFromSession(session, userId);
                    out.print("{\"success\":true,\"message\":\"Đã xóa khóa học khỏi giỏ hàng\",\"cartCount\":" + cart.getTotalItems() + ",\"totalPrice\":" + cart.getTotalPrice() + "}");
                } else {
                    out.print("{\"success\":false,\"message\":\"Không thể xóa khóa học khỏi giỏ hàng\"}");
                }
            }
        }
    }
    
    /**
     * Update cart item quantity
     */
    private void updateCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String courseId = request.getParameter("courseId");
        String quantityStr = request.getParameter("quantity");
        HttpSession session = request.getSession();
        String userId = getUserId(session);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            try {
                int quantity = Integer.parseInt(quantityStr);
                
                if (userId == null) {
                    out.print("{\"success\":false,\"message\":\"Phiên đăng nhập không hợp lệ\"}");
                } else if (courseId == null || courseId.trim().isEmpty()) {
                    out.print("{\"success\":false,\"message\":\"ID khóa học không hợp lệ\"}");
                } else if (quantity < 0) {
                    out.print("{\"success\":false,\"message\":\"Số lượng không hợp lệ\"}");
                } else {
                    boolean updated = cartService.updateCartItemQuantity(session, userId, courseId, quantity);
                    
                    if (updated) {
                        Cart cart = cartService.getCartFromSession(session, userId);
                        out.print("{\"success\":true,\"message\":\"Đã cập nhật giỏ hàng\",\"cartCount\":" + cart.getTotalItems() + ",\"totalPrice\":" + cart.getTotalPrice() + "}");
                    } else {
                        out.print("{\"success\":false,\"message\":\"Không thể cập nhật giỏ hàng\"}");
                    }
                }
            } catch (NumberFormatException e) {
                out.print("{\"success\":false,\"message\":\"Số lượng không hợp lệ\"}");
            }
        }
    }
    
    /**
     * Clear entire cart
     */
    private void clearCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String userId = getUserId(session);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            if (userId == null) {
                out.print("{\"success\":false,\"message\":\"Phiên đăng nhập không hợp lệ\"}");
            } else {
                cartService.clearCart(session, userId);
                out.print("{\"success\":true,\"message\":\"Đã xóa tất cả khóa học khỏi giỏ hàng\",\"cartCount\":0,\"totalPrice\":0.0}");
            }
        }
    }
    
    /**
     * Get cart item count (AJAX endpoint)
     */
    private void getCartCount(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String userId = getUserId(session);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            if (userId != null) {
                int cartCount = cartService.getCartItemCount(session, userId);
                out.print("{\"success\":true,\"cartCount\":" + cartCount + "}");
            } else {
                out.print("{\"success\":true,\"cartCount\":0}");
            }
        }
    }
    
    /**
     * Get user ID from session
     */
    private String getUserId(HttpSession session) {
        if (session == null) {
            return null;
        }
        
        Users user = (Users) session.getAttribute("account");
        return user != null ? user.getId() : null;
    }
}