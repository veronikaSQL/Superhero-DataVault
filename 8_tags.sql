use role data_classification;
use database raw;
use schema superhero;
use warehouse data_governance_wh;

-- -- can allow snowflake to assign tags 
-- CALL ASSOCIATE_SEMANTIC_CATEGORY_TAGS('HEROES_INFORMATION',EXTRACT_SEMANTIC_CATEGORIES('HEROES_INFORMATION'));

-- select * from table(information_schema.tag_references_all_columns('HEROES_INFORMATION', 'table'));

 -- assign custom tag to columns.

 select distinct
 'alter table ' || table_name || ' modify column "' || clsf.key || '" set tag raw.admin.bii_string=''NAME'';'
from   admin.data_classification 
,lateral flatten (input => classification ) clsf
where    
(clsf.value:recommendation.semantic_category::string  ilike 'NAME'
or clsf.value:alternates.semantic_category::string ilike 'NAME')
--and table_name not ilike '%MV_SUPERHEROES_MARVEL_SEARCH%'
; 

--COPY/PASTA 


select *
from table(information_schema.tag_references_all_columns('SUPERHERO.HEROES_INFORMATION', 'table'))
union all
select *
from table(information_schema.tag_references_all_columns('SUPERHERO.SUPERHEROES_KAGGLE_HEROES_NLP', 'table'))
union all
select *
from table(information_schema.tag_references_all_columns('SUPERHERO.SUPERHERO_POWERS', 'table'))
union all
select *
from table(information_schema.tag_references_all_columns('SUPERHERO.SUPERHERO_DB', 'table'))
union all
select *
from table(information_schema.tag_references_all_columns('SUPERHERO.MV_SUPERHEROES_MARVEL_SEARCH', 'table'))
;


-- to mask JSON with a function. consider performance implications
-- https://community.snowflake.com/s/article/How-To-Create-Conditional-Data-Masking-For-Variant-Data-Using-Javascript-UDF
-- https://www.snowflake.com/blog/masking-semi-structured-data-with-snowflake/

-- masking policy metadata
select * 
from table(information_schema.policy_references('RAW.ADMIN.NAME_MASKING')) ;
