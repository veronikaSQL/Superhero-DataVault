-- adding another source
INSERT INTO DATA_VAULT.HUB_BEING 
WITH READ_FROM_RAW AS (
        SELECT
            DISTINCT IMG as SOURCE_URL,
            'KAGGLE_NLP:' || SOURCE_URL AS URL,
            MD5(URL) AS HUB_BEING_KEY,
            parse_json(
                '{"Source_System": "https://www.kaggle.com/jonathanbesomi/superheroes-nlp-dataset", 
        "Source_Table": "SUPERHERO.DEMO.SUPERHEROS_KAGGLE_HEROES_NLP", 
        "Source_Columns": { "SOURCE_URL": ["IMG"] } 
         }'
            ) :: variant AS RECORD_SOURCE
        from
            SUPERHERO.DEMO.SUPERHEROS_KAGGLE_HEROES_NLP
        where
            img is not null
    )
SELECT
    SRC.HUB_BEING_KEY,
    SRC.URL,
    SRC.SOURCE_URL,
    SRC.RECORD_SOURCE,
    current_timestamp() :: timestamp_tz as LOAD_TIME
from
    READ_FROM_RAW SRC
    left join DATA_VAULT.HUB_BEING TGT
     ON SRC.HUB_BEING_KEY = TGT.HUB_BEING_KEY
    WHERE TGT.HUB_BEING_KEY IS NULL;