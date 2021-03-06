create or replace database SUPERHERO;

create or replace schema SUPERHERO.DEMO;

create or replace schema SUPERHERO.DATA_VAULT;

create or replace schema SUPERHERO.MART;


create or replace TABLE SUPERHERO.DEMO.SUPERHEROES_MARVEL_SEARCH (
	JSON_RAW VARIANT);

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

CREATE OR REPLACE TABLE SUPERHERO.DEMO.SUPERHEROS_KAGGLE_HEROES_NLP
(name VARCHAR(16777216), 
real_name VARCHAR(16777216), 
full_name VARCHAR(16777216), 
overall_score VARCHAR(16777216), 
history_text VARCHAR(16777216), 
powers_text VARCHAR(16777216), 
intelligence_score VARCHAR(16777216), 
strength_score VARCHAR(16777216), 
speed_score VARCHAR(16777216), 
durability_score VARCHAR(16777216), 
power_score VARCHAR(16777216), 
combat_score VARCHAR(16777216), 
superpowers VARCHAR(16777216), 
alter_egos VARCHAR(16777216), 
aliases VARCHAR(16777216), 
place_of_birth VARCHAR(16777216), 
first_appearance VARCHAR(16777216), 
creator VARCHAR(16777216), 
alignment VARCHAR(16777216), 
occupation VARCHAR(16777216), 
base VARCHAR(16777216), 
teams VARCHAR(16777216), 
relatives VARCHAR(16777216), 
gender VARCHAR(16777216), 
type_race VARCHAR(16777216), 
height VARCHAR(16777216), 
weight VARCHAR(16777216), 
eye_color VARCHAR(16777216), 
hair_color VARCHAR(16777216), 
skin_color VARCHAR(16777216), 
img VARCHAR(16777216), 
has_electrokinesis VARCHAR(16777216), 
has_energy_constructs VARCHAR(16777216), 
has_mind_control_resistance VARCHAR(16777216), 
has_matter_manipulation VARCHAR(16777216), 
has_telepathy_resistance VARCHAR(16777216), 
has_mind_control VARCHAR(16777216), 
has_enhanced_hearing VARCHAR(16777216), 
has_dimensional_travel VARCHAR(16777216), 
has_element_control VARCHAR(16777216), 
has_size_changing VARCHAR(16777216), 
has_fire_resistance VARCHAR(16777216), 
has_fire_control VARCHAR(16777216), 
has_dexterity VARCHAR(16777216), 
has_reality_warping VARCHAR(16777216), 
has_illusions VARCHAR(16777216), 
has_energy_beams VARCHAR(16777216), 
has_peak_human_condition VARCHAR(16777216), 
has_shapeshifting VARCHAR(16777216), 
has_heat_resistance VARCHAR(16777216), 
has_jump VARCHAR(16777216), 
has_self_sustenance VARCHAR(16777216), 
has_energy_absorption VARCHAR(16777216), 
has_cold_resistance VARCHAR(16777216), 
has_magic VARCHAR(16777216), 
has_telekinesis VARCHAR(16777216), 
has_toxin_and_disease_resistance VARCHAR(16777216), 
has_telepathy VARCHAR(16777216), 
has_regeneration VARCHAR(16777216), 
has_immortality VARCHAR(16777216), 
has_teleportation VARCHAR(16777216), 
has_force_fields VARCHAR(16777216), 
has_energy_manipulation VARCHAR(16777216), 
has_endurance VARCHAR(16777216), 
has_longevity VARCHAR(16777216), 
has_weapon_based_powers VARCHAR(16777216), 
has_energy_blasts VARCHAR(16777216), 
has_enhanced_senses VARCHAR(16777216), 
has_invulnerability VARCHAR(16777216), 
has_stealth VARCHAR(16777216), 
has_marksmanship VARCHAR(16777216), 
has_flight VARCHAR(16777216), 
has_accelerated_healing VARCHAR(16777216), 
has_weapons_master VARCHAR(16777216), 
has_intelligence VARCHAR(16777216), 
has_reflexes VARCHAR(16777216), 
has_super_speed VARCHAR(16777216), 
has_durability VARCHAR(16777216), 
has_stamina VARCHAR(16777216), 
has_agility VARCHAR(16777216), 
has_super_strength VARCHAR(16777216));


create or replace TABLE SUPERHERO.DATA_VAULT.SAT_BEING_KAGGLE_NLP_RAW (
	SAT_BEING_KAGGLE_NLP_KEY VARCHAR(32),
	HUB_BEING_KEY VARCHAR(32),
	URL VARCHAR(16777216),
	SOURCE_URL VARCHAR(16777216),
	NAME VARCHAR(16777216),
	REAL_NAME VARCHAR(16777216),
	FULL_NAME VARCHAR(16777216),
	OVERALL_SCORE VARCHAR(16777216),
	HISTORY_TEXT VARCHAR(16777216),
	POWERS_TEXT VARCHAR(16777216),
	INTELLIGENCE_SCORE VARCHAR(16777216),
	STRENGTH_SCORE VARCHAR(16777216),
	SPEED_SCORE VARCHAR(16777216),
	DURABILITY_SCORE VARCHAR(16777216),
	POWER_SCORE VARCHAR(16777216),
	COMBAT_SCORE VARCHAR(16777216),
	SUPERPOWERS VARCHAR(16777216),
	ALTER_EGOS VARCHAR(16777216),
	ALIASES VARCHAR(16777216),
	PLACE_OF_BIRTH VARCHAR(16777216),
	FIRST_APPEARANCE VARCHAR(16777216),
	CREATOR VARCHAR(16777216),
	ALIGNMENT VARCHAR(16777216),
	OCCUPATION VARCHAR(16777216),
	BASE VARCHAR(16777216),
	TEAMS VARCHAR(16777216),
	RELATIVES VARCHAR(16777216),
	GENDER VARCHAR(16777216),
	TYPE_RACE VARCHAR(16777216),
	HEIGHT VARCHAR(16777216),
	WEIGHT VARCHAR(16777216),
	EYE_COLOR VARCHAR(16777216),
	HAIR_COLOR VARCHAR(16777216),
	SKIN_COLOR VARCHAR(16777216),
	IMG VARCHAR(16777216),
	HAS_ELECTROKINESIS VARCHAR(16777216),
	HAS_ENERGY_CONSTRUCTS VARCHAR(16777216),
	HAS_MIND_CONTROL_RESISTANCE VARCHAR(16777216),
	HAS_MATTER_MANIPULATION VARCHAR(16777216),
	HAS_TELEPATHY_RESISTANCE VARCHAR(16777216),
	HAS_MIND_CONTROL VARCHAR(16777216),
	HAS_ENHANCED_HEARING VARCHAR(16777216),
	HAS_DIMENSIONAL_TRAVEL VARCHAR(16777216),
	HAS_ELEMENT_CONTROL VARCHAR(16777216),
	HAS_SIZE_CHANGING VARCHAR(16777216),
	HAS_FIRE_RESISTANCE VARCHAR(16777216),
	HAS_FIRE_CONTROL VARCHAR(16777216),
	HAS_DEXTERITY VARCHAR(16777216),
	HAS_REALITY_WARPING VARCHAR(16777216),
	HAS_ILLUSIONS VARCHAR(16777216),
	HAS_ENERGY_BEAMS VARCHAR(16777216),
	HAS_PEAK_HUMAN_CONDITION VARCHAR(16777216),
	HAS_SHAPESHIFTING VARCHAR(16777216),
	HAS_HEAT_RESISTANCE VARCHAR(16777216),
	HAS_JUMP VARCHAR(16777216),
	HAS_SELF_SUSTENANCE VARCHAR(16777216),
	HAS_ENERGY_ABSORPTION VARCHAR(16777216),
	HAS_COLD_RESISTANCE VARCHAR(16777216),
	HAS_MAGIC VARCHAR(16777216),
	HAS_TELEKINESIS VARCHAR(16777216),
	HAS_TOXIN_AND_DISEASE_RESISTANCE VARCHAR(16777216),
	HAS_TELEPATHY VARCHAR(16777216),
	HAS_REGENERATION VARCHAR(16777216),
	HAS_IMMORTALITY VARCHAR(16777216),
	HAS_TELEPORTATION VARCHAR(16777216),
	HAS_FORCE_FIELDS VARCHAR(16777216),
	HAS_ENERGY_MANIPULATION VARCHAR(16777216),
	HAS_ENDURANCE VARCHAR(16777216),
	HAS_LONGEVITY VARCHAR(16777216),
	HAS_WEAPON_BASED_POWERS VARCHAR(16777216),
	HAS_ENERGY_BLASTS VARCHAR(16777216),
	HAS_ENHANCED_SENSES VARCHAR(16777216),
	HAS_INVULNERABILITY VARCHAR(16777216),
	HAS_STEALTH VARCHAR(16777216),
	HAS_MARKSMANSHIP VARCHAR(16777216),
	HAS_FLIGHT VARCHAR(16777216),
	HAS_ACCELERATED_HEALING VARCHAR(16777216),
	HAS_WEAPONS_MASTER VARCHAR(16777216),
	HAS_INTELLIGENCE VARCHAR(16777216),
	HAS_REFLEXES VARCHAR(16777216),
	HAS_SUPER_SPEED VARCHAR(16777216),
	HAS_DURABILITY VARCHAR(16777216),
	HAS_STAMINA VARCHAR(16777216),
	HAS_AGILITY VARCHAR(16777216),
	HAS_SUPER_STRENGTH VARCHAR(16777216),
	RECORD_HASH VARCHAR(32),
	LOAD_TIME TIMESTAMP_TZ(9)
);
