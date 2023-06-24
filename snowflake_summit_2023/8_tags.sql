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
,lateral flatten (outer => true,input => clsf.value:extra_info.alternates) alt
where  
(clsf.value:semantic_category::string ilike 'NAME'
or alt.value:semantic_category::string ilike 'NAME')
--and table_name not ilike '%MV_SUPERHEROES_MARVEL_SEARCH%'
; 

alter table raw.SUPERHERO.SUPERHEROES_KAGGLE_HEROES_NLP modify column FULL_NAME set tag raw.admin.bii_string='NAME';
alter table raw.SUPERHERO.SUPERHEROES_KAGGLE_HEROES_NLP modify column "NAME" set tag raw.admin.bii_string='NAME';
alter table raw.SUPERHERO.SUPERHEROES_KAGGLE_HEROES_NLP modify column REAL_NAME set tag raw.admin.bii_string='NAME';
alter table raw.SUPERHERO.SUPERHERO_DB modify column FULL_NAME set tag raw.admin.bii_string='NAME';
alter table raw.SUPERHERO.SUPERHERO_DB modify column NAME set tag raw.admin.bii_string='NAME';
alter table raw.SUPERHERO.SUPERHERO_POWERS modify column HERO_NAMES set tag raw.admin.bii_string='NAME';
alter table raw.SUPERHERO.HEROES_INFORMATION modify column NAME set tag raw.admin.bii_string='NAME';
alter table raw.SUPERHERO.MV_SUPERHEROES_MARVEL_SEARCH modify column "name" set tag raw.admin.bii_string='NAME';
alter table raw.SUPERHERO.MV_SUPERHEROES_MARVEL_SEARCH modify column "superName" set tag raw.admin.bii_string='NAME';



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
