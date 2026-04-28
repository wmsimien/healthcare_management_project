# Load Data bronze tables

# The following tables are load via Python : bronze_patient and bronze_patient_encounter

# insert data bronze_admission_type from Excel IDS_mapping file
INSERT INTO bronze_admission_type (
	admission_type_description
) VALUES('Emergency'), ('Urgent'), ('Elective'), ('Newborn'), ('Not Available'), (NULL), ('Trauma Center'), ('Not Mapped');

# insert data into bronze_discharge_disposition based on data taken from Excel IDS_mapping file
# SNF -> Skilled Nursing Facility; ICF -> ; Intermediate Care Facility; AMA -> Against Medical Advice
INSERT INTO bronze_discharge_disposition (
	discharge_disposition_description
) VALUES('Discharged to home'), ('Discharged/transferred to another short term hospital'), 
	('Discharged/transferred to SNF'), ('Discharged/transferred to ICF'), 
    ('Discharged/transferred to another type of inpatient care institution'), ('Discharged/transferred to home with home health service'), 
    ('Left AMA'), ('Discharged/transferred to home under care of Home IV provider'), ('Admitted as an inpatient to this hospital'),
    ('Neonate discharged to another hospital for neonatal aftercare'), ('Expired'), 
    ('Still patient or expected to return for outpatient services'), ('Hospice / home'), ('Hospice / medical facility'),
    ('Discharged/transferred within this institution to Medicare approved swing bed'), 
    ('Discharged/transferred/referred another institution for outpatient services'),
    ('Discharged/transferred/referred to this institution for outpatient services'), (NULL), ('Expired at home. Medicaid only, hospice.'),
    ('Expired in a medical facility. Medicaid only, hospice.'), ('Expired, place unknown. Medicaid only, hospice.'),
    ('Discharged/transferred to another rehab fac including rehab units of a hospital .'), 
    ('Discharged/transferred to a long term care hospital.'), 
    ('Discharged/transferred to a nursing facility certified under Medicaid but not certified under Medicare.'), ('Not Mapped'),
    ('Unknown/Invalid'), ('Discharged/transferred to another Type of Health Care Institution not Defined Elsewhere'),
    ('Discharged/transferred to a federal health care facility.'), 
    ('Discharged/transferred/referred to a psychiatric hospital of psychiatric distinct part unit of a hospital'), 
    ('Discharged/transferred to a Critical Access Hospital (CAH).');
    
    
# insert data into bronze_admission_source based on data taken from Excel IDS_mapping file
INSERT INTO bronze_admission_source (
	admission_source_description
) VALUES(' Physician Referral'), ('Clinic Referral'), ('HMO Referral'), ('Transfer from a hospital'), 
(' Transfer from a Skilled Nursing Facility (SNF)'), (' Emergency Room'), (' Court/Law Enforcement'), 
(' Not Available'), ('Transfer from critial access hospital'), ('Normal Delivery'), (' Premature Delivery'),
(' Sick Baby'), (' Extramural Birth'), ('Not Available'), (NULL), (' Transfer From Another Home Health Agency'),
('Readmission to Same Home Health Agency'), (' Not Mapped'), ('Unknown/Invalid'), (' Transfer from hospital inpt/same fac reslt in a sep claim'),
(' Born inside this hospital'), (' Born outside this hospital'), (' Transfer from Ambulatory Surgery Center'), ('Transfer from Hospice');
