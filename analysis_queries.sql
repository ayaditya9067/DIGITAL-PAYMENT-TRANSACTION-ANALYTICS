-- SQL Questions--

-- Q1: Display all customers from Mumbai.--
SELECT CustomerID, FirstName, LastName, Email, PhoneNumber, City,CustomerStatus
FROM Customer
WHERE City = 'Mumbai';

-- Q2: Display all active merchants.
SELECT 
    MerchantID,
    MerchantName,
    BusinessType,
    City,
    MerchantStatus
FROM Merchant
WHERE MerchantStatus = 'Active';

-- Q3: List all successful transactions.
SELECT 
    TransactionID,
    CustomerID,
    MerchantID,
    Amount,
    TransactionType,
    TransactionStatus,
    TransactionDate
FROM Transaction
WHERE TransactionStatus = 'Success';

-- Q4: Find transactions with Amount > ₹2,000.
SELECT 
    TransactionID,
    CustomerID,
    MerchantID,
    Amount,
    TransactionType,
    TransactionStatus,
    TransactionDate
FROM Transaction
WHERE Amount > 2000.00;

-- Q5: Display transactions made through UPI.
SELECT 
    TransactionID,
    CustomerID,
    MerchantID,
    PaymentMethodID,
    Amount,
    PaymentChannel,
    TransactionStatus
FROM Transaction
WHERE PaymentChannel = 'UPI';

-- Q6: Display failed transactions with their failure reasons.
SELECT 
    TransactionID,
    CustomerID,
    MerchantID,
    Amount,
    TransactionStatus,
    FailureReason
FROM Transaction
WHERE TransactionStatus = 'Failed';


-- Q7: Find customers registered after 1 March 2025.
SELECT 
    CustomerID,
    FirstName,
    LastName,
    Email,
    RegistrationDate,
    CustomerStatus
FROM Customer
WHERE RegistrationDate > '2025-03-01';


-- Q8: Find minimum, maximum and average transaction amount.
SELECT 
    MIN(Amount) AS MinTransactionAmount,
    MAX(Amount) AS MaxTransactionAmount,
    ROUND(AVG(Amount), 2) AS AvgTransactionAmount
FROM Transaction;


-- Q9: Count total transactions.
SELECT 
    COUNT(TransactionID) AS TotalTransactions
FROM Transaction;


-- Q10: Count transactions by status.
SELECT 
    TransactionStatus,
    COUNT(TransactionID) AS TransactionCount
FROM Transaction
GROUP BY TransactionStatus
ORDER BY TransactionCount DESC;


-- Q11: Calculate total transaction value.
SELECT 
    SUM(Amount) AS TotalTransactionValue
FROM Transaction;

-- Q12: Calculate transaction count and total value by payment channel.
SELECT 
    PaymentChannel,
    COUNT(TransactionID) AS TransactionCount,
    SUM(Amount) AS TotalTransactionValue
FROM Transaction
GROUP BY PaymentChannel
ORDER BY TotalTransactionValue DESC;



-- Q13: Join Transaction and Customer to show customer name, date, amount and status.
SELECT 
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    t.TransactionDate,
    t.Amount,
    t.TransactionStatus
FROM `Transaction` t
JOIN Customer c ON t.CustomerID = c.CustomerID;

-- Q14: Join Transaction and Merchant to show merchant name and transaction value.
SELECT 
    m.MerchantName,
    t.Amount AS TransactionValue
FROM `Transaction` t
JOIN Merchant m ON t.MerchantID = m.MerchantID;


-- Q15: Find the top 5 merchants by successful transaction value.
SELECT 
    m.MerchantID,
    m.MerchantName,
    SUM(t.Amount) AS TotalSuccessfulValue
FROM Merchant m
JOIN `Transaction` t ON m.MerchantID = t.MerchantID
WHERE t.TransactionStatus = 'Success'
GROUP BY m.MerchantID, m.MerchantName
ORDER BY TotalSuccessfulValue DESC
LIMIT 5;


-- Q16: Find transaction count and total value by merchant.
SELECT 
    m.MerchantID,
    m.MerchantName,
    COUNT(t.TransactionID) AS TransactionCount,
    SUM(t.Amount) AS TotalTransactionValue
FROM Merchant m
LEFT JOIN `Transaction` t ON m.MerchantID = t.MerchantID
GROUP BY m.MerchantID, m.MerchantName
ORDER BY TotalTransactionValue DESC;


-- Q17: Find average transaction value by merchant.
SELECT 
    m.MerchantID,
    m.MerchantName,
    ROUND(AVG(t.Amount), 2) AS AvgTransactionValue
FROM Merchant m
JOIN `Transaction` t ON m.MerchantID = t.MerchantID
GROUP BY m.MerchantID, m.MerchantName
ORDER BY AvgTransactionValue DESC;


-- Q18: Calculate success rate by payment method type.
SELECT 
    pm.MethodType,
    COUNT(t.TransactionID) AS TotalTransactions,
    SUM(CASE WHEN t.TransactionStatus = 'Success' THEN 1 ELSE 0 END) AS SuccessfulTransactions,
    ROUND(
        (SUM(CASE WHEN t.TransactionStatus = 'Success' THEN 1 ELSE 0 END) * 100.0) / COUNT(t.TransactionID), 
        2
    ) AS SuccessRatePercentage
FROM PaymentMethod pm
JOIN `Transaction` t ON pm.PaymentMethodID = t.PaymentMethodID
GROUP BY pm.MethodType
ORDER BY SuccessRatePercentage DESC;


-- Q19: Calculate failure rate by payment channel.
SELECT 
    PaymentChannel,
    COUNT(TransactionID) AS TotalTransactions,
    SUM(CASE WHEN TransactionStatus = 'Failed' THEN 1 ELSE 0 END) AS FailedTransactions,
    ROUND(
        (SUM(CASE WHEN TransactionStatus = 'Failed' THEN 1 ELSE 0 END) * 100.0) / COUNT(TransactionID), 
        2
    ) AS FailureRatePercentage
FROM `Transaction`
GROUP BY PaymentChannel
ORDER BY FailureRatePercentage DESC;


-- Q20: Find the most common failure reason.
SELECT 
    FailureReason,
    COUNT(TransactionID) AS FailureCount
FROM `Transaction`
WHERE TransactionStatus = 'Failed' AND FailureReason IS NOT NULL
GROUP BY FailureReason
ORDER BY FailureCount DESC
LIMIT 1;


-- Q21: Find customers with more than 5 transactions.
SELECT 
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    COUNT(t.TransactionID) AS TotalTransactions
FROM Customer c
JOIN `Transaction` t ON c.CustomerID = t.CustomerID
GROUP BY c.CustomerID, CustomerName
HAVING COUNT(t.TransactionID) > 5
ORDER BY TotalTransactions DESC;


-- Q22: Find customers whose total transaction value exceeds ₹10,000.
SELECT 
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    SUM(t.Amount) AS TotalTransactionValue
FROM Customer c
JOIN `Transaction` t ON c.CustomerID = t.CustomerID
GROUP BY c.CustomerID, CustomerName
HAVING SUM(t.Amount) > 10000.00
ORDER BY TotalTransactionValue DESC;


-- Q23: Find merchants with more than 3 failed transactions.
SELECT 
    m.MerchantID,
    m.MerchantName,
    COUNT(t.TransactionID) AS FailedTransactionCount
FROM Merchant m
JOIN `Transaction` t ON m.MerchantID = t.MerchantID
WHERE t.TransactionStatus = 'Failed'
GROUP BY m.MerchantID, m.MerchantName
HAVING COUNT(t.TransactionID) > 3
ORDER BY FailedTransactionCount DESC;


-- Q24: Find monthly transaction volume and transaction value.
SELECT 
    DATE_FORMAT(TransactionDate, '%Y-%m') AS TransactionMonth,
    COUNT(TransactionID) AS TransactionVolume,
    SUM(Amount) AS TotalTransactionValue
FROM `Transaction`
GROUP BY DATE_FORMAT(TransactionDate, '%Y-%m')
ORDER BY TransactionMonth ASC;


-- Q25: Find daily transaction volume.
SELECT 
    DATE(TransactionDate) AS TransactionDay,
    COUNT(TransactionID) AS DailyTransactionVolume,
    SUM(Amount) AS DailyTransactionValue
FROM `Transaction`
GROUP BY DATE(TransactionDate)
ORDER BY TransactionDay ASC;


-- Q26: Calculate completed refund amount by merchant.
SELECT 
    m.MerchantID,
    m.MerchantName,
    SUM(r.RefundAmount) AS TotalCompletedRefundAmount
FROM Merchant m
JOIN `Transaction` t ON m.MerchantID = t.MerchantID
JOIN Refund r ON t.TransactionID = r.TransactionID
WHERE r.RefundStatus = 'Completed'
GROUP BY m.MerchantID, m.MerchantName
ORDER BY TotalCompletedRefundAmount DESC;


-- Q27: Find merchants with the highest refund count.
SELECT 
    m.MerchantID,
    m.MerchantName,
    COUNT(r.RefundID) AS TotalRefundCount
FROM Merchant m
JOIN `Transaction` t ON m.MerchantID = t.MerchantID
JOIN Refund r ON t.TransactionID = r.TransactionID
GROUP BY m.MerchantID, m.MerchantName
ORDER BY TotalRefundCount DESC;


-- Q28: Calculate settlement amount by settlement status.
SELECT 
    SettlementStatus,
    COUNT(SettlementID) AS TotalSettlements,
    SUM(SettlementAmount) AS TotalSettlementAmount
FROM Settlement
GROUP BY SettlementStatus
ORDER BY TotalSettlementAmount DESC;


-- Q29: Find pending settlement amount by merchant.
SELECT 
    m.MerchantID,
    m.MerchantName,
    SUM(s.SettlementAmount) AS PendingSettlementAmount
FROM Merchant m
JOIN Settlement s ON m.MerchantID = s.MerchantID
WHERE s.SettlementStatus = 'Pending'
GROUP BY m.MerchantID, m.MerchantName
ORDER BY PendingSettlementAmount DESC;


-- Q30: Calculate total processing fee collected.
SELECT 
    FeeType,
    COUNT(FeeID) AS FeeCount,
    SUM(FeeAmount) AS TotalFeeCollected
FROM TransactionFee
GROUP BY FeeType
WITH ROLLUP;


-- Q31: Find the top 5 customers by successful transaction value.
SELECT 
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    SUM(t.Amount) AS TotalSuccessfulValue
FROM Customer c
JOIN `Transaction` t ON c.CustomerID = t.CustomerID
WHERE t.TransactionStatus = 'Success'
GROUP BY c.CustomerID, CustomerName
ORDER BY TotalSuccessfulValue DESC
LIMIT 5;


-- Q32: Find the average transaction amount for each customer.
SELECT 
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    COUNT(t.TransactionID) AS TotalTransactions,
    ROUND(AVG(t.Amount), 2) AS AvgTransactionAmount
FROM Customer c
JOIN `Transaction` t ON c.CustomerID = t.CustomerID
GROUP BY c.CustomerID, CustomerName
ORDER BY AvgTransactionAmount DESC;


-- Q33: Find customers who have both successful and failed transactions.
SELECT 
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    SUM(CASE WHEN t.TransactionStatus = 'Success' THEN 1 ELSE 0 END) AS SuccessfulCount,
    SUM(CASE WHEN t.TransactionStatus = 'Failed' THEN 1 ELSE 0 END) AS FailedCount
FROM Customer c
JOIN `Transaction` t ON c.CustomerID = t.CustomerID
GROUP BY c.CustomerID, CustomerName
HAVING SuccessfulCount > 0 AND FailedCount > 0;


-- Q34: Find the merchant with the highest average successful transaction value.
SELECT 
    m.MerchantID,
    m.MerchantName,
    ROUND(AVG(t.Amount), 2) AS AvgSuccessfulTransactionValue
FROM Merchant m
JOIN `Transaction` t ON m.MerchantID = t.MerchantID
WHERE t.TransactionStatus = 'Success'
GROUP BY m.MerchantID, m.MerchantName
ORDER BY AvgSuccessfulTransactionValue DESC
LIMIT 1;


-- Q35: Calculate the success rate for each merchant.
SELECT 
    m.MerchantID,
    m.MerchantName,
    COUNT(t.TransactionID) AS TotalTransactions,
    SUM(CASE WHEN t.TransactionStatus = 'Success' THEN 1 ELSE 0 END) AS SuccessfulTransactions,
    ROUND(
        (SUM(CASE WHEN t.TransactionStatus = 'Success' THEN 1 ELSE 0 END) * 100.0) / NULLIF(COUNT(t.TransactionID), 0), 
        2
    ) AS SuccessRatePercentage
FROM Merchant m
LEFT JOIN `Transaction` t ON m.MerchantID = t.MerchantID
GROUP BY m.MerchantID, m.MerchantName
ORDER BY SuccessRatePercentage DESC;


-- Q36: Find merchants where failed transactions are more than successful transactions.
SELECT 
    m.MerchantID,
    m.MerchantName,
    SUM(CASE WHEN t.TransactionStatus = 'Failed' THEN 1 ELSE 0 END) AS FailedCount,
    SUM(CASE WHEN t.TransactionStatus = 'Success' THEN 1 ELSE 0 END) AS SuccessCount
FROM Merchant m
JOIN `Transaction` t ON m.MerchantID = t.MerchantID
GROUP BY m.MerchantID, m.MerchantName
HAVING FailedCount > SuccessCount;


-- Q37: Find the payment channel generating the highest successful transaction value.
SELECT 
    PaymentChannel,
    SUM(Amount) AS TotalSuccessfulValue
FROM `Transaction`
WHERE TransactionStatus = 'Success'
GROUP BY PaymentChannel
ORDER BY TotalSuccessfulValue DESC
LIMIT 1;


-- Q38: Compare average transaction value across payment channels.
SELECT 
    PaymentChannel,
    COUNT(TransactionID) AS TotalTransactions,
    ROUND(AVG(Amount), 2) AS AvgTransactionValue,
    ROUND(AVG(CASE WHEN TransactionStatus = 'Success' THEN Amount ELSE NULL END), 2) AS AvgSuccessfulValue
FROM `Transaction`
GROUP BY PaymentChannel
ORDER BY AvgTransactionValue DESC;


-- Q39: Find the most common failure reason for each payment channel.
WITH ChannelFailures AS (
    SELECT 
        PaymentChannel,
        FailureReason,
        COUNT(TransactionID) AS FailureCount,
        ROW_NUMBER() OVER (PARTITION BY PaymentChannel ORDER BY COUNT(TransactionID) DESC) AS rn
    FROM `Transaction`
    WHERE TransactionStatus = 'Failed' AND FailureReason IS NOT NULL
    GROUP BY PaymentChannel, FailureReason
)
SELECT 
    PaymentChannel,
    FailureReason AS MostCommonFailureReason,
    FailureCount
FROM ChannelFailures
WHERE rn = 1;


-- Q40: Find customers whose total successful transaction value is above the overall average customer transaction value.
WITH CustomerTotals AS (
    SELECT 
        c.CustomerID,
        CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
        SUM(t.Amount) AS TotalSuccessfulValue
    FROM Customer c
    JOIN `Transaction` t ON c.CustomerID = t.CustomerID
    WHERE t.TransactionStatus = 'Success'
    GROUP BY c.CustomerID, CustomerName
)
SELECT 
    CustomerID,
    CustomerName,
    TotalSuccessfulValue
FROM CustomerTotals
WHERE TotalSuccessfulValue > (
    SELECT AVG(TotalSuccessfulValue) FROM CustomerTotals
)
ORDER BY TotalSuccessfulValue DESC;



-- Q41: Find the total refunded amount and refund count for each merchant.
SELECT 
    m.MerchantID,
    m.MerchantName,
    COUNT(r.RefundID) AS TotalRefundCount,
    COALESCE(SUM(r.RefundAmount), 0) AS TotalRefundedAmount
FROM Merchant m
JOIN `Transaction` t ON m.MerchantID = t.MerchantID
JOIN Refund r ON t.TransactionID = r.TransactionID
WHERE r.RefundStatus = 'Completed'
GROUP BY m.MerchantID, m.MerchantName
ORDER BY TotalRefundedAmount DESC;


-- Q42: Find merchants where refunded amount is greater than the average refund amount across all merchants.
WITH MerchantRefunds AS (
    SELECT 
        m.MerchantID,
        m.MerchantName,
        SUM(r.RefundAmount) AS TotalMerchantRefund
    FROM Merchant m
    JOIN `Transaction` t ON m.MerchantID = t.MerchantID
    JOIN Refund r ON t.TransactionID = r.TransactionID
    WHERE r.RefundStatus = 'Completed'
    GROUP BY m.MerchantID, m.MerchantName
)
SELECT 
    MerchantID,
    MerchantName,
    TotalMerchantRefund
FROM MerchantRefunds
WHERE TotalMerchantRefund > (
    SELECT AVG(TotalMerchantRefund) FROM MerchantRefunds
)
ORDER BY TotalMerchantRefund DESC;


-- Q43: Calculate the refund percentage for each merchant based on successful transaction value.
SELECT 
    m.MerchantID,
    m.MerchantName,
    COALESCE(SUM(CASE WHEN t.TransactionStatus = 'Success' THEN t.Amount ELSE 0 END), 0) AS SuccessfulTxnValue,
    COALESCE(SUM(CASE WHEN r.RefundStatus = 'Completed' THEN r.RefundAmount ELSE 0 END), 0) AS CompletedRefundValue,
    ROUND(
        (COALESCE(SUM(CASE WHEN r.RefundStatus = 'Completed' THEN r.RefundAmount ELSE 0 END), 0) * 100.0) / 
        NULLIF(SUM(CASE WHEN t.TransactionStatus = 'Success' THEN t.Amount ELSE 0 END), 0),
        2
    ) AS RefundPercentage
FROM Merchant m
LEFT JOIN `Transaction` t ON m.MerchantID = t.MerchantID
LEFT JOIN Refund r ON t.TransactionID = r.TransactionID
GROUP BY m.MerchantID, m.MerchantName
ORDER BY RefundPercentage DESC;


-- Q44: Find merchants with pending settlements and their pending settlement amount.
SELECT 
    m.MerchantID,
    m.MerchantName,
    COUNT(s.SettlementID) AS PendingSettlementCount,
    SUM(s.SettlementAmount) AS TotalPendingSettlementAmount
FROM Merchant m
JOIN Settlement s ON m.MerchantID = s.MerchantID
WHERE s.SettlementStatus = 'Pending'
GROUP BY m.MerchantID, m.MerchantName
ORDER BY TotalPendingSettlementAmount DESC;


-- Q45: Compare successful transaction value with settled amount for each merchant.
SELECT 
    m.MerchantID,
    m.MerchantName,
    COALESCE(SUM(CASE WHEN t.TransactionStatus = 'Success' THEN t.Amount ELSE 0 END), 0) AS TotalSuccessfulValue,
    COALESCE(SUM(CASE WHEN s.SettlementStatus = 'Completed' THEN s.SettlementAmount ELSE 0 END), 0) AS TotalSettledAmount,
    COALESCE(SUM(CASE WHEN t.TransactionStatus = 'Success' THEN t.Amount ELSE 0 END), 0) - 
    COALESCE(SUM(CASE WHEN s.SettlementStatus = 'Completed' THEN s.SettlementAmount ELSE 0 END), 0) AS UnsettledBalance
FROM Merchant m
LEFT JOIN `Transaction` t ON m.MerchantID = t.MerchantID
LEFT JOIN Settlement s ON t.TransactionID = s.TransactionID
GROUP BY m.MerchantID, m.MerchantName
ORDER BY TotalSuccessfulValue DESC;


-- RISK ANALYSIS

-- Q46: Find the number of high-risk transactions for each merchant.
SELECT 
    m.MerchantID,
    m.MerchantName,
    COUNT(tr.RiskID) AS HighRiskTransactionCount
FROM Merchant m
JOIN `Transaction` t ON m.MerchantID = t.MerchantID
JOIN TransactionRisk tr ON t.TransactionID = tr.TransactionID
WHERE tr.RiskLevel = 'High' OR tr.RiskScore >= 75
GROUP BY m.MerchantID, m.MerchantName
ORDER BY HighRiskTransactionCount DESC;


-- Q47: Compare transaction status across different risk levels.
SELECT 
    tr.RiskLevel,
    t.TransactionStatus,
    COUNT(t.TransactionID) AS TransactionCount,
    SUM(t.Amount) AS TotalAmount
FROM TransactionRisk tr
JOIN `Transaction` t ON tr.TransactionID = t.TransactionID
GROUP BY tr.RiskLevel, t.TransactionStatus
ORDER BY tr.RiskLevel, TransactionCount DESC;

-- FEE ANALYSIS & COMPREHENSIVE EXECUTIVE KPI


-- Q48: Find the merchants generating the highest processing fee.
SELECT 
    m.MerchantID,
    m.MerchantName,
    COUNT(tf.FeeID) AS TotalFeesApplied,
    SUM(tf.FeeAmount) AS TotalProcessingFeeGenerated
FROM Merchant m
JOIN `Transaction` t ON m.MerchantID = t.MerchantID
JOIN TransactionFee tf ON t.TransactionID = tf.TransactionID
GROUP BY m.MerchantID, m.MerchantName
ORDER BY TotalProcessingFeeGenerated DESC;


-- Q49: Calculate the average processing fee per successful transaction for each merchant.
SELECT 
    m.MerchantID,
    m.MerchantName,
    COUNT(DISTINCT CASE WHEN t.TransactionStatus = 'Success' THEN t.TransactionID END) AS SuccessfulTxnCount,
    COALESCE(SUM(tf.FeeAmount), 0) AS TotalFeeAmount,
    ROUND(
        COALESCE(SUM(tf.FeeAmount), 0) / 
        NULLIF(COUNT(DISTINCT CASE WHEN t.TransactionStatus = 'Success' THEN t.TransactionID END), 0),
        2
    ) AS AvgFeePerSuccessfulTxn
FROM Merchant m
JOIN `Transaction` t ON m.MerchantID = t.MerchantID
LEFT JOIN TransactionFee tf ON t.TransactionID = tf.TransactionID
GROUP BY m.MerchantID, m.MerchantName
HAVING SuccessfulTxnCount > 0
ORDER BY AvgFeePerSuccessfulTxn DESC;


-- Q50: Find the top 5 merchants based on successful transaction value, along with transaction count, refund amount and processing fees.
SELECT 
    m.MerchantID,
    m.MerchantName,
    COUNT(DISTINCT t.TransactionID) AS TotalTransactionCount,
    COALESCE(SUM(CASE WHEN t.TransactionStatus = 'Success' THEN t.Amount ELSE 0 END), 0) AS TotalSuccessfulValue,
    COALESCE(SUM(DISTINCT CASE WHEN r.RefundStatus = 'Completed' THEN r.RefundAmount ELSE 0 END), 0) AS TotalRefundAmount,
    COALESCE(SUM(tf.FeeAmount), 0) AS TotalProcessingFees
FROM Merchant m
JOIN `Transaction` t ON m.MerchantID = t.MerchantID
LEFT JOIN Refund r ON t.TransactionID = r.TransactionID
LEFT JOIN TransactionFee tf ON t.TransactionID = tf.TransactionID
GROUP BY m.MerchantID, m.MerchantName
ORDER BY TotalSuccessfulValue DESC
LIMIT 5;
