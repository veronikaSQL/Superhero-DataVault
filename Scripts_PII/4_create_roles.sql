use role securityadmin;

create role analyst; 

grant role analyst to role sysadmin; 


use role accountadmin;

GRANT OPERATE, USAGE ON WAREHOUSE ad_hoc_wh TO ROLE analyst; 

grant usage, monitor on database RAW to role analyst;    
grant usage, monitor on schema raw.superhero to role analyst;  
grant select on all tables in schema raw.superhero to role analyst;

grant select on future views in database MART to role analyst; 
grant select on all views in database MART to role analyst; 