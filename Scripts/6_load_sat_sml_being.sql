-- map 2 sources based on aliases
use database data_vault;
use schema superhero;
use role sysadmin;


INSERT  INTO SUPERHERO.SAT_SML_BEING
with marvel as 
(
SELECT 
    PARSE.hub_being_key,
    PARSE.NAME,
    s.VALUE::string as ALIAS_NAME,
    PARSE.ALIASES,
    PARSE.BEING_ID_BKCC
FROM
    ( 
   select 
        hub_being_key, 
        NAME,
        BEING_ID_BKCC,
        ARRAY_TO_STRING(JSON_RAW:aliases::ARRAY,',') AS ALIASES
        -- ,JSON_RAW
            from staging.stg_superheroes_marvel_search
    ) PARSE
    , LATERAL FLATTEN (INPUT => SPLIT(PARSE.ALIASES,',')) s
  )  

select distinct
MD5(SS.BEING_ID_BKCC||MARVEL.BEING_ID_BKCC) AS SML_BEING_KEY,
ss.hub_being_key as hub_being_key_1,
marvel.hub_being_key as hub_being_key_2,
SS.BEING_ID_BKCC AS BEING_ID_BKCC_1,
MARVEL.BEING_ID_BKCC AS BEING_ID_BKCC_2,
ss.name as NAME_1,
marvel.NAME as NAME_2,
marvel.ALIASES,
current_timestamp()::timestamp_tz  as load_date
from STAGING.STG_SUPERHERO_SET ss 
    join marvel on ss.name = marvel.ALIAS_NAME 
where not exists(select * from SAT_SML_BEING sml 
                 where sml.hub_being_key_1 = ss.hub_being_key 
                and sml.hub_being_key_2 = marvel.hub_being_key );

-- SELECT * FROM STAGING.STG_SUPERHERO_SET;


SELECT * FROM DATA_VAULT.SUPERHERO.SAT_SML_BEING;

