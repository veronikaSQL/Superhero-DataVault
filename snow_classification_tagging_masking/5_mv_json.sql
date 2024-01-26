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

-- create MV to be used in data classification. Add select generated by the query above
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
, clsf.value:recommendation.privacy_category::string as privacy_category
, clsf.value:recommendation.semantic_category::string as semantic_category
, clsf.value:valid_value_ratio as valid_value_ratio --Specifies the ratio of valid values in the sample size. Invalid values include NULL, an empty string, and a string with more than 256 characters.
, clsf.value:recommendation.confidence::string as confidence --Relative confidence that Snowflake has based upon the column sampling process and how the column data aligns with how Snowflake classifies data.
, clsf.value:recommendation.coverage::numeric(5,2) as coverage --% of sampled cell values that match the rules for a particular category.
--alternates - Specifies information about each tag and value to consider other than the recommended tag.
, clsf.value:alternates.confidence::string  as alt_confidence
, clsf.value:alternates.coverage::numeric(5,2) as alt_probability
, clsf.value:alternates.privacy_category::string as alt_privacy_category
, clsf.value:alternates.semantic_category::string as alt_semantic_category
from   admin.data_classification 
,lateral flatten (input => classification ) clsf
where  
  (confidence is not null
    or privacy_category is not null
    or semantic_category is not null
   )
;