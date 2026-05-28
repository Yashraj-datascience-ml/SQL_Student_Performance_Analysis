-- =========================================
-- STUDENT PERFORMANCE & ATTENDANCE TRACKER
-- =========================================

-- 1. CREATE DATABASE
CREATE DATABASE IF NOT EXISTS student_tracker;
USE student_tracker;

-- =========================================
-- 2. TABLE CREATION
-- =========================================

-- Departments
CREATE TABLE Departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL UNIQUE
);

-- Students
CREATE TABLE Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    dob DATE,
    gender VARCHAR(10),
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(15) UNIQUE,
    address TEXT,
    admission_date DATE,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

-- Faculty
CREATE TABLE Faculty (
    faculty_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(15) UNIQUE,
    department_id INT,
    experience_years INT DEFAULT 0,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

-- Courses
CREATE TABLE Courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL,
    faculty_id INT,
    FOREIGN KEY (faculty_id) REFERENCES Faculty(faculty_id)
);

-- Enrollments
CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    UNIQUE(student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- Attendance
CREATE TABLE Attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    attendance_date DATE,
    status ENUM('Present', 'Absent', 'Late'),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- Grades
CREATE TABLE Grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    marks_obtained INT,
    grade VARCHAR(2),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- =========================================
-- 3. SAMPLE DATA INSERTION
-- =========================================

INSERT INTO Departments (department_name) VALUES
('Computer Science'),
('Mechanical'),
('Electrical');

INSERT INTO Students (name, dob, gender, email, phone_number, address, admission_date, department_id) VALUES
('Yashraj Sharma', '2003-05-10', 'Male', 'yash@gmail.com', '9876543210', 'Ahmedabad', '2022-06-01', 1),
('Anuradha Prajapati', '2002-08-15', 'Female', 'anu@gmail.com', '9876543211', 'Surat', '2022-06-01', 1),
('Amit Singh', '2003-01-20', 'Male', 'amit@gmail.com', '9876543212', 'Baroda', '2022-06-01', 2);

INSERT INTO Faculty (name, email, phone_number, department_id, experience_years) VALUES
('Dr. Mehta', 'mehta@gmail.com', '9999999991', 1, 10),
('Prof. Shah', 'shah@gmail.com', '9999999992', 2, 7);

INSERT INTO Courses (course_name, faculty_id) VALUES
('Database Management', 1),
('Operating Systems', 1),
('Thermodynamics', 2);

INSERT INTO Enrollments (student_id, course_id, enrollment_date) VALUES
(1, 1, '2023-01-01'),
(1, 2, '2023-01-01'),
(2, 1, '2023-01-01'),
(3, 3, '2023-01-01');

INSERT INTO Attendance (student_id, course_id, attendance_date, status) VALUES
(1, 1, '2023-09-01', 'Present'),
(1, 1, '2023-09-02', 'Absent'),
(2, 1, '2023-09-01', 'Present'),
(3, 3, '2023-09-01', 'Late');

INSERT INTO Grades (student_id, course_id, marks_obtained, grade) VALUES
(1, 1, 85, 'B'),
(1, 2, 92, 'A'),
(2, 1, 70, 'C'),
(3, 3, 60, 'C');

-- =========================================
-- 4. IMPORTANT QUERIES
-- =========================================

-- Students in Computer Science
SELECT s.name
FROM Students s
JOIN Departments d ON s.department_id = d.department_id
WHERE d.department_name = 'Computer Science';

-- Top 10 Students
SELECT student_id, AVG(marks_obtained) AS avg_marks
FROM Grades
GROUP BY student_id
ORDER BY avg_marks DESC
LIMIT 10;

-- Attendance below 75%
SELECT student_id,
       (SUM(status = 'Present') / COUNT(*)) * 100 AS attendance_percentage
FROM Attendance
GROUP BY student_id
HAVING attendance_percentage < 75;

-- Students NOT enrolled in any course
SELECT s.name
FROM Students s
LEFT JOIN Enrollments e ON s.student_id = e.student_id
WHERE e.student_id IS NULL;

-- Average marks per course
SELECT course_id, AVG(marks_obtained) AS avg_marks
FROM Grades
GROUP BY course_id;

-- Rank students (Window Function)
SELECT student_id,
       SUM(marks_obtained) AS total_marks,
       RANK() OVER (ORDER BY SUM(marks_obtained) DESC) AS rank
FROM Grades
GROUP BY student_id;

-- Students above average marks
SELECT *
FROM Grades
WHERE marks_obtained > (SELECT AVG(marks_obtained) FROM Grades);
