drop database data_vault;
drop database mart;

alter tag raw.admin.bii_string unset masking policy RAW.ADMIN.NAME_MASKING;
drop masking policy RAW.ADMIN.NAME_MASKING;
drop tag RAW.ADMIN.BII_STRING;
drop schema raw.admin;

drop role data_classification;
drop role analyst;
drop role analyst_bii;

drop materialized view raw.superhero.mv_superheroes_marvel_search;