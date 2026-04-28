# Ensure MySQL healthcare database is the default database and the bronze_ddl file has been executed.
# Create tables in healthcare database with data from the bronze level tables.
# Data has been clean in the bronze level from the raw dataset.  All tables will start w/ silver_

### Silver Level Tables

# create table: silver_admission_type:
CREATE TABLE IF NOT EXISTS silver_admission_type (
	admission_type_id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Unique identifier for each admission type',
  admission_type_description VARCHAR(50) COMMENT 'Description of admission type'
) COMMENT = 'Table storing inital data of admission types';

# create table silver_discharge_disposition:
CREATE TABLE IF NOT EXISTS silver_discharge_disposition (
	discharge_disposition_id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Unique identifier for each discharge disposition',
  discharge_disposition_description VARCHAR(255) COMMENT 'Description of discharge disposition'
) COMMENT = 'Table storing inital data of discharge disposition';

# create table silver_admission_source:
CREATE TABLE IF NOT EXISTS silver_admission_source (
	admission_source_id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Unique identifier for each admission source',
  admission_source_description VARCHAR(255) COMMENT 'Description of admission source'
) COMMENT = 'Table storing inital data of admission_source';


# create table silver_patient:
CREATE TABLE IF NOT EXISTS silver_patient (
	patient_nbr	BIGINT COMMENT 'Unique identifier for each patient',
	race VARCHAR(50) COMMENT 'Reported race of the patient, such as Caucasian, African American, Asian, etc.',
	gender VARCHAR(50) COMMENT 'Reported gender of the patient; Male, Female, Unknown/Invalid.',
	age	VARCHAR(20) COMMENT 'Age group of the patient in 10-year intervals, e.g., [60-70).',
	weight VARCHAR(20) COMMENT "Weight of the patient, if reported; ranges are categorized.",
  created_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Patient record created date",
  last_modified DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Patient record last modified date"
) COMMENT = 'Table storing patient information';

# create silver_patient_encounter table:
CREATE TABLE IF NOT EXISTS silver_patient_encounter (
  encounter_id BIGINT COMMENT 'Unique identifier for each patient encounter or hospital visit.',
	patient_nbr	BIGINT COMMENT 'Unique identifier for each patient',
	admission_type_id INT COMMENT 'Type of admission to the hospital (e.g., 1 = Emergency, 2 = Urgent, 3 = Elective).',
	discharge_disposition_id INT COMMENT 'Outcome of the hospitalization (e.g., 1 = Discharged to home, 2 = Discharged to short-term hospital, 3 = Expired).',
	admission_source_id	INT COMMENT 'Origin of the admission (e.g., 1 = Physician referral, 7 = Emergency Room).',
	time_in_hospital INT COMMENT 'Length of stay in the hospital, measured in days.',
	payer_code VARCHAR(15) COMMENT 'Type of payment source (e.g., MC = Medicare, MD = Medicaid, SP = Self-Pay, Not Captured).',
	medical_specialty VARCHAR(100) COMMENT 'Specialty of the admitting physician (e.g., Cardiology, Surgery).',
	num_lab_procedures	INT COMMENT 'Number of lab procedures performed during the encounter.',
	num_procedures	INT COMMENT 'Number of procedures performed during the encounter.',
	num_medications	INT COMMENT 'Number of medications administered or prescribed during the encounter.',
	number_outpatient INT COMMENT 'Number of outpatient visits in the year before the encounter.',
	number_emergency INT COMMENT 'Number of emergency visits in the year before the encounter.',
	number_inpatient INT COMMENT 'Number of inpatient visits in the year before the encounter.',
	diag_1 VARCHAR(8) COMMENT 'Primary diagnosis code (ICD-9-CM). Represents the main condition diagnosed.',
	diag_2 VARCHAR(8) COMMENT 'Secondary diagnosis code (ICD-9-CM). Represents additional medical conditions.',
	diag_3 VARCHAR(8) COMMENT 'Tertiary diagnosis code (ICD-9-CM). Represents other relevant conditions.',
	number_diagnoses INT COMMENT 'Total number of diagnoses assigned during the encounter.',
  max_glu_serum VARCHAR(10) COMMENT 'Maximum glucose serum test result (e.g., >200, >300, Normal, None if not measured).',
	A1Cresult VARCHAR(10) COMMENT 'Hemoglobin A1c test result indicating average blood sugar levels (e.g., >7, >8, Normal, None if not measured).',
	metformin VARCHAR(10) COMMENT 'Whether the drug metformin was prescribed (e.g., No drug not prescribed, Steady, Up, Down).',
	repaglinide VARCHAR(10) COMMENT 'Whether the drug metformin was prescribed (e.g., No drug not prescribed, Steady, Up, Down).',
	nateglinide VARCHAR(10) COMMENT 'Whether the drug metformin was prescribed (e.g., No drug not prescribed, Steady, Up, Down).',
	chlorpropamide VARCHAR(10) COMMENT 'Whether the drug metformin was prescribed (e.g., No drug not prescribed, Steady, Up, Down).',
	glimepiride VARCHAR(10) COMMENT 'Whether the drug metformin was prescribed (e.g., No drug not prescribed, Steady, Up, Down).',
	acetohexamide VARCHAR(10) COMMENT 'Whether the drug metformin was prescribed (e.g., No drug not prescribed, Steady, Up, Down).',
  glipizide VARCHAR(10) COMMENT 'Whether the drug metformin was prescribed (e.g., No drug not prescribed, Steady, Up, Down).',
	glyburide VARCHAR(10) COMMENT 'Whether the drug metformin was prescribed (e.g., No drug not prescribed, Steady, Up, Down).',
  tolbutamide VARCHAR(10) COMMENT 'Whether the drug metformin was prescribed (e.g., No drug not prescribed, Steady, Up, Down).',
	pioglitazone VARCHAR(10) COMMENT 'Whether the drug metformin was prescribed (e.g., No drug not prescribed, Steady, Up, Down).',
	rosiglitazone VARCHAR(10) COMMENT 'Whether the drug metformin was prescribed (e.g., No drug not prescribed, Steady, Up, Down).',
	acarbose VARCHAR(10) COMMENT 'Whether the drug metformin was prescribed (e.g., No drug not prescribed, Steady, Up, Down).',
	miglitol VARCHAR(10) COMMENT 'Whether the drug metformin was prescribed (e.g., No drug not prescribed, Steady, Up, Down).',
	troglitazone VARCHAR(10) COMMENT 'Whether the drug metformin was prescribed (e.g., No drug not prescribed, Steady, Up, Down).',
	tolazamide VARCHAR(10) COMMENT 'Whether the drug metformin was prescribed (e.g., No drug not prescribed, Steady, Up, Down).',
	examide VARCHAR(10) COMMENT 'Whether the drug metformin was prescribed (e.g., No drug not prescribed, Steady, Up, Down).',
	citoglipton VARCHAR(10) COMMENT 'Whether the drug metformin was prescribed (e.g., No drug not prescribed, Steady, Up, Down).',
	insulin	VARCHAR(10) COMMENT 'Whether the drug metformin was prescribed (e.g., No drug not prescribed, Steady, Up, Down).',
  glyburideMetformin VARCHAR(10) COMMENT 'Whether the drug metformin was prescribed (e.g., No drug not prescribed, Steady, Up, Down).',
	glipizideMetformin VARCHAR(10) COMMENT 'Whether the drug metformin was prescribed (e.g., No drug not prescribed, Steady, Up, Down).',
	glimepiridePioglitazone VARCHAR(10) COMMENT 'Whether the drug metformin was prescribed (e.g., No drug not prescribed, Steady, Up, Down).',
	metforminRosiglitazone VARCHAR(10) COMMENT 'Whether the drug metformin was prescribed (e.g., No drug not prescribed, Steady, Up, Down).',
	metforminPioglitazone VARCHAR(10) COMMENT 'Whether the drug metformin was prescribed (e.g., No drug not prescribed, Steady, Up, Down).',
	change_in_meds	VARCHAR(10) COMMENT 'Whether there was a change in diabetic medications during the encounter.  Values: change and no change',
	diabetesMed	VARCHAR(5) COMMENT 'Whether any diabetes medication was prescribed during the encounter. Values: yes and no',
	readmitted	VARCHAR(5) COMMENT 'Whether the patient was readmitted after discharge. Values include "<30" (readmitted within 30 days), ">30" (readmitted after 30 days), and "NO".',
	created_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Patient drug record created date",
  last_modified DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Patient drug record last modified date"
) COMMENT = 'Table storing patient encounter information';
