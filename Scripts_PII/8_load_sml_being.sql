-- map 2 sources based on aliases
use database data_vault;
use schema superhero;
use role sysadmin;

INSERT INTO SML_BEING
with marvel as 
(
SELECT 
    PARSE.hub_being_key,
    s.VALUE::string as name--,
 --   PARSE.ALIASES
FROM
    ( 
   select 
        hub_being_key, 
        ARRAY_TO_STRING(JSON_RAW:aliases::ARRAY,',') AS ALIASES
            from staging.stg_superheroes_marvel_search
    ) PARSE
    , LATERAL FLATTEN (INPUT => SPLIT(PARSE.ALIASES,',')) s
  )  

select distinct
ss.hub_being_key as hub_being_key_1,
marvel.hub_being_key as hub_being_key_2,
current_timestamp()::timestamp_tz  as load_date
--, ss.name --, marvel.ALIASES
from staging.stg_superhero_set ss 
    join marvel on ss.name = marvel.name 
where not exists(select * from SML_BEING sml 
                 where sml.hub_being_key_1 = ss.hub_being_key 
                and sml.hub_being_key_2 = marvel.hub_being_key );


SELECT *
FROM DATA_VAULT.SUPERHERO.SML_BEING;

