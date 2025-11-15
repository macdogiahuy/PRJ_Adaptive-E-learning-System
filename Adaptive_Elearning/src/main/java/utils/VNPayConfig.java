package utils;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.*;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

/**
 * VNPay Configuration and Utility Class
 * Author: AI Assistant
 * Date: November 1, 2025
 */
public class VNPayConfig {
    
    // VNPay Configuration - SANDBOX for testing
    public static final String VNP_TMN_CODE = "6CUK9JXX"; // Mã website tại VNPay
    public static final String VNP_HASH_SECRET = "6Z17A661GODYPD2C1DULO0XFCI704A15"; // Secret Key (removed ! character)
    public static final String VNP_URL = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html"; // Payment URL
    public static final String VNP_RETURN_URL = "http://localhost:8080/Adaptive_Elearning/vnpay-return"; // Return URL
    public static final String VNP_VERSION = "2.1.0";
    public static final String VNP_COMMAND = "pay";
    public static final String VNP_ORDER_TYPE = "other"; // Loại đơn hàng
    public static final String VNP_CURR_CODE = "VND";
    public static final String VNP_LOCALE = "vn"; // Ngôn ngữ: vn, en
    
    /**
     * Generate HMAC SHA512 hash
     */
    public static String hmacSHA512(String key, String data) {
        try {
            if (key == null || data == null) {
                throw new NullPointerException();
            }
            
            Mac hmac512 = Mac.getInstance("HmacSHA512");
            SecretKeySpec secretKey = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512");
            hmac512.init(secretKey);
            byte[] result = hmac512.doFinal(data.getBytes(StandardCharsets.UTF_8));
            
            StringBuilder sb = new StringBuilder(2 * result.length);
            for (byte b : result) {
                sb.append(String.format("%02x", b & 0xff));
            }
            return sb.toString();
            
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }
    
    /**
     * Build hash data for VNPay - URL encode parameters BEFORE hashing (theo VNPay sample)
     */
    public static String hashAllFields(Map<String, String> fields) {
        // Sort parameters
        List<String> fieldNames = new ArrayList<>(fields.keySet());
        Collections.sort(fieldNames);
        
        StringBuilder sb = new StringBuilder();
        boolean first = true;
        
        for (String fieldName : fieldNames) {
            String fieldValue = fields.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                if (!first) {
                    sb.append("&");
                }
                try {
                    // URL encode với US_ASCII theo VNPay sample
                    sb.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()));
                    sb.append("=");
                    sb.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                } catch (UnsupportedEncodingException e) {
                    // Fallback to non-encoded if error
                    sb.append(fieldName);
                    sb.append("=");
                    sb.append(fieldValue);
                }
                first = false;
            }
        }
        
        String hashData = sb.toString();
        System.out.println("=== HASH DATA (URL ENCODED) ===");
        System.out.println(hashData);
        System.out.println("=== SECRET KEY ===");
        System.out.println(VNP_HASH_SECRET);
        
        String hash = hmacSHA512(VNP_HASH_SECRET, hashData);
        System.out.println("=== GENERATED HASH ===");
        System.out.println(hash);
        
        return hash;
    }
    
    /**
     * Build hash data for verify signature - Parameters đã được URL encode với US_ASCII
     */
    public static String hashAllFieldsForVerify(Map<String, String> fields) {
        // Sort parameters
        List<String> fieldNames = new ArrayList<>(fields.keySet());
        Collections.sort(fieldNames);
        
        StringBuilder sb = new StringBuilder();
        boolean first = true;
        
        for (String fieldName : fieldNames) {
            String fieldValue = fields.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                if (!first) {
                    sb.append("&");
                }
                // Parameters đã được URL encode - không encode lại
                sb.append(fieldName);
                sb.append("=");
                sb.append(fieldValue);
                first = false;
            }
        }
        
        String hashData = sb.toString();
        System.out.println("=== HASH DATA FOR VERIFY ===");
        System.out.println(hashData);
        
        String hash = hmacSHA512(VNP_HASH_SECRET, hashData);
        System.out.println("=== GENERATED HASH FOR VERIFY ===");
        System.out.println(hash);
        
        return hash;
    }
    
    /**
     * Build query URL for VNPay
     */
    public static String buildQueryUrl(Map<String, String> params) throws UnsupportedEncodingException {
        List<String> fieldNames = new ArrayList<>(params.keySet());
        Collections.sort(fieldNames);
        
        StringBuilder query = new StringBuilder();
        Iterator<String> itr = fieldNames.iterator();
        
        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = params.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()));
                query.append('=');
                query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                if (itr.hasNext()) {
                    query.append('&');
                }
            }
        }
        return query.toString();
    }
    
    /**
     * Get current datetime in VNPay format
     */
    public static String getVNPayDate() {
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        Calendar calendar = Calendar.getInstance(TimeZone.getTimeZone("Asia/Ho_Chi_Minh"));
        return formatter.format(calendar.getTime());
    }
    
    /**
     * Get expire datetime (15 minutes from now)
     */
    public static String getExpireDate() {
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        Calendar calendar = Calendar.getInstance(TimeZone.getTimeZone("Asia/Ho_Chi_Minh"));
        calendar.add(Calendar.MINUTE, 15);
        return formatter.format(calendar.getTime());
    }
    
    /**
     * Generate transaction reference (TxnRef)
     */
    public static String getRandomNumber(int len) {
        Random rnd = new Random();
        String chars = "0123456789";
        StringBuilder sb = new StringBuilder(len);
        for (int i = 0; i < len; i++) {
            sb.append(chars.charAt(rnd.nextInt(chars.length())));
        }
        return sb.toString();
    }
}
