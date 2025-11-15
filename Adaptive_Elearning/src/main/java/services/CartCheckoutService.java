 package services;

import java.sql.*;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;
import com.google.gson.Gson;
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
            // 1. Pre-filter duplicate courses to avoid charging for already owned ones
            List<CartItem> originalItems = cartItems;
            List<CartItem> filteredItems = new java.util.ArrayList<>();
            List<String> skippedCourseNames = new java.util.ArrayList<>();
            for (CartItem item : originalItems) {
                if (isAlreadyEnrolled(conn, user.getId(), item.getCourseId())) {
                    logger.info("⏭️  Skipping already owned course: " + item.getCourseName() + " (" + item.getCourseId() + ")");
                    skippedCourseNames.add(item.getCourseName());
                } else {
                    filteredItems.add(item);
                }
            }

            if (filteredItems.isEmpty()) {
                logger.warning("All requested courses are already owned. Aborting checkout.");
                result.setSuccess(false);
                result.setMessage("Bạn đã sở hữu tất cả các khóa học trong giỏ. Không có khóa học mới để thanh toán.");
                result.setOriginalCourseCount(originalItems.size());
                result.setFilteredCourseCount(0);
                result.setSkippedCourses(skippedCourseNames);
                result.setEffectiveAmount(0);
                return result;
            }

            // Recalculate effective total based only on NEW courses
            double effectiveTotal = filteredItems.stream()
                    .mapToDouble(CartItem::getFinalPrice)
                    .sum();

            // Log difference if any
            if (Math.round(effectiveTotal) != Math.round(totalAmount)) {
                logger.info("💰 Adjusting total amount. Original submitted: " + totalAmount + ", Effective (new courses only): " + effectiveTotal);
            }

            // Use filtered list for downstream processing
            cartItems = filteredItems; // reassign for clarity
            totalAmount = effectiveTotal;
            result.setEffectiveAmount(effectiveTotal);
            result.setOriginalCourseCount(originalItems.size());
            result.setFilteredCourseCount(filteredItems.size());
            result.setSkippedCourses(skippedCourseNames);
            
            // Chuyển đổi danh sách course IDs thành JSON
            Gson gson = new Gson();
            List<String> courseIds = cartItems.stream()
                    .map(item -> item.getCourseId())
                    .toList();
            String courseIdsJson = gson.toJson(courseIds);
            
            logger.info("=== PROCESSING CHECKOUT WITH STORED PROCEDURE ===");
            logger.info("User ID: " + user.getId());
            logger.info("User ID Type: " + user.getId().getClass().getName());
            logger.info("Course IDs: " + courseIdsJson);
            logger.info("Number of courses: " + courseIds.size());
            logger.info("Total Amount: " + totalAmount);
            logger.info("Payment Method: " + paymentMethod);
            if (!skippedCourseNames.isEmpty()) {
                logger.info("Skipped (already owned): " + skippedCourseNames);
            }
            
            // Log individual course IDs
            for (int i = 0; i < cartItems.size(); i++) {
                CartItem item = cartItems.get(i);
                logger.info("  Course " + (i+1) + ": " + item.getCourseName() + " (ID: " + item.getCourseId() + ")");
            }
            
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
            // Enhance message with skip info
            if (!skippedCourseNames.isEmpty()) {
                message = message + " | Bỏ qua (đã sở hữu): " + String.join(", ", skippedCourseNames);
            }
            result.setMessage(message);
            
            logger.info("=== CHECKOUT SUCCESSFUL ===");
            logger.info("Bill ID: " + billId);
            logger.info("Checkout ID: " + checkoutId);
            logger.info("Message: " + message);

            // === Post-checkout reconciliation: verify all NEW courses got enrollments ===
            try {
                List<String> missing = findMissingEnrollments(conn, user.getId(), billId, courseIds);
                if (!missing.isEmpty()) {
                    logger.warning("⚠️ Missing enrollments detected for bill " + billId + ": " + missing);
                    // Detect possible root cause: unique index on BillId blocking multiple rows
                    if (isBillIdUniqueConstraint(conn)) {
                        logger.severe("Root Cause: Unique index on Enrollments.BillId prevents multiple courses under the same bill. Only first course inserted.");
                        result.setMessage(result.getMessage() + " | Lý do: BillId đang bị UNIQUE nên chỉ lưu được 1 khóa học. Cần gỡ index 'IX_Enrollments_BillId'.");
                    }
                    for (String missCourseId : missing) {
                        logger.info("Attempt recovery insert for missing course: " + missCourseId);
                        // Extra diagnostics before insert
                        logCourseAndUserPresence(conn, user.getId(), missCourseId);
                        if (!isAlreadyEnrolled(conn, user.getId(), missCourseId)) {
                            boolean inserted = insertEnrollment(conn, user.getId(), missCourseId, billId);
                            logger.info("Recovery insert for course " + missCourseId + " => " + (inserted ? "OK" : "FAILED"));
                            if (!inserted) {
                                logger.severe("Recovery insert failed for course " + missCourseId + ", will remain missing.");
                            }
                        } else {
                            logger.info("Course " + missCourseId + " appears enrolled after re-check.");
                        }
                    }
                    // Re-check after recovery
                    List<String> stillMissing = findMissingEnrollments(conn, user.getId(), billId, courseIds);
                    if (stillMissing.isEmpty()) {
                        logger.info("✅ Reconciliation successful. All courses enrolled.");
                    } else {
                        logger.severe("❌ Reconciliation failed for courses: " + stillMissing);
                        result.setMessage(result.getMessage() + " | Cảnh báo: chưa tạo được các khóa: " + String.join(", ", stillMissing));
                    }
                } else {
                    logger.info("✅ All requested new courses have enrollments.");
                }
            } catch (Exception reconErr) {
                logger.log(Level.SEVERE, "Reconciliation error", reconErr);
                result.setMessage(result.getMessage() + " | Lỗi kiểm tra sau thanh toán: " + reconErr.getMessage());
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "❌ DATABASE ERROR DURING CHECKOUT ❌", e);
            logger.severe("SQLException Details:");
            logger.severe("  Error Code: " + e.getErrorCode());
            logger.severe("  SQL State: " + e.getSQLState());
            logger.severe("  Message: " + e.getMessage());
            
            result.setSuccess(false);
            result.setMessage("Lỗi database: " + e.getMessage());
            
            // IMPORTANT: DO NOT FALLBACK - We need real enrollments!
            // The fallback creates fake success without actual database records
            logger.severe("⚠️ CHECKOUT FAILED - NO FALLBACK ⚠️");
            logger.severe("Enrollments were NOT created. User must retry.");
            
            // DO NOT USE SIMULATION MODE - it causes ghost purchases
            // try {
            //     logger.info("=== FALLBACK TO EMAIL SIMULATION ===");
            //     simulateCheckoutProcess(user, cartItems, totalAmount, paymentMethod);
            //     result.setSuccess(true);
            //     result.setBillId(UUID.randomUUID().toString());
            //     result.setMessage("Checkout thành công (simulation mode)");
            // } catch (Exception fallbackError) {
            //     logger.log(Level.SEVERE, "Fallback also failed", fallbackError);
            //     result.setMessage("Lỗi checkout: " + fallbackError.getMessage());
            // }
            
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
    // Removed unused simulation method (previously used for fallback ghost purchases)
    
    /**
     * Lấy connection
     */
    private Connection getConnection() throws SQLException {
        if (dataSource != null) {
            return dataSource.getConnection();
        } else {
            // Fallback direct connection
            String url = "jdbc:sqlserver://localhost:1433;databaseName=CourseHubDB1;encrypt=false;trustServerCertificate=true";
            String username = "sa";
            String password = "1234";  // ← FIXED: Match with persistence.xml
            return DriverManager.getConnection(url, username, password);
        }
    }

    /**
     * Check if user already enrolled in course (server-side safety before charging)
     */
    private boolean isAlreadyEnrolled(Connection conn, String userId, String courseId) {
        String sql = "SELECT COUNT(*) FROM Enrollments WHERE CAST(CreatorId AS VARCHAR(36)) = ? AND CAST(CourseId AS VARCHAR(36)) = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId);
            ps.setString(2, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            logger.log(Level.WARNING, "Error checking existing enrollment (continuing as not enrolled): " + courseId, e);
        }
        return false;
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
     * Find course IDs from the requested list that do NOT have an enrollment with this billId/user.
     */
    private List<String> findMissingEnrollments(Connection conn, String userId, String billId, List<String> requestedCourseIds) {
        List<String> missing = new java.util.ArrayList<>();
        if (requestedCourseIds == null || requestedCourseIds.isEmpty()) return missing;
        String sql = "SELECT CAST(CourseId AS VARCHAR(36)) FROM Enrollments WHERE BillId = ? AND CAST(CreatorId AS VARCHAR(36)) = ?";
        java.util.Set<String> present = new java.util.HashSet<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, billId);
            ps.setString(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    present.add(rs.getString(1));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.WARNING, "Error fetching existing enrollments for reconciliation", e);
            return missing; // return empty (do not falsely attempt inserts)
        }
        for (String cid : requestedCourseIds) {
            if (!present.contains(cid)) {
                missing.add(cid);
            }
        }
        return missing;
    }

    /**
     * Attempt to insert a missing enrollment post-transaction (idempotent).
     */
    private boolean insertEnrollment(Connection conn, String userId, String courseId, String billId) {
        String existsSql = "SELECT COUNT(*) FROM Enrollments WHERE CAST(CreatorId AS VARCHAR(36)) = ? AND CAST(CourseId AS VARCHAR(36)) = ?";
        try (PreparedStatement check = conn.prepareStatement(existsSql)) {
            check.setString(1, userId);
            check.setString(2, courseId);
            try (ResultSet rs = check.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    return true; // already there
                }
            }
        } catch (SQLException e) {
            logger.log(Level.WARNING, "Error pre-check enrollment existence", e);
            return false;
        }
        String insertSql = "INSERT INTO Enrollments (CreatorId, CourseId, BillId, Status, CreationTime, AssignmentMilestones, LectureMilestones, SectionMilestones) VALUES (?,?,?,?,GETDATE(),'{}','{}','{}')";
        try (PreparedStatement ins = conn.prepareStatement(insertSql)) {
            ins.setString(1, userId);
            ins.setString(2, courseId);
            ins.setString(3, billId);
            ins.setString(4, "In Progress");
            return ins.executeUpdate() == 1;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Failed to insert missing enrollment (recovery) for course " + courseId, e);
            return false;
        }
    }

    /**
     * Log presence of related entities to diagnose FK failures.
     */
    private void logCourseAndUserPresence(Connection conn, String userId, String courseId) {
        try (PreparedStatement ps1 = conn.prepareStatement("SELECT COUNT(*) FROM Users WHERE CAST(Id AS VARCHAR(36))=?");
             PreparedStatement ps2 = conn.prepareStatement("SELECT COUNT(*) FROM Courses WHERE CAST(Id AS VARCHAR(36))=?")) {
            ps1.setString(1, userId);
            ps2.setString(1, courseId);
            int userCount = 0; int courseCount = 0;
            try (ResultSet r1 = ps1.executeQuery()) { if (r1.next()) userCount = r1.getInt(1); }
            try (ResultSet r2 = ps2.executeQuery()) { if (r2.next()) courseCount = r2.getInt(1); }
            logger.info("Presence check => userExists=" + (userCount>0) + ", courseExists=" + (courseCount>0));
        } catch (SQLException e) {
            logger.log(Level.WARNING, "Error logging presence diagnostics", e);
        }
    }

    /**
     * Detect if a unique index on BillId exists (causing single enrollment per bill).
     */
    private boolean isBillIdUniqueConstraint(Connection conn) {
        String sql = "SELECT is_unique FROM sys.indexes WHERE name = 'IX_Enrollments_BillId' AND object_id = OBJECT_ID('dbo.Enrollments')";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                boolean unique = rs.getBoolean(1);
                logger.info("Index IX_Enrollments_BillId present. is_unique=" + unique);
                return unique;
            } else {
                logger.info("Index IX_Enrollments_BillId not present.");
            }
        } catch (SQLException e) {
            logger.log(Level.WARNING, "Error checking BillId index", e);
        }
        return false;
    }
    
    /**
     * Kết quả checkout
     */
    public static class CheckoutResult {
        private boolean success;
        private String billId;
        private String checkoutId;
        private String message;
        private double effectiveAmount;
        private int originalCourseCount;
        private int filteredCourseCount;
        private List<String> skippedCourses = java.util.Collections.emptyList();
        
        // Getters and setters
        public boolean isSuccess() { return success; }
        public void setSuccess(boolean success) { this.success = success; }
        
        public String getBillId() { return billId; }
        public void setBillId(String billId) { this.billId = billId; }
        
        public String getCheckoutId() { return checkoutId; }
        public void setCheckoutId(String checkoutId) { this.checkoutId = checkoutId; }
        
        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }
        public double getEffectiveAmount() { return effectiveAmount; }
        public void setEffectiveAmount(double effectiveAmount) { this.effectiveAmount = effectiveAmount; }
        public int getOriginalCourseCount() { return originalCourseCount; }
        public void setOriginalCourseCount(int originalCourseCount) { this.originalCourseCount = originalCourseCount; }
        public int getFilteredCourseCount() { return filteredCourseCount; }
        public void setFilteredCourseCount(int filteredCourseCount) { this.filteredCourseCount = filteredCourseCount; }
        public List<String> getSkippedCourses() { return skippedCourses; }
        public void setSkippedCourses(List<String> skippedCourses) { this.skippedCourses = skippedCourses; }
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