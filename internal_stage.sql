CREATE OR REPLACE TABLE TWEETS_INTERNAL (
  author              VARCHAR,
  content             VARCHAR,
  country             VARCHAR,
  date_time           VARCHAR,
  id                  VARCHAR,
  language            VARCHAR(10),
  latitude            STRING,
  longitude           STRING,
  number_of_likes     INT,
  number_of_shares    INT
);

CREATE OR REPLACE FILE FORMAT tweets_csv_format
  TYPE = 'CSV'
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  SKIP_HEADER = 1
  TRIM_SPACE = TRUE
  NULL_IF = ('NULL','')
  EMPTY_FIELD_AS_NULL = TRUE;

  CREATE OR REPLACE STAGE tweets_int_stage
  FILE_FORMAT = tweets_csv_format;

  
COPY INTO TWEETS_INTERNAL
FROM @tweets_int_stage/tweets.csv
FILE_FORMAT = (FORMAT_NAME = tweets_csv_format)
ON_ERROR = 'CONTINUE';

//select * from TWEETS_INTERNAL;
