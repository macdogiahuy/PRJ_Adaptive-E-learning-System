package model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Optional;

/**
 * Model class representing a shopping cart
 * Contains a list of CartItems and provides cart management functionality
 */
public class Cart implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private String userId;
    private List<CartItem> items;
    private Date createdDate;
    private Date lastModified;
    
    // Constructors
    public Cart() {
        this.items = new ArrayList<>();
        this.createdDate = new Date();
        this.lastModified = new Date();
    }
    
    public Cart(String userId) {
        this();
        this.userId = userId;
    }
    
    // Getters and Setters
    public String getUserId() {
        return userId;
    }
    
    public void setUserId(String userId) {
        this.userId = userId;
    }
    
    public List<CartItem> getItems() {
        return items;
    }
    
    public void setItems(List<CartItem> items) {
        this.items = items != null ? items : new ArrayList<>();
        updateLastModified();
    }
    
    public Date getCreatedDate() {
        return createdDate;
    }
    
    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }
    
    public Date getLastModified() {
        return lastModified;
    }
    
    public void setLastModified(Date lastModified) {
        this.lastModified = lastModified;
    }
    
    // Cart management methods
    
    /**
     * Add an item to the cart
     * If the course already exists, update quantity
     */
    public boolean addItem(CartItem item) {
        if (item == null || item.getCourseId() == null) {
            return false;
        }
        
        // Check if course already exists in cart
        Optional<CartItem> existingItem = findItemByCourseId(item.getCourseId());
        
        if (existingItem.isPresent()) {
            // For courses, we typically don't increase quantity, just replace
            // But we can update the item if needed
            CartItem existing = existingItem.get();
            existing.setQuantity(existing.getQuantity() + item.getQuantity());
            updateLastModified();
            return true;
        } else {
            // Add new item
            items.add(item);
            updateLastModified();
            return true;
        }
    }
    
    /**
     * Remove an item from the cart by course ID
     */
    public boolean removeItem(String courseId) {
        if (courseId == null) {
            return false;
        }
        
        boolean removed = items.removeIf(item -> courseId.equals(item.getCourseId()));
        if (removed) {
            updateLastModified();
        }
        return removed;
    }
    
    /**
     * Update item quantity
     */
    public boolean updateItemQuantity(String courseId, int quantity) {
        if (courseId == null || quantity < 0) {
            return false;
        }
        
        Optional<CartItem> item = findItemByCourseId(courseId);
        if (item.isPresent()) {
            if (quantity == 0) {
                return removeItem(courseId);
            } else {
                item.get().setQuantity(quantity);
                updateLastModified();
                return true;
            }
        }
        return false;
    }
    
    /**
     * Find item by course ID
     */
    public Optional<CartItem> findItemByCourseId(String courseId) {
        return items.stream()
                   .filter(item -> courseId.equals(item.getCourseId()))
                   .findFirst();
    }
    
    /**
     * Check if course exists in cart
     */
    public boolean containsCourse(String courseId) {
        return findItemByCourseId(courseId).isPresent();
    }
    
    /**
     * Clear all items from cart
     */
    public void clearCart() {
        items.clear();
        updateLastModified();
    }
    
    /**
     * Get total number of items in cart
     */
    public int getTotalItems() {
        return items.stream()
                   .mapToInt(CartItem::getQuantity)
                   .sum();
    }
    
    /**
     * Get total price of all items in cart
     */
    public double getTotalPrice() {
        return items.stream()
                   .mapToDouble(CartItem::getTotalPrice)
                   .sum();
    }
    
    /**
     * Get total original price (before discounts)
     */
    public double getTotalOriginalPrice() {
        return items.stream()
                   .mapToDouble(item -> item.getOriginalPrice() * item.getQuantity())
                   .sum();
    }
    
    /**
     * Get total discount amount
     */
    public double getTotalDiscountAmount() {
        return getTotalOriginalPrice() - getTotalPrice();
    }
    
    /**
     * Check if cart is empty
     */
    public boolean isEmpty() {
        return items.isEmpty();
    }
    
    /**
     * Get number of unique courses in cart
     */
    public int getUniqueItemCount() {
        return items.size();
    }
    
    /**
     * Update last modified timestamp
     */
    private void updateLastModified() {
        this.lastModified = new Date();
    }
    
    /**
     * Create a summary of the cart for display
     */
    public String getCartSummary() {
        if (isEmpty()) {
            return "Giỏ hàng trống";
        }
        
        return String.format("Giỏ hàng: %d khóa học - %,.0f₫", 
                           getUniqueItemCount(), getTotalPrice());
    }
    
    /**
     * Validate cart items
     */
    public boolean isValid() {
        return userId != null && !userId.trim().isEmpty() && 
               items != null && 
               items.stream().allMatch(item -> 
                   item.getCourseId() != null && 
                   item.getCourseName() != null && 
                   item.getFinalPrice() >= 0 && 
                   item.getQuantity() > 0
               );
    }
    
    @Override
    public String toString() {
        return "Cart{" +
                "userId='" + userId + '\'' +
                ", itemCount=" + items.size() +
                ", totalPrice=" + getTotalPrice() +
                ", lastModified=" + lastModified +
                '}';
    }
}