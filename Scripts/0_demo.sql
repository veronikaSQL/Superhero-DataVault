-- check source data
select * from raw.superhero.heroes_information;
select * from raw.superhero.superhero_powers;

select * from raw.superhero.superheroes_marvel_search ;

-- name is not a good business key based on definition and data
select name, count(*) from raw.superhero.heroes_information
group by 1 having count(*) >1;

select json_raw:name::string, count(*)
from raw.superhero.superheroes_marvel_search
group by 1 having count(*) >1;

-- create data vault schema and load marvel search data
select * from data_vault.superhero.hub_being;
select * from data_vault.superhero.sat_being_marvel_search_raw;
-- projected effective dates and current flag
select * from data_vault.superhero.sat_being_marvel_search;

-- insert a new record
select * from data_vault.superhero.sat_being_marvel_search
where hub_being_key ='1814e26137972d0a0813f2691204bc83'
--and is_current
;

-- lets add another data set. easy peasy
select * from data_vault.superhero.sat_being_superhero_set;

-- Since the business key is a source id and we cannot easily map just on the name, lets create a same as link
SELECT * FROM DATA_VAULT.SUPERHERO.SAT_SML_BEING;

-- having data in the data vault is not the final result. we need to make this data easy to consume by our end users
-- create information mart

SELECT * 
FROM MART.SUPERHERO.BEINGS_ALL
WHERE NAME ILIKE 'SPIDER-MAN';



