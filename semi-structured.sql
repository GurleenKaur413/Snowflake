

CREATE OR REPLACE TABLE json_table (data VARIANT);
CREATE OR REPLACE TABLE xml_table (data VARIANT);
CREATE OR REPLACE TABLE parquet_table (data VARIANT);
CREATE OR REPLACE TABLE avro_table (data VARIANT);

show tables;

//upload files in stages

-- JSON
COPY INTO json_table
FROM @~/employees.json
FILE_FORMAT = (TYPE = 'JSON');

-- XML
COPY INTO xml_table
FROM @~/employees.xml
FILE_FORMAT = (TYPE = 'XML' ROW_TAG='employee');

-- Parquet
COPY INTO parquet_table
FROM @~/products.parquet
FILE_FORMAT = (TYPE = 'PARQUET');

-- Avro
COPY INTO avro_table
FROM @~/events.avro
FILE_FORMAT = (TYPE = 'AVRO');


// query table
//json table
SELECT data:id AS emp_id, data:name AS emp_name
FROM json_table;



// xml table
SELECT data:id::NUMBER AS emp_id, data:name::STRING AS emp_name, data:department::STRING AS dept
FROM xml_table;

//parquet
SELECT data:id::NUMBER AS product_id, data:product_name::STRING AS product, data:price::NUMBER AS price
FROM parquet_table;

//avro
SELECT data:event_id::NUMBER AS id, data:event_name::STRING AS name, data:timestamp::STRING AS ts
FROM avro_table;

//Count skill occurrences
SELECT f.value AS skill, COUNT(*) AS frequency
FROM json_table, LATERAL FLATTEN(input => data:skills) f
GROUP BY skill
ORDER BY frequency DESC;

// Type conversion 
SELECT data:id::NUMBER AS emp_id, data:name::STRING AS emp_name
FROM json_table;

//bonus exercise: combine all forms in single table 
//hint: UNION ALL


