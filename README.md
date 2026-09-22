# DIGITAL-PAYMENT-TRANSACTION-ANALYTICS
SQL analytical project querying a digital payments database across 50 business questions. Features multi-table JOINs, aggregations, CTEs, and window functions to evaluate transaction success/failure rates, merchant GMV, customer spend behavior, refunds, settlements, processing fees, and risk scores.

A database design and SQL analytics project for PayFlow, a digital payments platform. This project covers 3NF database schema design, constraint enforcement, sample data population, and 50 SQL queries solving core business problems.

**Relational Schema (3NF)**

The database consists of 8 core tables with PRIMARY KEY, FOREIGN KEY, NOT NULL, UNIQUE, and CHECK constraints:
Customer — Customer details and registration tracking.Merchant — Onboarded business details and status.
PaymentMethod — Saved payment instruments (UPI, Cards, NetBanking, Wallets).
Transaction — Central transaction ledger, payment channels, and failure reasons.
Refund — Refund amounts, statuses, and reasons.
Settlement — Merchant payout balances and statuses ($T+2$).
TransactionFee — Processing fees collected per transaction.
TransactionRisk — Fraud scores ($0–100$), risk tiers, and review statuses.

**📁 Repository Files**
01_schema_and_data.sql: Table creation scripts, constraints, and populated sample data.
02_analysis_queries.sql: SQL solutions for all 50 business questions.
03_business_insights.md: Executive summary and strategic recommendations.
README.md: Project overview and key findings.

**Summary of SQL Analysis (Q1 – Q50)**
The queries in 02_analysis_queries.sql cover four main functional areas:
1. Platform Performance & Payment Channels (Q1–Q12, Q18–Q19, Q37–Q38):
Evaluated platform transaction counts, overall Gross Merchandise Value (GMV), and status breakdowns (Success, Failed, Pending, Reversed).
Compared payment channels (UPI, Credit/Debit Cards, NetBanking) across volume, total value, average ticket size, and channel success/failure rates.
2. Merchant & Customer Analytics (Q13–Q17, Q21–Q23, Q31–Q36, Q40, Q50):
Ranked top merchants and customers by transaction value using CTEs and window functions (ROW_NUMBER, DENSE_RANK).
Identified high-value customers (>₹10,000 spend) and customers whose spend exceeds the platform average.
Highlighted underperforming merchants with excessive transaction failures (>3 failed transactions or failed > successful).
3. Failure & Risk Diagnostics (Q6, Q20, Q39, Q46–Q47):
Analyzed drop-off reasons (e.g., Insufficient Funds, Gateway Timeouts) across overall volume and per payment channel.
Evaluated transaction completion rates across risk score levels ($0–100$) and identified high-risk transactions per merchant.
4. Refunds, Settlements & Fee Economics (Q26–Q30, Q41–Q45, Q48–Q49):
Measured completed refund amounts and calculated merchant refund percentages against successful GMV.
Monitored pending vs. settled payout balances per merchant.
Calculated total processing fees collected and average fee yield per successful transaction.

**How to Run**
Open your SQL client (MySQL / PostgreSQL).

Run 01_schema_and_data.sql to initialize the database and load sample data.

Execute 02_analysis_queries.sql to view solutions for all 50 questions.



















