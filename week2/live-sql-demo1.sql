CREATE TABLE customers (
  CustomerID NUMBER PRIMARY KEY,
  Name VARCHAR2(100),
  Age NUMBER,
  Balance NUMBER(10,2),
  IsVIP VARCHAR2(5),
  InterestRate NUMBER(5,2)
);

CREATE TABLE loans (
  LoanID NUMBER PRIMARY KEY,
  CustomerID NUMBER,
  DueDate DATE,
  FOREIGN KEY (CustomerID) REFERENCES customers(CustomerID)
);

-- Insert into customers
INSERT INTO customers VALUES (1, 'Charitha', 65, 8000, 'FALSE', 9.5);
INSERT INTO customers VALUES (2, 'Sneha', 45, 12000, 'FALSE', 8.5);
INSERT INTO customers VALUES (3, 'Madhu', 70, 15000, 'FALSE', 10.0);
INSERT INTO customers VALUES (4, 'Trisha', 59, 9500, 'FALSE', 9.0);

-- Insert into loans
INSERT INTO loans VALUES (101, 1, SYSDATE + 20);
INSERT INTO loans VALUES (102, 2, SYSDATE + 40);
INSERT INTO loans VALUES (103, 3, SYSDATE + 10);
INSERT INTO loans VALUES (104, 4, SYSDATE + 5);

COMMIT;

BEGIN
  FOR customer_rec IN (SELECT CustomerID FROM customers WHERE Age > 60) LOOP
    UPDATE customers
    SET InterestRate = InterestRate - (InterestRate * 0.01)
    WHERE CustomerID = customer_rec.CustomerID;
  END LOOP;
  COMMIT;
END;

BEGIN
  FOR customer_rec IN (SELECT CustomerID FROM customers WHERE Balance > 10000) LOOP
    UPDATE customers
    SET IsVIP = 'TRUE'
    WHERE CustomerID = customer_rec.CustomerID;
  END LOOP;
  COMMIT;
END;

SET SERVEROUTPUT ON;

BEGIN
  FOR loan_rec IN (
    SELECT LoanID, CustomerID, DueDate
    FROM loans
    WHERE DueDate BETWEEN SYSDATE AND (SYSDATE + 30)
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('Reminder: Loan ID ' || loan_rec.LoanID ||
                         ' for Customer ID ' || loan_rec.CustomerID ||
                         ' is due on ' || TO_CHAR(loan_rec.DueDate, 'DD-MON-YYYY'));
  END LOOP;
END;

