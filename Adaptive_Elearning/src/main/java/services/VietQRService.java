package services;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Random;
import java.util.logging.Logger;

/**
 * Service xử lý VietQR để tạo mã QR thanh toán
 */
public class VietQRService {
    
    private static final Logger LOGGER = Logger.getLogger(VietQRService.class.getName());
    
    // Cấu hình VietQR
    private static final String BANK_CODE = "970422"; // MB Bank
    private static final String ACCOUNT_NUMBER = "0763593290"; // Số tài khoản MB Bank
    private static final String ACCOUNT_NAME = "CHAU VUONG HOANG";
    private static final String QR_TEMPLATE = "compact2";
    
    // Base URL của VietQR API
    private static final String VIETQR_BASE_URL = "https://img.vietqr.io/image";
    
    // Thời gian hiệu lực của mã QR (20 phút)
    private static final int QR_VALIDITY_MINUTES = 20;
    
    /**
     * Tạo URL QR Code cho thanh toán
     * @param amount Số tiền thanh toán
     * @param orderId ID đơn hàng
     * @param description Mô tả thanh toán
     * @return URL của QR code
     */
    public String generateQRUrl(double amount, String orderId, String description) {
        try {
            // Format số tiền (loại bỏ phần thập phân)
            long amountLong = Math.round(amount);
            
            // Tạo nội dung chuyển khoản
            String transferContent = String.format("FlyUp %s %s", orderId, description);
            
            // Encode nội dung để tránh lỗi URL
            String encodedContent = URLEncoder.encode(transferContent, "UTF-8");
            String encodedAccountName = URLEncoder.encode(ACCOUNT_NAME, "UTF-8");
            
            // Tạo URL QR
            String qrUrl = String.format(
                "%s/%s-%s-%s.jpg?amount=%d&addInfo=%s&accountName=%s",
                VIETQR_BASE_URL,
                BANK_CODE,
                ACCOUNT_NUMBER,
                QR_TEMPLATE,
                amountLong,
                encodedContent,
                encodedAccountName
            );
            
            LOGGER.info("Generated QR URL: " + qrUrl);
            return qrUrl;
            
        } catch (UnsupportedEncodingException e) {
            LOGGER.severe("Error encoding QR parameters: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Tạo mã giao dịch ngẫu nhiên
     * @return Mã giao dịch duy nhất
     */
    public String generateTransactionId() {
        // Tạo mã theo format: VNP + timestamp + random
        LocalDateTime now = LocalDateTime.now();
        String timestamp = now.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        
        Random random = new Random();
        int randomNum = random.nextInt(9999) + 1000; // 4 số cuối
        
        return "VNP" + timestamp + randomNum;
    }
    
    /**
     * Tạo mã đơn hàng
     * @param userId ID người dùng
     * @return Mã đơn hàng
     */
    public String generateOrderId(String userId) {
        LocalDateTime now = LocalDateTime.now();
        String timestamp = now.format(DateTimeFormatter.ofPattern("yyyyMMddHHmm"));
        
        Random random = new Random();
        int randomNum = random.nextInt(999) + 100; // 3 số cuối
        
        return "EDU" + timestamp + randomNum;
    }
    
    /**
     * Kiểm tra thời gian hiệu lực của QR
     * @param createdTime Thời gian tạo QR
     * @return true nếu còn hiệu lực
     */
    public boolean isQRValid(LocalDateTime createdTime) {
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime expireTime = createdTime.plusMinutes(QR_VALIDITY_MINUTES);
        return now.isBefore(expireTime);
    }
    
    /**
     * Tính thời gian còn lại của QR (tính bằng giây)
     * @param createdTime Thời gian tạo QR
     * @return Số giây còn lại, -1 nếu đã hết hạn
     */
    public long getRemainingSeconds(LocalDateTime createdTime) {
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime expireTime = createdTime.plusMinutes(QR_VALIDITY_MINUTES);
        
        if (now.isAfter(expireTime)) {
            return -1; // Đã hết hạn
        }
        
        return java.time.Duration.between(now, expireTime).getSeconds();
    }
    
    /**
     * Tạo nội dung chuyển khoản chuẩn
     * @param orderId Mã đơn hàng
     * @param customerName Tên khách hàng
     * @return Nội dung chuyển khoản
     */
    public String createTransferContent(String orderId, String customerName) {
        // Giới hạn độ dài tên khách hàng
        String shortName = customerName;
        if (customerName.length() > 10) {
            shortName = customerName.substring(0, 10);
        }
        
        return String.format("FlyUp %s %s", orderId, shortName);
    }
    
    /**
     * Validate số tiền thanh toán
     * @param amount Số tiền
     * @return true nếu hợp lệ
     */
    public boolean isValidAmount(double amount) {
        return amount > 0 && amount <= 500000000; // Tối đa 500 triệu
    }
    
    /**
     * Format số tiền hiển thị
     * @param amount Số tiền
     * @return Chuỗi số tiền đã format
     */
    public String formatAmount(double amount) {
        return String.format("%,.0f", amount);
    }
    
    /**
     * Lấy thông tin ngân hàng
     * @return Thông tin ngân hàng dưới dạng HTML
     */
    public String getBankInfo() {
        return String.format(
            "<div class='bank-info'>" +
            "<p><strong>Ngân hàng:</strong> MB Bank (Military Bank)</p>" +
            "<p><strong>Số tài khoản:</strong> %s</p>" +
            "<p><strong>Chủ tài khoản:</strong> %s</p>" +
            "</div>",
            ACCOUNT_NUMBER,
            ACCOUNT_NAME
        );
    }
    
    /**
     * Lấy hướng dẫn thanh toán
     * @return HTML hướng dẫn
     */
    public String getPaymentInstructions() {
        return 
            "<div class='payment-instructions'>" +
            "<h4>Hướng dẫn thanh toán:</h4>" +
            "<ol>" +
            "<li>Mở ứng dụng ngân hàng trên điện thoại</li>" +
            "<li>Chọn chức năng quét mã QR</li>" +
            "<li>Quét mã QR bên trên</li>" +
            "<li>Kiểm tra thông tin và xác nhận thanh toán</li>" +
            "<li>Hoàn tất giao dịch</li>" +
            "</ol>" +
            "<p class='note'><strong>Lưu ý:</strong> Vui lòng giữ nguyên nội dung chuyển khoản để hệ thống có thể xác nhận thanh toán.</p>" +
            "</div>";
    }
}