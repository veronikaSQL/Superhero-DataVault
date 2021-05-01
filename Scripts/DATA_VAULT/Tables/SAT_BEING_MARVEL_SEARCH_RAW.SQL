INSERT INTO DATA_VAULT.SAT_BEING_MARVEL_SEARCH_RAW
WITH READ_FROM_SOURCE AS 
(
    SELECT
    DISTINCT
    JSON_RAW:urls.wikipedia::string as SOURCE_URL 
    ,'MARVEL_SEARCH:'||SOURCE_URL AS URL
    , MD5(URL) AS HUB_BEING_KEY
    , JSON_RAW:superName::string as NAME
    , JSON_RAW
    , MD5(UPPER(JSON_RAW)) AS RECORD_HASH
    from "SUPERHERO"."DEMO"."SUPERHEROES_MARVEL_SEARCH" 
  where JSON_RAW:urls.wikipedia::string is not NULL
)
  
  SELECT 
   MD5(SRC.HUB_BEING_KEY || current_timestamp()::timestamp_tz ) AS SAT_BEING_MARVEL_SEARCH_KEY
  ,SRC.HUB_BEING_KEY
  ,SRC.URL
  ,SRC.SOURCE_URL
  ,SRC.NAME
  ,SRC.JSON_RAW
  ,SRC.RECORD_HASH
  ,current_timestamp()::timestamp_tz as LOAD_TIME
from READ_FROM_SOURCE src
    LEFT JOIN DATA_VAULT.SAT_BEING_MARVEL_SEARCH_RAW TGT
    ON SRC.HUB_BEING_KEY = TGT.HUB_BEING_KEY
    AND SRC.RECORD_HASH = TGT.RECORD_HASH
    WHERE TGT.HUB_BEING_KEY IS NULL;
    -- TO TEST EFFECTIVE DATES INSERT UPDATED RECORD
INSERT INTO SAT_BEING_MARVEL_SEARCH_RAW

WITH UPDATED AS ( 
SELECT  
   parse_json(column1) AS JSON_RAW 
   , JSON_RAW:urls.wikipedia::string as SOURCE_URL 
    ,'MARVEL_SEARCH:'||SOURCE_URL AS URL
    , MD5(URL) AS HUB_BEING_KEY
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
  "name": "Spider-Woman TEST",
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
 
  SELECT  MD5(HUB_BEING_KEY || current_timestamp()::timestamp_tz ) AS SAT_BEING_MARVEL_SEARCH_KEY
  ,HUB_BEING_KEY
  ,URL
  ,SOURCE_URL
  ,NAME
  ,JSON_RAW
  ,RECORD_HASH
  ,current_timestamp()::timestamp_tz as LOAD_TIME
FROM UPDATED;
