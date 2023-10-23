use role accountadmin;

-- Grant data_classification role permissions to apply masking policy and tags
grant apply masking policy on account to role data_classification;


use role sysadmin;

use database raw;

 
--  tag for BII such as name and address. 

create or replace tag raw.admin.bii_string;

-- masking policy. Only analyst_bii and sysadmin can see data in clear text
CREATE OR REPLACE MASKING POLICY RAW.ADMIN.NAME_MASKING AS (VAL STRING)
returns string ->
CASE 
WHEN CURRENT_ROLE() ilike any ('ANALYST_BII','SYSADMIN') THEN VAL
    ELSE MD5(val)
END;


-- assign masking policy to TAG
alter tag raw.admin.bii_string set masking policy RAW.ADMIN.NAME_MASKING;

-- to alter masking policy, need to "unset" masking policy from tag, make changes and add it back. easy peasy 

