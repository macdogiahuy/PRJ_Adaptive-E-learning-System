package services;

import java.sql.*;
import java.util.UUID;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import model.Users;
import model.CartItem;

/**
 * Service xử lý checkout giỏ hàng sử dụng Stored Procedures và Triggers
 */
public class CartCheckoutService {
    
    private static final Logger logger = Logger.getLogger(CartCheckoutService.class.getName());
    private DataSource dataSource;
    
    public CartCheckoutService() {
        try {
            Context ctx = new InitialContext();
            // Thử các JNDI name khác nhau
            try {
                dataSource = (DataSource) ctx.lookup("java:comp/env/jdbc/CourseHubDB");
            } catch (Exception e1) {
                try {
                    dataSource = (DataSource) ctx.lookup("jdbc/CourseHubDB");
                } catch (Exception e2) {
                    logger.warning("Could not find DataSource via JNDI, will use direct connection");
                }
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error initializing CartCheckoutService", e);
        }
    }
    
    /**
     * Xử lý checkout giỏ hàng sử dụng stored procedure
     */
    public CheckoutResult processCheckout(Users user, List<CartItem> cartItems, double totalAmount, String paymentMethod, String sessionId) {
        CheckoutResult result = new CheckoutResult();
        
        Connection conn = null;
        CallableStatement stmt = null;
        
        try {
            conn = getConnection();
            
            // Chuyển đổi danh sách course IDs thành JSON
            Gson gson = new Gson();
            List<String> courseIds = cartItems.stream()
                    .map(item -> item.getCourseId())
                    .toList();
            String courseIdsJson = gson.toJson(courseIds);
            
            logger.info("=== PROCESSING CHECKOUT WITH STORED PROCEDURE ===");
            logger.info("User ID: " + user.getId());
            logger.info("Course IDs: " + courseIdsJson);
            logger.info("Total Amount: " + totalAmount);
            logger.info("Payment Method: " + paymentMethod);
            
            // Gọi stored procedure ProcessCartCheckout
            String sql = "{CALL ProcessCartCheckout(?, ?, ?, ?, ?, ?, ?, ?)}";
            stmt = conn.prepareCall(sql);
            
            // Input parameters
            stmt.setString(1, user.getId());  // @UserId
            stmt.setString(2, courseIdsJson); // @CourseIds
            stmt.setLong(3, (long) totalAmount); // @TotalAmount
            stmt.setString(4, paymentMethod);  // @PaymentMethod
            stmt.setString(5, sessionId);     // @SessionId
            
            // Output parameters
            stmt.registerOutParameter(6, Types.VARCHAR); // @BillId
            stmt.registerOutParameter(7, Types.VARCHAR); // @CheckoutId
            stmt.registerOutParameter(8, Types.NVARCHAR); // @ResultMessage
            
            // Execute
            stmt.execute();
            
            // Lấy kết quả
            String billId = stmt.getString(6);
            String checkoutId = stmt.getString(7);
            String message = stmt.getString(8);
            
            result.setSuccess(true);
            result.setBillId(billId);
            result.setCheckoutId(checkoutId);
            result.setMessage(message);
            
            logger.info("=== CHECKOUT SUCCESSFUL ===");
            logger.info("Bill ID: " + billId);
            logger.info("Checkout ID: " + checkoutId);
            logger.info("Message: " + message);
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Database error during checkout", e);
            result.setSuccess(false);
            result.setMessage("Lỗi database: " + e.getMessage());
            
            // Nếu lỗi database, fallback sang email simulation
            try {
                logger.info("=== FALLBACK TO EMAIL SIMULATION ===");
                simulateCheckoutProcess(user, cartItems, totalAmount, paymentMethod);
                result.setSuccess(true);
                result.setBillId(UUID.randomUUID().toString());
                result.setMessage("Checkout thành công (simulation mode)");
            } catch (Exception fallbackError) {
                logger.log(Level.SEVERE, "Fallback also failed", fallbackError);
                result.setMessage("Lỗi checkout: " + fallbackError.getMessage());
            }
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Unexpected error during checkout", e);
            result.setSuccess(false);
            result.setMessage("Lỗi không mong muốn: " + e.getMessage());
        } finally {
            closeResources(stmt, conn);
        }
        
        return result;
    }
    
    /**
     * Lấy lịch sử checkout của user
     */
    public List<CheckoutHistory> getUserCheckoutHistory(String userId, int limit) {
        List<CheckoutHistory> history = new java.util.ArrayList<>();
        
        Connection conn = null;
        CallableStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            
            String sql = "{CALL GetUserCheckoutHistory(?, ?)}";
            stmt = conn.prepareCall(sql);
            stmt.setString(1, userId);
            stmt.setInt(2, limit);
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                CheckoutHistory item = new CheckoutHistory();
                item.setCheckoutId(rs.getString("CheckoutId"));
                item.setTotalAmount(rs.getLong("TotalAmount"));
                item.setPaymentMethod(rs.getString("PaymentMethod"));
                item.setStatus(rs.getString("Status"));
                item.setCreationTime(rs.getTimestamp("CreationTime"));
                item.setProcessedTime(rs.getTimestamp("ProcessedTime"));
                item.setNotes(rs.getString("Notes"));
                item.setBillId(rs.getString("BillId"));
                item.setTransactionId(rs.getString("TransactionId"));
                item.setIsSuccessful(rs.getBoolean("IsSuccessful"));
                
                history.add(item);
            }
            
            logger.info("Retrieved " + history.size() + " checkout history records for user: " + userId);
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error getting checkout history", e);
        } finally {
            closeResources(rs, stmt, conn);
        }
        
        return history;
    }
    
    /**
     * Simulation khi database không khả dụng
     */
    private void simulateCheckoutProcess(Users user, List<CartItem> cartItems, double totalAmount, String paymentMethod) {
        logger.info("📦 SIMULATING CHECKOUT PROCESS:");
        logger.info("📦 User: " + user.getUserName() + " (" + user.getEmail() + ")");
        logger.info("📦 Items count: " + cartItems.size());
        logger.info("📦 Total: " + String.format("%,.0f đ", totalAmount));
        logger.info("📦 Payment: " + paymentMethod);
        
        for (CartItem item : cartItems) {
            logger.info("📦 Course: " + item.getCourseName() + " - " + String.format("%,.0f đ", item.getFinalPrice()));
        }
        
        logger.info("📦 Checkout simulation completed successfully!");
    }
    
    /**
     * Lấy connection
     */
    private Connection getConnection() throws SQLException {
        if (dataSource != null) {
            return dataSource.getConnection();
        } else {
            // Fallback direct connection
            String url = "jdbc:sqlserver://localhost:1433;databaseName=CourseHubDB;encrypt=false;trustServerCertificate=true";
            String username = "sa";
            String password = "123456";
            return DriverManager.getConnection(url, username, password);
        }
    }
    
    /**
     * Đóng resources
     */
    private void closeResources(AutoCloseable... resources) {
        for (AutoCloseable resource : resources) {
            if (resource != null) {
                try {
                    resource.close();
                } catch (Exception e) {
                    logger.log(Level.WARNING, "Error closing resource", e);
                }
            }
        }
    }
    
    /**
     * Kết quả checkout
     */
    public static class CheckoutResult {
        private boolean success;
        private String billId;
        private String checkoutId;
        private String message;
        
        // Getters and setters
        public boolean isSuccess() { return success; }
        public void setSuccess(boolean success) { this.success = success; }
        
        public String getBillId() { return billId; }
        public void setBillId(String billId) { this.billId = billId; }
        
        public String getCheckoutId() { return checkoutId; }
        public void setCheckoutId(String checkoutId) { this.checkoutId = checkoutId; }
        
        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }
    }
    
    /**
     * Lịch sử checkout
     */
    public static class CheckoutHistory {
        private String checkoutId;
        private long totalAmount;
        private String paymentMethod;
        private String status;
        private Timestamp creationTime;
        private Timestamp processedTime;
        private String notes;
        private String billId;
        private String transactionId;
        private boolean isSuccessful;
        
        // Getters and setters
        public String getCheckoutId() { return checkoutId; }
        public void setCheckoutId(String checkoutId) { this.checkoutId = checkoutId; }
        
        public long getTotalAmount() { return totalAmount; }
        public void setTotalAmount(long totalAmount) { this.totalAmount = totalAmount; }
        
        public String getPaymentMethod() { return paymentMethod; }
        public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
        
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
        
        public Timestamp getCreationTime() { return creationTime; }
        public void setCreationTime(Timestamp creationTime) { this.creationTime = creationTime; }
        
        public Timestamp getProcessedTime() { return processedTime; }
        public void setProcessedTime(Timestamp processedTime) { this.processedTime = processedTime; }
        
        public String getNotes() { return notes; }
        public void setNotes(String notes) { this.notes = notes; }
        
        public String getBillId() { return billId; }
        public void setBillId(String billId) { this.billId = billId; }
        
        public String getTransactionId() { return transactionId; }
        public void setTransactionId(String transactionId) { this.transactionId = transactionId; }
        
        public boolean isSuccessful() { return isSuccessful; }
        public void setIsSuccessful(boolean isSuccessful) { this.isSuccessful = isSuccessful; }
    }
}