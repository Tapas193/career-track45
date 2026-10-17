USE career_track;
CREATE OR REPLACE VIEW student_academic_summary AS
SELECT s.student_id,s.enrollment_number,s.full_name,a.semester,a.sgpa,a.cgpa,a.percentage
FROM students s JOIN academic_records a ON a.student_id=s.student_id;

CREATE OR REPLACE VIEW active_backlog_counts AS
SELECT s.student_id,s.full_name,COUNT(b.backlog_id) AS active_backlogs
FROM students s LEFT JOIN backlogs b
 ON b.student_id=s.student_id AND b.status='PENDING'
GROUP BY s.student_id,s.full_name;

CREATE OR REPLACE VIEW placement_application_summary AS
SELECT pa.application_id,s.student_id,s.full_name,c.company_name,
 pd.job_role,pa.status,po.offer_status,po.offered_package_lpa
FROM placement_applications pa
JOIN students s ON s.student_id=pa.student_id
JOIN placement_drives pd ON pd.drive_id=pa.drive_id
JOIN companies c ON c.company_id=pd.company_id
LEFT JOIN placement_offers po ON po.application_id=pa.application_id;

CREATE OR REPLACE VIEW latest_student_cgpa AS
SELECT a.student_id,a.semester,a.cgpa
FROM academic_records a
WHERE a.semester=(SELECT MAX(b.semester) FROM academic_records b WHERE b.student_id=a.student_id);
