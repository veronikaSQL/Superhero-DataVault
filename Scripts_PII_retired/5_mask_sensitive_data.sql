use role sysadmin;

use database raw;

CREATE OR REPLACE MASKING POLICY NAME_MASKING AS (VAL STRING)
returns string ->
 CASE WHEN CURRENT_ROLE() IN ('SYSADMIN') THEN VAL
 ELSE sha2(val)
 END;
 


select *
from table(information_schema.tag_references_all_columns('SUPERHERO.HEROES_INFORMATION', 'table'));
select *
from table(information_schema.tag_references_all_columns('SUPERHERO.SUPERHEROES_KAGGLE_HEROES_NLP', 'table'));
select *
from table(information_schema.tag_references_all_columns('SUPERHERO.SUPERHERO_POWERS', 'table'));
select *
from table(information_schema.tag_references_all_columns('SUPERHERO.SUPERHERO_DB', 'table'));
 
 
 alter table raw.SUPERHERO.SUPERHEROES_KAGGLE_HEROES_NLP modify column name set masking policy NAME_MASKING;
 alter table raw.SUPERHERO.HEROES_INFORMATION modify column name set masking policy NAME_MASKING;
 alter table raw.SUPERHERO.SUPERHERO_POWERS modify column hero_names set masking policy NAME_MASKING;
 alter table raw.SUPERHERO.SUPERHERO_DB modify column name set masking policy NAME_MASKING;
 
