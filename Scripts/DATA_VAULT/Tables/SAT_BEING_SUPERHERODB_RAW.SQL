 INSERT INTO DATA_VAULT.SAT_BEING_SUPERHERODB_RAW
WITH READ_FROM_RAW AS 
(
    SELECT DISTINCT
    'https://www.superherodb.com'||URL as SOURCE_URL 
    ,'SUPERHERODB:'||SOURCE_URL AS URL
    , MD5(URL) AS HUB_BEING_KEY
    , NAME
    , URL AS SOURCE_AS_IS_URL
    , INTELLIGENCE
    , STRENGTH
    , SPEED
    , DURABILITY
    , POWER
    , COMBAT
    , FULL_NAME
    , ALTER_EGOS
    , ALIASES
    , PLACE_OF_BIRTH
    , FIRST_APPEARANCE
    , CREATOR
    , ALIGNMENT
    , GENDER
    , RACE
    , HEIGHT
    , WEIGHT
    , EYE_COLOR
    , HAIR_COLOR
    , OCCUPATION
    , BASE
//    , TEAM_AFFILIATION
    , RELATIVES
    , SKIN_COLOR
    , TOTAL_POWER
    , MD5( UPPER(TRIM(IFNULL(NAME,'')))
          || '~' || IFNULL(INTELLIGENCE,'')
          || '~' || IFNULL(STRENGTH,'')
          || '~' || IFNULL( SPEED,'')
          || '~' || IFNULL(DURABILITY,'')
          || '~' || IFNULL( POWER,'')
          || '~' || IFNULL( COMBAT,'')
          || '~' || UPPER(TRIM(IFNULL(FULL_NAME,'')))
          || '~' || UPPER(TRIM(IFNULL(ALTER_EGOS,'')))
          || '~' || UPPER(TRIM(IFNULL(ALIASES,'')))
          || '~' || UPPER(TRIM(IFNULL(PLACE_OF_BIRTH,'')))
          || '~' || UPPER(TRIM(IFNULL(FIRST_APPEARANCE,'')))
          || '~' || UPPER(TRIM(IFNULL( CREATOR,'')))
          || '~' || UPPER(TRIM(IFNULL( ALIGNMENT,'')))
          || '~' || UPPER(TRIM(IFNULL( GENDER,'')))
          || '~' || UPPER(TRIM(IFNULL( RACE,'')))
          || '~' || UPPER(TRIM(IFNULL( HEIGHT,'')))
          || '~' || UPPER(TRIM(IFNULL( WEIGHT,'')))
          || '~' || UPPER(TRIM(IFNULL( EYE_COLOR,'')))
          || '~' || UPPER(TRIM(IFNULL( HAIR_COLOR,'')))
          || '~' || UPPER(TRIM(IFNULL( OCCUPATION,'')))
          || '~' || UPPER(TRIM(IFNULL( BASE,'')))
//          || '~' || UPPER(TRIM(IFNULL( TEAM_AFFILIATION,'')))
          || '~' || UPPER(TRIM(IFNULL( RELATIVES,'')))
          || '~' || UPPER(TRIM(IFNULL( SKIN_COLOR,'')))
          || '~' || IFNULL( TOTAL_POWER,'')
         ) AS RECORD_HASH
from "SUPERHERO"."DEMO"."SUPERHEROES_RAW"
  WHERE URL IS NOT NULL
  )
  
  SELECT
    MD5(SRC.HUB_BEING_KEY || current_timestamp()::timestamp_tz )AS SAT_BEING_SUPERHERODB_KEY
    , SRC.HUB_BEING_KEY
    , SRC.URL
    , SRC.SOURCE_URL
    , SRC.NAME
    , SRC.URL AS SOURCE_AS_IS_URL
    , SRC.INTELLIGENCE
    , SRC.STRENGTH
    , SRC.SPEED
    , SRC.DURABILITY
    , SRC.POWER
    , SRC.COMBAT
    , SRC.FULL_NAME
    , SRC.ALTER_EGOS
    , SRC.ALIASES
    , SRC.PLACE_OF_BIRTH
    , SRC.FIRST_APPEARANCE
    , SRC.CREATOR
    , SRC.ALIGNMENT
    , SRC.GENDER
    , SRC.RACE
    , SRC.HEIGHT
    , SRC.WEIGHT
    , SRC.EYE_COLOR
    , SRC.HAIR_COLOR
    , SRC.OCCUPATION
    , SRC.BASE
//    , SRC.TEAM_AFFILIATION
    , SRC.RELATIVES
    , SRC.SKIN_COLOR
    , SRC.TOTAL_POWER
    , SRC.RECORD_HASH
    , current_timestamp()::timestamp_tz as LOAD_TIME
from READ_FROM_RAW src
LEFT JOIN DATA_VAULT.SAT_BEING_SUPERHERODB_RAW TGT
    ON SRC.HUB_BEING_KEY = TGT.HUB_BEING_KEY
    AND SRC.RECORD_HASH = TGT.RECORD_HASH
    WHERE TGT.HUB_BEING_KEY IS NULL;
