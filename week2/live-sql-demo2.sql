CREATE TABLE savings_accounts (
  AccountID NUMBER PRIMARY KEY,
  CustomerID NUMBER,
  Balance NUMBER(10,2)
);

INSERT INTO savings_accounts VALUES (101, 1, 10000);
INSERT INTO savings_accounts VALUES (102, 2, 5000);
INSERT INTO savings_accounts VALUES (103, 3, 12000);
COMMIT;

CREATE OR REPLACE PROCEDURE ProcessMonthlyInterest AS
BEGIN
  FOR acc IN (SELECT AccountID, Balance FROM savings_accounts) LOOP
    UPDATE savings_accounts
    SET Balance = Balance + (Balance * 0.01)
    WHERE AccountID = acc.AccountID;
  END LOOP;
  COMMIT;
END;

CREATE TABLE employees (
  EmpID NUMBER PRIMARY KEY,
  Name VARCHAR2(100),
  Department VARCHAR2(50),
  Salary NUMBER(10,2)
);

INSERT INTO employees VALUES (1, 'Megha', 'HR', 50000);
INSERT INTO employees VALUES (2, 'Hari', 'IT', 60000);
INSERT INTO employees VALUES (3, 'Bindu', 'IT', 65000);
INSERT INTO employees VALUES (4, 'Suhan', 'HR', 52000);
COMMIT;

CREATE OR REPLACE PROCEDURE UpdateEmployeeBonus (
  dept IN VARCHAR2,
  bonus_percent IN NUMBER
) AS
BEGIN
  UPDATE employees
  SET Salary = Salary + (Salary * bonus_percent / 100)
  WHERE Department = dept;
  COMMIT;
END;

CREATE TABLE bank_accounts (
  AccountID NUMBER PRIMARY KEY,
  CustomerName VARCHAR2(100),
  Balance NUMBER(10,2)
);

INSERT INTO bank_accounts VALUES (201, 'Alice', 10000);
INSERT INTO bank_accounts VALUES (202, 'Bob', 8000);
COMMIT;

CREATE OR REPLACE PROCEDURE TransferFunds (
  source_acc IN NUMBER,
  target_acc IN NUMBER,
  amount IN NUMBER
) AS
  source_balance NUMBER;
BEGIN
  SELECT Balance INTO source_balance FROM bank_accounts WHERE AccountID = source_acc FOR UPDATE;

  IF source_balance < amount THEN
    RAISE_APPLICATION_ERROR(-20001, 'Insufficient balance in source account.');
  ELSE
    UPDATE bank_accounts
    SET Balance = Balance - amount
    WHERE AccountID = source_acc;

    UPDATE bank_accounts
    SET Balance = Balance + amount
    WHERE AccountID = target_acc;

    COMMIT;
  END IF;
END;