 use database raw;
 use schema superhero;

-- masking based on Roles
 use role analyst;
 
 select * from raw.SUPERHERO.SUPERHEROES_KAGGLE_HEROES_NLP;
 
 
 select * from raw.superhero.heroes_information hi
    left join raw.superhero.superhero_powers sp on
    hi.name = sp.hero_names;
    
 select * from raw.superhero.superhero_db;
 select * from raw.superhero.superheroes_marvel_search;
 
 
 
