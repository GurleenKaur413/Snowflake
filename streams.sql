-- Table to store raw orders loaded by Snowpipe
CREATE TABLE raw_orders (
    order_id INT,
    customer_name STRING,
    amount FLOAT,
    order_date DATE
);

-- Stream to track new rows in raw_orders
CREATE STREAM raw_orders_stream 
ON TABLE raw_orders
SHOW_INITIAL_ROWS = TRUE;  


-- Table to store processed/cleaned orders
CREATE TABLE processed_orders (
    order_id INT,
    customer_name STRING,
    amount FLOAT,
    order_date DATE
);

-- Task that moves new data from stream to processed table
CREATE TASK process_orders_task
WAREHOUSE = COMPUTE_WH
SCHEDULE = '1 MINUTE'  -- Run every minute
AS
INSERT INTO processed_orders
SELECT order_id, UPPER(customer_name), amount, order_date
FROM raw_orders_stream;


-- Internal stage to upload CSV files
CREATE  STAGE orders_stage;

//simulate stage with files orders.csv

CREATE PIPE orders_pipe
AUTO_INGEST = TRUE
AS
COPY INTO raw_orders
FROM @orders_stage
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY='"' SKIP_HEADER=1);

SELECT * FROM PROCESSED_ORDERS