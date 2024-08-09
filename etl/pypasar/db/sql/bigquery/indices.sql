/*bigquery OMOP CDM Indices
 There are no unique indices created because it is assumed that the primary key constraints have been run prior to
 implementing indices.
 */
/************************
 Standardized clinical data
 ************************/
create clustered index idx_person_id on person (person_id asc);
-- bigquery does not support indexes
create clustered index idx_observation_period_id_1 on observation_period (person_id asc);
create clustered index idx_visit_person_id_1 on visit_occurrence (person_id asc);
-- bigquery does not support indexes
create clustered index idx_visit_det_person_id_1 on visit_detail (person_id asc);
-- bigquery does not support indexes
-- bigquery does not support indexes
create clustered index idx_condition_person_id_1 on condition_occurrence (person_id asc);
-- bigquery does not support indexes
-- bigquery does not support indexes
create clustered index idx_drug_person_id_1 on drug_exposure (person_id asc);
-- bigquery does not support indexes
-- bigquery does not support indexes
create clustered index idx_procedure_person_id_1 on procedure_occurrence (person_id asc);
-- bigquery does not support indexes
-- bigquery does not support indexes
create clustered index idx_device_person_id_1 on device_exposure (person_id asc);
-- bigquery does not support indexes
-- bigquery does not support indexes
create clustered index idx_measurement_person_id_1 on measurement (person_id asc);
-- bigquery does not support indexes
-- bigquery does not support indexes
create clustered index idx_observation_person_id_1 on observation (person_id asc);
-- bigquery does not support indexes
-- bigquery does not support indexes
create clustered index idx_death_person_id_1 on death (person_id asc);
create clustered index idx_note_person_id_1 on note (person_id asc);
-- bigquery does not support indexes
-- bigquery does not support indexes
create clustered index idx_note_nlp_note_id_1 on note_nlp (note_id asc);
-- bigquery does not support indexes
create clustered index idx_specimen_person_id_1 on specimen (person_id asc);
-- bigquery does not support indexes
-- bigquery does not support indexes
-- bigquery does not support indexes
-- bigquery does not support indexes
/************************
 Standardized health system data
 ************************/
create clustered index idx_location_id_1 on location (location_id asc);
create clustered index idx_care_site_id_1 on care_site (care_site_id asc);
create clustered index idx_provider_id_1 on provider (provider_id asc);
/************************
 Standardized health economics
 ************************/
create clustered index idx_period_person_id_1 on payer_plan_period (person_id asc);
-- bigquery does not support indexes
/************************
 Standardized derived elements
 ************************/
create clustered index idx_drug_era_person_id_1 on drug_era (person_id asc);
-- bigquery does not support indexes
create clustered index idx_dose_era_person_id_1 on dose_era (person_id asc);
-- bigquery does not support indexes
create clustered index idx_condition_era_person_id_1 on condition_era (person_id asc);
-- bigquery does not support indexes
/**************************
 Standardized meta-data
 ***************************/
create clustered index idx_metadata_concept_id_1 on metadata (metadata_concept_id asc);
/**************************
 Standardized vocabularies
 ***************************/
create clustered index idx_concept_concept_id on concept (concept_id asc);
-- bigquery does not support indexes
-- bigquery does not support indexes
-- bigquery does not support indexes
-- bigquery does not support indexes
create clustered index idx_vocabulary_vocabulary_id on vocabulary (vocabulary_id asc);
create clustered index idx_domain_domain_id on domain (domain_id asc);
create clustered index idx_concept_class_class_id on concept_class (concept_class_id asc);
create clustered index idx_concept_relationship_id_1 on concept_relationship (concept_id_1 asc);
-- bigquery does not support indexes
-- bigquery does not support indexes
create clustered index idx_relationship_rel_id on relationship (relationship_id asc);
create clustered index idx_concept_synonym_id on concept_synonym (concept_id asc);
create clustered index idx_concept_ancestor_id_1 on concept_ancestor (ancestor_concept_id asc);
-- bigquery does not support indexes
create clustered index idx_source_to_concept_map_3 on source_to_concept_map (target_concept_id asc);
-- bigquery does not support indexes
-- bigquery does not support indexes
-- bigquery does not support indexes
create clustered index idx_drug_strength_id_1 on drug_strength (drug_concept_id asc);
-- bigquery does not support indexes
--Additional v6.0 indices
--CREATE CLUSTERED INDEX idx_survey_person_id_1 ON survey_conduct (person_id ASC);
--CREATE CLUSTERED INDEX idx_episode_person_id_1 ON episode (person_id ASC);
--CREATE INDEX idx_episode_concept_id_1 ON episode (episode_concept_id ASC);
--CREATE CLUSTERED INDEX idx_episode_event_id_1 ON episode_event (episode_id ASC);
--CREATE INDEX idx_ee_field_concept_id_1 ON episode_event (event_field_concept_id ASC);