use role sysadmin;
-- create table for data classification
USE DATABASE RAW;
USE SCHEMA ADMIN;

create or replace table data_classification 
(table_name string, 
 classification variant);


-- Grant the necessary privileges to the custom role
use role accountadmin;

create or replace role data_classification;
grant role data_classification to role sysadmin; 



GRANT OPERATE, USAGE ON WAREHOUSE ad_hoc_wh TO ROLE data_classification; 


grant imported privileges on database snowflake to role data_classification;
grant usage on database raw to role data_classification;
grant usage on schema raw.superhero to role data_classification;
grant usage on schema raw.admin to role data_classification;
grant apply tag on account to role data_classification;

grant select /*, update */ on all tables in schema raw.superhero to role data_classification;
grant select /*, update */  on future tables in schema raw.superhero to role data_classification;
grant select, update, insert, delete on table raw.admin.data_classification to role data_classification;



-- Use the data_classification role to generate the classification tags 

use role data_classification;
use database raw;
use schema superhero;



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




select
table_name
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
,clsf.value:semantic_category::string
,alt.value:semantic_category::string 
from   admin.data_classification 
,lateral flatten (input => classification ) clsf
,lateral flatten (outer => true,input => clsf.value:extra_info.alternates) alt
where  
clsf.value:semantic_category::string ilike 'NAME'
or alt.value:semantic_category::string ilike 'NAME';
;


alter table raw.SUPERHERO.SUPERHEROES_KAGGLE_HEROES_NLP modify column NAME set tag snowflake.core.semantic_category='NAME';
alter table raw.SUPERHERO.SUPERHERO_DB  modify column NAME set tag snowflake.core.semantic_category='NAME';
alter table raw.SUPERHERO.SUPERHERO_POWERS   modify column HERO_NAMES set tag snowflake.core.semantic_category='NAME';
alter table raw.SUPERHERO.HEROES_INFORMATION modify column NAME set tag snowflake.core.semantic_category='NAME';



select * from raw.SUPERHERO.SUPERHEROES_KAGGLE_HEROES_NLP;
select * from raw.SUPERHERO.SUPERHEROES_MARVEL_SEARCH;
select * 
from raw.SUPERHERO.HEROES_INFORMATION HI
    left join raw.superhero.superhero_powers sp
        on HI.name = sp.hero_names;
select * from raw.superhero.superhero_db;



--  For the PRIVACY_CATEGORY tag, the possible tag values are the privacy categories (IDENTIFIER, QUASI_IDENTIFIER, or SENSITIVE).

/*
Direct Identifier: Something that can directly identify someone.
Quasi Identifier: Something that can be combined together to identify someone.
Sensitive identifier: May not identify individual directly, but are personal information which users may not be comfortable sharing.
Spatiotemporal identifiers: Transactions, credit card history or other pattern generating data.
*/

select *
from table(information_schema.tag_references_all_columns('HEROES_INFORMATION', 'table'));


/*
direct identifiers
name, SSN, Drivers Licence #

Indirect identifiers 
uncommon race, ethnicity, extreme age, unusual occupation and other details. Combined with other information, such as state or county of residence, or information available through other sources such as professional directories, direct or indirect identifiers can disclose a respondent's identity.
*/
