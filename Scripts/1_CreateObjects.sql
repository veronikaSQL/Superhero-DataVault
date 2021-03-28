create or replace database SUPERHERO;

create or replace schema SUPERHERO.DEMO;

create or replace schema SUPERHERO.DATA_VAULT;

create or replace TABLE SUPERHERO.DEMO.SUPERHEROES_MARVEL_SEARCH (
	JSON_RAW VARIANT

create or replace TABLE SUPERHERO.DEMO.SUPERHEROES_RAW (
	NAME VARCHAR(16777216),
	URL VARCHAR(16777216),
	INTELLIGENCE VARCHAR(16777216),
	STRENGTH VARCHAR(16777216),
	SPEED VARCHAR(16777216),
	DURABILITY VARCHAR(16777216),
	POWER VARCHAR(16777216),
	COMBAT VARCHAR(16777216),
	FULL_NAME VARCHAR(16777216),
	ALTER_EGOS VARCHAR(16777216),
	ALIASES VARCHAR(16777216),
	PLACE_OF_BIRTH VARCHAR(16777216),
	FIRST_APPEARANCE VARCHAR(16777216),
	CREATOR VARCHAR(16777216),
	ALIGNMENT VARCHAR(16777216),
	GENDER VARCHAR(16777216),
	RACE VARCHAR(16777216),
	HEIGHT VARCHAR(16777216),
	WEIGHT VARCHAR(16777216),
	EYE_COLOR VARCHAR(16777216),
	HAIR_COLOR VARCHAR(16777216),
	OCCUPATION VARCHAR(16777216),
	BASE VARCHAR(16777216),
	TEAM_AFFILIATION VARCHAR(16777216),
	RELATIVES VARCHAR(16777216),
	SKIN_COLOR VARCHAR(16777216),
	TOTAL_POWER VARCHAR(16777216)
);



create or replace TABLE SUPERHERO.DATA_VAULT.HUB_BEING (
	HUB_BEING_KEY VARCHAR(32),
	URL VARCHAR(16777216),
	SOURCE_URL VARCHAR(16777216),
	RECORD_SOURCE VARIANT,
	LOAD_TIME TIMESTAMP_TZ(9)
);

create or replace TABLE SUPERHERO.DATA_VAULT.SAT_BEING_MARVEL_SEARCH_RAW (
	SAT_BEING_MARVEL_SEARCH_KEY VARCHAR(32),
	HUB_BEING_KEY VARCHAR(32),
	URL VARCHAR(16777216),
	SOURCE_URL VARCHAR(16777216),
	NAME VARCHAR(16777216),
	JSON_RAW VARIANT,
	RECORD_HASH VARCHAR(32),
	LOAD_TIME TIMESTAMP_TZ(9)
);
create or replace TABLE SUPERHERO.DATA_VAULT.SAT_BEING_SUPERHERODB_RAW (
	SAT_BEING_SUPERHERODB_KEY VARCHAR(32),
	HUB_BEING_KEY VARCHAR(32),
	URL VARCHAR(16777216),
	SOURCE_URL VARCHAR(16777216),
	NAME VARCHAR(16777216),
	SOURCE_AS_IS_URL VARCHAR(16777216),
	INTELLIGENCE VARCHAR(16777216),
	STRENGTH VARCHAR(16777216),
	SPEED VARCHAR(16777216),
	DURABILITY VARCHAR(16777216),
	POWER VARCHAR(16777216),
	COMBAT VARCHAR(16777216),
	FULL_NAME VARCHAR(16777216),
	ALTER_EGOS VARCHAR(16777216),
	ALIASES VARCHAR(16777216),
	PLACE_OF_BIRTH VARCHAR(16777216),
	FIRST_APPEARANCE VARCHAR(16777216),
	CREATOR VARCHAR(16777216),
	ALIGNMENT VARCHAR(16777216),
	GENDER VARCHAR(16777216),
	RACE VARCHAR(16777216),
	HEIGHT VARCHAR(16777216),
	WEIGHT VARCHAR(16777216),
	EYE_COLOR VARCHAR(16777216),
	HAIR_COLOR VARCHAR(16777216),
	OCCUPATION VARCHAR(16777216),
	BASE VARCHAR(16777216),
	RELATIVES VARCHAR(16777216),
	SKIN_COLOR VARCHAR(16777216),
	TOTAL_POWER VARCHAR(16777216),
	RECORD_HASH VARCHAR(32),
	LOAD_TIME TIMESTAMP_TZ(9)
);
create or replace TABLE SUPERHERO.DATA_VAULT.SML_BEING (
	SML_BEING_KEY VARCHAR(32),
	HUB_BEING_KEY_1 VARCHAR(32),
	HUB_BEING_KEY_2 VARCHAR(32),
	URL_1 VARCHAR(16777216),
	URL_2 VARCHAR(16777216),
	LOAD_TIME TIMESTAMP_TZ(9)
);

create or replace TABLE SUPERHERO.DATA_VAULT.SAT_SML_BEING (
	SML_BEING_KEY VARCHAR(32),
	HUB_BEING_KEY_1 VARCHAR(32),
	HUB_BEING_KEY_2 VARCHAR(32),
	URL_1 VARCHAR(16777216),
	URL_2 VARCHAR(16777216),
	VALUE_1 VARIANT,
	VALUE_2 VARIANT,
	ALIASES_1 VARIANT,
	ALIASES_2 VARIANT,
	LOAD_TIME TIMESTAMP_TZ(9)
);



CREATE OR REPLACE FILE FORMAT SUPERHERO.DATA_VAULT.JSON
	TYPE = JSON
	NULL_IF = ()
	ALLOW_DUPLICATE = TRUE
	IGNORE_UTF8_ERRORS = TRUE
;