CREATE DATABASE IF NOT EXISTS career_track CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE career_track;

CREATE TABLE IF NOT EXISTS users (
 user_id INT AUTO_INCREMENT PRIMARY KEY,
 email VARCHAR(150) NOT NULL UNIQUE,
 password_hash VARCHAR(255) NOT NULL,
 role ENUM('STUDENT','ADMIN','PLACEMENT_HEAD','ALUMNI') NOT NULL DEFAULT 'STUDENT',
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS students (
 student_id INT AUTO_INCREMENT PRIMARY KEY,
 user_id INT NOT NULL UNIQUE,
 enrollment_number VARCHAR(40) NOT NULL UNIQUE,
 full_name VARCHAR(120) NOT NULL,
 department VARCHAR(80) NOT NULL,
 admission_year SMALLINT NOT NULL,
 expected_graduation_year SMALLINT NOT NULL,
 graduation_completed BOOLEAN NOT NULL DEFAULT FALSE,
 phone VARCHAR(20),
 FOREIGN KEY (user_id) REFERENCES users(user_id)
);
CREATE TABLE IF NOT EXISTS courses (
 course_id INT AUTO_INCREMENT PRIMARY KEY,
 course_code VARCHAR(30) NOT NULL UNIQUE,
 course_name VARCHAR(150) NOT NULL,
 credits DECIMAL(4,1) NOT NULL,
 semester TINYINT NOT NULL,
 department VARCHAR(80) NOT NULL
);
CREATE TABLE IF NOT EXISTS academic_records (
 record_id INT AUTO_INCREMENT PRIMARY KEY,
 student_id INT NOT NULL,
 semester TINYINT NOT NULL,
 sgpa DECIMAL(4,2),
 cgpa DECIMAL(4,2),
 percentage DECIMAL(5,2),
 total_marks DECIMAL(8,2),
 obtained_marks DECIMAL(8,2),
 UNIQUE(student_id, semester),
 FOREIGN KEY (student_id) REFERENCES students(student_id)
);
CREATE TABLE IF NOT EXISTS subject_results (
 result_id INT AUTO_INCREMENT PRIMARY KEY,
 student_id INT NOT NULL,
 course_id INT NOT NULL,
 attempt_number INT NOT NULL DEFAULT 1,
 internal_marks DECIMAL(6,2),
 external_marks DECIMAL(6,2),
 grade VARCHAR(5),
 grade_points DECIMAL(4,2),
 result_status ENUM('PASS','FAIL','PENDING') DEFAULT 'PENDING',
 UNIQUE(student_id, course_id, attempt_number),
 FOREIGN KEY(student_id) REFERENCES students(student_id),
 FOREIGN KEY(course_id) REFERENCES courses(course_id)
);
CREATE TABLE IF NOT EXISTS backlogs (
 backlog_id INT AUTO_INCREMENT PRIMARY KEY,
 student_id INT NOT NULL,
 course_id INT NOT NULL,
 status ENUM('PENDING','CLEARED') NOT NULL DEFAULT 'PENDING',
 cleared_date DATE,
 UNIQUE(student_id, course_id),
 FOREIGN KEY(student_id) REFERENCES students(student_id),
 FOREIGN KEY(course_id) REFERENCES courses(course_id)
);
CREATE TABLE IF NOT EXISTS skills (
 skill_id INT AUTO_INCREMENT PRIMARY KEY,
 skill_name VARCHAR(100) NOT NULL UNIQUE
);
CREATE TABLE IF NOT EXISTS student_skills (
 student_id INT NOT NULL,
 skill_id INT NOT NULL,
 proficiency_level ENUM('BEGINNER','INTERMEDIATE','ADVANCED') DEFAULT 'BEGINNER',
 PRIMARY KEY(student_id, skill_id),
 FOREIGN KEY(student_id) REFERENCES students(student_id),
 FOREIGN KEY(skill_id) REFERENCES skills(skill_id)
);
CREATE TABLE IF NOT EXISTS certifications (
 certification_id INT AUTO_INCREMENT PRIMARY KEY,
 student_id INT NOT NULL,
 certification_name VARCHAR(150) NOT NULL,
 issuing_organization VARCHAR(150),
 issue_date DATE,
 certificate_url VARCHAR(500),
 FOREIGN KEY(student_id) REFERENCES students(student_id)
);
CREATE TABLE IF NOT EXISTS projects (
 project_id INT AUTO_INCREMENT PRIMARY KEY,
 student_id INT NOT NULL,
 project_title VARCHAR(150) NOT NULL,
 description TEXT,
 technologies_used VARCHAR(255),
 github_link VARCHAR(500),
 start_date DATE,
 end_date DATE,
 FOREIGN KEY(student_id) REFERENCES students(student_id)
);
CREATE TABLE IF NOT EXISTS internships (
 internship_id INT AUTO_INCREMENT PRIMARY KEY,
 student_id INT NOT NULL,
 company_name VARCHAR(150) NOT NULL,
 job_role VARCHAR(100),
 start_date DATE,
 end_date DATE,
 stipend DECIMAL(10,2),
 certificate_url VARCHAR(500),
 FOREIGN KEY(student_id) REFERENCES students(student_id)
);
CREATE TABLE IF NOT EXISTS companies (
 company_id INT AUTO_INCREMENT PRIMARY KEY,
 company_name VARCHAR(150) NOT NULL UNIQUE,
 industry VARCHAR(100),
 website VARCHAR(500)
);
CREATE TABLE IF NOT EXISTS placement_drives (
 drive_id INT AUTO_INCREMENT PRIMARY KEY,
 company_id INT NOT NULL,
 job_role VARCHAR(100) NOT NULL,
 package_lpa DECIMAL(8,2),
 minimum_cgpa DECIMAL(4,2) DEFAULT 0,
 maximum_active_backlogs INT DEFAULT 0,
 drive_date DATE,
 FOREIGN KEY(company_id) REFERENCES companies(company_id)
);
CREATE TABLE IF NOT EXISTS placement_applications (
 application_id INT AUTO_INCREMENT PRIMARY KEY,
 student_id INT NOT NULL,
 drive_id INT NOT NULL,
 application_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 status ENUM('APPLIED','SHORTLISTED','REJECTED','SELECTED') DEFAULT 'APPLIED',
 UNIQUE(student_id, drive_id),
 FOREIGN KEY(student_id) REFERENCES students(student_id),
 FOREIGN KEY(drive_id) REFERENCES placement_drives(drive_id)
);
CREATE TABLE IF NOT EXISTS interview_rounds (
 round_id INT AUTO_INCREMENT PRIMARY KEY,
 application_id INT NOT NULL,
 round_number INT NOT NULL,
 round_name VARCHAR(100) NOT NULL,
 round_date DATE,
 result ENUM('PENDING','PASS','FAIL') DEFAULT 'PENDING',
 feedback TEXT,
 UNIQUE(application_id, round_number),
 FOREIGN KEY(application_id) REFERENCES placement_applications(application_id)
);
CREATE TABLE IF NOT EXISTS placement_offers (
 offer_id INT AUTO_INCREMENT PRIMARY KEY,
 application_id INT NOT NULL UNIQUE,
 offered_package_lpa DECIMAL(8,2),
 offer_date DATE,
 joining_date DATE,
 offer_status ENUM('OFFERED','ACCEPTED','REJECTED') DEFAULT 'OFFERED',
 FOREIGN KEY(application_id) REFERENCES placement_applications(application_id)
);
CREATE TABLE IF NOT EXISTS alumni_profiles (
 alumni_id INT AUTO_INCREMENT PRIMARY KEY,
 student_id INT NOT NULL UNIQUE,
 graduation_year SMALLINT NOT NULL,
 current_company VARCHAR(150),
 current_designation VARCHAR(100),
 linkedin_url VARCHAR(500),
 FOREIGN KEY(student_id) REFERENCES students(student_id)
);
CREATE TABLE IF NOT EXISTS career_history (
 career_id INT AUTO_INCREMENT PRIMARY KEY,
 alumni_id INT NOT NULL,
 company_name VARCHAR(150) NOT NULL,
 designation VARCHAR(100),
 start_date DATE,
 end_date DATE,
 FOREIGN KEY(alumni_id) REFERENCES alumni_profiles(alumni_id)
);
CREATE TABLE IF NOT EXISTS alumni_feedback (
 feedback_id INT AUTO_INCREMENT PRIMARY KEY,
 alumni_id INT NOT NULL,
 feedback_text TEXT NOT NULL,
 rating TINYINT,
 submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT chk_rating CHECK(rating BETWEEN 1 AND 5),
 FOREIGN KEY(alumni_id) REFERENCES alumni_profiles(alumni_id)
);
