-- ============================================================
-- PROJECT     : BANKING MANAGEMENT SYSTEM
-- DATABASE    : MySQL
-- TABLES      : 15
-- QUERY TOPICS: 14 (5 queries each = 70 queries)
-- ============================================================

DROP DATABASE IF EXISTS banking_system;
CREATE DATABASE banking_system;
USE banking_system;

-- ============================================================
-- SECTION 1: TABLE CREATION (15 TABLES)
-- ============================================================

-- 1. Branches
CREATE TABLE Branches (
    branch_id INT PRIMARY KEY AUTO_INCREMENT,
    branch_name VARCHAR(100) NOT NULL,
    branch_city VARCHAR(50) NOT NULL,
    ifsc_code VARCHAR(15) UNIQUE NOT NULL
);

-- 2. Departments
CREATE TABLE Departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(50) NOT NULL
);

-- 3. Employees
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(100) NOT NULL,
    department_id INT,
    branch_id INT,
    designation VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id),
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);

-- 4. Customers
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    cust_name VARCHAR(100) NOT NULL,
    dob DATE,
    gender VARCHAR(10),
    phone VARCHAR(15),
    email VARCHAR(100),
    address VARCHAR(200),
    city VARCHAR(50),
    branch_id INT,
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);

-- 5. AccountTypes
CREATE TABLE AccountTypes (
    account_type_id INT PRIMARY KEY AUTO_INCREMENT,
    type_name VARCHAR(50) NOT NULL,
    interest_rate DECIMAL(5,2),
    min_balance DECIMAL(10,2)
);

-- 6. Accounts
CREATE TABLE Accounts (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    branch_id INT,
    account_type_id INT,
    account_number VARCHAR(20) UNIQUE NOT NULL,
    balance DECIMAL(12,2) DEFAULT 0,
    open_date DATE,
    status VARCHAR(20) DEFAULT 'Active',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id),
    FOREIGN KEY (account_type_id) REFERENCES AccountTypes(account_type_id)
);

-- 7. Transactions
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT,
    transaction_type VARCHAR(20),
    amount DECIMAL(12,2),
    transaction_date DATETIME,
    description VARCHAR(200),
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

-- 8. Cards
CREATE TABLE Cards (
    card_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT,
    card_number VARCHAR(20),
    card_type VARCHAR(20),
    expiry_date DATE,
    card_status VARCHAR(20) DEFAULT 'Active',
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

-- 9. LoanTypes
CREATE TABLE LoanTypes (
    loan_type_id INT PRIMARY KEY AUTO_INCREMENT,
    loan_name VARCHAR(50),
    interest_rate DECIMAL(5,2)
);

-- 10. Loans
CREATE TABLE Loans (
    loan_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    loan_type_id INT,
    branch_id INT,
    loan_amount DECIMAL(12,2),
    issue_date DATE,
    tenure_months INT,
    status VARCHAR(20) DEFAULT 'Active',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (loan_type_id) REFERENCES LoanTypes(loan_type_id),
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);

-- 11. LoanPayments
CREATE TABLE LoanPayments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    loan_id INT,
    payment_date DATE,
    amount_paid DECIMAL(10,2),
    FOREIGN KEY (loan_id) REFERENCES Loans(loan_id)
);

-- 12. FixedDeposits
CREATE TABLE FixedDeposits (
    fd_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    account_id INT,
    amount DECIMAL(12,2),
    start_date DATE,
    maturity_date DATE,
    interest_rate DECIMAL(5,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

-- 13. Beneficiaries
CREATE TABLE Beneficiaries (
    beneficiary_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    beneficiary_name VARCHAR(100),
    beneficiary_account_number VARCHAR(20),
    bank_name VARCHAR(100),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- 14. Cheques
CREATE TABLE Cheques (
    cheque_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT,
    cheque_number VARCHAR(20),
    issue_date DATE,
    amount DECIMAL(12,2),
    status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

-- 15. Nominees
CREATE TABLE Nominees (
    nominee_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    nominee_name VARCHAR(100),
    relation VARCHAR(50),
    dob DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- ============================================================
-- SECTION 2: SAMPLE DATA
-- ============================================================

INSERT INTO Branches (branch_name, branch_city, ifsc_code) VALUES
('Anna Nagar Branch','Chennai','BANK0001'),
('T Nagar Branch','Chennai','BANK0002'),
('Andheri Branch','Mumbai','BANK0003'),
('Koramangala Branch','Bangalore','BANK0004'),
('Salt Lake Branch','Kolkata','BANK0005');

INSERT INTO Departments (department_name) VALUES
('Loans'),('Customer Service'),('Operations'),('IT'),('HR');

INSERT INTO Employees (emp_name, department_id, branch_id, designation, salary, hire_date) VALUES
('Arun Kumar',1,1,'Loan Officer',45000,'2019-05-10'),
('Divya Shree',2,1,'Teller',30000,'2020-01-15'),
('Rahul Mehta',3,3,'Operations Manager',60000,'2018-03-20'),
('Priya Singh',4,4,'IT Support',40000,'2021-07-01'),
('Kavitha Rao',2,2,'Customer Rep',32000,'2020-11-11'),
('Suresh Babu',1,3,'Loan Officer',47000,'2017-09-09'),
('Anitha Menon',5,4,'HR Executive',38000,'2022-02-14');

INSERT INTO Customers (cust_name, dob, gender, phone, email, address, city, branch_id) VALUES
('Ramesh Iyer','1985-04-12','Male','9876543210','ramesh@mail.com','12 Gandhi St','Chennai',1),
('Sneha Patil','1990-08-25','Female','9876543211','sneha@mail.com','45 MG Road','Mumbai',3),
('Vikram Rao','1978-11-02','Male','9876543212','vikram@mail.com','7 Park Ave','Bangalore',4),
('Lakshmi Narayanan','1995-01-30','Female','9876543213','lakshmi@mail.com','9 Lake View','Kolkata',5),
('Arjun Das','1988-06-18','Male','9876543214','arjun@mail.com','23 Church St','Chennai',2),
('Meera Nair','1992-09-09','Female','9876543215','meera@mail.com','56 Hill Road','Mumbai',3),
('Kiran Kumar','1983-03-03','Male','9876543216','kiran@mail.com','3 Lake Town','Kolkata',5),
('Divya Bharathi','1997-12-20','Female','9876543217','divyab@mail.com','88 Anna Salai','Chennai',1);

INSERT INTO AccountTypes (type_name, interest_rate, min_balance) VALUES
('Savings',3.5,1000),
('Current',0,5000),
('Salary',4.0,0);

INSERT INTO Accounts (customer_id, branch_id, account_type_id, account_number, balance, open_date, status) VALUES
(1,1,1,'AC1001',125000,'2019-06-01','Active'),
(2,3,1,'AC1002',85000,'2020-02-10','Active'),
(3,4,2,'AC1003',560000,'2018-04-15','Active'),
(4,5,1,'AC1004',32000,'2021-01-20','Active'),
(5,2,3,'AC1005',48000,'2019-09-05','Active'),
(6,3,1,'AC1006',15000,'2022-03-11','Active'),
(7,5,2,'AC1007',210000,'2017-10-25','Active'),
(8,1,1,'AC1008',9000,'2022-06-30','Frozen');

INSERT INTO Transactions (account_id, transaction_type, amount, transaction_date, description) VALUES
(1,'Deposit',20000,'2024-01-05 10:00:00','Salary credit'),
(1,'Withdrawal',5000,'2024-01-10 15:30:00','ATM withdrawal'),
(2,'Deposit',10000,'2024-01-07 09:00:00','Cash deposit'),
(3,'Withdrawal',50000,'2024-02-01 12:00:00','Business payment'),
(3,'Deposit',100000,'2024-02-15 11:00:00','Client payment'),
(4,'Deposit',5000,'2024-01-20 14:00:00','Cash deposit'),
(5,'Withdrawal',3000,'2024-02-05 16:00:00','Online purchase'),
(6,'Deposit',2000,'2024-01-25 10:15:00','Cash deposit'),
(7,'Withdrawal',20000,'2024-02-10 13:00:00','Rent payment'),
(8,'Deposit',1000,'2024-01-30 09:30:00','Cash deposit'),
(1,'Withdrawal',8000,'2024-02-20 17:00:00','Utility bill'),
(3,'Withdrawal',25000,'2024-03-01 12:30:00','Vendor payment');

INSERT INTO Cards (account_id, card_number, card_type, expiry_date, card_status) VALUES
(1,'4111000000001001','Debit','2027-06-30','Active'),
(2,'4111000000001002','Debit','2026-02-28','Active'),
(3,'5500000000001003','Credit','2028-04-30','Active'),
(4,'4111000000001004','Debit','2025-01-31','Expired'),
(5,'5500000000001005','Credit','2027-09-30','Active'),
(7,'4111000000001007','Debit','2026-10-31','Active');

INSERT INTO LoanTypes (loan_name, interest_rate) VALUES
('Home Loan',7.5),('Personal Loan',11.0),('Car Loan',9.0),('Education Loan',8.0);

INSERT INTO Loans (customer_id, loan_type_id, branch_id, loan_amount, issue_date, tenure_months, status) VALUES
(1,1,1,2500000,'2020-05-01',240,'Active'),
(2,3,3,800000,'2021-03-15',60,'Active'),
(3,2,4,300000,'2022-01-10',24,'Closed'),
(4,4,5,500000,'2019-08-20',48,'Active'),
(6,3,3,600000,'2023-02-01',36,'Active'),
(7,1,5,1800000,'2018-11-05',180,'Active');

INSERT INTO LoanPayments (loan_id, payment_date, amount_paid) VALUES
(1,'2024-01-05',25000),
(1,'2024-02-05',25000),
(2,'2024-01-10',15000),
(2,'2024-02-10',15000),
(3,'2022-06-10',14000),
(4,'2024-01-20',12000),
(5,'2024-02-15',18000),
(6,'2024-01-25',20000);

INSERT INTO FixedDeposits (customer_id, account_id, amount, start_date, maturity_date, interest_rate) VALUES
(1,1,100000,'2023-01-01','2025-01-01',6.5),
(3,3,300000,'2022-06-01','2024-06-01',7.0),
(5,5,50000,'2023-09-01','2024-09-01',6.0),
(7,7,150000,'2021-01-01','2026-01-01',7.2);

INSERT INTO Beneficiaries (customer_id, beneficiary_name, beneficiary_account_number, bank_name) VALUES
(1,'Suresh Iyer','AC9001','HDFC Bank'),
(2,'Anil Patil','AC9002','ICICI Bank'),
(3,'Ganesh Rao','AC9003','SBI'),
(5,'Radha Das','AC9004','Axis Bank');

INSERT INTO Cheques (account_id, cheque_number, issue_date, amount, status) VALUES
(1,'CHQ0001','2024-01-15',15000,'Cleared'),
(3,'CHQ0002','2024-02-01',40000,'Cleared'),
(4,'CHQ0003','2024-01-22',5000,'Pending'),
(7,'CHQ0004','2024-02-05',12000,'Bounced');

INSERT INTO Nominees (customer_id, nominee_name, relation, dob) VALUES
(1,'Geetha Iyer','Spouse','1987-03-14'),
(2,'Anil Patil','Father','1960-07-22'),
(3,'Sunita Rao','Spouse','1980-05-19'),
(4,'Ravi Narayanan','Brother','1993-02-11'),
(5,'Radha Das','Mother','1958-12-01');

-- ============================================================
-- SECTION 3: QUERIES (14 TOPICS x 5 QUERIES = 70 QUERIES)
-- ============================================================

-- ----------------------------------------------------------
-- TOPIC 1: BASIC SELECT & WHERE
-- ----------------------------------------------------------
-- 1.1 List all customers from Chennai
SELECT * FROM Customers WHERE city = 'Chennai';

-- 1.2 Find all active accounts
SELECT * FROM Accounts WHERE status = 'Active';

-- 1.3 Get accounts with balance greater than 100000
SELECT account_number, balance FROM Accounts WHERE balance > 100000;

-- 1.4 List all female customers
SELECT cust_name, gender, city FROM Customers WHERE gender = 'Female';

-- 1.5 Find loans with amount between 500000 and 2000000
SELECT loan_id, customer_id, loan_amount FROM Loans WHERE loan_amount BETWEEN 500000 AND 2000000;


-- ----------------------------------------------------------
-- TOPIC 2: ORDER BY & LIMIT
-- ----------------------------------------------------------
-- 2.1 Top 3 customers by account balance
SELECT c.cust_name, a.balance
FROM Customers c JOIN Accounts a ON c.customer_id = a.customer_id
ORDER BY a.balance DESC LIMIT 3;

-- 2.2 List employees by salary ascending
SELECT emp_name, salary FROM Employees ORDER BY salary ASC;

-- 2.3 Latest 5 transactions
SELECT * FROM Transactions ORDER BY transaction_date DESC LIMIT 5;

-- 2.4 Loans sorted by issue date (oldest first)
SELECT loan_id, customer_id, issue_date FROM Loans ORDER BY issue_date ASC;

-- 2.5 Customers sorted alphabetically by name
SELECT cust_name, city FROM Customers ORDER BY cust_name ASC;


-- ----------------------------------------------------------
-- TOPIC 3: AGGREGATE FUNCTIONS (SUM, AVG, COUNT, MAX, MIN)
-- ----------------------------------------------------------
-- 3.1 Total balance held by the bank
SELECT SUM(balance) AS total_bank_balance FROM Accounts;

-- 3.2 Average loan amount issued
SELECT AVG(loan_amount) AS average_loan_amount FROM Loans;

-- 3.3 Total number of customers
SELECT COUNT(*) AS total_customers FROM Customers;

-- 3.4 Highest and lowest account balance
SELECT MAX(balance) AS highest_balance, MIN(balance) AS lowest_balance FROM Accounts;

-- 3.5 Total amount deposited across all transactions
SELECT SUM(amount) AS total_deposits FROM Transactions WHERE transaction_type = 'Deposit';


-- ----------------------------------------------------------
-- TOPIC 4: GROUP BY & HAVING
-- ----------------------------------------------------------
-- 4.1 Number of accounts per branch
SELECT branch_id, COUNT(*) AS account_count FROM Accounts GROUP BY branch_id;

-- 4.2 Total loan amount per loan type
SELECT loan_type_id, SUM(loan_amount) AS total_amount FROM Loans GROUP BY loan_type_id;

-- 4.3 Average balance per account type
SELECT account_type_id, AVG(balance) AS avg_balance FROM Accounts GROUP BY account_type_id;

-- 4.4 Branches having more than 2 customers
SELECT branch_id, COUNT(*) AS cust_count FROM Customers
GROUP BY branch_id HAVING COUNT(*) > 1;

-- 4.5 Customers with total transaction amount above 20000
SELECT account_id, SUM(amount) AS total_amount FROM Transactions
GROUP BY account_id HAVING SUM(amount) > 20000;


-- ----------------------------------------------------------
-- TOPIC 5: INNER JOIN
-- ----------------------------------------------------------
-- 5.1 Customer names with their account numbers and balances
SELECT c.cust_name, a.account_number, a.balance
FROM Customers c INNER JOIN Accounts a ON c.customer_id = a.customer_id;

-- 5.2 Employees with their department and branch names
SELECT e.emp_name, d.department_name, b.branch_name
FROM Employees e
INNER JOIN Departments d ON e.department_id = d.department_id
INNER JOIN Branches b ON e.branch_id = b.branch_id;

-- 5.3 Loan details with customer names and loan type
SELECT c.cust_name, lt.loan_name, l.loan_amount, l.status
FROM Loans l
INNER JOIN Customers c ON l.customer_id = c.customer_id
INNER JOIN LoanTypes lt ON l.loan_type_id = lt.loan_type_id;

-- 5.4 Transactions with account number and customer name
SELECT c.cust_name, a.account_number, t.transaction_type, t.amount
FROM Transactions t
INNER JOIN Accounts a ON t.account_id = a.account_id
INNER JOIN Customers c ON a.customer_id = c.customer_id;

-- 5.5 Card details with account and customer info
SELECT c.cust_name, a.account_number, cd.card_type, cd.card_status
FROM Cards cd
INNER JOIN Accounts a ON cd.account_id = a.account_id
INNER JOIN Customers c ON a.customer_id = c.customer_id;


-- ----------------------------------------------------------
-- TOPIC 6: LEFT JOIN
-- ----------------------------------------------------------
-- 6.1 All customers with their loans (including customers with no loans)
SELECT c.cust_name, l.loan_id, l.loan_amount
FROM Customers c LEFT JOIN Loans l ON c.customer_id = l.customer_id;

-- 6.2 All accounts with cards (including accounts without a card)
SELECT a.account_number, cd.card_type, cd.card_status
FROM Accounts a LEFT JOIN Cards cd ON a.account_id = cd.account_id;

-- 6.3 All customers with their fixed deposits (including those without FDs)
SELECT c.cust_name, fd.amount, fd.maturity_date
FROM Customers c LEFT JOIN FixedDeposits fd ON c.customer_id = fd.customer_id;

-- 6.4 All customers with their nominees (including those without a nominee)
SELECT c.cust_name, n.nominee_name, n.relation
FROM Customers c LEFT JOIN Nominees n ON c.customer_id = n.customer_id;

-- 6.5 All accounts with cheque records (including accounts with no cheques)
SELECT a.account_number, ch.cheque_number, ch.status
FROM Accounts a LEFT JOIN Cheques ch ON a.account_id = ch.account_id;


-- ----------------------------------------------------------
-- TOPIC 7: SUBQUERIES
-- ----------------------------------------------------------
-- 7.1 Customers whose balance is above the average balance
SELECT cust_name FROM Customers
WHERE customer_id IN (
    SELECT customer_id FROM Accounts WHERE balance > (SELECT AVG(balance) FROM Accounts)
);

-- 7.2 Employees earning more than the average salary
SELECT emp_name, salary FROM Employees
WHERE salary > (SELECT AVG(salary) FROM Employees);

-- 7.3 Customers who have taken the highest loan amount
SELECT cust_name FROM Customers
WHERE customer_id = (SELECT customer_id FROM Loans ORDER BY loan_amount DESC LIMIT 1);

-- 7.4 Accounts that have never had a transaction
SELECT account_number FROM Accounts
WHERE account_id NOT IN (SELECT DISTINCT account_id FROM Transactions);

-- 7.5 Branches that have issued more than one loan
SELECT branch_name FROM Branches
WHERE branch_id IN (
    SELECT branch_id FROM Loans GROUP BY branch_id HAVING COUNT(*) > 1
);


-- ----------------------------------------------------------
-- TOPIC 8: STRING FUNCTIONS
-- ----------------------------------------------------------
-- 8.1 Display customer names in uppercase
SELECT UPPER(cust_name) AS name_upper FROM Customers;

-- 8.2 Extract first 4 digits of account numbers
SELECT account_number, SUBSTRING(account_number,1,4) AS prefix FROM Accounts;

-- 8.3 Concatenate customer name with city
SELECT CONCAT(cust_name, ' - ', city) AS customer_info FROM Customers;

-- 8.4 Length of each customer's email address
SELECT cust_name, LENGTH(email) AS email_length FROM Customers;

-- 8.5 Customers whose name starts with 'A'
SELECT cust_name FROM Customers WHERE cust_name LIKE 'A%';


-- ----------------------------------------------------------
-- TOPIC 9: DATE FUNCTIONS
-- ----------------------------------------------------------
-- 9.1 Customer age calculated from date of birth
SELECT cust_name, dob, TIMESTAMPDIFF(YEAR, dob, CURDATE()) AS age FROM Customers;

-- 9.2 Loans issued in the year 2020
SELECT loan_id, customer_id, issue_date FROM Loans WHERE YEAR(issue_date) = 2020;

-- 9.3 Number of months remaining for FD maturity
SELECT fd_id, TIMESTAMPDIFF(MONTH, CURDATE(), maturity_date) AS months_remaining FROM FixedDeposits;

-- 9.4 Transactions made in January 2024
SELECT * FROM Transactions
WHERE transaction_date BETWEEN '2024-01-01' AND '2024-01-31';

-- 9.5 Employees who joined in the last 5 years
SELECT emp_name, hire_date FROM Employees
WHERE hire_date >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR);


-- ----------------------------------------------------------
-- TOPIC 10: VIEWS
-- ----------------------------------------------------------
-- 10.1 View for customer account summary
CREATE OR REPLACE VIEW vw_customer_account_summary AS
SELECT c.customer_id, c.cust_name, a.account_number, a.balance, b.branch_name
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
JOIN Branches b ON a.branch_id = b.branch_id;
SELECT * FROM vw_customer_account_summary;

-- 10.2 View for active loans
CREATE OR REPLACE VIEW vw_active_loans AS
SELECT l.loan_id, c.cust_name, lt.loan_name, l.loan_amount, l.status
FROM Loans l
JOIN Customers c ON l.customer_id = c.customer_id
JOIN LoanTypes lt ON l.loan_type_id = lt.loan_type_id
WHERE l.status = 'Active';
SELECT * FROM vw_active_loans;

-- 10.3 View for branch-wise total deposits
CREATE OR REPLACE VIEW vw_branch_deposits AS
SELECT b.branch_name, SUM(a.balance) AS total_deposits
FROM Branches b JOIN Accounts a ON b.branch_id = a.branch_id
GROUP BY b.branch_name;
SELECT * FROM vw_branch_deposits;

-- 10.4 View for employee details with department and branch
CREATE OR REPLACE VIEW vw_employee_details AS
SELECT e.emp_name, d.department_name, b.branch_name, e.salary
FROM Employees e
JOIN Departments d ON e.department_id = d.department_id
JOIN Branches b ON e.branch_id = b.branch_id;
SELECT * FROM vw_employee_details;

-- 10.5 View for high-value customers (balance above 100000)
CREATE OR REPLACE VIEW vw_high_value_customers AS
SELECT c.cust_name, a.balance
FROM Customers c JOIN Accounts a ON c.customer_id = a.customer_id
WHERE a.balance > 100000;
SELECT * FROM vw_high_value_customers;


-- ----------------------------------------------------------
-- TOPIC 11: STORED PROCEDURES
-- ----------------------------------------------------------
DELIMITER $$

-- 11.1 Procedure to get all accounts of a given customer
CREATE PROCEDURE GetCustomerAccounts(IN p_customer_id INT)
BEGIN
    SELECT * FROM Accounts WHERE customer_id = p_customer_id;
END$$

-- 11.2 Procedure to deposit money into an account
CREATE PROCEDURE DepositAmount(IN p_account_id INT, IN p_amount DECIMAL(12,2))
BEGIN
    UPDATE Accounts SET balance = balance + p_amount WHERE account_id = p_account_id;
    INSERT INTO Transactions(account_id, transaction_type, amount, transaction_date, description)
    VALUES (p_account_id, 'Deposit', p_amount, NOW(), 'Deposit via procedure');
END$$

-- 11.3 Procedure to withdraw money from an account (checks balance first)
CREATE PROCEDURE WithdrawAmount(IN p_account_id INT, IN p_amount DECIMAL(12,2))
BEGIN
    DECLARE current_balance DECIMAL(12,2);
    SELECT balance INTO current_balance FROM Accounts WHERE account_id = p_account_id;
    IF current_balance >= p_amount THEN
        UPDATE Accounts SET balance = balance - p_amount WHERE account_id = p_account_id;
        INSERT INTO Transactions(account_id, transaction_type, amount, transaction_date, description)
        VALUES (p_account_id, 'Withdrawal', p_amount, NOW(), 'Withdrawal via procedure');
    ELSE
        SELECT 'Insufficient balance' AS message;
    END IF;
END$$

-- 11.4 Procedure to get total loan amount for a customer
CREATE PROCEDURE GetCustomerLoanTotal(IN p_customer_id INT)
BEGIN
    SELECT customer_id, SUM(loan_amount) AS total_loans
    FROM Loans WHERE customer_id = p_customer_id
    GROUP BY customer_id;
END$$

-- 11.5 Procedure to close an account
CREATE PROCEDURE CloseAccount(IN p_account_id INT)
BEGIN
    UPDATE Accounts SET status = 'Closed' WHERE account_id = p_account_id;
END$$

DELIMITER ;

-- Example calls:
-- CALL GetCustomerAccounts(1);
-- CALL DepositAmount(1, 5000);
-- CALL WithdrawAmount(1, 2000);
-- CALL GetCustomerLoanTotal(1);
-- CALL CloseAccount(8);


-- ----------------------------------------------------------
-- TOPIC 12: TRIGGERS
-- ----------------------------------------------------------
DELIMITER $$

-- 12.1 Trigger to prevent negative balance on withdrawal update
CREATE TRIGGER trg_prevent_negative_balance
BEFORE UPDATE ON Accounts
FOR EACH ROW
BEGIN
    IF NEW.balance < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Balance cannot be negative';
    END IF;
END$$

-- 12.2 Trigger to log every new account creation into Transactions as an opening entry
CREATE TRIGGER trg_account_open_log
AFTER INSERT ON Accounts
FOR EACH ROW
BEGIN
    INSERT INTO Transactions(account_id, transaction_type, amount, transaction_date, description)
    VALUES (NEW.account_id, 'Deposit', NEW.balance, NOW(), 'Account opening balance');
END$$

-- 12.3 Trigger to auto-update card status to Expired based on expiry date on insert
CREATE TRIGGER trg_card_expiry_check
BEFORE INSERT ON Cards
FOR EACH ROW
BEGIN
    IF NEW.expiry_date < CURDATE() THEN
        SET NEW.card_status = 'Expired';
    END IF;
END$$

-- 12.4 Trigger to prevent deleting a customer who has active loans
CREATE TRIGGER trg_prevent_customer_delete
BEFORE DELETE ON Customers
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM Loans WHERE customer_id = OLD.customer_id AND status = 'Active') > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete customer with active loans';
    END IF;
END$$

-- 12.5 Trigger to timestamp loan closure automatically (loans marked Closed get a payment record note)
CREATE TRIGGER trg_loan_closure_note
AFTER UPDATE ON Loans
FOR EACH ROW
BEGIN
    IF NEW.status = 'Closed' AND OLD.status <> 'Closed' THEN
        INSERT INTO LoanPayments(loan_id, payment_date, amount_paid)
        VALUES (NEW.loan_id, CURDATE(), 0);
    END IF;
END$$

DELIMITER ;


-- ----------------------------------------------------------
-- TOPIC 13: WINDOW FUNCTIONS
-- ----------------------------------------------------------
-- 13.1 Rank customers by account balance
SELECT c.cust_name, a.balance,
       RANK() OVER (ORDER BY a.balance DESC) AS balance_rank
FROM Customers c JOIN Accounts a ON c.customer_id = a.customer_id;

-- 13.2 Running total of deposits per account ordered by date
SELECT account_id, transaction_date, amount,
       SUM(amount) OVER (PARTITION BY account_id ORDER BY transaction_date) AS running_total
FROM Transactions WHERE transaction_type = 'Deposit';

-- 13.3 Row number of loans per branch ordered by loan amount
SELECT branch_id, loan_id, loan_amount,
       ROW_NUMBER() OVER (PARTITION BY branch_id ORDER BY loan_amount DESC) AS row_num
FROM Loans;

-- 13.4 Average balance per account type shown alongside each account (window)
SELECT account_number, account_type_id, balance,
       AVG(balance) OVER (PARTITION BY account_type_id) AS type_avg_balance
FROM Accounts;

-- 13.5 Dense rank of employees by salary within each department
SELECT emp_name, department_id, salary,
       DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS salary_rank
FROM Employees;


-- ----------------------------------------------------------
-- TOPIC 14: SET OPERATIONS & CASE STATEMENTS
-- ----------------------------------------------------------
-- 14.1 List of all customer and employee names combined (UNION)
SELECT cust_name AS person_name, 'Customer' AS role FROM Customers
UNION
SELECT emp_name AS person_name, 'Employee' AS role FROM Employees;

-- 14.2 Cities that have both customers and branches (UNION to combine, then check via city match manually)
SELECT DISTINCT city FROM Customers
UNION
SELECT DISTINCT branch_city FROM Branches;

-- 14.3 Categorize accounts by balance range using CASE
SELECT account_number, balance,
    CASE
        WHEN balance >= 200000 THEN 'High Value'
        WHEN balance >= 50000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS balance_category
FROM Accounts;

-- 14.4 Categorize loans as Short/Medium/Long term using CASE
SELECT loan_id, tenure_months,
    CASE
        WHEN tenure_months <= 24 THEN 'Short Term'
        WHEN tenure_months <= 60 THEN 'Medium Term'
        ELSE 'Long Term'
    END AS loan_term_category
FROM Loans;

-- 14.5 UNION ALL of all deposit and withdrawal transaction counts
SELECT 'Deposit' AS type, COUNT(*) AS total FROM Transactions WHERE transaction_type = 'Deposit'
UNION ALL
SELECT 'Withdrawal' AS type, COUNT(*) AS total FROM Transactions WHERE transaction_type = 'Withdrawal';

-- ============================================================
-- END OF PROJECT — 15 TABLES, 70 QUERIES ACROSS 14 TOPICS
-- ============================================================-- ============================================================
-- PROJECT     : BANKING MANAGEMENT SYSTEM
-- DATABASE    : MySQL
-- TABLES      : 15
-- QUERY TOPICS: 14 (5 queries each = 70 queries)
-- ============================================================

DROP DATABASE IF EXISTS banking_system;
CREATE DATABASE banking_system;
USE banking_system;

-- ============================================================
-- SECTION 1: TABLE CREATION (15 TABLES)
-- ============================================================

-- 1. Branches
CREATE TABLE Branches (
    branch_id INT PRIMARY KEY AUTO_INCREMENT,
    branch_name VARCHAR(100) NOT NULL,
    branch_city VARCHAR(50) NOT NULL,
    ifsc_code VARCHAR(15) UNIQUE NOT NULL
);

-- 2. Departments
CREATE TABLE Departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(50) NOT NULL
);

-- 3. Employees
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(100) NOT NULL,
    department_id INT,
    branch_id INT,
    designation VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id),
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);

-- 4. Customers
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    cust_name VARCHAR(100) NOT NULL,
    dob DATE,
    gender VARCHAR(10),
    phone VARCHAR(15),
    email VARCHAR(100),
    address VARCHAR(200),
    city VARCHAR(50),
    branch_id INT,
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);

-- 5. AccountTypes
CREATE TABLE AccountTypes (
    account_type_id INT PRIMARY KEY AUTO_INCREMENT,
    type_name VARCHAR(50) NOT NULL,
    interest_rate DECIMAL(5,2),
    min_balance DECIMAL(10,2)
);

-- 6. Accounts
CREATE TABLE Accounts (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    branch_id INT,
    account_type_id INT,
    account_number VARCHAR(20) UNIQUE NOT NULL,
    balance DECIMAL(12,2) DEFAULT 0,
    open_date DATE,
    status VARCHAR(20) DEFAULT 'Active',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id),
    FOREIGN KEY (account_type_id) REFERENCES AccountTypes(account_type_id)
);

-- 7. Transactions
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT,
    transaction_type VARCHAR(20),
    amount DECIMAL(12,2),
    transaction_date DATETIME,
    description VARCHAR(200),
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

-- 8. Cards
CREATE TABLE Cards (
    card_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT,
    card_number VARCHAR(20),
    card_type VARCHAR(20),
    expiry_date DATE,
    card_status VARCHAR(20) DEFAULT 'Active',
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

-- 9. LoanTypes
CREATE TABLE LoanTypes (
    loan_type_id INT PRIMARY KEY AUTO_INCREMENT,
    loan_name VARCHAR(50),
    interest_rate DECIMAL(5,2)
);

-- 10. Loans
CREATE TABLE Loans (
    loan_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    loan_type_id INT,
    branch_id INT,
    loan_amount DECIMAL(12,2),
    issue_date DATE,
    tenure_months INT,
    status VARCHAR(20) DEFAULT 'Active',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (loan_type_id) REFERENCES LoanTypes(loan_type_id),
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);

-- 11. LoanPayments
CREATE TABLE LoanPayments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    loan_id INT,
    payment_date DATE,
    amount_paid DECIMAL(10,2),
    FOREIGN KEY (loan_id) REFERENCES Loans(loan_id)
);

-- 12. FixedDeposits
CREATE TABLE FixedDeposits (
    fd_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    account_id INT,
    amount DECIMAL(12,2),
    start_date DATE,
    maturity_date DATE,
    interest_rate DECIMAL(5,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

-- 13. Beneficiaries
CREATE TABLE Beneficiaries (
    beneficiary_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    beneficiary_name VARCHAR(100),
    beneficiary_account_number VARCHAR(20),
    bank_name VARCHAR(100),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- 14. Cheques
CREATE TABLE Cheques (
    cheque_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT,
    cheque_number VARCHAR(20),
    issue_date DATE,
    amount DECIMAL(12,2),
    status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

-- 15. Nominees
CREATE TABLE Nominees (
    nominee_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    nominee_name VARCHAR(100),
    relation VARCHAR(50),
    dob DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- ============================================================
-- SECTION 2: SAMPLE DATA
-- ============================================================

INSERT INTO Branches (branch_name, branch_city, ifsc_code) VALUES
('Anna Nagar Branch','Chennai','BANK0001'),
('T Nagar Branch','Chennai','BANK0002'),
('Andheri Branch','Mumbai','BANK0003'),
('Koramangala Branch','Bangalore','BANK0004'),
('Salt Lake Branch','Kolkata','BANK0005');

INSERT INTO Departments (department_name) VALUES
('Loans'),('Customer Service'),('Operations'),('IT'),('HR');

INSERT INTO Employees (emp_name, department_id, branch_id, designation, salary, hire_date) VALUES
('Arun Kumar',1,1,'Loan Officer',45000,'2019-05-10'),
('Divya Shree',2,1,'Teller',30000,'2020-01-15'),
('Rahul Mehta',3,3,'Operations Manager',60000,'2018-03-20'),
('Priya Singh',4,4,'IT Support',40000,'2021-07-01'),
('Kavitha Rao',2,2,'Customer Rep',32000,'2020-11-11'),
('Suresh Babu',1,3,'Loan Officer',47000,'2017-09-09'),
('Anitha Menon',5,4,'HR Executive',38000,'2022-02-14');

INSERT INTO Customers (cust_name, dob, gender, phone, email, address, city, branch_id) VALUES
('Ramesh Iyer','1985-04-12','Male','9876543210','ramesh@mail.com','12 Gandhi St','Chennai',1),
('Sneha Patil','1990-08-25','Female','9876543211','sneha@mail.com','45 MG Road','Mumbai',3),
('Vikram Rao','1978-11-02','Male','9876543212','vikram@mail.com','7 Park Ave','Bangalore',4),
('Lakshmi Narayanan','1995-01-30','Female','9876543213','lakshmi@mail.com','9 Lake View','Kolkata',5),
('Arjun Das','1988-06-18','Male','9876543214','arjun@mail.com','23 Church St','Chennai',2),
('Meera Nair','1992-09-09','Female','9876543215','meera@mail.com','56 Hill Road','Mumbai',3),
('Kiran Kumar','1983-03-03','Male','9876543216','kiran@mail.com','3 Lake Town','Kolkata',5),
('Divya Bharathi','1997-12-20','Female','9876543217','divyab@mail.com','88 Anna Salai','Chennai',1);

INSERT INTO AccountTypes (type_name, interest_rate, min_balance) VALUES
('Savings',3.5,1000),
('Current',0,5000),
('Salary',4.0,0);

INSERT INTO Accounts (customer_id, branch_id, account_type_id, account_number, balance, open_date, status) VALUES
(1,1,1,'AC1001',125000,'2019-06-01','Active'),
(2,3,1,'AC1002',85000,'2020-02-10','Active'),
(3,4,2,'AC1003',560000,'2018-04-15','Active'),
(4,5,1,'AC1004',32000,'2021-01-20','Active'),
(5,2,3,'AC1005',48000,'2019-09-05','Active'),
(6,3,1,'AC1006',15000,'2022-03-11','Active'),
(7,5,2,'AC1007',210000,'2017-10-25','Active'),
(8,1,1,'AC1008',9000,'2022-06-30','Frozen');

INSERT INTO Transactions (account_id, transaction_type, amount, transaction_date, description) VALUES
(1,'Deposit',20000,'2024-01-05 10:00:00','Salary credit'),
(1,'Withdrawal',5000,'2024-01-10 15:30:00','ATM withdrawal'),
(2,'Deposit',10000,'2024-01-07 09:00:00','Cash deposit'),
(3,'Withdrawal',50000,'2024-02-01 12:00:00','Business payment'),
(3,'Deposit',100000,'2024-02-15 11:00:00','Client payment'),
(4,'Deposit',5000,'2024-01-20 14:00:00','Cash deposit'),
(5,'Withdrawal',3000,'2024-02-05 16:00:00','Online purchase'),
(6,'Deposit',2000,'2024-01-25 10:15:00','Cash deposit'),
(7,'Withdrawal',20000,'2024-02-10 13:00:00','Rent payment'),
(8,'Deposit',1000,'2024-01-30 09:30:00','Cash deposit'),
(1,'Withdrawal',8000,'2024-02-20 17:00:00','Utility bill'),
(3,'Withdrawal',25000,'2024-03-01 12:30:00','Vendor payment');

INSERT INTO Cards (account_id, card_number, card_type, expiry_date, card_status) VALUES
(1,'4111000000001001','Debit','2027-06-30','Active'),
(2,'4111000000001002','Debit','2026-02-28','Active'),
(3,'5500000000001003','Credit','2028-04-30','Active'),
(4,'4111000000001004','Debit','2025-01-31','Expired'),
(5,'5500000000001005','Credit','2027-09-30','Active'),
(7,'4111000000001007','Debit','2026-10-31','Active');

INSERT INTO LoanTypes (loan_name, interest_rate) VALUES
('Home Loan',7.5),('Personal Loan',11.0),('Car Loan',9.0),('Education Loan',8.0);

INSERT INTO Loans (customer_id, loan_type_id, branch_id, loan_amount, issue_date, tenure_months, status) VALUES
(1,1,1,2500000,'2020-05-01',240,'Active'),
(2,3,3,800000,'2021-03-15',60,'Active'),
(3,2,4,300000,'2022-01-10',24,'Closed'),
(4,4,5,500000,'2019-08-20',48,'Active'),
(6,3,3,600000,'2023-02-01',36,'Active'),
(7,1,5,1800000,'2018-11-05',180,'Active');

INSERT INTO LoanPayments (loan_id, payment_date, amount_paid) VALUES
(1,'2024-01-05',25000),
(1,'2024-02-05',25000),
(2,'2024-01-10',15000),
(2,'2024-02-10',15000),
(3,'2022-06-10',14000),
(4,'2024-01-20',12000),
(5,'2024-02-15',18000),
(6,'2024-01-25',20000);

INSERT INTO FixedDeposits (customer_id, account_id, amount, start_date, maturity_date, interest_rate) VALUES
(1,1,100000,'2023-01-01','2025-01-01',6.5),
(3,3,300000,'2022-06-01','2024-06-01',7.0),
(5,5,50000,'2023-09-01','2024-09-01',6.0),
(7,7,150000,'2021-01-01','2026-01-01',7.2);

INSERT INTO Beneficiaries (customer_id, beneficiary_name, beneficiary_account_number, bank_name) VALUES
(1,'Suresh Iyer','AC9001','HDFC Bank'),
(2,'Anil Patil','AC9002','ICICI Bank'),
(3,'Ganesh Rao','AC9003','SBI'),
(5,'Radha Das','AC9004','Axis Bank');

INSERT INTO Cheques (account_id, cheque_number, issue_date, amount, status) VALUES
(1,'CHQ0001','2024-01-15',15000,'Cleared'),
(3,'CHQ0002','2024-02-01',40000,'Cleared'),
(4,'CHQ0003','2024-01-22',5000,'Pending'),
(7,'CHQ0004','2024-02-05',12000,'Bounced');

INSERT INTO Nominees (customer_id, nominee_name, relation, dob) VALUES
(1,'Geetha Iyer','Spouse','1987-03-14'),
(2,'Anil Patil','Father','1960-07-22'),
(3,'Sunita Rao','Spouse','1980-05-19'),
(4,'Ravi Narayanan','Brother','1993-02-11'),
(5,'Radha Das','Mother','1958-12-01');

-- ============================================================
-- SECTION 3: QUERIES (14 TOPICS x 5 QUERIES = 70 QUERIES)
-- ============================================================

-- ----------------------------------------------------------
-- TOPIC 1: BASIC SELECT & WHERE
-- ----------------------------------------------------------
-- 1.1 List all customers from Chennai
SELECT * FROM Customers WHERE city = 'Chennai';

-- 1.2 Find all active accounts
SELECT * FROM Accounts WHERE status = 'Active';

-- 1.3 Get accounts with balance greater than 100000
SELECT account_number, balance FROM Accounts WHERE balance > 100000;

-- 1.4 List all female customers
SELECT cust_name, gender, city FROM Customers WHERE gender = 'Female';

-- 1.5 Find loans with amount between 500000 and 2000000
SELECT loan_id, customer_id, loan_amount FROM Loans WHERE loan_amount BETWEEN 500000 AND 2000000;


-- ----------------------------------------------------------
-- TOPIC 2: ORDER BY & LIMIT
-- ----------------------------------------------------------
-- 2.1 Top 3 customers by account balance
SELECT c.cust_name, a.balance
FROM Customers c JOIN Accounts a ON c.customer_id = a.customer_id
ORDER BY a.balance DESC LIMIT 3;

-- 2.2 List employees by salary ascending
SELECT emp_name, salary FROM Employees ORDER BY salary ASC;

-- 2.3 Latest 5 transactions
SELECT * FROM Transactions ORDER BY transaction_date DESC LIMIT 5;

-- 2.4 Loans sorted by issue date (oldest first)
SELECT loan_id, customer_id, issue_date FROM Loans ORDER BY issue_date ASC;

-- 2.5 Customers sorted alphabetically by name
SELECT cust_name, city FROM Customers ORDER BY cust_name ASC;


-- ----------------------------------------------------------
-- TOPIC 3: AGGREGATE FUNCTIONS (SUM, AVG, COUNT, MAX, MIN)
-- ----------------------------------------------------------
-- 3.1 Total balance held by the bank
SELECT SUM(balance) AS total_bank_balance FROM Accounts;

-- 3.2 Average loan amount issued
SELECT AVG(loan_amount) AS average_loan_amount FROM Loans;

-- 3.3 Total number of customers
SELECT COUNT(*) AS total_customers FROM Customers;

-- 3.4 Highest and lowest account balance
SELECT MAX(balance) AS highest_balance, MIN(balance) AS lowest_balance FROM Accounts;

-- 3.5 Total amount deposited across all transactions
SELECT SUM(amount) AS total_deposits FROM Transactions WHERE transaction_type = 'Deposit';


-- ----------------------------------------------------------
-- TOPIC 4: GROUP BY & HAVING
-- ----------------------------------------------------------
-- 4.1 Number of accounts per branch
SELECT branch_id, COUNT(*) AS account_count FROM Accounts GROUP BY branch_id;

-- 4.2 Total loan amount per loan type
SELECT loan_type_id, SUM(loan_amount) AS total_amount FROM Loans GROUP BY loan_type_id;

-- 4.3 Average balance per account type
SELECT account_type_id, AVG(balance) AS avg_balance FROM Accounts GROUP BY account_type_id;

-- 4.4 Branches having more than 2 customers
SELECT branch_id, COUNT(*) AS cust_count FROM Customers
GROUP BY branch_id HAVING COUNT(*) > 1;

-- 4.5 Customers with total transaction amount above 20000
SELECT account_id, SUM(amount) AS total_amount FROM Transactions
GROUP BY account_id HAVING SUM(amount) > 20000;


-- ----------------------------------------------------------
-- TOPIC 5: INNER JOIN
-- ----------------------------------------------------------
-- 5.1 Customer names with their account numbers and balances
SELECT c.cust_name, a.account_number, a.balance
FROM Customers c INNER JOIN Accounts a ON c.customer_id = a.customer_id;

-- 5.2 Employees with their department and branch names
SELECT e.emp_name, d.department_name, b.branch_name
FROM Employees e
INNER JOIN Departments d ON e.department_id = d.department_id
INNER JOIN Branches b ON e.branch_id = b.branch_id;

-- 5.3 Loan details with customer names and loan type
SELECT c.cust_name, lt.loan_name, l.loan_amount, l.status
FROM Loans l
INNER JOIN Customers c ON l.customer_id = c.customer_id
INNER JOIN LoanTypes lt ON l.loan_type_id = lt.loan_type_id;

-- 5.4 Transactions with account number and customer name
SELECT c.cust_name, a.account_number, t.transaction_type, t.amount
FROM Transactions t
INNER JOIN Accounts a ON t.account_id = a.account_id
INNER JOIN Customers c ON a.customer_id = c.customer_id;

-- 5.5 Card details with account and customer info
SELECT c.cust_name, a.account_number, cd.card_type, cd.card_status
FROM Cards cd
INNER JOIN Accounts a ON cd.account_id = a.account_id
INNER JOIN Customers c ON a.customer_id = c.customer_id;


-- ----------------------------------------------------------
-- TOPIC 6: LEFT JOIN
-- ----------------------------------------------------------
-- 6.1 All customers with their loans (including customers with no loans)
SELECT c.cust_name, l.loan_id, l.loan_amount
FROM Customers c LEFT JOIN Loans l ON c.customer_id = l.customer_id;

-- 6.2 All accounts with cards (including accounts without a card)
SELECT a.account_number, cd.card_type, cd.card_status
FROM Accounts a LEFT JOIN Cards cd ON a.account_id = cd.account_id;

-- 6.3 All customers with their fixed deposits (including those without FDs)
SELECT c.cust_name, fd.amount, fd.maturity_date
FROM Customers c LEFT JOIN FixedDeposits fd ON c.customer_id = fd.customer_id;

-- 6.4 All customers with their nominees (including those without a nominee)
SELECT c.cust_name, n.nominee_name, n.relation
FROM Customers c LEFT JOIN Nominees n ON c.customer_id = n.customer_id;

-- 6.5 All accounts with cheque records (including accounts with no cheques)
SELECT a.account_number, ch.cheque_number, ch.status
FROM Accounts a LEFT JOIN Cheques ch ON a.account_id = ch.account_id;


-- ----------------------------------------------------------
-- TOPIC 7: SUBQUERIES
-- ----------------------------------------------------------
-- 7.1 Customers whose balance is above the average balance
SELECT cust_name FROM Customers
WHERE customer_id IN (
    SELECT customer_id FROM Accounts WHERE balance > (SELECT AVG(balance) FROM Accounts)
);

-- 7.2 Employees earning more than the average salary
SELECT emp_name, salary FROM Employees
WHERE salary > (SELECT AVG(salary) FROM Employees);

-- 7.3 Customers who have taken the highest loan amount
SELECT cust_name FROM Customers
WHERE customer_id = (SELECT customer_id FROM Loans ORDER BY loan_amount DESC LIMIT 1);

-- 7.4 Accounts that have never had a transaction
SELECT account_number FROM Accounts
WHERE account_id NOT IN (SELECT DISTINCT account_id FROM Transactions);

-- 7.5 Branches that have issued more than one loan
SELECT branch_name FROM Branches
WHERE branch_id IN (
    SELECT branch_id FROM Loans GROUP BY branch_id HAVING COUNT(*) > 1
);


-- ----------------------------------------------------------
-- TOPIC 8: STRING FUNCTIONS
-- ----------------------------------------------------------
-- 8.1 Display customer names in uppercase
SELECT UPPER(cust_name) AS name_upper FROM Customers;

-- 8.2 Extract first 4 digits of account numbers
SELECT account_number, SUBSTRING(account_number,1,4) AS prefix FROM Accounts;

-- 8.3 Concatenate customer name with city
SELECT CONCAT(cust_name, ' - ', city) AS customer_info FROM Customers;

-- 8.4 Length of each customer's email address
SELECT cust_name, LENGTH(email) AS email_length FROM Customers;

-- 8.5 Customers whose name starts with 'A'
SELECT cust_name FROM Customers WHERE cust_name LIKE 'A%';


-- ----------------------------------------------------------
-- TOPIC 9: DATE FUNCTIONS
-- ----------------------------------------------------------
-- 9.1 Customer age calculated from date of birth
SELECT cust_name, dob, TIMESTAMPDIFF(YEAR, dob, CURDATE()) AS age FROM Customers;

-- 9.2 Loans issued in the year 2020
SELECT loan_id, customer_id, issue_date FROM Loans WHERE YEAR(issue_date) = 2020;

-- 9.3 Number of months remaining for FD maturity
SELECT fd_id, TIMESTAMPDIFF(MONTH, CURDATE(), maturity_date) AS months_remaining FROM FixedDeposits;

-- 9.4 Transactions made in January 2024
SELECT * FROM Transactions
WHERE transaction_date BETWEEN '2024-01-01' AND '2024-01-31';

-- 9.5 Employees who joined in the last 5 years
SELECT emp_name, hire_date FROM Employees
WHERE hire_date >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR);


-- ----------------------------------------------------------
-- TOPIC 10: VIEWS
-- ----------------------------------------------------------
-- 10.1 View for customer account summary
CREATE OR REPLACE VIEW vw_customer_account_summary AS
SELECT c.customer_id, c.cust_name, a.account_number, a.balance, b.branch_name
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
JOIN Branches b ON a.branch_id = b.branch_id;
SELECT * FROM vw_customer_account_summary;

-- 10.2 View for active loans
CREATE OR REPLACE VIEW vw_active_loans AS
SELECT l.loan_id, c.cust_name, lt.loan_name, l.loan_amount, l.status
FROM Loans l
JOIN Customers c ON l.customer_id = c.customer_id
JOIN LoanTypes lt ON l.loan_type_id = lt.loan_type_id
WHERE l.status = 'Active';
SELECT * FROM vw_active_loans;

-- 10.3 View for branch-wise total deposits
CREATE OR REPLACE VIEW vw_branch_deposits AS
SELECT b.branch_name, SUM(a.balance) AS total_deposits
FROM Branches b JOIN Accounts a ON b.branch_id = a.branch_id
GROUP BY b.branch_name;
SELECT * FROM vw_branch_deposits;

-- 10.4 View for employee details with department and branch
CREATE OR REPLACE VIEW vw_employee_details AS
SELECT e.emp_name, d.department_name, b.branch_name, e.salary
FROM Employees e
JOIN Departments d ON e.department_id = d.department_id
JOIN Branches b ON e.branch_id = b.branch_id;
SELECT * FROM vw_employee_details;

-- 10.5 View for high-value customers (balance above 100000)
CREATE OR REPLACE VIEW vw_high_value_customers AS
SELECT c.cust_name, a.balance
FROM Customers c JOIN Accounts a ON c.customer_id = a.customer_id
WHERE a.balance > 100000;
SELECT * FROM vw_high_value_customers;


-- ----------------------------------------------------------
-- TOPIC 11: STORED PROCEDURES
-- ----------------------------------------------------------
DELIMITER $$

-- 11.1 Procedure to get all accounts of a given customer
CREATE PROCEDURE GetCustomerAccounts(IN p_customer_id INT)
BEGIN
    SELECT * FROM Accounts WHERE customer_id = p_customer_id;
END$$

-- 11.2 Procedure to deposit money into an account
CREATE PROCEDURE DepositAmount(IN p_account_id INT, IN p_amount DECIMAL(12,2))
BEGIN
    UPDATE Accounts SET balance = balance + p_amount WHERE account_id = p_account_id;
    INSERT INTO Transactions(account_id, transaction_type, amount, transaction_date, description)
    VALUES (p_account_id, 'Deposit', p_amount, NOW(), 'Deposit via procedure');
END$$

-- 11.3 Procedure to withdraw money from an account (checks balance first)
CREATE PROCEDURE WithdrawAmount(IN p_account_id INT, IN p_amount DECIMAL(12,2))
BEGIN
    DECLARE current_balance DECIMAL(12,2);
    SELECT balance INTO current_balance FROM Accounts WHERE account_id = p_account_id;
    IF current_balance >= p_amount THEN
        UPDATE Accounts SET balance = balance - p_amount WHERE account_id = p_account_id;
        INSERT INTO Transactions(account_id, transaction_type, amount, transaction_date, description)
        VALUES (p_account_id, 'Withdrawal', p_amount, NOW(), 'Withdrawal via procedure');
    ELSE
        SELECT 'Insufficient balance' AS message;
    END IF;
END$$

-- 11.4 Procedure to get total loan amount for a customer
CREATE PROCEDURE GetCustomerLoanTotal(IN p_customer_id INT)
BEGIN
    SELECT customer_id, SUM(loan_amount) AS total_loans
    FROM Loans WHERE customer_id = p_customer_id
    GROUP BY customer_id;
END$$

-- 11.5 Procedure to close an account
CREATE PROCEDURE CloseAccount(IN p_account_id INT)
BEGIN
    UPDATE Accounts SET status = 'Closed' WHERE account_id = p_account_id;
END$$

DELIMITER ;

-- Example calls:
-- CALL GetCustomerAccounts(1);
-- CALL DepositAmount(1, 5000);
-- CALL WithdrawAmount(1, 2000);
-- CALL GetCustomerLoanTotal(1);
-- CALL CloseAccount(8);


-- ----------------------------------------------------------
-- TOPIC 12: TRIGGERS
-- ----------------------------------------------------------
DELIMITER $$

-- 12.1 Trigger to prevent negative balance on withdrawal update
CREATE TRIGGER trg_prevent_negative_balance
BEFORE UPDATE ON Accounts
FOR EACH ROW
BEGIN
    IF NEW.balance < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Balance cannot be negative';
    END IF;
END$$

-- 12.2 Trigger to log every new account creation into Transactions as an opening entry
CREATE TRIGGER trg_account_open_log
AFTER INSERT ON Accounts
FOR EACH ROW
BEGIN
    INSERT INTO Transactions(account_id, transaction_type, amount, transaction_date, description)
    VALUES (NEW.account_id, 'Deposit', NEW.balance, NOW(), 'Account opening balance');
END$$

-- 12.3 Trigger to auto-update card status to Expired based on expiry date on insert
CREATE TRIGGER trg_card_expiry_check
BEFORE INSERT ON Cards
FOR EACH ROW
BEGIN
    IF NEW.expiry_date < CURDATE() THEN
        SET NEW.card_status = 'Expired';
    END IF;
END$$

-- 12.4 Trigger to prevent deleting a customer who has active loans
CREATE TRIGGER trg_prevent_customer_delete
BEFORE DELETE ON Customers
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM Loans WHERE customer_id = OLD.customer_id AND status = 'Active') > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete customer with active loans';
    END IF;
END$$

-- 12.5 Trigger to timestamp loan closure automatically (loans marked Closed get a payment record note)
CREATE TRIGGER trg_loan_closure_note
AFTER UPDATE ON Loans
FOR EACH ROW
BEGIN
    IF NEW.status = 'Closed' AND OLD.status <> 'Closed' THEN
        INSERT INTO LoanPayments(loan_id, payment_date, amount_paid)
        VALUES (NEW.loan_id, CURDATE(), 0);
    END IF;
END$$

DELIMITER ;


-- ----------------------------------------------------------
-- TOPIC 13: WINDOW FUNCTIONS
-- ----------------------------------------------------------
-- 13.1 Rank customers by account balance
SELECT c.cust_name, a.balance,
       RANK() OVER (ORDER BY a.balance DESC) AS balance_rank
FROM Customers c JOIN Accounts a ON c.customer_id = a.customer_id;

-- 13.2 Running total of deposits per account ordered by date
SELECT account_id, transaction_date, amount,
       SUM(amount) OVER (PARTITION BY account_id ORDER BY transaction_date) AS running_total
FROM Transactions WHERE transaction_type = 'Deposit';

-- 13.3 Row number of loans per branch ordered by loan amount
SELECT branch_id, loan_id, loan_amount,
       ROW_NUMBER() OVER (PARTITION BY branch_id ORDER BY loan_amount DESC) AS row_num
FROM Loans;

-- 13.4 Average balance per account type shown alongside each account (window)
SELECT account_number, account_type_id, balance,
       AVG(balance) OVER (PARTITION BY account_type_id) AS type_avg_balance
FROM Accounts;

-- 13.5 Dense rank of employees by salary within each department
SELECT emp_name, department_id, salary,
       DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS salary_rank
FROM Employees;


-- ----------------------------------------------------------
-- TOPIC 14: SET OPERATIONS & CASE STATEMENTS
-- ----------------------------------------------------------
-- 14.1 List of all customer and employee names combined (UNION)
SELECT cust_name AS person_name, 'Customer' AS role FROM Customers
UNION
SELECT emp_name AS person_name, 'Employee' AS role FROM Employees;

-- 14.2 Cities that have both customers and branches (UNION to combine, then check via city match manually)
SELECT DISTINCT city FROM Customers
UNION
SELECT DISTINCT branch_city FROM Branches;

-- 14.3 Categorize accounts by balance range using CASE
SELECT account_number, balance,
    CASE
        WHEN balance >= 200000 THEN 'High Value'
        WHEN balance >= 50000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS balance_category
FROM Accounts;

-- 14.4 Categorize loans as Short/Medium/Long term using CASE
SELECT loan_id, tenure_months,
    CASE
        WHEN tenure_months <= 24 THEN 'Short Term'
        WHEN tenure_months <= 60 THEN 'Medium Term'
        ELSE 'Long Term'
    END AS loan_term_category
FROM Loans;

-- 14.5 UNION ALL of all deposit and withdrawal transaction counts
SELECT 'Deposit' AS type, COUNT(*) AS total FROM Transactions WHERE transaction_type = 'Deposit'
UNION ALL
SELECT 'Withdrawal' AS type, COUNT(*) AS total FROM Transactions WHERE transaction_type = 'Withdrawal';

-- ============================================================
-- END OF PROJECT — 15 TABLES, 70 QUERIES ACROSS 14 TOPICS
-- ============================================================
