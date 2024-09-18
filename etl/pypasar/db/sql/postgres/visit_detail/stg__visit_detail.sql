-- Create or replace the staging view for visit_detail
CREATE OR REPLACE VIEW {OMOP_SCHEMA}.stg__visit_detail AS
    -- Extract relevant columns from the pre_op.char table
    WITH source AS (
        SELECT 
            po.id AS po_id, 
            pre.id AS pre_id,  
            po.session_startdate,
            po.anon_case_no,
            omp.person_source_value AS person_id,
            pre.Admission_Type,
            po.session_id,
            opr.session_id AS opr_session_id,
            opr.anon_surgeon_name AS surgeon_name,
            opr.anon_plan_anaesthetist_1_name AS anaesthetist_1_name,
            opr.anon_plan_anaesthetist_2_name AS anaesthetist_2_name,
            po.icu_admission_date,
            po.icu_admission_time,
            po.operation_starttime,
            po.operation_endtime,
            po.icu_discharge_date,
            po.icu_discharge_time,
            po.icu_location
        FROM {POSTOP_SCHEMA}.icu po
        LEFT JOIN {PREOP_SCHEMA}.char pre 
            ON pre.anon_case_no = po.anon_case_no
        LEFT JOIN {OMOP_SCHEMA}.person omp 
            ON omp.person_source_value = po.anon_case_no
        LEFT JOIN {INTRAOP_SCHEMA}.operation opr
            ON pre.anon_case_no = opr.anon_case_no 
    ),
    filteredSource AS (
        SELECT 
            *,
            ROW_NUMBER() OVER (PARTITION BY person_id ORDER BY session_startdate) AS unique_person_id,
            ROW_NUMBER() OVER (PARTITION BY session_id,  anon_case_no ORDER BY session_startdate) AS unique_visit_occurrence_id,
            ROW_NUMBER() OVER (ORDER BY session_startdate, po_id) AS  unique_visit_detail_id,
            ROW_NUMBER() OVER (PARTITION BY opr_session_id, surgeon_name,anaesthetist_1_name,anaesthetist_2_name  ORDER BY session_startdate) AS unique_provider_id
        FROM source s
    ),
    mapping AS (
        SELECT
            unique_visit_detail_id,
            unique_person_id AS person_id,
            CASE 
                WHEN Admission_Type = 'Inpatient' THEN 9201 
                WHEN Admission_Type = 'Day Surgery (DS)' THEN 9202 
                WHEN Admission_Type = 'Same Day Admission (SDA)' THEN 9203
                ELSE NULL
            END AS visit_detail_concept_id,
            -- if icu_admission_date,icu_discharge_date is null values is 2000-01-01
            COALESCE(icu_admission_date, '2000-01-01') AS check_icu_admission_date,
            COALESCE((icu_admission_date + operation_starttime::interval), '2000-01-01') AS concat_start_datetime,
            COALESCE(icu_discharge_date, '2000-01-01') AS check_icu_discharge_date,
            COALESCE((icu_discharge_date + operation_endtime::interval), '2000-01-01') AS concat_end_datetime,
            32879 AS visit_detail_type_concept_id,
            'ICU' AS visit_detail_source_value
            
        FROM filteredSource
    ),
    final AS (
        SELECT 
            fs.unique_visit_detail_id AS visit_detail_id,
            m.person_id AS person_id,
            m.visit_detail_concept_id,
            m.visit_detail_type_concept_id,
            m.check_icu_admission_date AS visit_detail_start_date,
            m.concat_start_datetime AS visit_detail_start_datetime,
            m.check_icu_discharge_date AS visit_detail_end_date,
            m.concat_end_datetime AS visit_detail_end_datetime,
            fs.unique_provider_id AS provider_id,
            fs.unique_visit_occurrence_id AS visit_occurrence_id
        FROM filteredSource fs
        JOIN mapping m
            ON fs.unique_visit_detail_id = m.unique_visit_detail_id 
        ORDER BY fs.session_startdate
    )
    SELECT
        visit_detail_id,
        person_id,
        visit_detail_concept_id,
        visit_detail_type_concept_id,
        visit_detail_start_date,
        visit_detail_start_datetime,
        visit_detail_end_date,
        visit_detail_end_datetime,
        provider_id,
        visit_occurrence_id
    FROM   final;
