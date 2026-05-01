#############################################################
# Ensure the MySQL healthcare dasebase is set as the default
# Cleaned Data from Silver Level Tables; Load final tables
#############################################################

# Insert into admission_type from silver_admission_type
INSERT INTO admission_type (admission_type_id, admission_type_description)
SELECT admission_type_id, admission_type_description
FROM silver_admission_type;

# Insert into admission_source from silver_admission_source
INSERT INTO admission_source (admission_source_id, admission_source_description)
SELECT admission_source_id, admission_source_description FROM silver_admission_source;

# Insert into discharge_disposition from silver_discharge_disposition
INSERT INTO discharge_disposition(discharge_disposition_id, discharge_disposition_description)
SELECT discharge_disposition_id, discharge_disposition_description FROM silver_discharge_disposition;

# insert data into ICD9 table from diabetic_data Excel file
# numberic values
INSERT INTO ICD9 (code_start_int, code_end_int, icd9_description)
VALUES (1,139,'INFECTIOUS AND PARASITIC DISEASES (001-139)'),
(140,239,'NEOPLASMS (140-239)'),
(240,279,'ENDOCRINE, NUTRITIONAL AND METABOLIC DISEASES, AND IMMUNITY DISORDERS (240-279)'),
(280,289,'DISEASES OF THE BLOOD AND BLOOD-FORMING ORGANS (280-289)'),
(290,319,'MENTAL, BEHAVIORAL AND NEURODEVELOPMENTAL DISORDERS (290-319)'),
(320,389,'DISEASES OF THE NERVOUS SYSTEM AND SENSE ORGANS (320-389)'),
(390,459,'DISEASES OF THE CIRCULATORY SYSTEM (390-459)'),
(460,519,'DISEASES OF THE RESPIRATORY SYSTEM (460-519)'),
(520,579,'DISEASES OF THE DIGESTIVE SYSTEM (520-579)'),
(580,629,'DISEASES OF THE GENITOURINARY SYSTEM (580-629)'),
(630,679,'COMPLICATIONS OF PREGNANCY, CHILDBIRTH, AND THE PUERPERIUM (630-679)'),
(680,709,'DISEASES OF THE SKIN AND SUBCUTANEOUS TISSUE (680-709)'),
(710,739,'DISEASES OF THE MUSCULOSKELETAL SYSTEM AND CONNECTIVE TISSUE (710-739)'),
(740,759,'CONGENITAL ANOMALIES (740-759)'),
(760,779,'CERTAIN CONDITIONS ORIGINATING IN THE PERINATAL PERIOD (760-779)'),
(780,799,'SYMPTOMS, SIGNS, AND ILL-DEFINED CONDITIONS (780-799)'),
(800,999,'INJURY AND POISONING (800-999)');
# string values
INSERT INTO ICD9 (code_start_str, code_end_str,icd9_description)
VALUES ('E000', 'E999','SUPPLEMENTARYCLASSIFICATION OF EXTERNAL CAUSES OF INJURY AND POISONING (E000-E999)'),
('V01','V91','SUPPLEMENTARY CLASSIFICATION OF FACTORS INFLUENCING HEALTH STATUS AND CONTACT WITH HEALTH SERVICES (V01-V91)');

# Insert into patient from silver_patient
INSERT INTO healthcare.patient (patient_nbr, race, gender, age, weight)
SELECT patient_nbr, race, gender, age, weight
FROM healthcare.silver_patient;

# Insert data from silver_patient_encounter to patient_encounter  
INSERT INTO patient_encounter(encounter_id,patient_nbr,admission_type_id,discharge_disposition_id,
  	admission_source_id,time_in_hospital,payer_code,medical_specialty,num_lab_procedures,num_procedures,
  	num_medications,number_outpatient,number_emergency,number_inpatient,diag_1,diag_2,diag_3,number_diagnoses,
    max_glu_serum,A1Cresult,metformin,repaglinide,nateglinide,chlorpropamide,glimepiride,acetohexamide,glipizide,
    glyburide,tolbutamide,pioglitazone,rosiglitazone,acarbose,miglitol,troglitazone,tolazamide,examide,citoglipton,
  	insulin,glyburideMetformin,glipizideMetformin,glimepiridePioglitazone,metforminRosiglitazone,metforminPioglitazone,change_in_meds,
  	diabetesMed,readmitted)
SELECT encounter_id,patient_nbr,admission_type_id,discharge_disposition_id,admission_source_id,time_in_hospital
    ,payer_code,medical_specialty,num_lab_procedures,num_procedures,num_medications,number_outpatient,number_emergency,number_inpatient
    ,diag_1,diag_2, diag_3,number_diagnoses, max_glu_serum, A1Cresult ,metformin,repaglinide,nateglinide,chlorpropamide
    ,glimepiride,acetohexamide,glipizide,glyburide,tolbutamide,pioglitazone,rosiglitazone,acarbose,miglitol,troglitazone
    ,tolazamide,examide,citoglipton,insulin,glyburideMetformin,glipizideMetformin,glimepiridePioglitazone,metforminRosiglitazone
    ,metforminPioglitazone,change_in_meds,diabetesMed,readmitted
FROM silver_patient_encounter;
