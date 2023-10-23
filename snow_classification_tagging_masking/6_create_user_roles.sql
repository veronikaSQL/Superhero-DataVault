use role securityadmin;

-- read for non-pii data
create or replace role analyst; 

GRANT OPERATE, USAGE ON WAREHOUSE ad_hoc_wh TO ROLE analyst; 

grant usage, monitor on database RAW to role analyst;    
grant usage, monitor on schema raw.superhero to role analyst;  
grant select on all tables in schema raw.superhero to role analyst;

grant usage, monitor on database MART to role analyst;    
grant usage, monitor on schema MART.superhero to role analyst;  
grant select on all tables in schema MART.superhero to role analyst;
GRANT SELECT ON  FUTURE TABLES IN SCHEMA MART.superhero to role analysT;
grant select on all VIEWS in schema MART.superhero to role analyst;
grant select on FUTURE VIEWS in schema MART.superhero to role analyst;

-- read for pii data
create or replace role analyst_bii;

grant role analyst to role analyst_bii;


-- don't like orphan roles
grant role analyst_bii to role sysadmin; 


--- LETS LOOK AT THE ROLES HIERARCHY IN SNOWSIGHT

