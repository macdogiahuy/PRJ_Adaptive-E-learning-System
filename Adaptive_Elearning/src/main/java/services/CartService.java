package services;

import model.Cart;
import model.CartItem;
import controller.CourseManagementController;
import controller.CourseManagementController.Course;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Service class for managing shopping cart operations
 * Handles cart storage in session and provides cart management functionality
 */
public class CartService {
    
    private static final String CART_SESSION_KEY = "userCart";
    private CourseManagementController courseController;
    
    // In-memory storage for demo purposes (in production, use database)
    private static final Map<String, Cart> userCarts = new ConcurrentHashMap<>();
    
    public CartService() {
        this.courseController = new CourseManagementController();
    }
    
    /**
     * Get cart from session, create new if doesn't exist
     */
    public Cart getCartFromSession(HttpSession session, String userId) {
        if (session == null || userId == null) {
            return new Cart();
        }
        
        Cart cart = (Cart) session.getAttribute(CART_SESSION_KEY);
        if (cart == null || !userId.equals(cart.getUserId())) {
            cart = new Cart(userId);
            session.setAttribute(CART_SESSION_KEY, cart);
        }
        
        return cart;
    }
    
    /**
     * Save cart to session
     */
    public void saveCartToSession(HttpSession session, Cart cart) {
        if (session != null && cart != null) {
            session.setAttribute(CART_SESSION_KEY, cart);
        }
    }
    
    /**
     * Add course to cart
     */
    public boolean addCourseToCart(HttpSession session, String userId, String courseId) {
        try {
            // Get course details
            Course course = courseController.getCourseById(courseId);
            if (course == null) {
                return false;
            }
            
            // Get user's cart
            Cart cart = getCartFromSession(session, userId);
            
            // Check if course already in cart
            if (cart.containsCourse(courseId)) {
                return false; // Course already in cart
            }
            
            // Create cart item
            CartItem cartItem = new CartItem(
                course.getId(),
                course.getTitle(),
                "", // Description not available in current Course model
                course.getThumbUrl(),
                course.getInstructorName(),
                course.getPrice(),
                course.getDiscountPrice(),
                course.getLevel(),
                userId
            );
            
            // Add to cart
            boolean added = cart.addItem(cartItem);
            
            if (added) {
                saveCartToSession(session, cart);
            }
            
            return added;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Remove course from cart
     */
    public boolean removeCourseFromCart(HttpSession session, String userId, String courseId) {
        Cart cart = getCartFromSession(session, userId);
        boolean removed = cart.removeItem(courseId);
        
        if (removed) {
            saveCartToSession(session, cart);
        }
        
        return removed;
    }
    
    /**
     * Update item quantity in cart
     */
    public boolean updateCartItemQuantity(HttpSession session, String userId, String courseId, int quantity) {
        Cart cart = getCartFromSession(session, userId);
        boolean updated = cart.updateItemQuantity(courseId, quantity);
        
        if (updated) {
            saveCartToSession(session, cart);
        }
        
        return updated;
    }
    
    /**
     * Clear entire cart
     */
    public void clearCart(HttpSession session, String userId) {
        Cart cart = getCartFromSession(session, userId);
        cart.clearCart();
        saveCartToSession(session, cart);
    }
    
    /**
     * Get cart item count
     */
    public int getCartItemCount(HttpSession session, String userId) {
        Cart cart = getCartFromSession(session, userId);
        return cart.getTotalItems();
    }
    
    /**
     * Get cart total price
     */
    public double getCartTotalPrice(HttpSession session, String userId) {
        Cart cart = getCartFromSession(session, userId);
        return cart.getTotalPrice();
    }
    
    /**
     * Check if course is in cart
     */
    public boolean isCourseInCart(HttpSession session, String userId, String courseId) {
        Cart cart = getCartFromSession(session, userId);
        return cart.containsCourse(courseId);
    }
    
    /**
     * Get cart summary for display
     */
    public String getCartSummary(HttpSession session, String userId) {
        Cart cart = getCartFromSession(session, userId);
        return cart.getCartSummary();
    }
    
    /**
     * Validate cart before checkout
     */
    public boolean validateCart(HttpSession session, String userId) {
        Cart cart = getCartFromSession(session, userId);
        
        if (cart.isEmpty()) {
            return false;
        }
        
        // Check if all courses still exist and are available
        for (CartItem item : cart.getItems()) {
            try {
                Course course = courseController.getCourseById(item.getCourseId());
                if (course == null) {
                    // Course no longer exists, remove from cart
                    cart.removeItem(item.getCourseId());
                    saveCartToSession(session, cart);
                }
            } catch (SQLException e) {
                e.printStackTrace();
                return false;
            }
        }
        
        return cart.isValid();
    }
    
    /**
     * Process checkout (placeholder for actual payment processing)
     */
    public boolean processCheckout(HttpSession session, String userId) {
        if (!validateCart(session, userId)) {
            return false;
        }
        
        Cart cart = getCartFromSession(session, userId);
        
        // TODO: Implement actual payment processing
        // TODO: Create enrollment records
        // TODO: Send confirmation emails
        
        // For now, just clear the cart after successful "purchase"
        clearCart(session, userId);
        
        return true;
    }
    
    /**
     * Transfer cart from anonymous session to logged-in user
     */
    public void transferAnonymousCart(HttpSession session, String userId) {
        Cart anonymousCart = (Cart) session.getAttribute(CART_SESSION_KEY);
        
        if (anonymousCart != null && anonymousCart.getUserId() == null) {
            // Update cart user ID
            anonymousCart.setUserId(userId);
            
            // Update all cart items user ID
            for (CartItem item : anonymousCart.getItems()) {
                item.setUserId(userId);
            }
            
            saveCartToSession(session, anonymousCart);
        }
    }
    
    /**
     * Get cart statistics for admin/analytics
     */
    public Map<String, Object> getCartStatistics() {
        Map<String, Object> stats = new HashMap<>();
        
        int totalCarts = userCarts.size();
        int activeCarts = 0;
        double totalValue = 0;
        
        for (Cart cart : userCarts.values()) {
            if (!cart.isEmpty()) {
                activeCarts++;
                totalValue += cart.getTotalPrice();
            }
        }
        
        stats.put("totalCarts", totalCarts);
        stats.put("activeCarts", activeCarts);
        stats.put("totalValue", totalValue);
        stats.put("averageCartValue", activeCarts > 0 ? totalValue / activeCarts : 0);
        
        return stats;
    }
}