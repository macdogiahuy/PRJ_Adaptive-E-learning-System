-- =============================================
-- Update Payment Methods from COD to VNPay
-- Author: AI Assistant
-- Date: November 1, 2025
-- =============================================

USE CourseHubDB;
GO

-- 1. Check current payment methods
SELECT 
    PaymentMethod,
    COUNT(*) as Total
FROM CheckoutCarts
GROUP BY PaymentMethod;
GO

-- 2. Check Gateway values
SELECT 
    Gateway,
    COUNT(*) as Total
FROM CheckoutCarts
GROUP BY Gateway;
GO

-- 3. View sample records with COD
SELECT TOP 10
    CheckoutId,
    UserId,
    TotalAmount,
    PaymentMethod,
    Gateway,
    Status,
    CreatedDate
FROM CheckoutCarts
WHERE PaymentMethod = 'COD'
ORDER BY CreatedDate DESC;
GO

-- =============================================
-- OPTIONAL: Update existing COD records to VNPay
-- Chỉ chạy nếu bạn muốn chuyển đổi dữ liệu cũ
-- =============================================

/*
-- Backup first
SELECT * INTO CheckoutCarts_Backup_20251101
FROM CheckoutCarts;
GO

-- Update COD to VNPay
UPDATE CheckoutCarts
SET 
    PaymentMethod = 'VNPay',
    Gateway = 'VNPAY'
WHERE PaymentMethod = 'COD';
GO

-- Verify update
SELECT 
    PaymentMethod,
    Gateway,
    COUNT(*) as Total
FROM CheckoutCarts
GROUP BY PaymentMethod, Gateway;
GO
*/

-- =============================================
-- Verify database constraints
-- =============================================

-- Check if PaymentMethod column accepts 'VNPay'
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'CheckoutCarts'
AND COLUMN_NAME IN ('PaymentMethod', 'Gateway');
GO

-- =============================================
-- Test new VNPay payment
-- =============================================

DECLARE @TestUserId VARCHAR(50) = '8C3D6D81-2D70-4B5D-87BD-0A9B2D4DA4ED'; -- HuynhGiang59
DECLARE @TestAmount DECIMAL(18, 2) = 100000;
DECLARE @TestSessionId VARCHAR(100) = 'TEST_VNPAY_SESSION';

-- Check if user exists
IF EXISTS (SELECT 1 FROM Users WHERE Id = @TestUserId)
BEGIN
    PRINT 'User exists: ' + @TestUserId;
    
    -- Test checkout with VNPay
    PRINT 'Testing VNPay payment method...';
    PRINT 'Amount: ' + CAST(@TestAmount AS VARCHAR);
    PRINT 'Session: ' + @TestSessionId;
    
    -- Stored procedure should accept 'VNPay' as payment method
    PRINT 'Ready to test sp_ProcessCartCheckout with PaymentMethod = VNPay';
END
ELSE
BEGIN
    PRINT 'User not found!';
END
GO

-- =============================================
-- Statistics after VNPay integration
-- =============================================

-- Total checkouts by payment method
SELECT 
    PaymentMethod,
    COUNT(*) as TotalCheckouts,
    SUM(TotalAmount) as TotalRevenue,
    AVG(TotalAmount) as AvgOrderValue
FROM CheckoutCarts
WHERE Status = 'Completed'
GROUP BY PaymentMethod
ORDER BY TotalCheckouts DESC;
GO

-- Recent VNPay transactions
SELECT TOP 20
    cc.CheckoutId,
    u.UserName,
    cc.TotalAmount,
    cc.PaymentMethod,
    cc.Gateway,
    cc.Status,
    cc.CreatedDate
FROM CheckoutCarts cc
INNER JOIN Users u ON cc.UserId = u.Id
WHERE cc.PaymentMethod = 'VNPay'
ORDER BY cc.CreatedDate DESC;
GO

PRINT '==============================================';
PRINT 'VNPay Integration - Database Verification Complete';
PRINT '==============================================';
