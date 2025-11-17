package test;

import utils.VNPayConfig;
import java.util.HashMap;
import java.util.Map;

/**
 * Test VNPay Signature Generation
 * Author: AI Assistant  
 * Date: November 1, 2025
 */
public class TestVNPaySignature {
    
    public static void main(String[] args) {
        System.out.println("=== VNPAY SIGNATURE TEST ===\n");
        
        // Sample parameters (from your log)
        Map<String, String> params = new HashMap<>();
        params.put("vnp_Version", "2.1.0");
        params.put("vnp_Command", "pay");
        params.put("vnp_TmnCode", "6CUK9JXX");
        params.put("vnp_Amount", "50000000"); // 500,000 VND * 100
        params.put("vnp_CurrCode", "VND");
        params.put("vnp_TxnRef", "18079751");
        params.put("vnp_OrderInfo", "Thanh toan khoa hoc - de180551chauvuonghoang@gmail.com");
        params.put("vnp_OrderType", "other");
        params.put("vnp_Locale", "vn");
        params.put("vnp_ReturnUrl", "http://localhost:8080/Adaptive_Elearning/vnpay-return");
        params.put("vnp_IpAddr", "127.0.0.1");
        params.put("vnp_CreateDate", "20251101204324");
        params.put("vnp_ExpireDate", "20251101205824");
        
        System.out.println("1. Parameters:");
        params.forEach((k, v) -> System.out.println("   " + k + " = " + v));
        
        System.out.println("\n2. Secret Key:");
        System.out.println("   " + VNPayConfig.VNP_HASH_SECRET);
        
        System.out.println("\n3. Generating hash...");
        String hash = VNPayConfig.hashAllFields(params);
        
        System.out.println("\n4. Expected vs Actual:");
        System.out.println("   Actual: " + hash);
        System.out.println("   From Log: b2aa53fcb32bf2eaf748cfc6f8d861737524fcd7498f111201939a85fa43a7777f7c5229416eb92c9781846ec5581c96ec153ff8f90d580cab72da592c8f9428");
        
        boolean match = hash.equals("b2aa53fcb32bf2eaf748cfc6f8d861737524fcd7498f111201939a85fa43a7777f7c5229416eb92c9781846ec5581c96ec153ff8f90d580cab72da592c8f9428");
        System.out.println("\n5. Match: " + (match ? "✓ YES" : "✗ NO"));
        
        if (!match) {
            System.out.println("\n=== TROUBLESHOOTING ===");
            System.out.println("Possible issues:");
            System.out.println("1. Secret key incorrect");
            System.out.println("2. Parameter values differ");
            System.out.println("3. Hash algorithm issue");
            System.out.println("4. Character encoding problem");
        }
        
        System.out.println("\n=== END TEST ===");
    }
}
