-- Student Performance Analysis (Kaggle Dataset)
-- pgAdmin/PostgreSQL + Tableau

-- 0) Setup: Create analysis table (subset of columns)

CREATE TABLE IF NOT EXISTS student_academic_performance (
  student_id SERIAL PRIMARY KEY,
  prev_score INT,
  exam_score INT,
  attendance INT,
  hours_studied INT,
  tutoring_sess INT,
  access_to_res VARCHAR(50),
  motiv_level VARCHAR(50)
);

-- 1) Data pipeline (B): Insert from staging table (student_raw)
-- Note: student_raw contains the original Kaggle columns.

INSERT INTO student_academic_performance
(prev_score, exam_score, attendance, hours_studied, tutoring_sess, access_to_res, motiv_level)
SELECT
  previous_scores,
  exam_score,
  attendance,
  hours_studied,
  tutoring_sessions,
  access_to_resources,
  motivation_level
FROM student_raw;

-- 2) Derived metric: improvement (score_diff = exam_score - prev_score)

ALTER TABLE student_academic_performance
ADD COLUMN IF NOT EXISTS score_diff INT;

UPDATE student_academic_performance
SET score_diff = exam_score - prev_score
WHERE score_diff IS NULL;

-- 3) Task 1: Access to Resources vs Improvement

SELECT
  access_to_res,
  COUNT(*) AS student_count,
  AVG(score_diff) AS avg_score_diff
FROM student_academic_performance
GROUP BY access_to_res
ORDER BY access_to_res;

-- 4) Task 2: Study Hours vs Improvement

SELECT
  hours_studied,
  COUNT(*) AS student_count,
  AVG(score_diff) AS avg_score_diff
FROM student_academic_performance
GROUP BY hours_studied
ORDER BY hours_studied;

-- 5) Task 3: Tutoring Sessions vs Improvement

SELECT
  tutoring_sess,
  COUNT(*) AS student_count,
  AVG(score_diff) AS avg_score_diff
FROM student_academic_performance
GROUP BY tutoring_sess
ORDER BY tutoring_sess;
