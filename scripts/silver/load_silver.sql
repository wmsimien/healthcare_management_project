#############################################################
# Ensure the MySQL healthcare database is set a default db
# Clean Data from bronze tables and load silver layer tables
#############################################################

# Insert into silver_admission_type from bronze_admission_type
INSERT INTO silver_admission_type (admission_type_id, admission_type_description)
SELECT admission_type_id
	, IFNULL(TRIM(admission_type_description), 'Not Selected') AS admission_type_description
FROM bronze_admission_type;

# insert int silver_discharge_disposition from bronze_discharge_disposition
INSERT INTO silver_discharge_disposition(discharge_disposition_id, discharge_disposition_description)
SELECT discharge_disposition_id
	, IFNULL(TRIM(discharge_disposition_description), 'Not Selected') AS discharge_disposition_description
FROM bronze_discharge_disposition;

# insert data into silver_admission_source from bronze_admission_source
INSERT INTO silver_admission_source (admission_source_id,admission_source_description)
SELECT admission_source_id
	, IFNULL(TRIM(admission_source_description), 'Not Selected') AS admission_source_description
FROM bronze_admission_source;


# Insert data from bronze_patient to silver_patient    
INSERT INTO healthcare.silver_patient (patient_nbr, race, gender, age, weight)
SELECT patient_nbr
    , CASE
		WHEN race = 'AfricanAmerican' THEN REPLACE(race, 'AfricanAmerican', 'African American') 
        WHEN race = '?' THEN REPLACE(race, '?', 'Not Captured') 
		ELSE TRIM(race)
	END AS race
    , TRIM(gender)
    , REPLACE(REPLACE(age, '[', ''), ')', '') AS age
    , CASE
        WHEN weight = '?' THEN REPLACE(weight, '?', 'Not Captured') 
		ELSE REPLACE(REPLACE(weight, '[', ''), ')', '')
	END AS weight
FROM bronze_patient;

# Insert data into silver_patient_encounter from bronze_patient_encounter to   
INSERT INTO silver_patient_encounter(encounter_id,patient_nbr,admission_type_id,discharge_disposition_id,
	admission_source_id,time_in_hospital,payer_code,medical_specialty,num_lab_procedures,num_procedures,
	num_medications,number_outpatient,number_emergency,number_inpatient,diag_1,diag_2,diag_3,number_diagnoses,
    max_glu_serum,A1Cresult,metformin,repaglinide,nateglinide,chlorpropamide,glimepiride,acetohexamide,glipizide,
    glyburide,tolbutamide,pioglitazone,rosiglitazone,acarbose,miglitol,troglitazone,tolazamide,examide,citoglipton,
	insulin,glyburideMetformin,glipizideMetformin,glimepiridePioglitazone,metforminRosiglitazone,metforminPioglitazone,change_in_meds,
	diabetesMed,readmitted)
SELECT encounter_id,patient_nbr,admission_type_id,discharge_disposition_id,admission_source_id,time_in_hospital
	, CASE 
		WHEN payer_code = '?' THEN REPLACE(payer_code, '?', 'Not Captured') 
        ELSE TRIM(payer_code)
    END AS payer_code
    ,CASE 
		WHEN medical_specialty = '?' THEN REPLACE(medical_specialty, '?', 'Not Captured')
        WHEN medical_specialty = 'InternalMedicine' THEN REPLACE(medical_specialty, 'InternalMedicine', 'Internal Medicine')
		WHEN medical_specialty = 'Family/GeneralPractice' THEN REPLACE(medical_specialty, 'Family/GeneralPractice', 'Family/General Practice')
        WHEN medical_specialty = 'Obsterics&Gynecology-GynecologicOnco' THEN REPLACE(medical_specialty, 'Obsterics&Gynecology-GynecologicOnco', 'Obsterics & Gynecology-Gynecologic Onco')
        WHEN medical_specialty = 'ObstetricsandGynecology' THEN REPLACE(medical_specialty, 'ObstetricsandGynecology', 'Obstetrics And Gynecology')
        WHEN medical_specialty = 'Surgery-Colon&Rectal' THEN REPLACE(medical_specialty, 'Surgery-Colon&Rectal', 'Surgery-Colon & Rectal')
        WHEN medical_specialty = 'Surgery-PlasticwithinHeadandNeck' THEN REPLACE(medical_specialty, 'Surgery-PlasticwithinHeadandNeck', 'Surgery-Plastic Within Head And Neck')
        WHEN medical_specialty = 'Pediatrics-EmergencyMedicine' THEN REPLACE(medical_specialty, 'Pediatrics-EmergencyMedicine', 'Pediatrics-Emergency Medicine')
        WHEN medical_specialty = 'PhysicalMedicineandRehabilitation' THEN REPLACE(medical_specialty, 'PhysicalMedicineandRehabilitation', 'Physical Medicine And Rehabilitation')
        WHEN medical_specialty = 'InfectiousDiseases' THEN REPLACE(medical_specialty, 'InfectiousDiseases', 'Infectious Diseases')
        WHEN medical_specialty = 'AllergyandImmunology' THEN REPLACE(medical_specialty, 'AllergyandImmunology', 'Allergy And Immunology')
        WHEN medical_specialty = 'Pediatrics-InfectiousDiseases' THEN REPLACE(medical_specialty, 'Pediatrics-InfectiousDiseases', 'Pediatrics-Infectious Diseases')
        WHEN medical_specialty = 'Pediatrics-AllergyandImmunology' THEN REPLACE(medical_specialty, 'Pediatrics-AllergyandImmunology', 'Pediatrics-Allergy And Immunology')
        WHEN medical_specialty = 'PhysicianNotFound' THEN REPLACE(medical_specialty, 'PhysicianNotFound', 'Physician Not Found')
        WHEN medical_specialty = 'SurgicalSpecialty' THEN REPLACE(medical_specialty, 'SurgicalSpecialty', 'Surgical Specialty')
        WHEN medical_specialty = 'SportsMedicine' THEN REPLACE(medical_specialty, 'SportsMedicine', 'Sports Medicine')
        ELSE TRIM(medical_specialty)
    END AS medical_specialty,num_lab_procedures,num_procedures,num_medications,number_outpatient,number_emergency,number_inpatient
    , CASE 
		WHEN diag_1 = '?' THEN REPLACE(diag_1, '?', 799) 
        ELSE TRIM(diag_1)
    END AS diag_1
    , CASE 
		WHEN diag_2 = '?' THEN REPLACE(diag_2, '?', 799) 
        ELSE TRIM(diag_2)
    END AS diag_2
    , CASE 
		WHEN diag_3 = '?' THEN REPLACE(diag_3, '?', 799) 
        ELSE TRIM(diag_3)
    END AS diag_3,number_diagnoses
    , IFNULL(max_glu_serum, 'None') AS max_glu_serum
	, COALESCE(A1Cresult, 'None') AS A1Cresult ,metformin,repaglinide,nateglinide,chlorpropamide,glimepiride,acetohexamide,glipizide,
    glyburide,tolbutamide,pioglitazone,rosiglitazone,acarbose,miglitol,troglitazone,tolazamide,examide,citoglipton,
	insulin,glyburideMetformin,glipizideMetformin,glimepiridePioglitazone,metforminRosiglitazone,metforminPioglitazone
    , CASE 
		WHEN change_in_meds = 'Ch' THEN REPLACE(change_in_meds, 'Ch', 'Change')
        WHEN change_in_meds = 'No' THEN REPLACE(change_in_meds, 'No', 'No Change')
        ELSE change_in_meds
    END AS change_in_meds,diabetesMed
     , CASE 
        WHEN readmitted = 'NO' THEN REPLACE(readmitted, 'NO', 'No')
        ELSE TRIM(readmitted)
	 END as readmitted
FROM bronze_patient_encounter;
