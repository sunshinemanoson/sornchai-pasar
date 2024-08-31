-- *******************************************************************
-- NAME: person.sql
-- DESC: Final table - person
-- *******************************************************************
-- CHANGE LOG:
-- DATE        VERS  INITIAL  CHANGE DESCRIPTION
-- ----------  ----  -------  ----------------------------------------
-- 2024-08-27  1.00           Initial create
--
-- *******************************************************************

SELECT
    "person_id",
    "gender_concept_id",
    "year_of_birth",
    NULL AS "month_of_birth",
    NULL AS "day_of_birth",
    NULL AS "birth_datetime",
    "race_concept_id",
    0 AS "ethnicity_concept_id",
    NULL AS "location_id",
    NULL AS "provider_id",
    NULL AS "care_site_id",
    "person_source_value",
    "gender_source_value",
    NULL AS "gender_source_concept_id",
    "race_source_value",
    NULL AS "race_source_concept_id",
    NULL AS "ethnicity_source_value",
    NULL AS "ethnicity_source_concept_id"
FROM stg__person;