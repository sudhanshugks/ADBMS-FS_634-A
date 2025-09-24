DROP TABLE IF EXISTS StudentEnrollments;

-- ===========================================
-- Create Table
-- ===========================================
CREATE TABLE StudentEnrollments (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    course_id VARCHAR(10) NOT NULL,
    enrollment_date DATE NOT NULL
);

-- Insert initial data
INSERT INTO StudentEnrollments (student_id, student_name, course_id, enrollment_date)
VALUES
(1, 'Ashish', 'CSE101', '2024-06-01'),
(2, 'Smaran', 'CSE102', '2024-06-01'),
(3, 'Vaibhav', 'CSE103', '2024-06-01');

SELECT * FROM StudentEnrollments;

-- ===========================================
-- Part A: Simulate Deadlock Between Two Users
-- (Run in two different sessions)
-- ===========================================
-- Session A
START TRANSACTION;
UPDATE StudentEnrollments SET enrollment_date = '2024-07-01' WHERE student_id = 1;
UPDATE StudentEnrollments SET enrollment_date = '2024-07-02' WHERE student_id = 2;
-- Waits if Session B already locked row 2

-- Session B
START TRANSACTION;
UPDATE StudentEnrollments SET enrollment_date = '2024-07-05' WHERE student_id = 2;
UPDATE StudentEnrollments SET enrollment_date = '2024-07-06' WHERE student_id = 1;
-- Deadlock occurs → DB rolls back one transaction automatically

-- ===========================================
-- Part B: MVCC – Concurrent Reads and Writes
-- ===========================================
-- Session A (set isolation BEFORE transaction)
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
SELECT * FROM StudentEnrollments WHERE student_id = 1;
-- Sees old value

-- Session B
START TRANSACTION;
UPDATE StudentEnrollments SET enrollment_date = '2024-07-10' WHERE student_id = 1;
COMMIT;

-- Session A (still in same transaction → snapshot)
SELECT * FROM StudentEnrollments WHERE student_id = 1;
COMMIT;

-- Session A (new transaction after commit → sees updated value)
SELECT * FROM StudentEnrollments WHERE student_id = 1;

-- ===========================================
-- Part C: Compare Locking vs MVCC
-- ===========================================
-- Locking approach
-- Session A
START TRANSACTION;
SELECT * FROM StudentEnrollments WHERE student_id = 1 FOR UPDATE;
-- Locks row

-- Session B (this will block until Session A commits)
START TRANSACTION;
SELECT * FROM StudentEnrollments WHERE student_id = 1;
COMMIT;

-- MVCC approach
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
SELECT * FROM StudentEnrollments WHERE student_id = 1;
-- Sees snapshot

-- Session B
START TRANSACTION;
UPDATE StudentEnrollments SET enrollment_date = '2024-07-15' WHERE student_id = 1;
COMMIT;

-- Session A (still in same transaction → snapshot)
SELECT * FROM StudentEnrollments WHERE student_id = 1;
COMMIT;

-- Session A (new transaction → sees updated value)
SELECT * FROM StudentEnrollments WHERE student_id = 1;
