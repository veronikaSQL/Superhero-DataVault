use role accountadmin;

-- Grant data_classification role permissions to apply masking policy and tags
grant apply masking policy on account to role data_classification;


use role sysadmin;

use database raw;

 
--  tag for PII such as name and address. 
create or replace tag raw.admin.pii_string;

-- masking policy. Only analyst_pii and sysadmin can see data in clear text
CREATE OR REPLACE MASKING POLICY RAW.ADMIN.NAME_MASKING AS (VAL STRING)
returns string ->
CASE 
WHEN CURRENT_ROLE() ilike any ('ANALYST_PII','SYSADMIN') THEN VAL
    ELSE MD5(val)
END;


-- assign masking policy to TAG
alter tag raw.admin.pii_string set masking policy RAW.ADMIN.NAME_MASKING;

-- to alter masking policy, need to "unset" masking policy from tag, make changes and add it back. easy peasy 

