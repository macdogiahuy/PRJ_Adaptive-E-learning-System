package services;

import utils.VNPayConfig;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

/**
 * VNPay Payment Service
 * Author: AI Assistant
 * Date: November 1, 2025
 */
public class VNPayService {
    
    /**
     * Create VNPay payment URL
     * 
     * @param amount Amount in VND (must be integer, no decimal)
     * @param orderInfo Order description
     * @param txnRef Transaction reference (order ID)
     * @param ipAddress User IP address
     * @return Payment URL
     */
    public String createPaymentUrl(long amount, String orderInfo, String txnRef, String ipAddress) 
            throws UnsupportedEncodingException {
        
        Map<String, String> vnpParams = new HashMap<>();
        
        // Required parameters (RAW VALUES - not encoded yet)
        vnpParams.put("vnp_Version", VNPayConfig.VNP_VERSION);
        vnpParams.put("vnp_Command", VNPayConfig.VNP_COMMAND);
        vnpParams.put("vnp_TmnCode", VNPayConfig.VNP_TMN_CODE);
        vnpParams.put("vnp_Amount", String.valueOf(amount * 100)); // VNPay requires amount * 100
        vnpParams.put("vnp_CurrCode", VNPayConfig.VNP_CURR_CODE);
        vnpParams.put("vnp_TxnRef", txnRef);
        vnpParams.put("vnp_OrderInfo", orderInfo); // Raw value, not encoded
        vnpParams.put("vnp_OrderType", VNPayConfig.VNP_ORDER_TYPE);
        vnpParams.put("vnp_Locale", VNPayConfig.VNP_LOCALE);
        vnpParams.put("vnp_ReturnUrl", VNPayConfig.VNP_RETURN_URL);
        vnpParams.put("vnp_IpAddr", ipAddress);
        vnpParams.put("vnp_CreateDate", VNPayConfig.getVNPayDate());
        vnpParams.put("vnp_ExpireDate", VNPayConfig.getExpireDate());
        

      
        
        // STEP 1: Generate secure hash from RAW values (not encoded)
        String vnpSecureHash = VNPayConfig.hashAllFields(vnpParams);
        
        // STEP 2: Build query string with URL encoding
        String queryUrl = VNPayConfig.buildQueryUrl(vnpParams);
        
        // STEP 3: Build final payment URL
        String paymentUrl = VNPayConfig.VNP_URL + "?" + queryUrl + "&vnp_SecureHash=" + vnpSecureHash;
        
        System.out.println("=== VNPAY PAYMENT URL CREATED ===");
        System.out.println("TxnRef: " + txnRef);
        System.out.println("Amount: " + amount + " VND");
        System.out.println("Payment URL: " + paymentUrl);
        
        return paymentUrl;
    }
    
    /**
     * Verify VNPay return signature
     * 
     * @param params Parameters from VNPay return (raw values - không encode)
     * @return true if signature is valid
     */
    public boolean verifyReturnSignature(Map<String, String> params) {
        String vnpSecureHash = params.get("vnp_SecureHash");
        params.remove("vnp_SecureHash");
        params.remove("vnp_SecureHashType");
        
        // Dùng method hashAllFieldsForVerify - KHÔNG encode
        String signValue = VNPayConfig.hashAllFieldsForVerify(params);
        
        return signValue.equals(vnpSecureHash);
    }
    
    /**
     * Get transaction status from VNPay response code
     * 
     * @param responseCode VNPay response code
     * @return Status message
     */
    public String getTransactionStatus(String responseCode) {
        switch (responseCode) {
            case "00":
                return "Giao dịch thành công";
            case "07":
                return "Trừ tiền thành công. Giao dịch bị nghi ngờ (liên quan tới lừa đảo, giao dịch bất thường).";
            case "09":
                return "Giao dịch không thành công do: Thẻ/Tài khoản của khách hàng chưa đăng ký dịch vụ InternetBanking tại ngân hàng.";
            case "10":
                return "Giao dịch không thành công do: Khách hàng xác thực thông tin thẻ/tài khoản không đúng quá 3 lần";
            case "11":
                return "Giao dịch không thành công do: Đã hết hạn chờ thanh toán. Xin quý khách vui lòng thực hiện lại giao dịch.";
            case "12":
                return "Giao dịch không thành công do: Thẻ/Tài khoản của khách hàng bị khóa.";
            case "13":
                return "Giao dịch không thành công do Quý khách nhập sai mật khẩu xác thực giao dịch (OTP). Xin quý khách vui lòng thực hiện lại giao dịch.";
            case "24":
                return "Giao dịch không thành công do: Khách hàng hủy giao dịch";
            case "51":
                return "Giao dịch không thành công do: Tài khoản của quý khách không đủ số dư để thực hiện giao dịch.";
            case "65":
                return "Giao dịch không thành công do: Tài khoản của Quý khách đã vượt quá hạn mức giao dịch trong ngày.";
            case "75":
                return "Ngân hàng thanh toán đang bảo trì.";
            case "79":
                return "Giao dịch không thành công do: KH nhập sai mật khẩu thanh toán quá số lần quy định. Xin quý khách vui lòng thực hiện lại giao dịch";
            default:
                return "Giao dịch thất bại";
        }
    }
}
