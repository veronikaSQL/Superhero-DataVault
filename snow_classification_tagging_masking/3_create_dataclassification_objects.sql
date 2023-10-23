USE ROLE SYSADMIN;
CREATE OR REPLACE SCHEMA RAW.ADMIN; -- SCHEMA FOR DATA CLASSIFICATION OBJECTS

-- create table to save output from data classification
USE DATABASE RAW;
USE SCHEMA ADMIN;

create or replace table admin.data_classification 
(
table_name string,
classification variant
);