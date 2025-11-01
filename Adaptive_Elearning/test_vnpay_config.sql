-- =============================================
-- VNPay Configuration Test
-- Verify VNPay integration with real credentials
-- Author: AI Assistant
-- Date: November 1, 2025
-- =============================================

USE CourseHubDB;
GO

PRINT '==============================================';
PRINT 'VNPAY CONFIGURATION TEST';
PRINT '==============================================';
PRINT '';

-- Test VNPay Configuration
PRINT '1. VNPay Credentials:';
PRINT '   TMN Code: 6CUK9JXX';
PRINT '   Hash Secret: 6Z17A661GODYPD2C1DUL00XFC!704A16';
PRINT '   Payment URL: https://sandbox.vnpayment.vn/paymentv2/vpcpay.html';
PRINT '   Return URL: http://localhost:8080/Adaptive_Elearning/vnpay-return';
PRINT '';

-- Test User
DECLARE @TestUserId VARCHAR(50) = '8C3D6D81-2D70-4B5D-87BD-0A9B2D4DA4ED'; -- HuynhGiang59

PRINT '2. Test User:';
SELECT 
    Id,
    UserName,
    Email,
    Role
FROM Users
WHERE Id = @TestUserId;
PRINT '';

-- Test Courses for Cart
PRINT '3. Available Courses for Testing:';
SELECT TOP 5
    c.Id,
    c.Title,
    c.Price,
    i.FullName as InstructorName
FROM Courses c
INNER JOIN Instructors i ON c.InstructorId = i.Id
WHERE c.IsActive = 1
AND c.Price > 0
ORDER BY c.Id DESC;
PRINT '';

-- Test Payment Flow
PRINT '4. VNPay Payment Flow Test:';
PRINT '   Step 1: User adds courses to cart';
PRINT '   Step 2: Click "Thanh toán" button';
PRINT '   Step 3: Select VNPay payment method';
PRINT '   Step 4: Redirect to VNPay with params:';
PRINT '           - vnp_TmnCode: 6CUK9JXX';
PRINT '           - vnp_Amount: [TotalAmount * 100]';
PRINT '           - vnp_TxnRef: [Random 8 digits]';
PRINT '           - vnp_ReturnUrl: http://localhost:8080/Adaptive_Elearning/vnpay-return';
PRINT '   Step 5: User pays on VNPay sandbox';
PRINT '   Step 6: VNPay redirects back to vnpay-return';
PRINT '   Step 7: Verify signature with Hash Secret';
PRINT '   Step 8: Process checkout if signature valid';
PRINT '';

-- Test Card Information (Sandbox)
PRINT '5. VNPay Sandbox Test Card:';
PRINT '   Bank: NCB (Ngân hàng Quốc Dân)';
PRINT '   Card Number: 9704198526191432198';
PRINT '   Card Holder: NGUYEN VAN A';
PRINT '   Issue Date: 07/15';
PRINT '   OTP: 123456';
PRINT '';

-- Check existing checkouts
PRINT '6. Recent Checkout Records:';
SELECT TOP 5
    CheckoutId,
    UserId,
    TotalAmount,
    PaymentMethod,
    Gateway,
    Status
FROM CheckoutCarts
ORDER BY CheckoutId DESC;
PRINT '';

-- Verify database schema supports VNPay
PRINT '7. Database Schema Verification:';
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'CheckoutCarts'
AND COLUMN_NAME IN ('PaymentMethod', 'Gateway', 'TransactionId');
PRINT '';

PRINT '==============================================';
PRINT 'VNPAY READY TO TEST!';
PRINT '==============================================';
PRINT '';
PRINT 'Next Steps:';
PRINT '1. Start Tomcat: run-tomcat10.bat';
PRINT '2. Login as: HuynhGiang59 / 123';
PRINT '3. Add courses to cart';
PRINT '4. Click "Thanh toán"';
PRINT '5. Select VNPay';
PRINT '6. Use test card on VNPay sandbox';
PRINT '7. Verify checkout success';
PRINT '';
