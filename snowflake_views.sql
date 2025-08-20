USE DATABASE demo_db;

show databases;

-- Create a schema inside the database
CREATE SCHEMA sales_schema;-- Create a standard view
CREATE OR REPLACE VIEW EMPLOYEE_VIEW AS
SELECT NAME, DEPARTMENT
FROM EMPLOYEES
WHERE DEPARTMENT = 'IT';

-- Query the view
SELECT * FROM EMPLOYEE_VIEW;

-----materialized view----
-- Create a materialized view
CREATE OR REPLACE MATERIALIZED VIEW EMPLOYEE_IT_VIEW AS
SELECT NAME, DEPARTMENT
FROM EMPLOYEES
WHERE DEPARTMENT = 'IT';

-- Query the materialized view
SELECT * FROM EMPLOYEE_IT_VIEW;


----comparison---

//USE SCHEMA DEMO_DB.LAB_SCHEMA;

-- Create a sample sales table
CREATE OR REPLACE TABLE SALES (
    ID INT,
    CUSTOMER STRING,
    AMOUNT NUMBER,
    REGION STRING
);

-- Insert sample data
INSERT INTO SALES VALUES
(1, 'Alice', 200, 'North'),
(2, 'Bob', 500, 'South'),
(3, 'Charlie', 700, 'East'),
(4, 'David', 400, 'North'),
(5, 'Emma', 300, 'South');


SELECT * FROM sales;

-- A view showing sales from the North region
CREATE OR REPLACE VIEW SALES_NORTH_VIEW AS
SELECT CUSTOMER, AMOUNT
FROM SALES
WHERE REGION = 'North';

-- Query the view
SELECT * FROM SALES_NORTH_VIEW;

-- Create a materialized view for South region sales
CREATE OR REPLACE MATERIALIZED VIEW SALES_SOUTH_VIEW AS
SELECT CUSTOMER, AMOUNT
FROM SALES
WHERE REGION = 'South';

-- Query the materialized view
SELECT * FROM SALES_SOUTH_VIEW;

-- Insert new data
INSERT INTO SALES VALUES (6, 'Frank', 900, 'South');

-- Query both views again
SELECT * FROM SALES_NORTH_VIEW;   -- Standard View
SELECT * FROM SALES_SOUTH_VIEW;   -- Materialized View

-- See how much storage is used by views
SELECT TABLE_NAME, BYTES, ROW_COUNT
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'LAB_SCHEMA';

