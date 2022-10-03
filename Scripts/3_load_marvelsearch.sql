
use role sysadmin;
use database data_vault;
use schema staging;


-- create staging view
create or replace view STAGING.STG_SUPERHEROES_MARVEL_SEARCH
as
SELECT 
JSON_RAW:urls.wikipedia::string as BEING_ID,
'https://github.com/algolia/marvel-search:' || BEING_ID::STRING AS BEING_ID_BKCC,
MD5(BEING_ID_BKCC) AS HUB_BEING_KEY,
parse_json(
    '{"Source_System": "https://github.com/algolia/marvel-search", 
    "Source_Table": "RAW.SUPERHERO.SUPERHEROES_MARVEL_SEARCH", 
     "Source_Columns": { "SOURCE_URL": ["JSON_RAW:urls.wikipedia"] } 
      }' ) :: variant AS RECORD_SOURCE,
current_timestamp()::timestamp_tz as LOAD_TIME, -- in UTC
MD5(BEING_ID_BKCC ||  LOAD_TIME) as SAT_BEING_MARVEL_SEARCH_KEY,
JSON_RAW:superName::string as NAME,
JSON_RAW,
MD5(JSON_RAW) AS RECORD_HASH
from RAW.SUPERHERO.SUPERHEROES_MARVEL_SEARCH;



SELECT * FROM STAGING.STG_SUPERHEROES_MARVEL_SEARCH;


use schema superhero;

INSERT INTO superhero.HUB_BEING
SELECT 
    DISTINCT 
    HUB_BEING_KEY,
    BEING_ID,
    BEING_ID_BKCC,
    RECORD_SOURCE,
    LOAD_TIME     
FROM DATA_VAULT.STAGING.STG_SUPERHEROES_MARVEL_SEARCH STG
 WHERE NOT EXISTS (SELECT * FROM DATA_VAULT.SUPERHERO.HUB_BEING HB WHERE STG.HUB_BEING_KEY = HB.HUB_BEING_KEY );


INSERT INTO superhero.SAT_BEING_MARVEL_SEARCH_RAW ( SAT_BEING_MARVEL_SEARCH_KEY,
    HUB_BEING_KEY,
    BEING_ID,
    BEING_ID_BKCC,
    NAME,
    JSON_RAW,
    RECORD_HASH,
    LOAD_TIME )
SELECT 
    SAT_BEING_MARVEL_SEARCH_KEY,
    HUB_BEING_KEY,
    BEING_ID,
    BEING_ID_BKCC,
    NAME,
    JSON_RAW,
    RECORD_HASH,
    LOAD_TIME   
FROM DATA_VAULT.STAGING.STG_SUPERHEROES_MARVEL_SEARCH STG
 WHERE NOT EXISTS (SELECT * FROM DATA_VAULT.SUPERHERO.SAT_BEING_MARVEL_SEARCH_RAW SB WHERE STG.HUB_BEING_KEY = SB.HUB_BEING_KEY 
                  and STG.RECORD_HASH = SB.RECORD_HASH);



SELECT *
FROM DATA_VAULT.SUPERHERO.HUB_BEING;

SELECT *
FROM DATA_VAULT.SUPERHERO.SAT_BEING_MARVEL_SEARCH_RAW;


-- PROJECT EFFECTIVE DATES IN A VIEW
CREATE OR REPLACE VIEW SUPERHERO.SAT_BEING_MARVEL_SEARCH
AS
WITH CTE_READ_FROM_RAW 
AS (
    SELECT  
      SAT_BEING_MARVEL_SEARCH_KEY,
      HUB_BEING_KEY,
      BEING_ID,
      BEING_ID_BKCC,
      NAME,
      JSON_RAW,
      RECORD_HASH,
      LOAD_TIME,   
      LOAD_TIME as EFFECTIVE_FROM_DT,
      lead(LOAD_TIME) over (partition by HUB_BEING_KEY order by LOAD_TIME) as EFFECTIVE_TO_DT  
    FROM SUPERHERO.SAT_BEING_MARVEL_SEARCH_RAW
  )
  SELECT
      SAT_BEING_MARVEL_SEARCH_KEY,
      HUB_BEING_KEY,
      BEING_ID,
      BEING_ID_BKCC,
      NAME,
      JSON_RAW,
      LOAD_TIME,   
      EFFECTIVE_FROM_DT ,
      ifnull(EFFECTIVE_TO_DT, '2099-12-31'::timestamp_tz)  as EFFECTIVE_TO_DT,
      (EFFECTIVE_TO_DT is null) as IS_CURRENT ,
      RECORD_HASH 
      FROM CTE_READ_FROM_RAW; 

    
 -- TO TEST EFFECTIVE DATES INSERT UPDATED RECORD
INSERT INTO SUPERHERO.SAT_BEING_MARVEL_SEARCH_RAW
WITH UPDATED AS ( 
SELECT  
   parse_json(column1) AS JSON_RAW 
   , JSON_RAW:urls.wikipedia::string as BEING_ID 
    ,'https://github.com/algolia/marvel-search:'||BEING_ID AS BEING_ID_BKCC
    , MD5(BEING_ID_BKCC) AS HUB_BEING_KEY
    , JSON_RAW:superName::string as NAME
    , MD5(UPPER(JSON_RAW)) AS RECORD_HASH
FROM VALUES
('{
  "aliases": [
    "Spider-Woman"
  ],
  "authors": [
    "Archie Goodwin",
    "Marie Severin"
  ],
  "description": "Spider-Woman is the codename of several fictional characters in comic books published by Marvel Comics.",
  "images": {
    "background": "http://x.annihil.us/u/prod/marvel/i/mg/8/c0/537bc50e40e1c.gif",
    "thumbnail": "http://x.annihil.us/u/prod/marvel/i/mg/c/50/537bc4ac6fc72/standard_xlarge.jpg"
  },
  "mainColor": {
    "blue": 6,
    "green": 6,
    "hexa": "3F0606",
    "red": 63
  },
  "name": "Spider-Woman UPDATED",
  "partners": [],
  "powers": [],
  "ranking": {
    "comicCount": 0,
    "eventCount": 0,
    "pageviewCount": 6788,
    "serieCount": 0,
    "storyCount": 0
  },
  "secretIdentities": [],
  "species": [],
  "superName": "Spider-Woman TEST",
  "teams": [],
  "urls": {
    "marvel": "http://marvel.com/characters/55/spider-woman",
    "wikipedia": "https://en.wikipedia.org/wiki/Spider-Woman"
  }
}')
  )
 
  SELECT  
  MD5(HUB_BEING_KEY || current_timestamp()::timestamp_tz ) AS SAT_BEING_MARVEL_SEARCH_KEY
  ,HUB_BEING_KEY
  ,BEING_ID
  ,BEING_ID_BKCC
  ,NAME
  ,JSON_RAW
  ,RECORD_HASH
  ,current_timestamp()::timestamp_tz as LOAD_TIME
FROM UPDATED;
