-- *******************************************************************
-- NAME: stg__person.sql
-- DESC: Create the staging view - person
-- *******************************************************************
-- CHANGE LOG:
-- DATE        VERS  INITIAL  CHANGE DESCRIPTION
-- ----------  ----  -------  ----------------------------------------
-- 2024-08-27  1.00           Initial create
--
-- *******************************************************************

-- Select distinct values to ensure no duplicate anon_case_no
WITH unique AS (
    SELECT 
        DISTINCT "anon_case_no" AS "unique_anon_case_no",
        "gender",
        "Age_Time_of_Surgery",
        "operation_startdate",
        "institution_code",
        "race"
    FROM pre_op.char
), 
-- Rename columns
naming AS (
    SELECT 
        "unique_anon_case_no" AS "person_source_value",
        "gender" AS "gender_source_value",
        "race" AS "race_source_value"
    FROM unique
), 
-- Map gender and race values to their respective concept IDs
mapping AS (
    SELECT
        "person_source_value",
        CASE "gender_source_value"
            WHEN 'MALE' THEN 8507
            WHEN 'FEMALE' THEN 8532
            ELSE 0
        END AS "gender_concept_id",
        CASE "race"
            WHEN 'Chinese' THEN 38003579
            WHEN 'Asian Indian' THEN 38003574
            WHEN 'Malay' THEN 4028336
            ELSE 0
        END AS "race_concept_id"
    FROM naming
), 
-- Calculate the year of birth
computing AS (
    SELECT
        "person_source_value",
        EXTRACT(YEAR FROM "operation_startdate")::INT - "Age_Time_of_Surgery"::INT AS "year_of_birth"
    FROM naming
), 
-- Combine the mapped gender and race with the calculated year of birth
final AS (
    SELECT 
        n."person_source_value", 
        n."gender_source_value", 
        n."race_source_value",
        m."gender_concept_id", 
        m."race_concept_id",
        c."year_of_birth"
    FROM naming AS n
    LEFT JOIN mapping AS m
      ON n."person_source_value" = m."person_source_value"
    LEFT JOIN computing AS c
      ON n."person_source_value" = c."person_source_value"
)

-- Create the staging view for the person table, assigning a unique person_id
CREATE VIEW stg__person AS
SELECT
    ROW_NUMBER() OVER (ORDER BY "person_source_value") AS "person_id",
    "gender_concept_id",
    "year_of_birth",
    "race_concept_id",
    "person_source_value",
    "gender_source_value",
    "race_source_value"
FROM final;