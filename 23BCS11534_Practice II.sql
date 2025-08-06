-- Part A: Create Tables
CREATE TABLE Departments (
    dept_id   INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Courses (
    course_id   INT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    dept_id     INT NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);
-- Part B: Insert Data
INSERT INTO Departments (dept_id, dept_name) VALUES
  (1, 'Computer Science'),
  (2, 'Electrical'),
  (3, 'Mechanical'),
  (4, 'Civil'),
  (5, 'Electronics');

INSERT INTO Courses (course_id, course_name, dept_id) VALUES
  (101, 'DBMS', 1),
  (102, 'Operating Systems', 1),
  (103, 'Power Systems', 2),
  (104, 'Digital Circuits', 2),
  (105, 'Thermodynamics', 3),
  (106, 'Fluid Mechanics', 3),
  (107, 'Structural Engineering', 4),
  (108, 'Surveying', 4),
  (109, 'Embedded Systems', 5),
  (110, 'VLSI Design', 5);

-- Part C: Query for Departments with More Than Two Courses
SELECT dept_name
FROM Departments
WHERE dept_id IN (
    SELECT dept_id
    FROM Courses
    GROUP BY dept_id
    HAVING COUNT(*) > 2
);

--Grant SELECT Access to viewer_user
GRANT SELECT ON Courses TO viewer_user;

-- Optional: Create the user (if not exists)
CREATE USER viewer_user IDENTIFIED BY '23BCS11534';  -- MySQL
-- or
CREATE USER viewer_user WITH PASSWORD '23BCS11534';  -- PostgreSQL
