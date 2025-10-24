package services;

import model.CartItem;
import jakarta.servlet.http.HttpSession;
import java.util.*;

/**
 * Service class for managing shopping cart operations
 */
public class CartService {
    private static final String CART_SESSION_KEY = "cart";
    
    /**
     * Get cart items from session
     */
    @SuppressWarnings("unchecked")
    public List<CartItem> getCartItems(HttpSession session) {
        List<CartItem> cart = (List<CartItem>) session.getAttribute(CART_SESSION_KEY);
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute(CART_SESSION_KEY, cart);
        }
        return cart;
    }
    
    /**
     * Add item to cart
     */
    public boolean addToCart(HttpSession session, CartItem item) {
        List<CartItem> cart = getCartItems(session);
        
        // Check if item already exists in cart
        for (CartItem existingItem : cart) {
            if (existingItem.getCourseId().equals(item.getCourseId())) {
                // Update quantity
                existingItem.setQuantity(existingItem.getQuantity() + item.getQuantity());
                session.setAttribute(CART_SESSION_KEY, cart);
                return true;
            }
        }
        
        // Add new item
        cart.add(item);
        session.setAttribute(CART_SESSION_KEY, cart);
        return true;
    }
    
    /**
     * Update item quantity in cart
     */
    public boolean updateCartItem(HttpSession session, String courseId, int quantity) {
        List<CartItem> cart = getCartItems(session);
        
        for (CartItem item : cart) {
            if (item.getCourseId().equals(courseId)) {
                if (quantity <= 0) {
                    cart.remove(item);
                } else {
                    item.setQuantity(quantity);
                }
                session.setAttribute(CART_SESSION_KEY, cart);
                return true;
            }
        }
        return false;
    }
    
    /**
     * Remove item from cart
     */
    public boolean removeFromCart(HttpSession session, String courseId) {
        List<CartItem> cart = getCartItems(session);
        
        Iterator<CartItem> iterator = cart.iterator();
        while (iterator.hasNext()) {
            CartItem item = iterator.next();
            if (item.getCourseId().equals(courseId)) {
                iterator.remove();
                session.setAttribute(CART_SESSION_KEY, cart);
                return true;
            }
        }
        return false;
    }
    
    /**
     * Clear entire cart
     */
    public void clearCart(HttpSession session) {
        session.removeAttribute(CART_SESSION_KEY);
    }
    
    /**
     * Get total amount
     */
    public double getTotalAmount(List<CartItem> cartItems) {
        return cartItems.stream()
                .mapToDouble(item -> item.getFinalPrice() * item.getQuantity())
                .sum();
    }
    
    /**
     * Get total discount
     */
    public double getTotalDiscount(List<CartItem> cartItems) {
        return cartItems.stream()
                .mapToDouble(item -> (item.getOriginalPrice() - item.getFinalPrice()) * item.getQuantity())
                .sum();
    }
    
    /**
     * Get item count
     */
    public int getItemCount(List<CartItem> cartItems) {
        return cartItems.stream()
                .mapToInt(CartItem::getQuantity)
                .sum();
    }
    
    /**
     * Check if cart is empty
     */
    public boolean isCartEmpty(HttpSession session) {
        List<CartItem> cart = getCartItems(session);
        return cart.isEmpty();
    }
    
    /**
     * Create sample cart item for testing
     */
    public CartItem createSampleCartItem(String courseId, String title, double price) {
        CartItem item = new CartItem();
        item.setCourseId(courseId);
        item.setCourseName(title);
        item.setOriginalPrice(price);
        item.setFinalPrice(price);
        item.setQuantity(1);
        item.setCourseImage("/Adaptive_Elearning/assets/images/course-default.jpg");
        item.setInstructorName("Giảng viên");
        item.setAddedDate(new Date());
        return item;
    }
    
    /**
     * Add sample data for testing
     */
    public void addSampleData(HttpSession session) {
        if (isCartEmpty(session)) {
            addToCart(session, createSampleCartItem("course1", "Lập trình Java cơ bản", 299000));
            addToCart(session, createSampleCartItem("course2", "Thiết kế web với HTML/CSS", 199000));
            addToCart(session, createSampleCartItem("course3", "JavaScript và jQuery", 249000));
        }
    }
}