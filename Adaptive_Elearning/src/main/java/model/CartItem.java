package model;

import java.io.Serializable;
import java.util.Date;

/**
 * Model class representing an item in the shopping cart
 * Each CartItem represents a course that a user wants to purchase
 */
public class CartItem implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private String courseId;
    private String courseName;
    private String courseDescription;
    private String courseImage;
    private String instructorName;
    private double originalPrice;
    private double discountPrice;
    private double finalPrice;
    private int quantity;
    private String level;
    private Date addedDate;
    private String userId;
    
    // Constructors
    public CartItem() {}
    
    public CartItem(String courseId, String courseName, String courseDescription, 
                   String courseImage, String instructorName, double originalPrice, 
                   double discountPrice, String level, String userId) {
        this.courseId = courseId;
        this.courseName = courseName;
        this.courseDescription = courseDescription;
        this.courseImage = courseImage;
        this.instructorName = instructorName;
        this.originalPrice = originalPrice;
        this.discountPrice = discountPrice;
        this.finalPrice = discountPrice > 0 ? discountPrice : originalPrice;
        this.quantity = 1; // Courses typically have quantity 1
        this.level = level;
        this.userId = userId;
        this.addedDate = new Date();
    }
    
    // Getters and Setters
    public String getCourseId() {
        return courseId;
    }
    
    public void setCourseId(String courseId) {
        this.courseId = courseId;
    }
    
    public String getCourseName() {
        return courseName;
    }
    
    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }
    
    public String getCourseDescription() {
        return courseDescription;
    }
    
    public void setCourseDescription(String courseDescription) {
        this.courseDescription = courseDescription;
    }
    
    public String getCourseImage() {
        return courseImage;
    }
    
    public void setCourseImage(String courseImage) {
        this.courseImage = courseImage;
    }
    
    public String getInstructorName() {
        return instructorName;
    }
    
    public void setInstructorName(String instructorName) {
        this.instructorName = instructorName;
    }
    
    public double getOriginalPrice() {
        return originalPrice;
    }
    
    public void setOriginalPrice(double originalPrice) {
        this.originalPrice = originalPrice;
    }
    
    public double getDiscountPrice() {
        return discountPrice;
    }
    
    public void setDiscountPrice(double discountPrice) {
        this.discountPrice = discountPrice;
        this.finalPrice = discountPrice > 0 ? discountPrice : originalPrice;
    }
    
    public double getFinalPrice() {
        return finalPrice;
    }
    
    public void setFinalPrice(double finalPrice) {
        this.finalPrice = finalPrice;
    }
    
    public int getQuantity() {
        return quantity;
    }
    
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    public String getLevel() {
        return level;
    }
    
    public void setLevel(String level) {
        this.level = level;
    }
    
    public Date getAddedDate() {
        return addedDate;
    }
    
    public void setAddedDate(Date addedDate) {
        this.addedDate = addedDate;
    }
    
    public String getUserId() {
        return userId;
    }
    
    public void setUserId(String userId) {
        this.userId = userId;
    }
    
    // Utility methods
    public double getTotalPrice() {
        return finalPrice * quantity;
    }
    
    public boolean hasDiscount() {
        return discountPrice > 0 && discountPrice < originalPrice;
    }
    
    public double getDiscountAmount() {
        if (hasDiscount()) {
            return originalPrice - discountPrice;
        }
        return 0;
    }
    
    public double getDiscountPercentage() {
        if (hasDiscount()) {
            return ((originalPrice - discountPrice) / originalPrice) * 100;
        }
        return 0;
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        
        CartItem cartItem = (CartItem) obj;
        return courseId != null ? courseId.equals(cartItem.courseId) : cartItem.courseId == null;
    }
    
    @Override
    public int hashCode() {
        return courseId != null ? courseId.hashCode() : 0;
    }
    
    // Alias methods for JSP compatibility
    public String getTitle() {
        return courseName;
    }
    
    public String getThumbnail() {
        return courseImage;
    }
    
    public double getPrice() {
        return finalPrice;
    }
    
    @Override
    public String toString() {
        return "CartItem{" +
                "courseId='" + courseId + '\'' +
                ", courseName='" + courseName + '\'' +
                ", finalPrice=" + finalPrice +
                ", quantity=" + quantity +
                ", userId='" + userId + '\'' +
                '}';
    }
}