# Hướng dẫn tích hợp VNPay

## 📋 Tổng quan

Đã thay thế COD bằng VNPay - Cổng thanh toán trực tuyến của Việt Nam.

## 🔧 Cấu hình VNPay

### 1. Đăng ký tài khoản VNPay Sandbox (Test)

1. Truy cập: https://sandbox.vnpayment.vn/
2. Đăng ký tài khoản test
3. Sau khi đăng ký, bạn sẽ nhận được:
   - **TMN Code** (Mã website)
   - **Hash Secret** (Khóa bí mật)

### 2. Cập nhật VNPayConfig.java

Mở file `src/main/java/utils/VNPayConfig.java` và cập nhật:

```java
public static final String VNP_TMN_CODE = "YOUR_TMN_CODE"; // Thay bằng TMN Code của bạn
public static final String VNP_HASH_SECRET = "YOUR_SECRET_KEY"; // Thay bằng Hash Secret
public static final String VNP_RETURN_URL = "http://localhost:8080/Adaptive_Elearning/vnpay-return";
```

**VÍ DỤ SANDBOX:**
```java
public static final String VNP_TMN_CODE = "VNPTEST01";
public static final String VNP_HASH_SECRET = "SANDBOXSECRETKEY123456";
```

### 3. Return URL trong VNPay Portal

Đăng nhập vào VNPay Merchant Portal và cấu hình Return URL:
```
http://localhost:8080/Adaptive_Elearning/vnpay-return
```

**Cho production:**
```
https://yourdomain.com/Adaptive_Elearning/vnpay-return
```

## 🏗️ Cấu trúc đã tạo

### Backend Files

1. **utils/VNPayConfig.java**
   - Cấu hình VNPay
   - HMAC SHA512 hashing
   - Build query URL
   - Generate transaction reference

2. **services/VNPayService.java**
   - Create payment URL
   - Verify return signature
   - Get transaction status messages

3. **servlet/VNPayReturnServlet.java**
   - Handle VNPay callback
   - Verify payment
   - Process checkout
   - Update database

4. **servlet/CheckoutServlet.java** (Updated)
   - Redirect to VNPay instead of COD
   - Generate TxnRef
   - Create payment URL

### Frontend Files

1. **cart.jsp** (Updated)
   - Removed COD option
   - Show VNPay option only
   - Updated payment flow

## 🔄 Luồng thanh toán VNPay

```
1. User clicks "Thanh toán" → cart.jsp
2. Select VNPay → showPaymentMethodModal()
3. Click VNPay option → /checkout
4. CheckoutServlet creates VNPay URL → redirect to VNPay
5. User pays on VNPay → VNPay processes payment
6. VNPay redirects back → /vnpay-return
7. VNPayReturnServlet verifies signature → process checkout
8. Update database → send email → redirect to success page
```

## 📊 Database Changes

Không cần thay đổi database schema. Payment method sẽ được lưu là "VNPay" thay vì "COD":

```sql
-- Trong bảng CheckoutCarts
PaymentMethod VARCHAR(20) = 'VNPay'
Gateway VARCHAR(50) = 'VNPAY'
```

## 🧪 Testing với VNPay Sandbox

### Thông tin test card:

**Ngân hàng NCB (Ngân hàng Quốc Dân):**
- Số thẻ: `9704198526191432198`
- Tên chủ thẻ: `NGUYEN VAN A`
- Ngày phát hành: `07/15`
- Mật khẩu OTP: `123456`

**Các ngân hàng khác:**
- Tham khảo: https://sandbox.vnpayment.vn/apis/docs/huong-dan-tich-hop/

### Test flow:

1. **Add courses to cart**
2. **Click "Thanh toán"**
3. **Select VNPay**
4. **Được redirect đến VNPay sandbox**
5. **Chọn ngân hàng NCB**
6. **Nhập thông tin test card**
7. **Nhập OTP: 123456**
8. **Xác nhận thanh toán**
9. **Được redirect về /vnpay-return**
10. **Checkout successful!**

## 🔒 Security Features

### 1. HMAC SHA512 Signature
```java
String signValue = VNPayConfig.hashAllFields(params);
boolean isValid = signValue.equals(vnpSecureHash);
```

### 2. Amount Verification
```java
long vnpAmount = Long.parseLong(params.get("vnp_Amount"));
// Verify with session amount
```

### 3. IP Address Tracking
```java
String ipAddress = request.getRemoteAddr();
vnpParams.put("vnp_IpAddr", ipAddress);
```

## 📱 Response Codes

| Code | Meaning |
|------|---------|
| 00 | Giao dịch thành công |
| 07 | Trừ tiền thành công (nghi ngờ gian lận) |
| 09 | Chưa đăng ký InternetBanking |
| 10 | Xác thực sai quá 3 lần |
| 11 | Hết hạn chờ thanh toán |
| 12 | Thẻ bị khóa |
| 13 | Sai mật khẩu OTP |
| 24 | Khách hàng hủy giao dịch |
| 51 | Không đủ số dư |
| 65 | Vượt hạn mức giao dịch |
| 75 | Ngân hàng bảo trì |

## ⚙️ Production Deployment

### 1. Update VNPayConfig for production:
```java
public static final String VNP_TMN_CODE = "YOUR_PRODUCTION_TMN";
public static final String VNP_HASH_SECRET = "YOUR_PRODUCTION_SECRET";
public static final String VNP_URL = "https://vnpayment.vn/paymentv2/vpcpay.html"; // Production URL
public static final String VNP_RETURN_URL = "https://yourdomain.com/Adaptive_Elearning/vnpay-return";
```

### 2. SSL Certificate Required
VNPay yêu cầu HTTPS cho production. Đảm bảo:
- ✅ Domain có SSL certificate
- ✅ Return URL dùng HTTPS
- ✅ Server hỗ trợ TLS 1.2+

### 3. Whitelist IP
Đăng nhập VNPay Portal và whitelist server IP của bạn.

## 🐛 Troubleshooting

### Error: Invalid Signature
```
Solution: 
- Check VNP_HASH_SECRET is correct
- Check parameter sorting (must be alphabetical)
- Check URL encoding
```

### Error: Invalid TMN Code
```
Solution:
- Verify VNP_TMN_CODE in VNPayConfig.java
- Check TMN Code status in VNPay Portal
```

### Error: Return URL not called
```
Solution:
- Check VNP_RETURN_URL is accessible
- Verify URL is whitelisted in VNPay Portal
- Check firewall/network settings
```

## 📝 Files Modified

### Created:
- ✅ `utils/VNPayConfig.java` - Configuration
- ✅ `services/VNPayService.java` - Payment service
- ✅ `servlet/VNPayReturnServlet.java` - Callback handler

### Modified:
- ✅ `servlet/CheckoutServlet.java` - Removed COD, added VNPay
- ✅ `cart.jsp` - Updated UI to show VNPay only

### Removed:
- ❌ COD payment option
- ❌ VietQR payment (replaced by VNPay)

## 🎯 Next Steps

1. **Đăng ký VNPay Sandbox:**
   - https://sandbox.vnpayment.vn/

2. **Update VNPayConfig.java:**
   - Add TMN Code
   - Add Hash Secret

3. **Test payment flow:**
   - Use test card numbers
   - Verify checkout process

4. **Production deployment:**
   - Get production credentials
   - Update configuration
   - Setup SSL
   - Whitelist IP

## 📞 Support

- VNPay Sandbox: https://sandbox.vnpayment.vn/
- VNPay Documentation: https://sandbox.vnpayment.vn/apis/docs/
- VNPay Hotline: 1900 55 55 77

---

**Author:** AI Assistant  
**Date:** November 1, 2025  
**Version:** 1.0.0
