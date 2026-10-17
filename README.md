# Career Track — MySQL Database

Career Track tracks the journey **admission → academics → skills/projects → internships → placements → graduation → alumni**.

## Requirements
- MySQL 8.0+ (CHECK constraint support)
- MySQL Workbench

## Files
- `schema.sql` — creates the database and 19 linked tables
- `seed.sql` — inserts fictional demonstration data
- `views.sql` — dashboard-friendly SQL views
- `queries.sql` — example SELECT queries
- `er_diagram.mmd` — Mermaid ER diagram source (can be rendered to PNG later)

## Setup in MySQL Workbench
1. Open MySQL Workbench and connect to your local MySQL server.
2. **File → Open SQL Script** → select `schema.sql`.
3. Click the lightning-bolt **Execute All** button.
4. Open and execute `seed.sql` **once**.
5. Open and execute `views.sql`.
6. Run `SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='career_track' AND table_type='BASE TABLE';` — expected **19**.
7. Run `SELECT * FROM career_track.student_academic_summary;`.
8. Open `queries.sql` and run individual SELECT queries.

**Note:** `schema.sql` is safe to run again on an existing schema but does **not** migrate/alter existing tables. `seed.sql` is **not** repeatable and should only run on a fresh database.

## Tables
Users and students; courses, academic_records, subject_results, backlogs; skills, student_skills, certifications, projects, internships; companies, placement_drives, placement_applications, interview_rounds, placement_offers; alumni_profiles, career_history, alumni_feedback.

## Team integration
- The backend must use its own DB connection configured through environment variables; **never commit DB passwords or `.env`**.
- The backend hashes passwords securely (Argon2id or bcrypt) before storing them. Seed hashes are placeholders, so seed accounts **cannot log in** until replaced.
- Use parameterized queries and enforce student-specific authorization in backend routes.
- `student_id` is the stable identity; graduation does not delete academic history.
- Alumni promotion: after verified graduation and once the expected graduation year is reached, insert the alumni profile and update `users.role` inside **one transaction**. This is application logic, not an automatic trigger.
- The placement applicant is a student with a `placement_applications` row, not a separate role.
- Percentage and CGPA in the sample are **fictional stored demonstration values**. Production calculations must follow college-specific credit and conversion rules.
- Add access controls, validation, indexes, migrations, and automated tests before production use.
