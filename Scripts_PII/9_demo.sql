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
    