use database raw;
USE ROLE SYSADMIN;

CREATE OR REPLACE DATABASE DATA_VAULT;
CREATE OR REPLACE SCHEMA DATA_VAULT.SUPERHERO;
CREATE OR REPLACE SCHEMA DATA_VAULT.STAGING;

CREATE OR REPLACE DATABASE MART;
CREATE OR REPLACE SCHEMA MART.SUPERHERO;

USE DATABASE DATA_VAULT;
USE SCHEMA SUPERHERO;


create or replace TABLE HUB_BEING (
	HUB_BEING_KEY VARCHAR(32),
	BEING_ID VARCHAR(16777216),
	BEING_ID_BKCC VARCHAR(16777216),
	RECORD_SOURCE VARIANT,
	LOAD_TIME TIMESTAMP_TZ(9)
);


create or replace TABLE SAT_BEING_SUPERHERO_SET_BII (
	SAT_BEING_SUPERHERO_SET_BII VARCHAR(32),
	HUB_BEING_KEY VARCHAR(32),
	NAME VARCHAR(16777216),
	GENDER VARCHAR(16777216),
	EYE_COLOR VARCHAR(16777216),
	RACE VARCHAR(16777216),
	HAIR_COLOR VARCHAR(16777216),
	HEIGHT NUMBER(9,4),
	WEIGHT NUMBER(9,4),
	SKIN_COLOR VARCHAR(16777216),
	RECORD_HASH VARCHAR(32),
	LOAD_DATE TIMESTAMP_TZ(9)
);


-- create or replace TABLE SAT_BEING_MARVEL_SEARCH_BII (
-- 	SAT_BEING_MARVEL_SEARCH_KEY VARCHAR(32),
-- 	HUB_BEING_KEY VARCHAR(32),
-- 	BEING_ID NUMBER(38,0),
-- 	BEING_ID_BKCC VARCHAR(16777216),
-- 	JSON_RAW VARIANT,
-- 	RECORD_HASH VARCHAR(32),
-- 	LOAD_DATE TIMESTAMP_TZ(9)
-- );

create or replace TABLE DATA_VAULT.SUPERHERO.SAT_BEING_SUPERHERO_SET (
	SAT_BEING_SUPERHERO_SET_KEY VARCHAR(32),
	HUB_BEING_KEY VARCHAR(32),
	PUBLISHER VARCHAR(16777216),
	ALIGNMENT VARCHAR(16777216),
	AGILITY BOOLEAN,
	ACCELERATED_HEALING BOOLEAN,
	LANTERN_POWER_RING BOOLEAN,
	DIMENSIONAL_AWARENESS BOOLEAN,
	COLD_RESISTANCE BOOLEAN,
	DURABILITY BOOLEAN,
	STEALTH BOOLEAN,
	ENERGY_ABSORPTION BOOLEAN,
	FLIGHT BOOLEAN,
	DANGER_SENSE BOOLEAN,
	UNDERWATER_BREATHING BOOLEAN,
	MARKSMANSHIP BOOLEAN,
	WEAPONS_MASTER BOOLEAN,
	POWER_AUGMENTATION BOOLEAN,
	ANIMAL_ATTRIBUTES BOOLEAN,
	LONGEVITY BOOLEAN,
	INTELLIGENCE BOOLEAN,
	SUPER_STRENGTH BOOLEAN,
	CRYOKINESIS BOOLEAN,
	TELEPATHY BOOLEAN,
	ENERGY_ARMOR BOOLEAN,
	ENERGY_BLASTS BOOLEAN,
	DUPLICATION BOOLEAN,
	SIZE_CHANGING BOOLEAN,
	DENSITY_CONTROL BOOLEAN,
	STAMINA BOOLEAN,
	ASTRAL_TRAVEL BOOLEAN,
	AUDIO_CONTROL BOOLEAN,
	DEXTERITY BOOLEAN,
	OMNITRIX BOOLEAN,
	SUPER_SPEED BOOLEAN,
	POSSESSION BOOLEAN,
	ANIMAL_ORIENTED_POWERS BOOLEAN,
	WEAPON_BASED_POWERS BOOLEAN,
	ELECTROKINESIS BOOLEAN,
	DARKFORCE_MANIPULATION BOOLEAN,
	DEATH_TOUCH BOOLEAN,
	TELEPORTATION BOOLEAN,
	ENHANCED_SENSES BOOLEAN,
	TELEKINESIS BOOLEAN,
	ENERGY_BEAMS BOOLEAN,
	MAGIC BOOLEAN,
	HYPERKINESIS BOOLEAN,
	JUMP BOOLEAN,
	CLAIRVOYANCE BOOLEAN,
	DIMENSIONAL_TRAVEL BOOLEAN,
	POWER_SENSE BOOLEAN,
	SHAPESHIFTING BOOLEAN,
	PEAK_HUMAN_CONDITION BOOLEAN,
	IMMORTALITY BOOLEAN,
	CAMOUFLAGE BOOLEAN,
	ELEMENT_CONTROL BOOLEAN,
	PHASING BOOLEAN,
	ASTRAL_PROJECTION BOOLEAN,
	ELECTRICAL_TRANSPORT BOOLEAN,
	FIRE_CONTROL BOOLEAN,
	PROJECTION BOOLEAN,
	SUMMONING BOOLEAN,
	ENHANCED_MEMORY BOOLEAN,
	REFLEXES BOOLEAN,
	INVULNERABILITY BOOLEAN,
	ENERGY_CONSTRUCTS BOOLEAN,
	FORCE_FIELDS BOOLEAN,
	SELF_SUSTENANCE BOOLEAN,
	ANTI_GRAVITY BOOLEAN,
	EMPATHY BOOLEAN,
	POWER_NULLIFIER BOOLEAN,
	RADIATION_CONTROL BOOLEAN,
	PSIONIC_POWERS BOOLEAN,
	ELASTICITY BOOLEAN,
	SUBSTANCE_SECRETION BOOLEAN,
	ELEMENTAL_TRANSMOGRIFICATION BOOLEAN,
	TECHNOPATH_CYBERPATH BOOLEAN,
	PHOTOGRAPHIC_REFLEXES BOOLEAN,
	SEISMIC_POWER BOOLEAN,
	ANIMATION BOOLEAN,
	PRECOGNITION BOOLEAN,
	MIND_CONTROL BOOLEAN,
	FIRE_RESISTANCE BOOLEAN,
	POWER_ABSORPTION BOOLEAN,
	ENHANCED_HEARING BOOLEAN,
	NOVA_FORCE BOOLEAN,
	INSANITY BOOLEAN,
	HYPNOKINESIS BOOLEAN,
	ANIMAL_CONTROL BOOLEAN,
	NATURAL_ARMOR BOOLEAN,
	INTANGIBILITY BOOLEAN,
	ENHANCED_SIGHT BOOLEAN,
	MOLECULAR_MANIPULATION BOOLEAN,
	HEAT_GENERATION BOOLEAN,
	ADAPTATION BOOLEAN,
	GLIDING BOOLEAN,
	POWER_SUIT BOOLEAN,
	MIND_BLAST BOOLEAN,
	PROBABILITY_MANIPULATION BOOLEAN,
	GRAVITY_CONTROL BOOLEAN,
	REGENERATION BOOLEAN,
	LIGHT_CONTROL BOOLEAN,
	ECHOLOCATION BOOLEAN,
	LEVITATION BOOLEAN,
	TOXIN_AND_DISEASE_CONTROL BOOLEAN,
	BANISH BOOLEAN,
	ENERGY_MANIPULATION BOOLEAN,
	HEAT_RESISTANCE BOOLEAN,
	NATURAL_WEAPONS BOOLEAN,
	TIME_TRAVEL BOOLEAN,
	ENHANCED_SMELL BOOLEAN,
	ILLUSIONS BOOLEAN,
	THIRSTOKINESIS BOOLEAN,
	HAIR_MANIPULATION BOOLEAN,
	ILLUMINATION BOOLEAN,
	OMNIPOTENT BOOLEAN,
	CLOAKING BOOLEAN,
	CHANGING_ARMOR BOOLEAN,
	POWER_COSMIC BOOLEAN,
	BIOKINESIS BOOLEAN,
	WATER_CONTROL BOOLEAN,
	RADIATION_IMMUNITY BOOLEAN,
	VISION_TELESCOPIC BOOLEAN,
	TOXIN_AND_DISEASE_RESISTANCE BOOLEAN,
	SPATIAL_AWARENESS BOOLEAN,
	ENERGY_RESISTANCE BOOLEAN,
	TELEPATHY_RESISTANCE BOOLEAN,
	MOLECULAR_COMBUSTION BOOLEAN,
	OMNILINGUALISM BOOLEAN,
	PORTAL_CREATION BOOLEAN,
	MAGNETISM BOOLEAN,
	MIND_CONTROL_RESISTANCE BOOLEAN,
	PLANT_CONTROL BOOLEAN,
	SONAR BOOLEAN,
	SONIC_SCREAM BOOLEAN,
	TIME_MANIPULATION BOOLEAN,
	ENHANCED_TOUCH BOOLEAN,
	MAGIC_RESISTANCE BOOLEAN,
	INVISIBILITY BOOLEAN,
	SUB_MARINER BOOLEAN,
	RADIATION_ABSORPTION BOOLEAN,
	INTUITIVE_APTITUDE BOOLEAN,
	VISION_MICROSCOPIC BOOLEAN,
	MELTING BOOLEAN,
	WIND_CONTROL BOOLEAN,
	SUPER_BREATH BOOLEAN,
	WALLCRAWLING BOOLEAN,
	VISION_NIGHT BOOLEAN,
	VISION_INFRARED BOOLEAN,
	GRIM_REAPING BOOLEAN,
	MATTER_ABSORPTION BOOLEAN,
	THE_FORCE BOOLEAN,
	RESURRECTION BOOLEAN,
	TERRAKINESIS BOOLEAN,
	VISION_HEAT BOOLEAN,
	VITAKINESIS BOOLEAN,
	RADAR_SENSE BOOLEAN,
	QWARDIAN_POWER_RING BOOLEAN,
	WEATHER_CONTROL BOOLEAN,
	VISION_XRAY BOOLEAN,
	VISION_THERMAL BOOLEAN,
	WEB_CREATION BOOLEAN,
	REALITY_WARPING BOOLEAN,
	ODIN_FORCE BOOLEAN,
	SYMBIOTE_COSTUME BOOLEAN,
	SPEED_FORCE BOOLEAN,
	PHOENIX_FORCE BOOLEAN,
	MOLECULAR_DISSIPATION BOOLEAN,
	VISION_CRYO BOOLEAN,
	OMNIPRESENT BOOLEAN,
	OMNISCIENT BOOLEAN,
	RECORD_HASH VARCHAR(32),
	LOAD_DATE TIMESTAMP_TZ(9)
);

-- create or replace TABLE DATA_VAULT.SUPERHERO.SML_BEING (
-- 	HUB_BEING_KEY_1 VARCHAR(32),
-- 	HUB_BEING_KEY_2 VARCHAR(32),
-- 	LOAD_DATE TIMESTAMP_TZ(9)
-- );

--- LETS CHECK ERD


-- permissions for analyst
use role accountadmin;
grant usage, monitor on database MART to role analyst;  
grant usage, monitor on schema MART.superhero to role analyst; 
grant select on future views in schema MART.superhero to role analyst; 
grant select on all views in schema MART.superhero to role analyst; 

grant usage on database data_vault to role data_classification;
grant usage on schema data_vault.superhero to role data_classification;

