
-- Grant the necessary privileges to the custom role
use role accountadmin;

-- create new role to perform data classification functions
create or replace role data_classification;
-- don't like to have orphaned roles
grant role data_classification to role sysadmin; 

-- create warehouse dedicated to data gonvernace functions
create warehouse if not exists data_governance_wh;

-- allow data_classification function to use dedicated data gonvernance  warehouse
GRANT OPERATE, USAGE ON WAREHOUSE data_governance_wh TO ROLE data_classification; 

-- data classification includes querying some snowflake metadata
grant imported privileges on database snowflake to role data_classification;

-- GOVERNANCE_ADMIN Snowflake database role is granted the APPLY privilege on the PRIVACY_CATEGORY and SEMANTIC_CATEGORY system tags (e.g. apply on tag privacy_category to role governance_admin). This grant allows users with the GOVERNANCE_ADMIN role to apply these tags to objects that the GOVERNANCE_ADMIN owns (i.e. has the OWNERSHIP privilege on the object).
-- grant database role snowflake.governance_admin to role data_classification;


grant usage on database raw to role data_classification;
grant usage on schema raw.superhero to role data_classification;
grant usage on schema raw.admin to role data_classification;
grant apply tag on account to role data_classification;

-- grant select on tables/ where data needs to be classified
grant select on all tables in schema raw.superhero to role data_classification;
grant select on future tables in schema raw.superhero to role data_classification;

grant select on all materialized views in schema raw.superhero to role data_classification;
grant select on future materialized views in schema raw.superhero to role data_classification;

-- grant permissions on the data classifiction tracking table
grant select, update, insert, delete on table raw.admin.data_classification to role data_classification;



-- Use the data_classification role to perform data classification

use role data_classification;
use database raw;
use schema superhero;
use warehouse data_governance_wh;

-- data classification
select system$get_tag_allowed_values('snowflake.core.privacy_category');
select system$get_tag_allowed_values('snowflake.core.semantic_category');

-- function EXTRACT_SEMANTIC_CATEGORIES( '<object_name>' [ , <max_rows_to_scan> ] ) max_rows_to_scan 0-10000 (10000 - default)
SELECT
    f.key::varchar as column_name,
    f.value:"privacy_category"::varchar as privacy_category,  
    f.value:"semantic_category"::varchar as semantic_category,
    f.value:"extra_info":"probability"::number(10,2) as probability,
    f.value:"extra_info":"alternates"::variant as alternates
  FROM
  TABLE(FLATTEN(EXTRACT_SEMANTIC_CATEGORIES('HEROES_INFORMATION',500)::VARIANT)) AS f;


/* 
 - Enterpise feature
 - Requires compute to run. XSM WH could be good enough if time is not concern 
 - Unsupported data types: GEOGRAPHY, BINARY, VARIANT. For variant lateral flatten first
 - probabily > .8 - semantic_category
 - probability > .15 -  alternates
** Identifier - uniquely identify an individual. 
EMAIL, IBAN, IMEI, IP_ADDRESS, VIN, NAME, PAYMENT_CARD, PHONE_NUMBER (US numbers only), URL, US_BANK_ACCOUNT, US_DRIVERS_LICENSE, US_PASSPORT, US_SSN, US_STREET_ADDRESS
** Quasi-identifier (non sensitive PII, indirect, not useful by itself)  - uniquely identify an individual when 2 or more are combined
AGE, GENDER, COUNTRY, DATE_OF_BIRTH, ETHNICITY, LATITUDE, LAT_LONG, LONGITUDE, MARITAL_STATUS, OCCUPATION, US_POSTAL_CODE, US_STATE_OR_TERRITORY, US_COUNTY, US_CITY, YEAR_OF_BIRTH
** Sensitive - Not enough to identify an individual, something an individual might not want to disclose. 
SALARY (only)
*/


select 'select extract_semantic_categories(''"'|| table_catalog ||'"."'||table_schema||'"."' ||table_name ||'"'');
insert into admin.data_classification
select ''raw.'||table_schema||'.' ||table_name ||''' as table_name, *
from table (result_scan(last_query_id()));
' 
from raw.information_schema.tables 
where table_schema ilike any ('superhero'); 


select extract_semantic_categories('"RAW"."SUPERHERO"."SUPERHEROES_KAGGLE_HEROES_NLP"'); 
insert into admin.data_classification 
select 'raw.SUPERHERO.SUPERHEROES_KAGGLE_HEROES_NLP' as table_name, * from table (result_scan(last_query_id())); 

select extract_semantic_categories('"RAW"."SUPERHERO"."SUPERHEROES_MARVEL_SEARCH"'); 
insert into admin.data_classification 
select 'raw.SUPERHERO.SUPERHEROES_MARVEL_SEARCH' as table_name, * from table (result_scan(last_query_id())); 

select extract_semantic_categories('"RAW"."SUPERHERO"."SUPERHERO_DB"');
insert into admin.data_classification 
select 'raw.SUPERHERO.SUPERHERO_DB' as table_name, * from table (result_scan(last_query_id())); 

select extract_semantic_categories('"RAW"."SUPERHERO"."HEROES_INFORMATION"'); 
insert into admin.data_classification 
select 'raw.SUPERHERO.HEROES_INFORMATION' as table_name, * from table (result_scan(last_query_id())); 


select extract_semantic_categories('"RAW"."SUPERHERO"."SUPERHERO_POWERS"'); 
insert into admin.data_classification 
select 'raw.SUPERHERO.SUPERHERO_POWERS' as table_name, * from table (result_scan(last_query_id())); 

-- we created an materialized view to run data classification on a JSON
select extract_semantic_categories('"RAW"."SUPERHERO"."MV_SUPERHEROES_MARVEL_SEARCH"'); 
insert into admin.data_classification 
select 'raw.SUPERHERO.MV_SUPERHEROES_MARVEL_SEARCH' as table_name, * from table (result_scan(last_query_id())); 

-- here is what we logged
select *
from admin.data_classification;

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

