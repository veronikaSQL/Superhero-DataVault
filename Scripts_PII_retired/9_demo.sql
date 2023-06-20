use database data_vault;
use schema superhero;
use role sysadmin;

--- BKCC
select 
hb.being_id,
sbms_bii.json_raw:name::string as name,
sbss_bii.name,
*
from data_vault.superhero.hub_being hb
left join data_vault.superhero.sat_being_marvel_search_bii sbms_bii
    on hb.hub_being_key = sbms_bii.hub_being_key
left join data_vault.superhero.sat_being_superhero_set sbss
    on hb.hub_being_key = sbss.hub_being_key
left join data_vault.superhero.sat_being_superhero_set_bii sbss_bii
    on hb.hub_being_key = sbss_bii.hub_being_key
where hb.being_id = 24;


-- sml
select 
sbss_bii.name, sbss_bii.gender, sbss_bii.eye_color, sbss_bii.race, sbss_bii.hair_color, sbss_bii.height, sbss_bii.weight, sbss_bii.skin_color,
 sbms_bii.json_raw:aliases::string as aliaces, sbms_bii.json_raw:powers::string as powers, sbms_bii.json_raw:superName::string as superName  ,
sbss.* 
from data_vault.superhero.sml_being smlb
join data_vault.superhero.sat_being_superhero_set sbss
    on smlb.hub_being_key_1 = sbss.hub_being_key
join data_vault.superhero.sat_being_superhero_set_bii sbss_bii
    on smlb.hub_being_key_1 = sbss_bii.hub_being_key
join data_vault.superhero.sat_being_marvel_search_bii sbms_bii
     on smlb.hub_being_key_2 = sbms_bii.hub_being_key
 where name = 'Captain Marvel';


-- check query history

SELECT b.value:"objectName", t.*, q.query_text
from SNOWFLAKE.ACCOUNT_USAGE.ACCESS_HISTORY t
LEFT JOIN SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY q on q.query_id = t.query_id,
LATERAL FLATTEN(CASE WHEN ARRAY_SIZE(t.base_objects_accessed)>0 then t.base_objects_accessed ELSE t.objects_modified END) b
where q.USER_NAME ilike 'Veronika'
ORDER BY query_start_time desc
limit 20;
;

use role analyst;

-- sml
select 
sbss_bii.name, sbss_bii.gender, sbss_bii.eye_color, sbss_bii.race, sbss_bii.hair_color, sbss_bii.height, sbss_bii.weight, sbss_bii.skin_color,
 sbms_bii.json_raw:aliases::string as aliaces, sbms_bii.json_raw:powers::string as powers, sbms_bii.json_raw:superName::string as superName  ,
sbss.* 
from data_vault.superhero.sml_being smlb
join data_vault.superhero.sat_being_superhero_set sbss
    on smlb.hub_being_key_1 = sbss.hub_being_key
join data_vault.superhero.sat_being_superhero_set_bii sbss_bii
    on smlb.hub_being_key_1 = sbss_bii.hub_being_key
join data_vault.superhero.sat_being_marvel_search_bii sbms_bii
     on smlb.hub_being_key_2 = sbms_bii.hub_being_key
 where name = 'Captain Marvel';
 
 use role sysadmin;
 use database mart;
 use schema superhero;
 
 create or replace view beings_all
 as
 select 
sbss_bii.name, sbss_bii.gender, sbss_bii.eye_color, sbss_bii.race, sbss_bii.hair_color, sbss_bii.height, sbss_bii.weight, sbss_bii.skin_color,
 sbms_bii.json_raw:aliases::string as aliaces, 
 sbms_bii.json_raw:powers::string as powers, 
 sbms_bii.json_raw:superName::string as superName ,
 sbss.*
from data_vault.superhero.sml_being smlb
join data_vault.superhero.sat_being_superhero_set sbss
    on smlb.hub_being_key_1 = sbss.hub_being_key
join data_vault.superhero.sat_being_superhero_set_bii sbss_bii
    on smlb.hub_being_key_1 = sbss_bii.hub_being_key
join data_vault.superhero.sat_being_marvel_search_bii sbms_bii
     on smlb.hub_being_key_2 = sbms_bii.hub_being_key;
 

use role accountadmin;
grant usage on database mart to role data_classification;
grant usage on schema mart.superhero to role data_classification;
grant select on all views in schema mart.superhero to role data_classification;
grant select on future views in schema mart.superhero to role data_classification;

use role sysadmin;

CREATE OR REPLACE MASKING POLICY NAME_MASKING AS (VAL STRING)
returns string ->
 CASE WHEN CURRENT_ROLE() IN ('SYSADMIN') THEN VAL
 ELSE sha2(val)
 END;
 

alter view beings_all modify column name set masking policy NAME_MASKING;


 use role analyst;
 use database mart;
 use schema superhero;
 
 select * from beings_all;
 
 
 use role sysadmin;
 
 select *
 from data_vault.superhero.sat_being_superhero_set_bii
 where  name ilike 'godzilla';
 
 -- HUB_BEING_KEY 275c242790b275b07ec6889e789f2ca3
 
 update data_vault.superhero.sat_being_superhero_set_bii
 set name = 'anonymized'
 where name ilike 'godzilla';

-- the rest of the information is still there

 
 select * 
 from data_vault.superhero.hub_being hub
 join data_vault.superhero.sat_being_superhero_set_bii super_bii
    on hub.hub_being_key = super_bii.hub_being_key
 join data_vault.superhero.sat_being_superhero_set super
    on hub.hub_being_key = super.hub_being_key
where super.HUB_BEING_KEY  = '275c242790b275b07ec6889e789f2ca3';
 