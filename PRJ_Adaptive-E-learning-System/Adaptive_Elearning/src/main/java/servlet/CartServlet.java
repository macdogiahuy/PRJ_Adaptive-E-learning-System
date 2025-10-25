package servlet;

import model.CartItem;
import model.Courses;
import jakarta.persistence.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.google.gson.Gson;

/**
 * Servlet xử lý giỏ hàng (Shopping Cart)
 * Các chức năng: thêm, xóa, xem, làm trống giỏ hàng
 */
@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(CartServlet.class.getName());
    private static final String CART_SESSION_KEY = "cart";
    private EntityManagerFactory emf;
    
    @Override
    public void init() throws ServletException {
        super.init();
        this.emf = Persistence.createEntityManagerFactory("Adaptive_ElearningPU");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "view";
        }
        
        try {
            switch (action) {
                case "view":
                    viewCart(request, response, session);
                    break;
                case "remove":
                    removeFromCart(request, response, session);
                    break;
                case "clear":
                    clearCart(request, response, session);
                    break;
                case "count":
                    getCartCount(request, response, session);
                    break;
                default:
                    viewCart(request, response, session);
                    break;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing cart request", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Có lỗi xảy ra khi xử lý giỏ hàng");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "add";
        }
        
        try {
            switch (action) {
                case "add":
                    addToCart(request, response, session);
                    break;
                case "remove":
                    removeFromCart(request, response, session);
                    break;
                case "clear":
                    clearCart(request, response, session);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
                    break;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing cart request", e);
            sendJsonResponse(response, false, "Có lỗi xảy ra: " + e.getMessage(), null);
        }
    }
    
    /**
     * Thêm khóa học vào giỏ hàng
     */
    private void addToCart(HttpServletRequest request, HttpServletResponse response, 
                          HttpSession session) throws IOException {
        String courseId = request.getParameter("courseId");
        
        if (courseId == null || courseId.trim().isEmpty()) {
            sendJsonResponse(response, false, "ID khóa học không hợp lệ", null);
            return;
        }
        
        // Lấy giỏ hàng từ session
        Map<String, CartItem> cart = getCartFromSession(session);
        
        // Kiểm tra khóa học đã có trong giỏ hàng chưa
        if (cart.containsKey(courseId)) {
            sendJsonResponse(response, false, "Khóa học đã có trong giỏ hàng", 
                           Map.of("cartCount", cart.size()));
            return;
        }
        
        // Lấy thông tin khóa học từ database
        Courses course = getCourseById(courseId);
        if (course == null) {
            sendJsonResponse(response, false, "Không tìm thấy khóa học", null);
            return;
        }
        
        // Tạo CartItem từ thông tin khóa học
        String instructorName = "Unknown";
        if (course.getInstructorId() != null && course.getInstructorId().getCreatorId() != null) {
            instructorName = course.getInstructorId().getCreatorId().getUserName();
        }
        
        CartItem cartItem = new CartItem(
            course.getId(),
            course.getTitle(),
            course.getIntro(),
            course.getThumbUrl(),
            instructorName,
            course.getPrice(),
            course.getDiscount() > 0 ? course.getPrice() * (1 - course.getDiscount() / 100) : 0,
            course.getLevel(),
            null // userId sẽ được set khi checkout
        );
        
        // Thêm vào giỏ hàng
        cart.put(courseId, cartItem);
        session.setAttribute(CART_SESSION_KEY, cart);
        
        // Trả về kết quả
        sendJsonResponse(response, true, "Đã thêm khóa học vào giỏ hàng", 
                       Map.of("cartCount", cart.size(), "cartItem", cartItem));
    }
    
    /**
     * Xóa khóa học khỏi giỏ hàng
     */
    private void removeFromCart(HttpServletRequest request, HttpServletResponse response, 
                               HttpSession session) throws IOException {
        String courseId = request.getParameter("courseId");
        
        if (courseId == null || courseId.trim().isEmpty()) {
            sendJsonResponse(response, false, "ID khóa học không hợp lệ", null);
            return;
        }
        
        Map<String, CartItem> cart = getCartFromSession(session);
        
        if (cart.containsKey(courseId)) {
            cart.remove(courseId);
            session.setAttribute(CART_SESSION_KEY, cart);
            sendJsonResponse(response, true, "Đã xóa khóa học khỏi giỏ hàng", 
                           Map.of("cartCount", cart.size()));
        } else {
            sendJsonResponse(response, false, "Khóa học không có trong giỏ hàng", null);
        }
    }
    
    /**
     * Làm trống giỏ hàng
     */
    private void clearCart(HttpServletRequest request, HttpServletResponse response, 
                          HttpSession session) throws IOException {
        session.removeAttribute(CART_SESSION_KEY);
        sendJsonResponse(response, true, "Đã làm trống giỏ hàng", Map.of("cartCount", 0));
    }
    
    /**
     * Hiển thị trang giỏ hàng
     */
    private void viewCart(HttpServletRequest request, HttpServletResponse response, 
                         HttpSession session) throws ServletException, IOException {
        Map<String, CartItem> cart = getCartFromSession(session);
        List<CartItem> cartItems = new ArrayList<>(cart.values());
        
        // Tính tổng tiền
        double totalAmount = cartItems.stream()
                                      .mapToDouble(CartItem::getFinalPrice)
                                      .sum();
        
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("totalAmount", totalAmount);
        request.setAttribute("cartCount", cartItems.size());
        
        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }
    
    /**
     * Lấy số lượng sản phẩm trong giỏ hàng
     */
    private void getCartCount(HttpServletRequest request, HttpServletResponse response, 
                             HttpSession session) throws IOException {
        Map<String, CartItem> cart = getCartFromSession(session);
        sendJsonResponse(response, true, "Success", Map.of("cartCount", cart.size()));
    }
    
    /**
     * Lấy giỏ hàng từ session
     */
    @SuppressWarnings("unchecked")
    private Map<String, CartItem> getCartFromSession(HttpSession session) {
        Map<String, CartItem> cart = (Map<String, CartItem>) session.getAttribute(CART_SESSION_KEY);
        if (cart == null) {
            cart = new HashMap<>();
            session.setAttribute(CART_SESSION_KEY, cart);
        }
        return cart;
    }
    
    /**
     * Lấy thông tin khóa học từ database
     */
    private Courses getCourseById(String courseId) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.find(Courses.class, courseId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting course by ID: " + courseId, e);
            return null;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }
    
    /**
     * Gửi JSON response
     */
    private void sendJsonResponse(HttpServletResponse response, boolean success, 
                                  String message, Map<String, Object> data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        Map<String, Object> jsonResponse = new HashMap<>();
        jsonResponse.put("success", success);
        jsonResponse.put("message", message);
        if (data != null) {
            jsonResponse.putAll(data);
        }
        
        Gson gson = new Gson();
        response.getWriter().write(gson.toJson(jsonResponse));
    }
    
    @Override
    public void destroy() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
        super.destroy();
    }
}
