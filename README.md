# Superhero-DataVault

Sources:

https://www.superherodb.com​
https://github.com/algolia/marvel-search​
https://www.kaggle.com/jonathanbesomi/superheroes-nlp-dataset
https://www.kaggle.com/claudiodavi/superhero-set

Original Version create for WWDVC21
Sample code is written for Snowflake but can be easily adjusted for other databases
1. To create a database, schemas, and tables execute 1_CreateObjects.sql
2. Load data using your favorite import tool. I used "Load Table" functionality in Snowflake's GUI
    - Data/superherodb/superhero_raw.csv to  SUPERHERO.DEMO.SUPERHEROES_RAW
    - Data/marvel_search/*.* to SUPERHERO.DEMO.SUPERHEROES_MARVEL_SEARCH
3. Populate Data Vault tables by executing files in DATA_VAULT/Tables/* in any order
4. Create effectivity Satellite views by executing scrpts in DATA_VAULT/Views/*
5. Create Information Mart views by executing Mart/Views/*
6. Demo queires can be found in DemoQueries.sql

-- Add new data source
7. Load data using your favorite import tool. I used "Load Table" functionality in Snowflake's GUI   
  - Data/kaggle_superhero/superheroes_nlp_dataset.csv to SUPERHERO.DEMO.SUPERHEROS_KAGGLE_HEROES_NLP
8. Add new data to hub_being by executing table/hub_being_2.sql
9. create new Sat data_vault/tables/SAT_being kaggle_nlp.sql
10. create new effectivity SAT data_vault/views/sat_being_kaggle_nlp.sql
11. modify  beings_all view to add new source to by executing mart/views/beings_all_2.sql 

PII, Data Clssification, Data Masking WWDVC 2022
Scripts_PII

