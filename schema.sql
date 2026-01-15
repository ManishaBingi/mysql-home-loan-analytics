use home_loans_project;

-- Customers Table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    age INT,
    city VARCHAR(50),
    income DECIMAL(10,2)
);

-- Loans Table
CREATE TABLE Loans (
    loan_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    loan_amount DECIMAL(12,2),
    interest_rate DECIMAL(5,2),
    start_date DATE,
    tenure_years INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Payments Table
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    loan_id INT,
    payment_date DATE,
    amount DECIMAL(12,2),
    FOREIGN KEY (loan_id) REFERENCES Loans(loan_id)
);

INSERT INTO Customers (name, age, city, income) VALUES
('Ravi Kumar', 35, 'Hyderabad', 85000.00),
('Anita Sharma', 42, 'Mumbai', 120000.00),
('Suresh Reddy', 29, 'Bangalore', 65000.00),
('Priya Mehta', 31, 'Delhi', 95000.00),
('Arjun Singh', 45, 'Chennai', 110000.00);

INSERT INTO Loans (customer_id, loan_amount, interest_rate, start_date, tenure_years) VALUES
(1, 500000.00, 7.5, '2022-01-15', 10),
(2, 800000.00, 8.0, '2021-06-10', 15),
(3, 300000.00, 9.0, '2023-03-05', 5),
(4, 450000.00, 7.0, '2022-11-20', 7),
(5, 1000000.00, 6.5, '2020-09-01', 20);

INSERT INTO Payments (loan_id, payment_date, amount) VALUES
(1, '2022-07-15', 50000.00),
(1, '2023-01-15', 60000.00),
(2, '2021-12-10', 80000.00),
(2, '2022-06-10', 85000.00),
(3, '2023-06-05', 30000.00),
(4, '2023-03-20', 45000.00),
(5, '2021-03-01', 100000.00),
(5, '2022-03-01', 120000.00);

