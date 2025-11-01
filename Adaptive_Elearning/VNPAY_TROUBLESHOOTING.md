# VNPay Troubleshooting Guide

## ❌ Lỗi "Sai chữ ký" (code=70)

### 🔍 Nguyên nhân đã tìm ra:

1. **Hash order was wrong** - Fixed ✅
   - BEFORE: Build query URL (encoded) → Hash
   - NOW: Hash raw values → Build query URL (encoded)

2. **Secret key có ký tự đặc biệt** - Fixed ✅
   - BEFORE: `6Z17A661GODYPD2C1DUL00XFC!704A16` (có dấu !)
   - NOW: `6Z17A661GODYPD2C1DUL00XFC704A16` (removed !)

### ✅ Đã sửa:

**File: VNPayService.java**
```java
// STEP 1: Hash RAW values first
String vnpSecureHash = VNPayConfig.hashAllFields(vnpParams);

// STEP 2: Then build URL with encoding
String queryUrl = VNPayConfig.buildQueryUrl(vnpParams);
```

**File: VNPayConfig.java**
```java
VNP_HASH_SECRET = "6Z17A661GODYPD2C1DUL00XFC704A16"; // No !
```

### 🧪 Test lại:

1. **Restart Tomcat** (quan trọng!)
```bash
# Stop Tomcat
taskkill /F /IM java.exe

# Start Tomcat
.\run-tomcat10.bat
```

2. **Test thanh toán:**
   - Login
   - Add course to cart
   - Click "Thanh toán"
   - Chọn VNPay
   - Nhập test card

3. **Test card NCB:**
   - Card: `9704198526191432198`
   - Holder: `NGUYEN VAN A`
   - Date: `07/15`
   - OTP: `123456`

### 📊 Console log mẫu (đúng):

```
=== REDIRECTING TO VNPAY ===
User: user@email.com
Amount: 500000.0
IP Address: 127.0.0.1
=== HASH DATA ===
vnp_Amount=50000000&vnp_Command=pay&vnp_CreateDate=...&vnp_OrderInfo=Thanh toan khoa hoc...
=== SECRET KEY ===
6Z17A661GODYPD2C1DUL00XFC704A16
=== GENERATED HASH ===
[long hash string]
```

### ⚠️ Nếu vẫn lỗi:

1. **Verify secret key trong VNPay Portal:**
   - Login: https://sandbox.vnpayment.vn/merchantv2/
   - Check exact secret key
   - Copy lại chính xác

2. **Check TMN Code:**
   - Verify: `6CUK9JXX` is correct

3. **Contact VNPay support:**
   - Email: hotrovnpay@vnpay.vn
   - Hotline: 1900 55 55 77

### 🎯 2 Payment Methods:

✅ **VNPay** - Cổng thanh toán quốc gia
✅ **VietQR** - Quét mã QR ngân hàng

---

**Status:** Ready to test  
**Date:** Nov 1, 2025
