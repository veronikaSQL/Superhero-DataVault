INSERT INTO DATA_VAULT.HUB_BEING 
WITH READ_FROM_RAW AS 
(
    SELECT
    DISTINCT
    JSON_RAW:urls.wikipedia::string as SOURCE_URL 
    ,'MARVEL_SEARCH:'||SOURCE_URL AS URL
    , MD5(URL) AS HUB_BEING_KEY
    , parse_json( 
        '{"Source_System": "https://github.com/algolia/marvel-search", 
        "Source_Table": "SUPERHERO.DEMO.SUPERHEROES_MARVEL_SEARCH", 
        "Source_Columns": { "SOURCE_URL": ["JSON_RAW:urls.wikipedia"] } 
         }' )::variant AS RECORD_SOURCE
    from "SUPERHERO"."DEMO"."SUPERHEROES_MARVEL_SEARCH"
    WHERE JSON_RAW:urls.wikipedia IS NOT NULL
    UNION ALL
    SELECT DISTINCT
    'https://www.superherodb.com'||URL as SOURCE_URL 
    ,'SUPERHERODB:'||SOURCE_URL AS URL
    , MD5(URL) AS HUB_BEING_KEY
    , parse_json( 
        '{"Source_System": "www.superherodb.com", 
        "Source_Table": "SUPERHERO.DEMO.SUPERHEROES_RAW", 
        "Source_Columns": { "SOURCE_URL": ["URL"] } 
         }' )::variant AS RECORD_SOURCE
    from "SUPERHERO"."DEMO"."SUPERHEROES_RAW"
  WHERE URL IS NOT NULL
  )
  
  SELECT HUB_BEING_KEY
  ,URL
  ,SOURCE_URL
  ,RECORD_SOURCE
  ,current_timestamp()::timestamp_tz as LOAD_TIME
from READ_FROM_RAW src;
