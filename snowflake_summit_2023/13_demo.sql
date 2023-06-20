use role analyst;
use warehouse ad_hoc_wh;

select name, *
from mart.superhero.super_beings;

use role analyst_pii;

select name, *
from mart.superhero.super_beings;

-- godzilla wants to be forgotten. LETS NOTE HUB_KEY
select name, hub_being_key,*
from mart.superhero.super_beings
where name ilike 'godzilla';

use role sysadmin;

select *
from data_vault.superhero.sat_being_superhero_set_bii
where name ilike 'godzilla';

-- remove name
update data_vault.superhero.sat_being_superhero_set_bii
set name = 'GDPR'
where name ilike 'godzilla';

-- the name is no longer there but all the other data is still there
select *
from  mart.superhero.super_beings
where hub_being_key = '275c242790b275b07ec6889e789f2ca3';

-- SUMMARY
use role data_classification;

-- clasified data
SELECT * FROM RAW.ADMIN.DATA_CLASSIFICATION;

-- CREATED PII TAG
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.TAGS;
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.TAG_REFERENCES;

-- masking policy. contains history
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.MASKING_POLICIES
--WHERE DELETED IS NULL
;
USE SCHEMA RAW.ADMIN;
SHOW MASKING POLICIES;
DESC MASKING POLICY NAME_MASKING;

-- ASSIGNED MASKING POLICY TO THE TAG
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.MASKING_POLICIES;
SHOW TAGS IN SCHEMA RAW.ADMIN;

-- GOTCHAS
-- JSON - using UDF to mask is not efficient
--     create MV with parsed JSON
--     only allow users access to it
--     apply tags to columns
--     load parsed JSON into DV or parse out PII into columns and replace them with masked values inside JSON????
--     PII data cannot be used for business keys. Hash is deterministic (MD(5) of "Veronika" is always f481b55e4aa9188bb83cc1c786333417). Need to generate sequence to be used as a business key. 

