USE career_track;
-- Student profile
SELECT * FROM students WHERE student_id=1;
-- Semester-wise marks
SELECT semester,sgpa,cgpa,percentage FROM academic_records WHERE student_id=1 ORDER BY semester;
-- Subject-wise marks
SELECT c.course_code,c.course_name,r.internal_marks,r.external_marks,r.grade,r.result_status
FROM subject_results r JOIN courses c ON c.course_id=r.course_id WHERE r.student_id=1;
-- Current backlogs
SELECT s.full_name,c.course_name,b.status FROM backlogs b
JOIN students s ON s.student_id=b.student_id JOIN courses c ON c.course_id=b.course_id
WHERE b.status='PENDING';
-- Projects and internships
SELECT * FROM projects WHERE student_id=1;
SELECT * FROM internships WHERE student_id=3;
-- Applications and offers
SELECT * FROM placement_application_summary;
-- Latest CGPA
SELECT * FROM latest_student_cgpa;
-- Potentially eligible students for a drive (simple CGPA + backlog rules only)
SELECT s.student_id,s.full_name,d.drive_id
FROM students s JOIN latest_student_cgpa g ON g.student_id=s.student_id
CROSS JOIN placement_drives d
JOIN active_backlog_counts b ON b.student_id=s.student_id
WHERE g.cgpa >= d.minimum_cgpa AND b.active_backlogs <= d.maximum_active_backlogs;
-- Alumni profiles
SELECT s.full_name,a.graduation_year,a.current_company,a.current_designation
FROM alumni_profiles a JOIN students s ON s.student_id=a.student_id;
-- IMPORTANT: eligibility is provisional; backend must check other college/company rules.
