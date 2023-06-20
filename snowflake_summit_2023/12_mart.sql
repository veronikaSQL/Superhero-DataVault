use database mart;
use warehouse ad_hoc_wh;
use schema superhero;
use role sysadmin;

-- create mart view joining "BII" and non "BII" data 
 create or replace view super_beings
 as
 select hb.being_id
 , hb.hub_being_key
 , sbst_bii.name
 , sbst.* exclude (sat_being_superhero_set_key, hub_being_key)
 from data_vault.superhero.hub_being hb
 left join data_vault.superhero.sat_being_superhero_set sbst
     on hb.hub_being_key = sbst.hub_being_key
 left join data_vault.superhero.sat_being_superhero_set_bii sbst_bii
     on hb.hub_being_key = sbst_bii.hub_being_key
;

-- add pii tag to the view

alter table mart.superhero.super_beings modify column name set tag raw.admin.pii_string='NAME';

