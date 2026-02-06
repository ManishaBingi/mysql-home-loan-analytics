use home_loans_project;

select * from customers;
select * from loans;
select * from payments;

-- 1. Total loan amount disbursed by city
SELECT c.city, SUM(l.loan_amount) AS total_loans FROM Customers c 
JOIN Loans l ON c.customer_id = l.customer_id GROUP BY c.city ORDER BY total_loans DESC;
-- Average interest rate by tenure
SELECT l.tenure_years, ROUND(AVG(l.interest_rate),2) AS avg_interest_rate FROM Loans l 
GROUP BY l.tenure_years ORDER BY tenure_years;
-- 3. Top 5 customers by total loan amount 
SELECT c.name, SUM(l.loan_amount) AS total_loans FROM Customers c 
JOIN Loans l ON c.customer_id = l.customer_id GROUP BY c.name ORDER BY total_loans DESC LIMIT 5;
-- 4. Loan repayment progress (percentage paid) 
SELECT l.loan_id, c.name, SUM(p.amount) AS total_paid, l.loan_amount, 
ROUND((SUM(p.amount)/l.loan_amount)*100,2) AS repayment_percentage FROM Loans l JOIN Customers c ON l.customer_id = c.customer_id 
LEFT JOIN Payments p ON l.loan_id = p.loan_id GROUP BY l.loan_id, c.name, l.loan_amount ORDER BY repayment_percentage DESC;
-- 5. Monthly payment trends (total payments per month)
SELECT DATE_FORMAT(p.payment_date, '%Y-%m') AS month, 
SUM(p.amount) AS total_payments FROM Payments p GROUP BY month ORDER BY month;
-- 6. Customers with loans above 5 lakh 
SELECT c.name, l.loan_amount, l.tenure_years FROM Customers c 
JOIN Loans l ON c.customer_id = l.customer_id WHERE l.loan_amount > 500000 ORDER BY l.loan_amount DESC; 
-- 7. Income vs Loan Amount (to check affordability ratio) 
SELECT c.name, c.income, l.loan_amount, ROUND(l.loan_amount/c.income,2) AS loan_to_income_ratio 
FROM Customers c JOIN Loans l ON c.customer_id = l.customer_id ORDER BY loan_to_income_ratio DESC;
-- 8.Customer Loan portfolio
SELECT c.name, COUNT(l.loan_id) AS total_loans,
       SUM(l.loan_amount) AS total_amount,
       ROUND(AVG(l.interest_rate),2) AS avg_interest_rate
FROM Customers c
JOIN Loans l ON c.customer_id = l.customer_id
GROUP BY c.name
ORDER BY total_amount DESC;
-- 9. Highest Paying Customers (Total Payments Made)
SELECT c.name, SUM(p.amount) AS total_paid
FROM Customers c
JOIN Loans l ON c.customer_id = l.customer_id
JOIN Payments p ON l.loan_id = p.loan_id
GROUP BY c.name
ORDER BY total_paid DESC
LIMIT 5;
-- 10. Loans Near Completion (≥80% Paid)
SELECT l.loan_id, c.name, l.loan_amount,
       SUM(p.amount) AS total_paid,
       ROUND((SUM(p.amount)/l.loan_amount)*100,2) AS repayment_percentage
FROM Loans l
JOIN Customers c ON l.customer_id = c.customer_id
JOIN Payments p ON l.loan_id = p.loan_id
GROUP BY l.loan_id, c.name, l.loan_amount
HAVING repayment_percentage >= 80
ORDER BY repayment_percentage DESC;
-- 11.City-wise Average Income vs Loan Amount
SELECT c.city,
       ROUND(AVG(c.income),2) AS avg_income,
       ROUND(AVG(l.loan_amount),2) AS avg_loan_amount,
       ROUND(AVG(l.loan_amount)/AVG(c.income),2) AS loan_to_income_ratio
FROM Customers c
JOIN Loans l ON c.customer_id = l.customer_id
GROUP BY c.city
ORDER BY loan_to_income_ratio DESC;
-- 12.Interest Revenue Projection (Expected Total Interest)
SELECT l.loan_id, c.name,
       l.loan_amount,
       l.interest_rate,
       ROUND((l.loan_amount * l.interest_rate * l.tenure_years)/100,2) AS projected_interest
FROM Loans l
JOIN Customers c ON l.customer_id = c.customer_id
ORDER BY projected_interest DESC;
-- 13. Delayed Payments (Payments after due date assumption)
SELECT p.payment_id, c.name, l.loan_id, p.payment_date, l.start_date
FROM Payments p
JOIN Loans l ON p.loan_id = l.loan_id
JOIN Customers c ON l.customer_id = c.customer_id
WHERE MONTH(p.payment_date) <> MONTH(l.start_date);
-- 14. Customer Loan Tenure Distribution
SELECT tenure_years, COUNT(*) AS total_loans
FROM Loans
GROUP BY tenure_years
ORDER BY tenure_years;
-- 15. Default Risk Flag (Customers with High Loan-to-Income Ratio and Low Payments)
 SELECT c.name, c.income, l.loan_amount,
       ROUND(l.loan_amount/c.income,2) AS loan_to_income_ratio,
       IFNULL(SUM(p.amount),0) AS total_paid,
       l.loan_amount - IFNULL(SUM(p.amount),0) AS outstanding_balance,
       CASE 
         WHEN (l.loan_amount/c.income) > 10 AND (SUM(p.amount) IS NULL OR SUM(p.amount) < (0.2*l.loan_amount))
         THEN 'High Risk'
         ELSE 'Normal'
       END AS risk_flag
FROM Customers c
JOIN Loans l ON c.customer_id = l.customer_id
LEFT JOIN Payments p ON l.loan_id = p.loan_id
GROUP BY c.name, c.income, l.loan_amount
ORDER BY risk_flag DESC, outstanding_balance DESC;

