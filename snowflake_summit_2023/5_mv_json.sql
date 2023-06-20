USE ROLE SYSADMIN;

-- this table has variant data type
SELECT *
FROM RAW.SUPERHERO.SUPERHEROES_MARVEL_SEARCH;

-- run data classification on Variant
select extract_semantic_categories('"RAW"."SUPERHERO"."SUPERHEROES_MARVEL_SEARCH"'); 


-- extract all possible elements from JSON
with sch_read as ( 
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
    ( select JSON_RAW as json_field
      from RAW.SUPERHERO.SUPERHEROES_MARVEL_SEARCH 
  )v 
    , table( flatten( input=>v.json_field, recursive=>true ) ) f 
where f.key is not null 
    and typeof(f.value) not in ('OBJECT', 'NULL_VALUE') 
) 
-- order duplicates by datatype VARCHAR before INTEGER 
, windowed as ( 
select json_path  
, data_type 
  , row_number() over (partition by json_path order by data_type desc ) as 
seq 
  from sch_read 
) 
select  
'select ' 
|| 
trim(LISTAGG (',JSON_RAW:'|| json_path ||'::'||data_type ||' as "'||json_path ||'"'|| chr(10))|| '\r',',') -- trim to remove leading comma.  listagg to flatten rows to a string 
-- || 
-- ', * ' 
|| 
chr(10)--|| '\r' 
|| 
'FROM RAW.SUPERHERO.SUPERHEROES_MARVEL_SEARCH ' 
|| 
chr(10)--|| '\r' 
|| ';' as qry 
from windowed where seq = 1 
order by json_path; 

-- create MV to be used in data classification
CREATE OR REPLACE MATERIALIZED VIEW RAW.SUPERHERO.MV_SUPERHEROES_MARVEL_SEARCH
AS



-- we created an materialized view to run data classification on a JSON
use role data_classification;
use database raw;
use schema superhero;
use warehouse data_governance_wh;
select extract_semantic_categories('"RAW"."SUPERHERO"."MV_SUPERHEROES_MARVEL_SEARCH"'); 
insert into admin.data_classification 
select 'raw.SUPERHERO.MV_SUPERHEROES_MARVEL_SEARCH' as table_name, * from table (result_scan(last_query_id())); 


-- lets exctract useful data from JSON
select
table_name
, classification
, clsf.key as COLUMN_NAME
, clsf.value:extra_info.probability::numeric(5,2) as probability
, clsf.value:privacy_category::string as privacy_category
, clsf.value:semantic_category::string as semantic_category
, alt.value:privacy_category::string  as alternates_privacy_category
, alt.value:probability::numeric(5,2) as alternates_probability
, alt.value:semantic_category::string  as alternates_semantic_category

from   admin.data_classification 
,lateral flatten (input => classification ) clsf
,lateral flatten (outer => true,input => clsf.value:extra_info.alternates) alt
where  
  (probability is not null
    or privacy_category is not null
    or semantic_category is not null
    or ALTERNATES_PRIVACY_CATEGORY is not null
    or ALTERNATES_PROBABILITY is not null
    or ALTERNATES_SEMANTIC_CATEGORY is not null)
-- and 'NAME' in ( clsf.value:semantic_category::string , alt.value:semantic_category::string )
;


 
-- find tables that have columns of category NAME in them 
 select distinct
table_name
,clsf.key as COLUMN_NAME
,clsf.value:extra_info.probability::numeric(5,2) as probability
,clsf.value:semantic_category::string
,alt.value:semantic_category::string 
,alt.value:probability::numeric(5,2) as alternates_probability
from   admin.data_classification 
,lateral flatten (input => classification ) clsf
,lateral flatten (outer => true,input => clsf.value:extra_info.alternates) alt
where  
(clsf.value:semantic_category::string ilike 'NAME'
or alt.value:semantic_category::string ilike 'NAME')
;