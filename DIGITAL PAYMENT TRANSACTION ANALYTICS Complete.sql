DROP DATABASE IF EXISTS payflow_analytics;

CREATE DATABASE payflow_analytics;
USE payflow_analytics;

CREATE TABLE Customer (
 CustomerID INT PRIMARY KEY, 
 FirstName VARCHAR(50) NOT NULL, 
 LastName VARCHAR(50) NOT NULL,
 Email VARCHAR(100) NOT NULL UNIQUE, 
 PhoneNumber VARCHAR(15) NOT NULL UNIQUE,
 RegistrationDate DATE NOT NULL, 
 City VARCHAR(50),
 CustomerStatus VARCHAR(20) NOT NULL DEFAULT 'Active',
 CHECK (CustomerStatus IN ('Active','Inactive','Blocked'))
);

CREATE TABLE Merchant (
 MerchantID INT PRIMARY KEY, 
 MerchantName VARCHAR(100) NOT NULL UNIQUE, 
 BusinessType VARCHAR(50) NOT NULL,
 City VARCHAR(50), 
 RegistrationDate DATE NOT NULL,
 MerchantStatus VARCHAR(20) NOT NULL DEFAULT 'Active',
 CHECK (MerchantStatus IN ('Active','Inactive','Suspended'))
);

CREATE TABLE PaymentMethod (
 PaymentMethodID INT PRIMARY KEY, 
 CustomerID INT NOT NULL,
 MethodType VARCHAR(30) NOT NULL,
 Provider VARCHAR(50) NOT NULL, 
 AccountIdentifier VARCHAR(30) NOT NULL,
 IsActive BOOLEAN NOT NULL DEFAULT TRUE,
 FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
 CHECK (MethodType IN ('UPI','Card','Wallet','Net Banking'))
);

CREATE TABLE `Transaction` (
 TransactionID INT PRIMARY KEY, 
 CustomerID INT NOT NULL,
 MerchantID INT NOT NULL, 
 PaymentMethodID INT NOT NULL,
 TransactionDate DATETIME NOT NULL, 
 Amount DECIMAL(12,2) NOT NULL CHECK (Amount > 0),
 TransactionType VARCHAR(20) NOT NULL, 
 TransactionStatus VARCHAR(20) NOT NULL,
 PaymentChannel VARCHAR(20) NOT NULL, 
 TransactionReference VARCHAR(30) NOT NULL UNIQUE,
 FailureReason VARCHAR(100),
 FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
 FOREIGN KEY (MerchantID) REFERENCES Merchant(MerchantID),
 FOREIGN KEY (PaymentMethodID) REFERENCES PaymentMethod(PaymentMethodID),
 CHECK (TransactionType IN ('Payment','Transfer')),
 CHECK (TransactionStatus IN ('Success','Failed','Pending','Reversed')),
 CHECK (PaymentChannel IN ('UPI','App','Web','POS'))
);

CREATE TABLE Refund (
 RefundID INT PRIMARY KEY, 
 TransactionID INT NOT NULL, 
 RefundAmount DECIMAL(12,2) NOT NULL CHECK (RefundAmount > 0),
 RefundDate DATE NOT NULL, 
 RefundStatus VARCHAR(20) NOT NULL, 
 RefundReason VARCHAR(100),
 FOREIGN KEY (TransactionID) REFERENCES `Transaction`(TransactionID),
 CHECK (RefundStatus IN ('Initiated','Completed','Failed'))
);

CREATE TABLE Settlement (
 SettlementID INT PRIMARY KEY, 
 MerchantID INT NOT NULL, 
 TransactionID INT NOT NULL UNIQUE,
 SettlementAmount DECIMAL(12,2) NOT NULL CHECK (SettlementAmount > 0),
 SettlementDate DATE NOT NULL, 
 SettlementStatus VARCHAR(20) NOT NULL,
 SettlementReference VARCHAR(30) NOT NULL UNIQUE,
 FOREIGN KEY (MerchantID) REFERENCES Merchant(MerchantID),
 FOREIGN KEY (TransactionID) REFERENCES `Transaction`(TransactionID),
 CHECK (SettlementStatus IN ('Pending','Settled','Failed'))
);

CREATE TABLE TransactionFee (
 FeeID INT PRIMARY KEY, 
 TransactionID INT NOT NULL, 
 FeeType VARCHAR(30) NOT NULL,
 FeeAmount DECIMAL(12,2) NOT NULL CHECK (FeeAmount >= 0), FeeDate DATE NOT NULL,
 FOREIGN KEY (TransactionID) REFERENCES `Transaction`(TransactionID)
);

CREATE TABLE TransactionRisk (
 RiskID INT PRIMARY KEY, 
 TransactionID INT NOT NULL UNIQUE, 
 RiskScore INT NOT NULL CHECK (RiskScore BETWEEN 0 AND 100),
 RiskLevel VARCHAR(20) NOT NULL, 
 ReviewStatus VARCHAR(30) NOT NULL, 
 ReviewDate DATE,
 FOREIGN KEY (TransactionID) REFERENCES `Transaction`(TransactionID),
 CHECK (RiskLevel IN ('Low','Medium','High')),
 CHECK (ReviewStatus IN ('Not Reviewed','Reviewed','Escalated'))
);

INSERT INTO Customer (CustomerID, FirstName, LastName, Email, PhoneNumber, RegistrationDate, City, CustomerStatus) VALUES
(1, 'Aarav', 'Sharma', 'aarav.sharma@gmail.com', '9876501001', '2025-01-12', 'Mumbai', 'Active'),
(2, 'Priya', 'Patil', 'priya.patil@gmail.com', '9876501002', '2025-01-18', 'Pune', 'Active'),
(3, 'Rohan', 'Deshmukh', 'rohan.deshmukh@gmail.com', '9876501003', '2025-02-03', 'Nashik', 'Active'),
(4, 'Sneha', 'Kulkarni', 'sneha.kulkarni@gmail.com', '9876501004', '2025-02-11', 'Mumbai', 'Active'),
(5, 'Vikram', 'Joshi', 'vikram.joshi@gmail.com', '9876501005', '2025-02-20', 'Nagpur', 'Active'),
(6, 'Neha', 'More', 'neha.more@gmail.com', '9876501006', '2025-03-01', 'Pune', 'Active'),
(7, 'Aditya', 'Yevate', 'aditya.yev@gmail.com', '9876501007', '2025-03-07', 'Pune', 'Active'),
(8, 'Isha', 'Mehta', 'isha.mehta@gmail.com', '9876501008', '2025-03-15', 'Mumbai', 'Active'),
(9, 'Kunal', 'Shinde', 'kunal.shinde@gmail.com', '9876501009', '2025-03-20', 'Aurangabad', 'Active'),
(10, 'Pooja', 'Jadhav', 'pooja.jadhav@gmail.com', '9876501010', '2025-04-02', 'Kolhapur', 'Active'),
(11, 'Rahul', 'Nair', 'rahul.nair@gmail.com', '9876501011', '2025-04-12', 'Mumbai', 'Active'),
(12, 'Ananya', 'Desai', 'ananya.desai@gmail.com', '9876501012', '2025-04-21', 'Pune', 'Active'),
(13, 'Siddharth', 'Kale', 'siddharth.kale@gmail.com', '9876501013', '2025-05-05', 'Nashik', 'Active'),
(14, 'Tanvi', 'Bhosale', 'tanvi.bhosale@gmail.com', '9876501014', '2025-05-18', 'Nagpur', 'Inactive'),
(15, 'Manish', 'Pawar', 'manish.pawar@gmail.com', '9876501015', '2025-06-01', 'Mumbai', 'Blocked');
INSERT INTO Merchant (MerchantID, MerchantName, BusinessType, City, RegistrationDate, MerchantStatus) VALUES
(1, 'QuickMart', 'E-commerce', 'Mumbai', '2024-06-10', 'Active'),
(2, 'FreshBasket', 'Grocery', 'Pune', '2024-07-04', 'Active'),
(3, 'UrbanBites', 'Food', 'Mumbai', '2024-08-19', 'Active'),
(4, 'RideGo', 'Travel', 'Pune', '2024-09-02', 'Active'),
(5, 'StyleHub', 'Fashion', 'Mumbai', '2024-09-28', 'Active'),
(6, 'MediCare Plus', 'Healthcare', 'Nashik', '2024-10-11', 'Active'),
(7, 'BookNest', 'Education', 'Nagpur', '2024-11-05', 'Active'),
(8, 'HomeKart', 'Home & Lifestyle', 'Pune', '2024-12-14', 'Active'),
(9, 'TechZone', 'Electronics', 'Mumbai', '2025-01-08', 'Active'),
(10, 'FitLife', 'Fitness', 'Aurangabad', '2025-01-25', 'Suspended');
INSERT INTO PaymentMethod (PaymentMethodID, CustomerID, MethodType, Provider, AccountIdentifier, IsActive) VALUES
(1, 1, 'UPI', 'Google Pay', '****1001', 1),
(2, 1, 'Card', 'HDFC Bank', '****4421', 1),
(3, 2, 'UPI', 'PhonePe', '****1002', 1),
(4, 2, 'Card', 'ICICI Bank', '****8832', 1),
(5, 3, 'Wallet', 'Paytm', '****7711', 1),
(6, 3, 'UPI', 'Google Pay', '****1003', 1),
(7, 4, 'UPI', 'PhonePe', '****1004', 1),
(8, 4, 'Net Banking', 'SBI', '****2204', 1),
(9, 5, 'Card', 'Axis Bank', '****3315', 1),
(10, 5, 'UPI', 'Google Pay', '****1005', 1),
(11, 6, 'UPI', 'PhonePe', '****1006', 1),
(12, 7, 'UPI', 'Google Pay', '****1007', 1),
(13, 7, 'Card', 'HDFC Bank', '****7717', 1),
(14, 8, 'Wallet', 'Paytm', '****7788', 1),
(15, 8, 'UPI', 'Google Pay', '****1008', 1),
(16, 9, 'UPI', 'PhonePe', '****1009', 1),
(17, 10, 'Card', 'ICICI Bank', '****8810', 1),
(18, 11, 'UPI', 'Google Pay', '****1011', 1),
(19, 12, 'UPI', 'PhonePe', '****1012', 1),
(20, 13, 'Card', 'SBI', '****8813', 1),
(21, 14, 'UPI', 'Google Pay', '****1014', 1),
(22, 15, 'UPI', 'PhonePe', '****1015', 1);
INSERT INTO `Transaction` (TransactionID, CustomerID, MerchantID, PaymentMethodID, TransactionDate, Amount, TransactionType, TransactionStatus, PaymentChannel, TransactionReference, FailureReason) VALUES
(1, 9, 3, 16, '2026-03-03 15:17:00', 799, 'Payment', 'Success', 'Web', 'TXN202600001', NULL),
(2, 4, 6, 7, '2026-02-23 13:04:00', 599, 'Payment', 'Failed', 'Web', 'TXN202600002', 'Daily Limit Exceeded'),
(3, 11, 7, 18, '2026-03-26 16:09:00', 999, 'Payment', 'Success', 'App', 'TXN202600003', NULL),
(4, 12, 10, 19, '2026-02-26 18:25:00', 1999, 'Payment', 'Success', 'App', 'TXN202600004', NULL),
(5, 9, 2, 16, '2026-01-09 10:09:00', 499, 'Payment', 'Success', 'POS', 'TXN202600005', NULL),
(6, 7, 10, 13, '2026-03-03 17:16:00', 149, 'Transfer', 'Success', 'UPI', 'TXN202600006', NULL),
(7, 13, 2, 20, '2026-02-09 15:10:00', 4999, 'Transfer', 'Success', 'UPI', 'TXN202600007', NULL),
(8, 9, 9, 16, '2026-01-16 19:19:00', 599, 'Transfer', 'Success', 'App', 'TXN202600008', NULL),
(9, 13, 9, 20, '2026-03-11 09:38:00', 1499, 'Payment', 'Success', 'POS', 'TXN202600009', NULL),
(10, 2, 5, 4, '2026-02-02 09:15:00', 249, 'Transfer', 'Success', 'UPI', 'TXN202600010', NULL),
(11, 14, 9, 21, '2026-01-19 11:42:00', 7999, 'Transfer', 'Success', 'App', 'TXN202600011', NULL),
(12, 9, 4, 16, '2026-03-13 20:44:00', 599, 'Transfer', 'Pending', 'Web', 'TXN202600012', NULL),
(13, 11, 8, 18, '2026-03-10 16:07:00', 799, 'Transfer', 'Failed', 'UPI', 'TXN202600013', 'Bank Declined'),
(14, 1, 10, 1, '2026-01-31 09:04:00', 199, 'Payment', 'Success', 'App', 'TXN202600014', NULL),
(15, 15, 6, 22, '2026-01-12 17:15:00', 999, 'Payment', 'Success', 'POS', 'TXN202600015', NULL),
(16, 9, 10, 16, '2026-03-17 16:15:00', 7999, 'Payment', 'Failed', 'App', 'TXN202600016', 'Invalid UPI PIN'),
(17, 2, 6, 4, '2026-02-26 15:29:00', 199, 'Payment', 'Success', 'UPI', 'TXN202600017', NULL),
(18, 7, 2, 13, '2026-02-03 12:12:00', 4999, 'Transfer', 'Success', 'App', 'TXN202600018', NULL),
(19, 3, 8, 6, '2026-02-03 10:28:00', 299, 'Payment', 'Reversed', 'UPI', 'TXN202600019', NULL),
(20, 2, 3, 3, '2026-02-24 16:30:00', 599, 'Payment', 'Success', 'POS', 'TXN202600020', NULL),
(21, 3, 1, 6, '2026-02-21 13:59:00', 4999, 'Transfer', 'Pending', 'Web', 'TXN202600021', NULL),
(22, 12, 3, 19, '2026-01-27 13:13:00', 199, 'Transfer', 'Success', 'UPI', 'TXN202600022', NULL),
(23, 1, 10, 1, '2026-03-05 17:58:00', 499, 'Payment', 'Success', 'UPI', 'TXN202600023', NULL),
(24, 14, 2, 21, '2026-03-20 10:43:00', 799, 'Payment', 'Failed', 'UPI', 'TXN202600024', 'Invalid UPI PIN'),
(25, 10, 10, 17, '2026-01-13 15:42:00', 1499, 'Payment', 'Success', 'Web', 'TXN202600025', NULL),
(26, 11, 4, 18, '2026-02-05 15:08:00', 1299, 'Transfer', 'Success', 'POS', 'TXN202600026', NULL),
(27, 15, 1, 22, '2026-03-02 18:36:00', 299, 'Payment', 'Success', 'UPI', 'TXN202600027', NULL),
(28, 9, 3, 16, '2026-02-16 10:56:00', 799, 'Transfer', 'Success', 'Web', 'TXN202600028', NULL),
(29, 3, 9, 6, '2026-02-10 18:51:00', 149, 'Payment', 'Success', 'Web', 'TXN202600029', NULL),
(30, 15, 5, 22, '2026-01-17 10:47:00', 399, 'Payment', 'Failed', 'Web', 'TXN202600030', 'Network Timeout'),
(31, 12, 4, 19, '2026-03-31 19:54:00', 999, 'Transfer', 'Success', 'POS', 'TXN202600031', NULL),
(32, 15, 2, 22, '2026-03-25 15:53:00', 999, 'Payment', 'Success', 'UPI', 'TXN202600032', NULL),
(33, 6, 5, 11, '2026-01-23 20:28:00', 2999, 'Payment', 'Failed', 'UPI', 'TXN202600033', 'Daily Limit Exceeded'),
(34, 2, 9, 3, '2026-01-07 14:37:00', 399, 'Payment', 'Success', 'POS', 'TXN202600034', NULL),
(35, 1, 6, 2, '2026-01-08 14:13:00', 799, 'Transfer', 'Success', 'UPI', 'TXN202600035', NULL),
(36, 13, 10, 20, '2026-01-22 12:55:00', 499, 'Transfer', 'Success', 'App', 'TXN202600036', NULL),
(37, 1, 6, 1, '2026-02-24 19:55:00', 799, 'Payment', 'Success', 'Web', 'TXN202600037', NULL),
(38, 13, 7, 20, '2026-01-07 16:14:00', 599, 'Transfer', 'Success', 'POS', 'TXN202600038', NULL),
(39, 5, 4, 9, '2026-01-06 19:12:00', 2499, 'Transfer', 'Success', 'Web', 'TXN202600039', NULL),
(40, 14, 5, 21, '2026-02-16 19:32:00', 2499, 'Payment', 'Success', 'Web', 'TXN202600040', NULL),
(41, 2, 3, 4, '2026-03-18 13:02:00', 299, 'Transfer', 'Success', 'POS', 'TXN202600041', NULL),
(42, 12, 7, 19, '2026-03-21 17:07:00', 2499, 'Transfer', 'Failed', 'App', 'TXN202600042', 'Daily Limit Exceeded'),
(43, 1, 1, 2, '2026-03-10 17:43:00', 599, 'Transfer', 'Pending', 'Web', 'TXN202600043', NULL),
(44, 2, 10, 4, '2026-02-12 19:54:00', 299, 'Transfer', 'Success', 'Web', 'TXN202600044', NULL),
(45, 11, 6, 18, '2026-02-23 20:18:00', 399, 'Transfer', 'Success', 'App', 'TXN202600045', NULL),
(46, 11, 3, 18, '2026-03-22 18:19:00', 2499, 'Transfer', 'Success', 'UPI', 'TXN202600046', NULL),
(47, 5, 7, 9, '2026-03-18 18:41:00', 1499, 'Transfer', 'Failed', 'POS', 'TXN202600047', 'Invalid UPI PIN'),
(48, 11, 9, 18, '2026-03-04 20:10:00', 249, 'Payment', 'Failed', 'Web', 'TXN202600048', 'Network Timeout'),
(49, 14, 5, 21, '2026-01-31 12:09:00', 149, 'Payment', 'Success', 'UPI', 'TXN202600049', NULL),
(50, 8, 8, 14, '2026-02-25 19:36:00', 599, 'Transfer', 'Success', 'POS', 'TXN202600050', NULL),
(51, 7, 3, 12, '2026-03-27 20:00:00', 299, 'Payment', 'Success', 'POS', 'TXN202600051', NULL),
(52, 3, 1, 6, '2026-03-15 12:58:00', 299, 'Payment', 'Success', 'POS', 'TXN202600052', NULL),
(53, 13, 9, 20, '2026-03-15 18:20:00', 4999, 'Transfer', 'Pending', 'POS', 'TXN202600053', NULL),
(54, 15, 8, 22, '2026-03-01 13:48:00', 799, 'Transfer', 'Success', 'Web', 'TXN202600054', NULL),
(55, 11, 5, 18, '2026-02-28 10:45:00', 1299, 'Transfer', 'Reversed', 'App', 'TXN202600055', NULL),
(56, 6, 9, 11, '2026-01-13 11:09:00', 799, 'Payment', 'Reversed', 'POS', 'TXN202600056', NULL),
(57, 12, 2, 19, '2026-02-25 15:21:00', 4999, 'Payment', 'Success', 'POS', 'TXN202600057', NULL),
(58, 4, 7, 8, '2026-03-18 20:01:00', 2499, 'Payment', 'Success', 'POS', 'TXN202600058', NULL),
(59, 6, 7, 11, '2026-02-25 17:47:00', 799, 'Payment', 'Success', 'POS', 'TXN202600059', NULL),
(60, 5, 8, 10, '2026-01-06 15:21:00', 2499, 'Transfer', 'Success', 'App', 'TXN202600060', NULL),
(61, 15, 10, 22, '2026-03-12 09:58:00', 2499, 'Payment', 'Success', 'UPI', 'TXN202600061', NULL),
(62, 11, 3, 18, '2026-03-03 11:03:00', 999, 'Transfer', 'Success', 'POS', 'TXN202600062', NULL),
(63, 4, 6, 8, '2026-02-15 15:17:00', 2999, 'Payment', 'Reversed', 'Web', 'TXN202600063', NULL),
(64, 8, 9, 14, '2026-01-09 14:14:00', 249, 'Payment', 'Failed', 'UPI', 'TXN202600064', 'Merchant Error'),
(65, 4, 1, 7, '2026-03-23 11:15:00', 399, 'Payment', 'Failed', 'UPI', 'TXN202600065', 'Invalid UPI PIN'),
(66, 8, 6, 15, '2026-01-24 18:38:00', 299, 'Transfer', 'Success', 'App', 'TXN202600066', NULL),
(67, 2, 5, 3, '2026-03-17 19:58:00', 2499, 'Payment', 'Success', 'POS', 'TXN202600067', NULL),
(68, 2, 2, 3, '2026-04-02 13:54:00', 299, 'Transfer', 'Pending', 'UPI', 'TXN202600068', NULL),
(69, 9, 6, 16, '2026-01-11 17:41:00', 1499, 'Transfer', 'Reversed', 'UPI', 'TXN202600069', NULL),
(70, 14, 2, 21, '2026-02-27 14:40:00', 4999, 'Transfer', 'Success', 'App', 'TXN202600070', NULL),
(71, 3, 10, 6, '2026-03-12 16:29:00', 2999, 'Transfer', 'Success', 'Web', 'TXN202600071', NULL),
(72, 14, 2, 21, '2026-02-07 16:15:00', 4999, 'Transfer', 'Success', 'POS', 'TXN202600072', NULL),
(73, 1, 6, 2, '2026-01-26 16:13:00', 1999, 'Transfer', 'Failed', 'Web', 'TXN202600073', 'Network Timeout'),
(74, 15, 9, 22, '2026-01-04 17:12:00', 249, 'Transfer', 'Success', 'App', 'TXN202600074', NULL),
(75, 8, 8, 14, '2026-03-26 20:31:00', 4999, 'Payment', 'Success', 'UPI', 'TXN202600075', NULL),
(76, 5, 7, 9, '2026-04-01 12:19:00', 1999, 'Transfer', 'Success', 'POS', 'TXN202600076', NULL),
(77, 7, 6, 13, '2026-04-02 16:17:00', 1299, 'Payment', 'Success', 'Web', 'TXN202600077', NULL),
(78, 2, 6, 3, '2026-01-18 20:34:00', 499, 'Payment', 'Success', 'App', 'TXN202600078', NULL),
(79, 12, 5, 19, '2026-03-19 17:38:00', 1299, 'Payment', 'Success', 'UPI', 'TXN202600079', NULL),
(80, 5, 6, 9, '2026-01-25 13:00:00', 399, 'Payment', 'Success', 'Web', 'TXN202600080', NULL);
INSERT INTO Refund (RefundID, TransactionID, RefundAmount, RefundDate, RefundStatus, RefundReason) VALUES
(1, 1, 399.5, '2026-03-12', 'Completed', 'Duplicate Payment'),
(2, 7, 4999, '2026-02-17', 'Completed', 'Customer Request'),
(3, 8, 599, '2026-01-24', 'Failed', 'Product Return'),
(4, 14, 199, '2026-02-01', 'Completed', 'Product Return'),
(5, 15, 999, '2026-01-14', 'Failed', 'Product Return'),
(6, 22, 199, '2026-01-28', 'Completed', 'Duplicate Payment'),
(7, 28, 399.5, '2026-02-21', 'Completed', 'Duplicate Payment'),
(8, 29, 149, '2026-02-17', 'Initiated', 'Duplicate Payment'),
(9, 35, 399.5, '2026-01-15', 'Failed', 'Product Return'),
(10, 36, 499, '2026-02-01', 'Failed', 'Order Cancelled'),
(11, 49, 149, '2026-02-01', 'Initiated', 'Customer Request'),
(12, 50, 299.5, '2026-03-01', 'Completed', 'Order Cancelled'),
(13, 57, 4999, '2026-02-28', 'Completed', 'Duplicate Payment'),
(14, 70, 4999, '2026-03-02', 'Completed', 'Product Return'),
(15, 71, 2999, '2026-03-22', 'Failed', 'Order Cancelled'),
(16, 77, 1299, '2026-04-07', 'Completed', 'Product Return'),
(17, 78, 499, '2026-01-22', 'Completed', 'Duplicate Payment');
INSERT INTO Settlement (SettlementID, MerchantID, TransactionID, SettlementAmount, SettlementDate, SettlementStatus, SettlementReference) VALUES
(1, 10, 4, 1969.02, '2026-02-28', 'Settled', 'SET20260001'),
(2, 9, 8, 590.02, '2026-01-19', 'Settled', 'SET20260002'),
(3, 3, 20, 590.02, '2026-02-27', 'Settled', 'SET20260003'),
(4, 3, 28, 787.02, '2026-02-18', 'Settled', 'SET20260004'),
(5, 2, 32, 984.02, '2026-03-26', 'Settled', 'SET20260005'),
(6, 10, 36, 491.52, '2026-01-23', 'Settled', 'SET20260006'),
(7, 5, 40, 2461.52, '2026-02-19', 'Failed', 'SET20260007'),
(8, 10, 44, 294.52, '2026-02-14', 'Pending', 'SET20260008'),
(9, 1, 52, 294.52, '2026-03-16', 'Pending', 'SET20260009'),
(10, 8, 60, 2461.52, '2026-01-09', 'Settled', 'SET20260010'),
(11, 2, 72, 4924.02, '2026-02-10', 'Pending', 'SET20260011'),
(12, 7, 76, 1969.02, '2026-04-03', 'Failed', 'SET20260012'),
(13, 6, 80, 393.02, '2026-01-28', 'Pending', 'SET20260013');
INSERT INTO TransactionFee (FeeID, TransactionID, FeeType, FeeAmount, FeeDate) VALUES
(1, 3, 'Processing', 14.98, '2026-03-26'),
(2, 6, 'Processing', 2.23, '2026-03-03'),
(3, 9, 'Processing', 22.48, '2026-03-11'),
(4, 15, 'Processing', 14.98, '2026-01-12'),
(5, 18, 'Processing', 74.98, '2026-02-03'),
(6, 27, 'Processing', 4.48, '2026-03-02'),
(7, 36, 'Processing', 7.48, '2026-01-22'),
(8, 39, 'Processing', 37.48, '2026-01-06'),
(9, 45, 'Processing', 5.98, '2026-02-23'),
(10, 51, 'Processing', 4.48, '2026-03-27'),
(11, 54, 'Processing', 11.98, '2026-03-01'),
(12, 57, 'Processing', 74.98, '2026-02-25'),
(13, 60, 'Processing', 37.48, '2026-01-06'),
(14, 63, 'Processing', 44.98, '2026-02-15'),
(15, 66, 'Processing', 4.48, '2026-01-24'),
(16, 69, 'Processing', 22.48, '2026-01-11'),
(17, 72, 'Processing', 74.98, '2026-02-07'),
(18, 75, 'Processing', 74.98, '2026-03-26'),
(19, 78, 'Processing', 7.48, '2026-01-18');
INSERT INTO TransactionRisk (RiskID, TransactionID, RiskScore, RiskLevel, ReviewStatus, ReviewDate) VALUES
(1, 1, 61, 'Medium', 'Not Reviewed', NULL),
(2, 2, 81, 'High', 'Not Reviewed', NULL),
(3, 3, 60, 'Medium', 'Reviewed', '2026-03-27'),
(4, 4, 82, 'High', 'Escalated', '2026-02-27'),
(5, 5, 37, 'Low', 'Not Reviewed', NULL),
(6, 6, 16, 'Low', 'Not Reviewed', NULL),
(7, 7, 99, 'High', 'Escalated', '2026-02-10'),
(8, 8, 78, 'High', 'Escalated', '2026-01-17'),
(9, 9, 80, 'High', 'Escalated', '2026-03-12'),
(10, 10, 7, 'Low', 'Reviewed', '2026-02-03'),
(11, 11, 93, 'High', 'Escalated', '2026-01-20'),
(12, 12, 10, 'Low', 'Not Reviewed', NULL),
(13, 13, 65, 'Medium', 'Reviewed', '2026-03-11'),
(14, 14, 40, 'Low', 'Not Reviewed', NULL),
(15, 15, 79, 'High', 'Escalated', '2026-01-13'),
(16, 16, 75, 'High', 'Reviewed', '2026-03-18'),
(17, 17, 16, 'Low', 'Reviewed', '2026-02-27'),
(18, 18, 64, 'Medium', 'Reviewed', '2026-02-04'),
(19, 19, 47, 'Medium', 'Reviewed', '2026-02-04'),
(20, 20, 90, 'High', 'Escalated', '2026-02-25'),
(21, 21, 33, 'Low', 'Not Reviewed', NULL),
(22, 22, 47, 'Medium', 'Reviewed', '2026-01-28'),
(23, 23, 93, 'High', 'Escalated', '2026-03-06'),
(24, 24, 68, 'Medium', 'Reviewed', '2026-03-21'),
(25, 25, 89, 'High', 'Escalated', '2026-01-14'),
(26, 26, 56, 'Medium', 'Not Reviewed', NULL),
(27, 27, 63, 'Medium', 'Not Reviewed', NULL),
(28, 28, 45, 'Medium', 'Reviewed', '2026-02-17'),
(29, 29, 46, 'Medium', 'Not Reviewed', NULL),
(30, 30, 56, 'Medium', 'Not Reviewed', NULL),
(31, 31, 89, 'High', 'Escalated', '2026-04-01'),
(32, 32, 74, 'Medium', 'Reviewed', '2026-03-26'),
(33, 33, 57, 'Medium', 'Not Reviewed', NULL),
(34, 34, 29, 'Low', 'Reviewed', '2026-01-08'),
(35, 35, 84, 'High', 'Escalated', '2026-01-09'),
(36, 36, 68, 'Medium', 'Reviewed', '2026-01-23'),
(37, 37, 11, 'Low', 'Not Reviewed', NULL),
(38, 38, 39, 'Low', 'Not Reviewed', NULL),
(39, 39, 41, 'Low', 'Reviewed', '2026-01-07'),
(40, 40, 94, 'High', 'Escalated', '2026-02-17'),
(41, 41, 67, 'Medium', 'Not Reviewed', NULL),
(42, 42, 8, 'Low', 'Not Reviewed', NULL),
(43, 43, 95, 'High', 'Escalated', '2026-03-11'),
(44, 44, 25, 'Low', 'Reviewed', '2026-02-13'),
(45, 45, 75, 'High', 'Escalated', '2026-02-24'),
(46, 46, 6, 'Low', 'Reviewed', '2026-03-23'),
(47, 47, 16, 'Low', 'Not Reviewed', NULL),
(48, 48, 19, 'Low', 'Reviewed', '2026-03-05'),
(49, 49, 20, 'Low', 'Not Reviewed', NULL),
(50, 50, 68, 'Medium', 'Reviewed', '2026-02-26'),
(51, 51, 70, 'Medium', 'Reviewed', '2026-03-28'),
(52, 52, 58, 'Medium', 'Reviewed', '2026-03-16'),
(53, 53, 80, 'High', 'Escalated', '2026-03-16'),
(54, 54, 36, 'Low', 'Reviewed', '2026-03-02'),
(55, 55, 75, 'High', 'Not Reviewed', NULL),
(56, 56, 54, 'Medium', 'Not Reviewed', NULL),
(57, 57, 96, 'High', 'Escalated', '2026-02-26'),
(58, 58, 70, 'Medium', 'Not Reviewed', NULL),
(59, 59, 13, 'Low', 'Reviewed', '2026-02-26'),
(60, 60, 58, 'Medium', 'Reviewed', '2026-01-07'),
(61, 61, 69, 'Medium', 'Reviewed', '2026-03-13'),
(62, 62, 5, 'Low', 'Reviewed', '2026-03-04'),
(63, 63, 43, 'Low', 'Reviewed', '2026-02-16'),
(64, 64, 24, 'Low', 'Reviewed', '2026-01-10'),
(65, 65, 73, 'Medium', 'Reviewed', '2026-03-24'),
(66, 66, 49, 'Medium', 'Reviewed', '2026-01-25'),
(67, 67, 75, 'High', 'Escalated', '2026-03-18'),
(68, 68, 74, 'Medium', 'Reviewed', '2026-04-03'),
(69, 69, 63, 'Medium', 'Reviewed', '2026-01-12'),
(70, 70, 44, 'Low', 'Not Reviewed', NULL),
(71, 71, 78, 'High', 'Escalated', '2026-03-13'),
(72, 72, 69, 'Medium', 'Not Reviewed', NULL),
(73, 73, 57, 'Medium', 'Not Reviewed', NULL),
(74, 74, 45, 'Medium', 'Reviewed', '2026-01-05'),
(75, 75, 99, 'High', 'Escalated', '2026-03-27'),
(76, 76, 53, 'Medium', 'Reviewed', '2026-04-02'),
(77, 77, 89, 'High', 'Escalated', '2026-04-03'),
(78, 78, 88, 'High', 'Escalated', '2026-01-19'),
(79, 79, 24, 'Low', 'Reviewed', '2026-03-20'),
(80, 80, 9, 'Low', 'Not Reviewed', NULL);

-- Row-count validation
SELECT 'Customer' AS TableName, 
COUNT(*) AS RowCount FROM Customer UNION ALL SELECT 'Merchant',
COUNT(*) FROM Merchant UNION ALL SELECT 'PaymentMethod',
COUNT(*) FROM PaymentMethod UNION ALL SELECT 'Transaction',
COUNT(*) FROM `Transaction` UNION ALL SELECT 'Refund',
COUNT(*) FROM Refund UNION ALL SELECT 'Settlement',
COUNT(*) FROM Settlement UNION ALL SELECT 'TransactionFee',
COUNT(*) FROM TransactionFee UNION ALL SELECT 'TransactionRisk',

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
