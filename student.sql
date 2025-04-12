
-- departments table
CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- courses table

CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dept_id INT REFERENCES departments(dept_id)
);

-- students table
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    age INT,
    dept_id INT REFERENCES departments(dept_id)
);

-- enrollments table

CREATE TABLE enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES students(student_id),
    course_id INT REFERENCES courses(course_id),
    enrollment_date DATE DEFAULT CURRENT_DATE
);

-- lecturers table
CREATE TABLE lecturers (
    lecturer_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE
);

-- course lectures table
CREATE TABLE course_lecturers (
    id SERIAL PRIMARY KEY,
    course_id INT REFERENCES courses(course_id),
    lecturer_id INT REFERENCES lecturers(lecturer_id)
);


INSERT INTO departments (name) VALUES
('Computer Science'),
('Electrical Engineering'),
('Mechanical Engineering'),
('Business Administration');

INSERT INTO courses (name, dept_id) VALUES
('Database Systems', 1),
('Operating Systems', 1),
('Digital Circuits', 2),
('Thermodynamics', 3),
('Marketing Principles', 4);

INSERT INTO students (full_name, email, age, dept_id) VALUES
('Alice Kimani', 'alice@example.com', 21, 1),
('Brian Otieno', 'brian@example.com', 22, 2),
('Carol Njeri', 'carol@example.com', 20, 1),
('Daniel Mwangi', 'daniel@example.com', 23, 4);

INSERT INTO enrollments (student_id, course_id) VALUES
(1, 1),  -- Alice in Database Systems
(1, 2),  -- Alice in Operating Systems
(2, 3),  -- Brian in Digital Circuits
(3, 1),  -- Carol in Database Systems
(4, 5);  -- Daniel in Marketing Principles

-- testing

SELECT * FROM departments;
SELECT * FROM courses;
SELECT * FROM students;
SELECT * FROM enrollments;

-- show all corses done by Alice
SELECT c.name AS course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE s.full_name = 'Alice Kimani';

--  list all students and their departments
SELECT s.full_name, d.name AS department
FROM students s
JOIN departments d ON s.dept_id = d.dept_id;

-- show all students enrolled in a course "Database Systems"
SELECT s.full_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.name = 'Database Systems';

-- courses offered by computer science
SELECT c.name AS course_name
FROM courses c
JOIN departments d ON c.dept_id = d.dept_id
WHERE d.name = 'Computer Science';

--  list number of students in each department

SELECT d.name AS department, COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON s.dept_id = d.dept_id
GROUP BY d.name;

--  List number of students in each course
SELECT c.name AS course_name, COUNT(e.student_id) AS num_students
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.name;

-- Show students not enrolled in any course
SELECT s.full_name
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
WHERE e.enrollment_id IS NULL;

-- show full profile with courses they are taking

SELECT s.full_name, s.email, c.name AS course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
ORDER BY s.full_name;

