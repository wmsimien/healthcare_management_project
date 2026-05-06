# BASE SQL
WITH cte1 AS (
	SELECT pe.patient_nbr
		,pe.encounter_id
		,adt.admission_type_description
		,ads.admission_source_description
		,dd.discharge_disposition_description
		,time_in_hospital,payer_code,medical_specialty,num_lab_procedures,num_procedures
		,num_medications,number_outpatient,number_emergency,number_inpatient
		,diag_1,diag_2,diag_3,number_diagnoses
		,max_glu_serum,A1Cresult,metformin,repaglinide,nateglinide,chlorpropamide,acetohexamide,glimepiride,glipizide,glyburide
		,tolbutamide,tolazamide,examide,pioglitazone,rosiglitazone,troglitazone,acarbose,miglitol,citoglipton,insulin
		,glyburideMetformin,glipizideMetformin,glimepiridePioglitazone,metforminRosiglitazone,metforminPioglitazone
		,change_in_meds,diabetesMed,readmitted
	FROM patient_encounter pe
	INNER JOIN admission_type adt
		ON pe.admission_type_id = adt.admission_type_id
	INNER JOIN admission_source ads
		ON pe.admission_source_id = ads.admission_source_id
	INNER JOIN discharge_disposition dd
		ON pe.discharge_disposition_id = dd.discharge_disposition_id
	ORDER BY pe.patient_nbr, pe.encounter_id DESC)
	, cte2 AS (
	SELECT patient_nbr,encounter_id
		,admission_type_description
		,admission_source_description
		,discharge_disposition_description
		,time_in_hospital,payer_code,medical_specialty,num_lab_procedures,num_procedures
		,num_medications,number_outpatient,number_emergency,number_inpatient
		,cte1.diag_1
		,icd9_1.icd9_description AS diag_1_desc
		,cte1.diag_2
		,icd9_2.icd9_description AS diag_2_desc
		,cte1.diag_3
		,number_diagnoses
		,max_glu_serum,A1Cresult,metformin,repaglinide,nateglinide,chlorpropamide,acetohexamide,glimepiride,glipizide,glyburide
		,tolbutamide,tolazamide,examide,pioglitazone,rosiglitazone,troglitazone,acarbose,miglitol,citoglipton,insulin
		,glyburideMetformin,glipizideMetformin,glimepiridePioglitazone,metforminRosiglitazone,metforminPioglitazone
		,change_in_meds,diabetesMed,readmitted
	FROM cte1
	INNER JOIN icd9 icd9_1
		ON cte1.diag_1 BETWEEN icd9_1.code_start_int AND icd9_1.code_end_int
			OR cte1.diag_1 BETWEEN icd9_1.code_start_str AND icd9_1.code_end_str
	INNER JOIN icd9 AS icd9_2
		ON cte1.diag_2 BETWEEN icd9_2.code_start_int AND icd9_2.code_end_int
			OR cte1.diag_2 BETWEEN icd9_2.code_start_str AND icd9_2.code_end_str
	)
	SELECT patient_nbr,encounter_id
		,admission_type_description
		,admission_source_description
		,discharge_disposition_description
		,time_in_hospital,payer_code,medical_specialty,num_lab_procedures,num_procedures
		,num_medications,number_outpatient,number_emergency,number_inpatient
		,cte2.diag_1
		,cte2.diag_1_desc
		,cte2.diag_2
		,cte2.diag_2_desc
		,cte2.diag_3
		,icd9_3.icd9_description AS diag_3_desc
		,number_diagnoses
		,max_glu_serum,A1Cresult,metformin,repaglinide,nateglinide,chlorpropamide,acetohexamide,glimepiride,glipizide,glyburide
		,tolbutamide,tolazamide,examide,pioglitazone,rosiglitazone,troglitazone,acarbose,miglitol,citoglipton,insulin
		,glyburideMetformin,glipizideMetformin,glimepiridePioglitazone,metforminRosiglitazone,metforminPioglitazone
		,change_in_meds,diabetesMed,readmitted
	FROM cte2
	INNER JOIN icd9 AS icd9_3
		ON cte2.diag_3 BETWEEN icd9_3.code_start_int AND icd9_3.code_end_int
			OR cte2.diag_3 BETWEEN icd9_3.code_start_str AND icd9_3.code_end_str
	; # 101,766 rows
    
#####################
#      Questio      #
#####################

	# 1. What is the breakdown of patients per admission_type?
	WITH patient_encounter_all_cte AS (
	SELECT pe.patient_nbr
		,pe.encounter_id
		,adt.admission_type_description
		,ads.admission_source_description
		,dd.discharge_disposition_description
		,time_in_hospital,payer_code,medical_specialty,num_lab_procedures,num_procedures
		,num_medications,number_outpatient,number_emergency,number_inpatient
		,number_diagnoses
		,max_glu_serum,A1Cresult,metformin,repaglinide,nateglinide,chlorpropamide,acetohexamide,glimepiride,glipizide,glyburide
		,tolbutamide,tolazamide,examide,pioglitazone,rosiglitazone,troglitazone,acarbose,miglitol,citoglipton,insulin
		,glyburideMetformin,glipizideMetformin,glimepiridePioglitazone,metforminRosiglitazone,metforminPioglitazone
		,change_in_meds,diabetesMed,readmitted
	FROM patient_encounter pe
	INNER JOIN admission_type adt
		ON pe.admission_type_id = adt.admission_type_id
	INNER JOIN admission_source ads
		ON pe.admission_source_id = ads.admission_source_id
	INNER JOIN discharge_disposition dd
		ON pe.discharge_disposition_id = dd.discharge_disposition_id
	ORDER BY pe.patient_nbr, pe.encounter_id DESC)
	SELECT admission_type_description
		, COUNT(patient_nbr) AS cnt
	FROM patient_encounter_all_cte
	GROUP BY admission_type_description
	ORDER BY COUNT(patient_nbr) DESC; 

	# 2. What are the admission types? (Why) - represents the priority
						# and nature of the patient's arrival, often used for scheduling and administrative analysis.
	SELECT *
	FROM admission_type; # 8 rows; Not Available(5) 4785

		# 2a. What is the patient encounter break dwon by admission types
		SELECT adt.admission_type_id
			,admission_type_description
			, COUNT(patient_nbr) AS number_of_patients
		FROM patient_encounter pe
		INNER JOIN admission_type adt
			ON pe.admission_type_id = adt.admission_type_id
		GROUP BY adt.admission_type_id
		,admission_type_description
	ORDER BY COUNT(patient_nbr) DESC ; # 8 rows

	# 3. What are the discharge_disposition types?
	#########################################################
	# Discharge disposition is the final destination or setting 
	# a patient goes to upon leaving a healthcare facility, 
	# determining their next level of care. It defines whether 
	# the patient is going home (with or without support), 
	# transferring to another facility (like nursing or rehab), 
	# or leaving against medical advice
	########################################################
	SELECT discharge_disposition_id
		, discharge_disposition_description
	FROM discharge_disposition; # 30 rows

	# 4. Admission Source? (Where) - identifies the location or 
						# context of the patient immediately prior to being admitted to the facility
	SELECT admission_source_id
		, admission_source_description
	FROM admission_source; # 24 rows

	# Break down admission source per patient encounter?
	SELECT ads.admission_source_id
		,admission_source_description
		, COUNT(patient_nbr) AS number_of_patients
	FROM patient_encounter pe
	INNER JOIN admission_source ads
		ON pe.admission_source_id = ads.admission_source_id
	GROUP BY ads.admission_source_id
		,admission_source_description
	ORDER BY COUNT(patient_nbr) DESC ;# 16 rows; '7','Court/Law Enforcement','57494' (56.50%) of dataset
	-- LIMIT 10 ;

	# 5. Breakdown by diagnosis (primary)
	####################################################
	# ICD-9 codes for diabetes treatment center on the 250.xx series, 
	# requiring a 4th digit for complications and a 5th digit for 
	# type/control (0=Type II/Unspecified, 1=Type I, 2=Uncontrolled Type II, 
	# 3=Uncontrolled Type I). Common codes include 250.00 (Type II, no complications) 
	# and 250.01 (Type I, no complications)
	####################################################
	WITH patient_primary_diagnosis_cte AS (
	SELECT pe.patient_nbr
		,diag_1
		,icd9_1.icd9_description
	FROM patient_encounter pe
	INNER JOIN icd9 icd9_1
		ON pe.diag_1 BETWEEN icd9_1.code_start_int AND icd9_1.code_end_int
			OR pe.diag_1 BETWEEN icd9_1.code_start_str AND icd9_1.code_end_str
	)
	SELECT diag_1
		, icd9_description
		, COUNT(ppdc.patient_nbr) AS cnt
		, ROW_NUMBER() OVER(ORDER BY COUNT(ppdc.patient_nbr) DESC) AS rnk
	FROM patient_primary_diagnosis_cte ppdc
	GROUP BY diag_1
		,icd9_description
	ORDER BY COUNT(ppdc.patient_nbr) DESC # 716 rows; 250.8 row 15; 250.6 row 19; 250.7 row 29; 250.13 row 30; 250.02 row 35;250.11 row 37;
	LIMIT 10; # top ten

	# 6. Number of Patient Encounters
	SELECT patient_nbr
		, num_of_visits
	FROM (
	SELECT pe.patient_nbr
		, COUNT(pe.patient_nbr) AS num_of_visits
		, COUNT(pe.encounter_id) AS total_number_of_encounters
		, ROW_NUMBER() OVER(PARTITION BY pe.patient_nbr) AS row_num
	FROM patient_encounter pe
	INNER JOIN patient p
		ON pe.patient_nbr = p.patient_nbr
	GROUP BY pe.patient_nbr
	ORDER BY pe.patient_nbr) t
	ORDER BY num_of_visits DESC
	; # 71,518 rows

	# 7. Patinet Breakdown By Race
	SELECT race
		, race_cnt
	FROM 
	(
	SELECT race
		, COUNT(patient_nbr) OVER(PARTITION BY race) AS race_cnt
		, ROW_NUMBER() OVER(PARTITION BY race) AS row_num_race
	FROM patient ) t
	WHERE row_num_race = 1
	ORDER BY race_cnt DESC;

	# 8. Calculate the average length of hospital stay for each admission type
	WITH time_in_hospital_per_admission_type_cte AS (
	SELECT 
		pe.admission_type_id
		,adt.admission_type_description
		,pe.time_in_hospital
	FROM patient_encounter pe
	INNER JOIN admission_type adt
		ON pe.admission_type_id = adt.admission_type_id
	)
	SELECT 
	-- admission_type_id
		admission_type_description
		,COUNT(time_in_hospital) AS time_in_hospital_count
		,SUM(time_in_hospital) AS total_time_in_hospital
		,ROUND(SUM(time_in_hospital) / COUNT(time_in_hospital),2) AS avg_time_in_hospital
	FROM time_in_hospital_per_admission_type_cte 
	GROUP BY admission_type_description
	ORDER BY  SUM(time_in_hospital) DESC; 

	# 9. Determine the number of readmitted patients and the percentage of total encounters that they represent
	SELECT 
		pe.readmitted
        , COUNT(pe.encounter_id) AS num_of_encounters
        , COUNT(DISTINCT pe.patient_nbr) AS num_of_readmitted_patients
        , ROUND(COUNT(DISTINCT pe.patient_nbr) / COUNT(pe.encounter_id),2) * 100 AS percentage_of_total_encounters
	FROM patient_encounter pe
	INNER JOIN patient p
		ON pe.patient_nbr = p.patient_nbr
	GROUP BY pe.readmitted 
    ORDER BY pe.readmitted ;

	# 10. Identify the age distribution of patients
	SELECT p.age
		, COUNT(pe.patient_nbr) AS age_distribution
        , COUNT(DISTINCT pe.patient_nbr) AS num_of_readmitted_patients
	FROM patient_encounter pe
	INNER JOIN patient p
		ON pe.patient_nbr = p.patient_nbr
	GROUP BY p.age
	ORDER BY COUNT(pe.patient_nbr) DESC; # 10 rows
    
  #11. Calculate the average number of medications prescribed for patients in each age group
    	SELECT p.age
		, COUNT(pe.patient_nbr) AS age_distribution
        , COUNT(DISTINCT pe.patient_nbr) AS num_of_readmitted_patients
        , SUM(pe.num_medications) AS total_meds
		FROM patient_encounter pe
		INNER JOIN patient p
			ON pe.patient_nbr = p.patient_nbr
		GROUP BY p.age
		ORDER BY COUNT(pe.patient_nbr) DESC; # 10 rows

	#12. See completeness of specific data which may be used to speak to data validation
		# completeness of race data 'Other' which initially had '?'
		SELECT total_records
			, other_race_cnt
			, total_records - other_race_cnt AS missing_race
			, ROUND((total_records - other_race_cnt) / total_records,2) * 100 AS missing_race_percentage
		FROM (
		SELECT 
			COUNT(*) AS total_records
			, (SELECT COUNT(race) FROM patient WHERE race = 'Other' GROUP BY race) AS other_race_cnt
		FROM patient) t;

		# completeness of payer_code data 'Other' which initially had '?'
		SELECT total_records
			, missing_payer_code
			, total_records - missing_payer_code AS missing_payers
			, ROUND((total_records - missing_payer_code) / total_records,2) * 100 AS missing_payers_percentage
		FROM (
		SELECT 
			COUNT(*) AS total_records
			, (SELECT COUNT(payer_code) FROM patient_encounter WHERE payer_code = 'Not Captured' GROUP BY payer_code) AS missing_payer_code
		FROM patient_encounter) t;

		# breakdown of patient payer code
		SELECT payer_code
			, COUNT(patient_nbr) AS payor_patient_cnts
		FROM patient_encounter
		GROUP BY payer_code
		ORDER BY COUNT(patient_nbr) DESC;

		# completeness of medical_specialty data 'Other' which initially had '?'
		SELECT total_records
			, missing_medical_specialty
			, total_records - missing_medical_specialty AS missing_medical_specialties
			, ROUND((total_records - missing_medical_specialty) / total_records,2) * 100 AS missing_medical_specialties_percentage
		FROM (
		SELECT 
			COUNT(*) AS total_records
			, (SELECT COUNT(medical_specialty) FROM patient_encounter 
					WHERE medical_specialty = 'Not Captured' GROUP BY medical_specialty) AS missing_medical_specialty
		FROM patient_encounter) t;

		# breakdown of patient medical_specialty
		SELECT medical_specialty
			, COUNT(patient_nbr) AS medical_specialty_patient_cnts
		FROM patient_encounter
		GROUP BY medical_specialty
		ORDER BY COUNT(patient_nbr) DESC; # 73 rows
