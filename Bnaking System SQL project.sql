DROP DATABASE IF EXISTS banking_system;
CREATE DATABASE banking_system;
USE banking_system;

-- ============================================================
-- SECTION 1: TABLE CREATION (10 TABLES)
-- ============================================================

-- 1. BRANCHES
CREATE TABLE branches (
    branch_id     INT PRIMARY KEY AUTO_INCREMENT,
    branch_name   VARCHAR(100) NOT NULL,
    city          VARCHAR(50),
    state         VARCHAR(50),
    ifsc_code     VARCHAR(15) UNIQUE,
    manager_name  VARCHAR(100),
    phone         VARCHAR(15)
);

-- 2. EMPLOYEES
CREATE TABLE employees (
    employee_id   INT PRIMARY KEY AUTO_INCREMENT,
    first_name    VARCHAR(50),
    last_name     VARCHAR(50),
    branch_id     INT,
    designation   VARCHAR(50),
    salary        DECIMAL(10,2),
    hire_date     DATE,
    email         VARCHAR(100),
    phone         VARCHAR(15),
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);

-- 3. CUSTOMERS
CREATE TABLE customers (
    customer_id   INT PRIMARY KEY AUTO_INCREMENT,
    first_name    VARCHAR(50),
    last_name     VARCHAR(50),
    dob           DATE,
    gender        VARCHAR(10),
    city          VARCHAR(50),
    state         VARCHAR(50),
    phone         VARCHAR(15),
    email         VARCHAR(100),
    pan_number    VARCHAR(15) UNIQUE,
    created_date  DATE
);

-- 4. ACCOUNT TYPES
CREATE TABLE account_types (
    account_type_id INT PRIMARY KEY AUTO_INCREMENT,
    type_name       VARCHAR(60),
    interest_rate   DECIMAL(5,2),
    min_balance     DECIMAL(10,2)
);

-- 5. ACCOUNTS
CREATE TABLE accounts (
    account_id      INT PRIMARY KEY AUTO_INCREMENT,
    customer_id     INT,
    branch_id       INT,
    account_type_id INT,
    account_number  VARCHAR(20) UNIQUE,
    balance         DECIMAL(12,2) DEFAULT 0,
    status          VARCHAR(15) DEFAULT 'ACTIVE',
    opened_date     DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id),
    FOREIGN KEY (account_type_id) REFERENCES account_types(account_type_id)
);

-- 6. TRANSACTIONS
CREATE TABLE transactions (
    transaction_id   INT PRIMARY KEY AUTO_INCREMENT,
    account_id       INT,
    transaction_type VARCHAR(15),   -- DEPOSIT, WITHDRAWAL
    amount           DECIMAL(12,2),
    transaction_date DATETIME,
    description      VARCHAR(150),
    balance_after    DECIMAL(12,2),
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

-- 7. LOAN TYPES
CREATE TABLE loan_types (
    loan_type_id      INT PRIMARY KEY AUTO_INCREMENT,
    loan_name         VARCHAR(60),
    interest_rate     DECIMAL(5,2),
    max_amount        DECIMAL(12,2),
    max_tenure_months INT
);

-- 8. LOANS
CREATE TABLE loans (
    loan_id           INT PRIMARY KEY AUTO_INCREMENT,
    customer_id       INT,
    loan_type_id      INT,
    branch_id         INT,
    principal_amount  DECIMAL(12,2),
    interest_rate     DECIMAL(5,2),
    tenure_months     INT,
    emi_amount        DECIMAL(10,2),
    start_date        DATE,
    status            VARCHAR(15),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (loan_type_id) REFERENCES loan_types(loan_type_id),
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);

-- 9. LOAN PAYMENTS
CREATE TABLE loan_payments (
    payment_id           INT PRIMARY KEY AUTO_INCREMENT,
    loan_id              INT,
    payment_date         DATE,
    amount_paid          DECIMAL(10,2),
    principal_component  DECIMAL(10,2),
    interest_component   DECIMAL(10,2),
    payment_status       VARCHAR(15),
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
);

-- 10. BALANCE HISTORY
CREATE TABLE balance_history (
    history_id       INT PRIMARY KEY AUTO_INCREMENT,
    account_id       INT,
    balance_date     DATE,
    opening_balance  DECIMAL(12,2),
    closing_balance  DECIMAL(12,2),
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);


-- ============================================================
-- SECTION 2: INSERT DATA (20 ROWS PER TABLE)
-- ============================================================

-- ---------- 1. BRANCHES (20 rows) ----------
INSERT INTO branches (branch_name, city, state, ifsc_code, manager_name, phone) VALUES
('Chennai Main','Chennai','Tamil Nadu','BANK0001','Ravi Kumar','9840011001'),
('T Nagar Branch','Chennai','Tamil Nadu','BANK0002','Lakshmi Narayan','9840011002'),
('Anna Nagar Branch','Chennai','Tamil Nadu','BANK0003','Suresh Babu','9840011003'),
('Mumbai Fort','Mumbai','Maharashtra','BANK0004','Anita Shah','9820011004'),
('Andheri Branch','Mumbai','Maharashtra','BANK0005','Rohit Mehta','9820011005'),
('Connaught Place','Delhi','Delhi','BANK0006','Vikram Sethi','9810011006'),
('Karol Bagh Branch','Delhi','Delhi','BANK0007','Pooja Arora','9810011007'),
('MG Road Branch','Bangalore','Karnataka','BANK0008','Karthik Rao','9900011008'),
('Whitefield Branch','Bangalore','Karnataka','BANK0009','Deepa Iyer','9900011009'),
('Banjara Hills','Hyderabad','Telangana','BANK0010','Srinivas Reddy','9940011010'),
('Park Street','Kolkata','West Bengal','BANK0011','Soumya Banerjee','9830011011'),
('Salt Lake Branch','Kolkata','West Bengal','BANK0012','Arijit Das','9830011012'),
('Pune Camp','Pune','Maharashtra','BANK0013','Sanjay Patil','9860011013'),
('Hinjewadi Branch','Pune','Maharashtra','BANK0014','Neha Joshi','9860011014'),
('Navrangpura','Ahmedabad','Gujarat','BANK0015','Kiran Patel','9870011015'),
('Malviya Nagar','Jaipur','Rajasthan','BANK0016','Rajendra Singh','9950011016'),
('Hazratganj Branch','Lucknow','Uttar Pradesh','BANK0017','Anil Verma','9950011017'),
('Civil Lines','Kanpur','Uttar Pradesh','BANK0018','Manoj Tiwari','9950011018'),
('RS Puram','Coimbatore','Tamil Nadu','BANK0019','Meena Subramaniam','9840011019'),
('Edappally','Kochi','Kerala','BANK0020','Thomas Jacob','9940011020');

-- ---------- 2. EMPLOYEES (20 rows) ----------
INSERT INTO employees (first_name, last_name, branch_id, designation, salary, hire_date, email, phone) VALUES
('Arun','Prakash',1,'Branch Manager',85000,'2015-03-12','arun.prakash@bank.com','9001000001'),
('Divya','Shankar',1,'Loan Officer',52000,'2018-06-23','divya.shankar@bank.com','9001000002'),
('Ramesh','Iyer',2,'Cashier',32000,'2019-01-15','ramesh.iyer@bank.com','9001000003'),
('Priya','Venkat',2,'Clerk',28000,'2020-09-09','priya.venkat@bank.com','9001000004'),
('Suresh','Kumar',3,'Branch Manager',86000,'2014-11-02','suresh.kumar@bank.com','9001000005'),
('Anjali','Menon',3,'Teller',30000,'2021-02-18','anjali.menon@bank.com','9001000006'),
('Vivek','Nair',4,'Branch Manager',90000,'2013-07-21','vivek.nair@bank.com','9001000007'),
('Sneha','Joshi',4,'Loan Officer',54000,'2017-05-30','sneha.joshi@bank.com','9001000008'),
('Rahul','Deshmukh',5,'Cashier',31000,'2019-08-14','rahul.deshmukh@bank.com','9001000009'),
('Kavya','Reddy',5,'Clerk',27500,'2022-03-03','kavya.reddy@bank.com','9001000010'),
('Manish','Gupta',6,'Branch Manager',88000,'2014-04-19','manish.gupta@bank.com','9001000011'),
('Ritu','Sharma',6,'Teller',29500,'2020-12-01','ritu.sharma@bank.com','9001000012'),
('Aditya','Verma',7,'Loan Officer',53000,'2018-10-10','aditya.verma@bank.com','9001000013'),
('Pallavi','Singh',7,'Clerk',28000,'2021-07-07','pallavi.singh@bank.com','9001000014'),
('Karthik','Subramani',8,'Branch Manager',87000,'2015-09-25','karthik.s@bank.com','9001000015'),
('Swathi','Rao',8,'Cashier',31500,'2019-11-11','swathi.rao@bank.com','9001000016'),
('Naveen','Kumar',9,'Teller',30500,'2020-05-05','naveen.kumar@bank.com','9001000017'),
('Harini','Krishnan',9,'Clerk',27000,'2022-01-20','harini.k@bank.com','9001000018'),
('Mahesh','Reddy',10,'Branch Manager',89000,'2013-12-12','mahesh.reddy@bank.com','9001000019'),
('Lavanya','Prasad',10,'Loan Officer',52500,'2017-08-08','lavanya.p@bank.com','9001000020');

-- ---------- 3. CUSTOMERS (20 rows) ----------
INSERT INTO customers (first_name, last_name, dob, gender, city, state, phone, email, pan_number, created_date) VALUES
('Aarav','Sharma','1990-05-12','Male','Chennai','Tamil Nadu','9123456701','aarav.sharma@mail.com','ABCDE1234A','2018-01-10'),
('Diya','Patel','1992-08-21','Female','Mumbai','Maharashtra','9123456702','diya.patel@mail.com','ABCDE1235B','2018-02-15'),
('Vihaan','Reddy','1988-11-03','Male','Bangalore','Karnataka','9123456703','vihaan.reddy@mail.com','ABCDE1236C','2018-03-20'),
('Ananya','Iyer','1995-02-17','Female','Chennai','Tamil Nadu','9123456704','ananya.iyer@mail.com','ABCDE1237D','2018-04-05'),
('Arjun','Singh','1985-07-29','Male','Delhi','Delhi','9123456705','arjun.singh@mail.com','ABCDE1238E','2018-05-12'),
('Ishaan','Mehta','1993-09-09','Male','Mumbai','Maharashtra','9123456706','ishaan.mehta@mail.com','ABCDE1239F','2018-06-18'),
('Saanvi','Nair','1991-12-25','Female','Hyderabad','Telangana','9123456707','saanvi.nair@mail.com','ABCDE1240G','2018-07-22'),
('Aditi','Banerjee','1989-04-14','Female','Kolkata','West Bengal','9123456708','aditi.banerjee@mail.com','ABCDE1241H','2018-08-30'),
('Krishna','Rao','1994-06-06','Male','Pune','Maharashtra','9123456709','krishna.rao@mail.com','ABCDE1242I','2018-09-09'),
('Meera','Joshi','1996-01-19','Female','Pune','Maharashtra','9123456710','meera.joshi@mail.com','ABCDE1243J','2018-10-14'),
('Rohan','Patel','1987-03-23','Male','Ahmedabad','Gujarat','9123456711','rohan.patel@mail.com','ABCDE1244K','2018-11-20'),
('Kavya','Singh','1992-10-10','Female','Jaipur','Rajasthan','9123456712','kavya.singh@mail.com','ABCDE1245L','2018-12-25'),
('Rohit','Verma','1990-02-28','Male','Lucknow','Uttar Pradesh','9123456713','rohit.verma@mail.com','ABCDE1246M','2019-01-15'),
('Pooja','Tiwari','1993-05-05','Female','Kanpur','Uttar Pradesh','9123456714','pooja.tiwari@mail.com','ABCDE1247N','2019-02-20'),
('Dev','Subramaniam','1994-07-07','Male','Coimbatore','Tamil Nadu','9123456715','dev.subramaniam@mail.com','ABCDE1248O','2019-03-25'),
('Joel','Thomas','1987-12-02','Male','Kochi','Kerala','9123456716','joel.thomas@mail.com','ABCDE1249P','2019-04-30'),
('Vikram','Nathan','1988-01-27','Male','Chennai','Tamil Nadu','9123456717','vikram.nathan@mail.com','ABCDE1250Q','2019-05-10'),
('Sanjana','Rao','1993-08-16','Female','Bangalore','Karnataka','9123456718','sanjana.rao@mail.com','ABCDE1251R','2019-06-18'),
('Yash','Malhotra','1991-02-09','Male','Delhi','Delhi','9123456719','yash.malhotra@mail.com','ABCDE1252S','2019-07-22'),
('Tara','Khanna','1996-10-30','Female','Mumbai','Maharashtra','9123456720','tara.khanna@mail.com','ABCDE1253T','2019-08-28');

-- ---------- 4. ACCOUNT TYPES (20 rows) ----------
INSERT INTO account_types (type_name, interest_rate, min_balance) VALUES
('Savings Regular',3.50,1000),
('Savings Premium',4.00,5000),
('Savings Senior Citizen',4.50,1000),
('Savings Women Special',4.00,2000),
('Savings Student',3.00,0),
('Savings Salary',3.50,0),
('Current Basic',0.00,5000),
('Current Premium',0.00,25000),
('Current Business',0.00,50000),
('Current Corporate',0.00,100000),
('Fixed Deposit 1Yr',6.50,10000),
('Fixed Deposit 2Yr',6.75,10000),
('Fixed Deposit 3Yr',7.00,10000),
('Fixed Deposit 5Yr',7.25,10000),
('Recurring Deposit',6.00,500),
('NRI Savings',3.75,10000),
('NRI Current',0.00,50000),
('Zero Balance Savings',3.00,0),
('Pension Savings',4.25,0),
('Minor Savings',3.00,500);

-- ---------- 5. ACCOUNTS (20 rows) ----------
INSERT INTO accounts (customer_id, branch_id, account_type_id, account_number, balance, status, opened_date) VALUES
(1,1,1,'AC100000001',152000.00,'ACTIVE','2018-01-12'),
(2,4,2,'AC100000002',89000.00,'ACTIVE','2018-02-18'),
(3,8,7,'AC100000003',320000.00,'ACTIVE','2018-03-22'),
(4,1,1,'AC100000004',45000.00,'ACTIVE','2018-04-08'),
(5,6,9,'AC100000005',780000.00,'ACTIVE','2018-05-15'),
(6,5,1,'AC100000006',23000.00,'ACTIVE','2018-06-20'),
(7,10,2,'AC100000007',67000.00,'ACTIVE','2018-07-25'),
(8,11,1,'AC100000008',15000.00,'INACTIVE','2018-08-31'),
(9,13,11,'AC100000009',200000.00,'ACTIVE','2018-09-10'),
(10,14,1,'AC100000010',38000.00,'ACTIVE','2018-10-16'),
(11,15,7,'AC100000011',95000.00,'ACTIVE','2018-11-22'),
(12,16,1,'AC100000012',12000.00,'ACTIVE','2018-12-27'),
(13,17,4,'AC100000013',54000.00,'ACTIVE','2019-01-17'),
(14,18,1,'AC100000014',8000.00,'ACTIVE','2019-02-22'),
(15,19,2,'AC100000015',76000.00,'ACTIVE','2019-03-27'),
(16,20,1,'AC100000016',29000.00,'ACTIVE','2019-04-02'),
(17,1,9,'AC100000017',410000.00,'ACTIVE','2019-05-12'),
(18,2,1,'AC100000018',5000.00,'CLOSED','2019-06-19'),
(19,3,1,'AC100000019',62000.00,'ACTIVE','2019-07-24'),
(20,4,2,'AC100000020',88000.00,'ACTIVE','2019-08-29');

-- ---------- 6. TRANSACTIONS (20 rows) ----------
INSERT INTO transactions (account_id, transaction_type, amount, transaction_date, description, balance_after) VALUES
(1,'DEPOSIT',20000,'2024-01-05 10:15:00','Salary credit',152000),
(2,'WITHDRAWAL',5000,'2024-01-06 11:20:00','ATM withdrawal',89000),
(3,'DEPOSIT',50000,'2024-01-07 09:30:00','Cheque deposit',320000),
(4,'WITHDRAWAL',2000,'2024-01-08 14:45:00','Cash withdrawal',45000),
(5,'DEPOSIT',100000,'2024-01-09 16:00:00','Business deposit',780000),
(6,'WITHDRAWAL',1000,'2024-01-10 12:10:00','Online purchase',23000),
(7,'DEPOSIT',15000,'2024-01-11 13:25:00','Salary credit',67000),
(8,'WITHDRAWAL',3000,'2024-01-12 17:40:00','Bill payment',15000),
(9,'DEPOSIT',25000,'2024-01-13 10:05:00','FD interest',200000),
(10,'WITHDRAWAL',4000,'2024-01-14 11:55:00','ATM withdrawal',38000),
(11,'DEPOSIT',30000,'2024-01-15 09:15:00','Cheque deposit',95000),
(12,'WITHDRAWAL',1500,'2024-01-16 15:20:00','Online purchase',12000),
(13,'DEPOSIT',10000,'2024-01-17 10:40:00','Salary credit',54000),
(14,'WITHDRAWAL',500,'2024-01-18 12:30:00','Cash withdrawal',8000),
(15,'DEPOSIT',12000,'2024-01-19 13:10:00','Cheque deposit',76000),
(16,'WITHDRAWAL',2500,'2024-01-20 16:50:00','Bill payment',29000),
(17,'DEPOSIT',60000,'2024-01-21 09:00:00','Business deposit',410000),
(18,'WITHDRAWAL',1000,'2024-01-22 11:35:00','Account closure',5000),
(19,'DEPOSIT',8000,'2024-01-23 10:25:00','Salary credit',62000),
(20,'WITHDRAWAL',3500,'2024-01-24 14:15:00','ATM withdrawal',88000);

-- ---------- 7. LOAN TYPES (20 rows) ----------
INSERT INTO loan_types (loan_name, interest_rate, max_amount, max_tenure_months) VALUES
('Home Loan Fixed',8.50,8000000,240),
('Home Loan Floating',8.25,8000000,240),
('Car Loan New',9.00,1500000,84),
('Car Loan Used',10.50,800000,60),
('Personal Loan',12.00,1000000,60),
('Education Loan Domestic',9.50,2000000,120),
('Education Loan Abroad',10.00,4000000,180),
('Gold Loan',9.75,500000,36),
('Business Loan MSME',11.00,5000000,84),
('Agriculture Loan',7.50,1000000,60),
('Two Wheeler Loan',11.50,200000,36),
('Loan Against Property',9.25,10000000,180),
('Loan Against FD',7.00,500000,60),
('Consumer Durable Loan',13.00,300000,24),
('Overdraft Loan',12.50,1000000,12),
('Working Capital Loan',11.25,5000000,36),
('Term Loan',10.75,3000000,60),
('Mortgage Loan',8.75,6000000,180),
('Renovation Loan',10.25,1500000,84),
('Marriage Loan',13.50,1000000,60);

-- ---------- 8. LOANS (20 rows) ----------
INSERT INTO loans (customer_id, loan_type_id, branch_id, principal_amount, interest_rate, tenure_months, emi_amount, start_date, status) VALUES
(1,1,1,2500000,8.50,180,24500,'2021-01-15','ACTIVE'),
(2,3,4,800000,9.00,60,16800,'2021-02-20','ACTIVE'),
(3,5,8,300000,12.00,36,9950,'2021-03-25','CLOSED'),
(4,6,1,1200000,9.50,84,18600,'2021-04-10','ACTIVE'),
(5,9,6,3000000,11.00,84,52000,'2021-05-15','ACTIVE'),
(6,2,5,1800000,8.25,180,17200,'2021-06-20','ACTIVE'),
(7,4,10,450000,10.50,48,11600,'2021-07-25','ACTIVE'),
(8,8,11,200000,9.75,24,9200,'2021-08-30','CLOSED'),
(9,1,13,3500000,8.50,240,30500,'2021-09-04','ACTIVE'),
(10,5,14,250000,12.00,36,8300,'2021-10-09','ACTIVE'),
(11,11,15,150000,11.50,36,4950,'2021-11-14','ACTIVE'),
(12,12,16,5000000,9.25,180,51000,'2021-12-19','ACTIVE'),
(13,3,17,600000,9.00,60,12500,'2022-01-23','ACTIVE'),
(14,6,18,900000,9.50,84,14000,'2022-02-27','ACTIVE'),
(15,9,19,2000000,11.00,60,43500,'2022-04-03','ACTIVE'),
(16,5,20,180000,12.00,24,8500,'2022-05-08','CLOSED'),
(17,1,1,4000000,8.50,240,34800,'2022-06-13','ACTIVE'),
(18,7,2,5000000,10.00,180,53700,'2022-07-18','ACTIVE'),
(19,14,3,250000,13.00,24,11700,'2022-08-23','ACTIVE'),
(20,8,4,180000,9.75,24,8300,'2022-09-27','CLOSED');

-- ---------- 9. LOAN PAYMENTS (20 rows) ----------
INSERT INTO loan_payments (loan_id, payment_date, amount_paid, principal_component, interest_component, payment_status) VALUES
(1,'2024-01-15',24500,16200,8300,'PAID'),
(2,'2024-01-20',16800,11200,5600,'PAID'),
(3,'2024-01-25',9950,8200,1750,'PAID'),
(4,'2024-01-10',18600,9500,9100,'PAID'),
(5,'2024-01-15',52000,30000,22000,'PAID'),
(6,'2024-01-20',17200,9200,8000,'PAID'),
(7,'2024-01-25',11600,7100,4500,'PAID'),
(8,'2024-01-30',9200,7800,1400,'PAID'),
(9,'2024-02-04',30500,18200,12300,'PAID'),
(10,'2024-02-09',8300,5700,2600,'PAID'),
(11,'2024-02-14',4950,3700,1250,'PAID'),
(12,'2024-02-19',51000,28800,22200,'PAID'),
(13,'2024-02-23',12500,8000,4500,'PAID'),
(14,'2024-02-27',14000,8400,5600,'PAID'),
(15,'2024-03-03',43500,24700,18800,'PAID'),
(16,'2024-03-08',8500,7100,1400,'PAID'),
(17,'2024-03-13',34800,19200,15600,'PAID'),
(18,'2024-03-18',53700,28900,24800,'PAID'),
(19,'2024-03-23',11700,9400,2300,'PAID'),
(20,'2024-03-27',8300,7000,1300,'PAID');

-- ---------- 10. BALANCE HISTORY (20 rows) ----------
INSERT INTO balance_history (account_id, balance_date, opening_balance, closing_balance) VALUES
(1,'2024-01-01',132000,152000),
(2,'2024-01-01',94000,89000),
(3,'2024-01-01',270000,320000),
(4,'2024-01-01',47000,45000),
(5,'2024-01-01',680000,780000),
(6,'2024-01-01',24000,23000),
(7,'2024-01-01',52000,67000),
(8,'2024-01-01',18000,15000),
(9,'2024-01-01',175000,200000),
(10,'2024-01-01',42000,38000),
(11,'2024-01-01',65000,95000),
(12,'2024-01-01',13500,12000),
(13,'2024-01-01',44000,54000),
(14,'2024-01-01',8500,8000),
(15,'2024-01-01',64000,76000),
(16,'2024-01-01',31500,29000),
(17,'2024-01-01',350000,410000),
(18,'2024-01-01',6000,5000),
(19,'2024-01-01',54000,62000),
(20,'2024-01-01',91500,88000);


-- ============================================================
-- SECTION 3: TRIGGERS
-- ============================================================

-- TRIGGER 1: Block a withdrawal that would overdraw an account
DELIMITER //
CREATE TRIGGER trg_before_transaction_insert
BEFORE INSERT ON transactions
FOR EACH ROW
BEGIN
    DECLARE current_balance DECIMAL(12,2);
    SELECT balance INTO current_balance FROM accounts WHERE account_id = NEW.account_id;

    IF NEW.transaction_type = 'WITHDRAWAL' AND NEW.amount > current_balance THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient balance for this withdrawal';
    END IF;
END //
DELIMITER ;

-- TRIGGER 2: After a transaction is inserted, auto-update account balance
-- and log the change into balance_history
DELIMITER //
CREATE TRIGGER trg_after_transaction_insert
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    DECLARE old_bal DECIMAL(12,2);

    SELECT balance INTO old_bal FROM accounts WHERE account_id = NEW.account_id;

    IF NEW.transaction_type = 'DEPOSIT' THEN
        UPDATE accounts SET balance = balance + NEW.amount WHERE account_id = NEW.account_id;
    ELSEIF NEW.transaction_type = 'WITHDRAWAL' THEN
        UPDATE accounts SET balance = balance - NEW.amount WHERE account_id = NEW.account_id;
    END IF;

    INSERT INTO balance_history (account_id, balance_date, opening_balance, closing_balance)
    VALUES (NEW.account_id, DATE(NEW.transaction_date), old_bal, NEW.balance_after);
END //
DELIMITER ;


-- ============================================================
-- SECTION 4: VIEWS
-- ============================================================

CREATE VIEW vw_customer_account_summary AS
SELECT c.customer_id, CONCAT(c.first_name,' ',c.last_name) AS customer_name,
       a.account_number, a.balance, b.branch_name, t.type_name
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN branches b ON a.branch_id = b.branch_id
JOIN account_types t ON a.account_type_id = t.account_type_id;

CREATE VIEW vw_active_loans_summary AS
SELECT l.loan_id, CONCAT(c.first_name,' ',c.last_name) AS customer_name,
       lt.loan_name, l.principal_amount, l.interest_rate, l.emi_amount, l.status
FROM loans l
JOIN customers c ON l.customer_id = c.customer_id
JOIN loan_types lt ON l.loan_type_id = lt.loan_type_id
WHERE l.status = 'ACTIVE';


-- ============================================================
-- SECTION 5: STORED PROCEDURES
-- ============================================================

DELIMITER //
CREATE PROCEDURE sp_get_customer_statement(IN p_customer_id INT)
BEGIN
    SELECT t.transaction_id, a.account_number, t.transaction_type,
           t.amount, t.transaction_date, t.balance_after
    FROM transactions t
    JOIN accounts a ON t.account_id = a.account_id
    WHERE a.customer_id = p_customer_id
    ORDER BY t.transaction_date;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_loan_outstanding(IN p_loan_id INT, OUT p_outstanding DECIMAL(12,2))
BEGIN
    DECLARE total_paid DECIMAL(12,2);
    SELECT IFNULL(SUM(principal_component),0) INTO total_paid
    FROM loan_payments WHERE loan_id = p_loan_id;

    SELECT principal_amount - total_paid INTO p_outstanding
    FROM loans WHERE loan_id = p_loan_id;
END //
DELIMITER ;


-- ============================================================
-- SECTION 6: QUERIES 
-- ============================================================

-- Q1  Customers from Chennai
SELECT * FROM customers WHERE city = 'Chennai';

-- Q2 Active accounts with balance above 50000
SELECT account_number, balance FROM accounts WHERE balance > 50000;

-- Q3 Branches in Tamil Nadu
SELECT branch_name, city FROM branches WHERE state = 'Tamil Nadu';

-- Q4 Count customers per state
SELECT state, COUNT(*) AS total FROM customers GROUP BY state;

-- Q5 [JOIN] Customer name with account balance
SELECT c.first_name, a.balance FROM customers c JOIN accounts a ON c.customer_id = a.customer_id;

-- Q6 [JOIN] Account with branch name
SELECT a.account_number, b.branch_name FROM accounts a JOIN branches b ON a.branch_id = b.branch_id;

-- Q7 [JOIN] Loan with loan type name
SELECT l.loan_id, lt.loan_name FROM loans l JOIN loan_types lt ON l.loan_type_id = lt.loan_type_id;

-- Q8 [LEFT JOIN] Customers with their loans (if any)
SELECT c.first_name, l.loan_id FROM customers c LEFT JOIN loans l ON c.customer_id = l.customer_id;

-- Q9 [LEFT JOIN] Branches with employee count
SELECT b.branch_name, COUNT(e.employee_id) AS emp_count FROM branches b LEFT JOIN employees e ON b.branch_id = e.branch_id GROUP BY b.branch_name;

-- Q10 [SELF JOIN] Employees in the same branch
SELECT e1.first_name, e2.first_name FROM employees e1 JOIN employees e2 ON e1.branch_id = e2.branch_id AND e1.employee_id < e2.employee_id;

-- ---------------- LEVEL 3: AGGREGATE / GROUP BY / HAVING  ----------------

-- Q11 [AGGREGATE] Total balance per branch
SELECT branch_id, SUM(balance) AS total_balance FROM accounts GROUP BY branch_id;

-- Q12 [AGGREGATE+HAVING] Branches with total balance above 100000
SELECT branch_id, SUM(balance) AS total_balance FROM accounts GROUP BY branch_id HAVING SUM(balance) > 100000;

-- Q13 [AGGREGATE] Average loan amount per loan type
SELECT loan_type_id, AVG(principal_amount) AS avg_amount FROM loans GROUP BY loan_type_id;

-- Q14 [AGGREGATE] Total paid per loan
SELECT loan_id, SUM(amount_paid) AS total_paid FROM loan_payments GROUP BY loan_id;

-- Q15 [AGGREGATE] Average salary per designation
SELECT designation, AVG(salary) AS avg_salary FROM employees GROUP BY designation;

-- ---------------- LEVEL 4: SUBQUERIES / CTE  ----------------

-- Q16 [SUBQUERY] Accounts with balance above the average balance
SELECT account_number, balance FROM accounts WHERE balance > (SELECT AVG(balance) FROM accounts);

-- Q17 [CORRELATED SUBQUERY] Customers with more than one account
SELECT first_name FROM customers c WHERE (SELECT COUNT(*) FROM accounts a WHERE a.customer_id = c.customer_id) > 1;

-- Q18 [CTE] Total deposit per customer using a CTE
WITH deposits AS (SELECT customer_id, SUM(balance) AS total FROM accounts GROUP BY customer_id)
SELECT * FROM deposits WHERE total > 50000;

-- ---------------- LEVEL 5: VIEWS  ----------------

-- Q19 [VIEW USAGE] Customer account summary view
SELECT * FROM vw_customer_account_summary WHERE balance > 50000;

-- Q20 [VIEW USAGE] Active loans summary view
SELECT * FROM vw_active_loans_summary;

-- ---------------- LEVEL 6: STORED PROCEDURES ----------------

-- Q21 [STORED PROCEDURE] Customer statement for customer_id = 1
CALL sp_get_customer_statement(1);

-- Q22 [STORED PROCEDURE] Outstanding amount for loan_id = 5
CALL sp_loan_outstanding(5, @outstanding);
SELECT @outstanding;

------------------- LEVEL 7: WINDOW FUNCTIONS - ADVANCED ----------------

-- Q23 [WINDOW FUNCTION] Rank accounts by balance within each branch
SELECT branch_id, account_number, balance, RANK() OVER (PARTITION BY branch_id ORDER BY balance DESC) AS rnk FROM accounts;

-- Q24 [WINDOW FUNCTION] Running total of transaction amounts per account
SELECT account_id, amount, SUM(amount) OVER (PARTITION BY account_id ORDER BY transaction_date) AS running_total FROM transactions;

-- Q25 [WINDOW FUNCTION] Row number of loans ordered by amount per loan type
SELECT loan_type_id, principal_amount, ROW_NUMBER() OVER (PARTITION BY loan_type_id ORDER BY principal_amount DESC) AS rnk FROM loans;
