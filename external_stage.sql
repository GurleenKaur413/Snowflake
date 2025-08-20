USE DATABASE MY_DB;           
USE SCHEMA MY_SCHEMA;         

CREATE OR REPLACE TABLE TWEETS_RAW (
  author               VARCHAR,
  content              VARCHAR,
  country              VARCHAR,
  date_time            VARCHAR,  
  id                   VARCHAR,   
  language             VARCHAR(10),
  latitude             VARCHAR,  
  longitude            VARCHAR,
  number_of_likes      VARCHAR,   
  number_of_shares     VARCHAR
);

--------create file format----
CREATE OR REPLACE FILE FORMAT tweets_csv_format
  TYPE = 'CSV'
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  SKIP_HEADER = 1
  TRIM_SPACE = TRUE
  NULL_IF = ('NULL','')
  EMPTY_FIELD_AS_NULL = TRUE;


----storage integration---
CREATE OR REPLACE STORAGE INTEGRATION my_gcs_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = GCS
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('gcs://snowflake_gk/');

  DESC STORAGE INTEGRATION my_gcs_integration;


----create external stage---
CREATE OR REPLACE STAGE tweets_gcs_stage
  URL = 'gcs://snowflake_gk/'
  STORAGE_INTEGRATION = my_gcs_integration
  FILE_FORMAT = tweets_csv_format;

LIST @tweets_gcs_stage;

---load data---
COPY INTO TWEETS_RAW
FROM @tweets_gcs_stage/tweets.csv
FILE_FORMAT = (FORMAT_NAME = 'tweets_csv_format')
ON_ERROR = 'CONTINUE'   ;


SELECT COUNT(*) AS rows_loaded FROM TWEETS_RAW;
SELECT * FROM TWEETS_RAW LIMIT 10;

_