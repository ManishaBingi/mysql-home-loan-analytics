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

