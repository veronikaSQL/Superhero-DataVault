  
USE DATABASE SUPERHERO;
USE SCHEMA DEMO;

-- RAW DATA IN "STAGE". More than just "superheros"
SELECT * 
FROM SUPERHERO.DEMO.SUPERHEROES_MARVEL_SEARCH ;

SELECT * 
FROM SUPERHERO.DEMO.SUPERHEROES_RAW
 WHERE NAME ILIKE ANY ('%HARRY POTTER%','%YODA%')
;





USE SCHEMA DATA_VAULT;
-- Document some metadata in RECORD_SOURCE
SELECT
RECORD_SOURCE:Source_Columns.SOURCE_URL::STRING AS SOURCE_COLUMN
,RECORD_SOURCE:Source_System::STRING AS SOURCE_SYSTEM
,RECORD_SOURCE:Source_Table::STRING AS SOURCE_TABLE
,*
FROM DATA_VAULT.HUB_BEING;

-- extract some elements but take JSON as well
SELECT * FROM SAT_BEING_MARVEL_SEARCH_RAW;

-- take all attributes from source AS IS
SELECT * FROM SAT_BEING_SUPERHERODB_RAW;




-- a way to match "the same" record coming from different source
SELECT * FROM DATA_VAULT.SML_BEING;



SELECT SAT.*
FROM SML_BEING SML
JOIN SAT_SML_BEING SAT
    ON SML.SML_BEING_KEY = SAT.SML_BEING_KEY;


-- Effectivity Satellite
SELECT * FROM
SAT_BEING_MARVEL_SEARCH  
WHERE HUB_BEING_KEY = '730d91d4e289a9bad355f17a2b2bebd9'
  AND IS_CURRENT
;



SELECT MARVEL.NAME AS MARVEL_NAME
,SUPERDB.NAME AS SUPERDB_NAME
,MARVEL.JSON_RAW:species::array as SPECIES
,SUPERDB.RACE
,SAT.*
FROM 
SML_BEING SML
JOIN SAT_BEING_MARVEL_SEARCH MARVEL ON SML.HUB_BEING_KEY_1 = MARVEL.HUB_BEING_KEY
JOIN SAT_BEING_SUPERHERODB SUPERDB ON SML.HUB_BEING_KEY_2 = SUPERDB.HUB_BEING_KEY
JOIN SAT_SML_BEING SAT ON SML.HUB_BEING_KEY_1 = SAT.HUB_BEING_KEY_1 AND SML.HUB_BEING_KEY_2 = SAT.HUB_BEING_KEY_2
WHERE SUPERDB.NAME ilike  'Spider-Woman%'
AND MARVEL.IS_CURRENT AND SUPERDB.IS_CURRENT
;


-- union all sources in information mart
SELECT * FROM MART.BEINGS_ALL
WHERE NAME ILIKE 'Iron Man'
;


-- Lets add another source
SELECT *
FROM SUPERHERO.DEMO.SUPERHEROS_KAGGLE_HEROES_NLP ;


-- Here is everything 
SELECT DISTINCT
RECORD_SOURCE:Source_Columns.SOURCE_URL::STRING AS SOURCE_URL
,RECORD_SOURCE:Source_System::STRING AS SOURCE_SYSTEM
,RECORD_SOURCE:Source_Table::STRING AS SPURCE_TABLE
FROM DATA_VAULT.HUB_BEING;


-- NEW sat
SELECT * 
FROM DATA_VAULT.SAT_BEING_KAGGLE_NLP;

-- NEW ERD


-- ADD ADDITIONAL SOURCE TO BEINGS_ALL VIEW

-- information mart
SELECT * FROM MART.BEINGS_ALL
 WHERE NAME ILIKE 'Iron Man';
-- WHERE NAME ILIKE 'CAPTAIN MARVEL';

-- DASHBOARD






-- fun with VARIANT columns
SELECT DISTINCT 
f.path
,f.value 
,typeof(f.value) 
FROM  
SAT_BEING_MARVEL_SEARCH_RAW, 
LATERAL FLATTEN(JSON_RAW, RECURSIVE=>true) f 
WHERE 
TYPEOF(f.value) != 'OBJECT'; 

-- extract all elements and their data types from json
with schema_on_read as ( 
select distinct 
    regexp_replace(f.path,'(\\[[0-9]+\\])','') as json_path 
    , case 
        when try_to_number(f.value::string) is null then 
            case 
                when try_to_timestamp(replace(f.value,',','.')::string) is not null then 'TIMESTAMP_NTZ'::variant 
                when try_to_timestamp(concat(substring(f.value,0,26),':',substring(f.value,27,2))::string) is not null then 'TIMESTAMP_LTZ'::variant 
                else typeof(f.value)::variant 
            end 
        when length(f.value) > 1 and try_to_number(f.value::string) = 0 then typeof(f.value)::variant 
            else typeof(to_number(f.value::string))::variant 
      end as data_type 
from 
    ( select json_raw as json_data from  SAT_BEING_MARVEL_SEARCH_RAW )v , table( flatten( input=>v.json_data, recursive=>true ) ) f 
where f.key is not null 
      and typeof(f.value) not in ('OBJECT', 'NULL_VALUE') 
) 
select * from schema_on_read;


-- because I love variant, here is a way to query it. Notice case sensitivity 
select  
JSON_RAW:superName::varchar AS superName
,JSON_RAW:name::varchar AS Name
,JSON_RAW:description::varchar as description
,JSON_RAW:teams::STRING AS teams 
,JSON_RAW:POWERS::STRING AS CAP_POWERS -- case sensitive 
,JSON_RAW:powers::array as powers 
,JSON_RAW:authors::array as authors 
,JSON_RAW:urls.wikipedia::string as urls 
,JSON_RAW:species::array as species
,*
from SAT_BEING_MARVEL_SEARCH_RAW
where JSON_RAW:superName::varchar = 'Captain Marvel';


