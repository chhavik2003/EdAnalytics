/*Project Title: Student Result Management System (SRMS)
Build a database to manage students’ academic records. 
This system will allow you to store, retrieve, and analyze student performance 
data using SQL queries.*/

SET SQL_SAFE_UPDATES = 0;
Create database if not exists SRMS ;
use SRMS ;
Create table students (
stud_id int Primary key , name varchar(50),gender varchar (10),
dob DATE , department VARCHAR(50) );
INSERT INTO students VALUES
(1,'Norma Fisher','F','2001-09-05','ME'),
(2,'Katelyn Hull','M','2006-07-15','EE'),
(3,'John Silva','F','2007-03-15','ME'),
(4,'Charles Taylor','F','2000-04-13','ME'),
(5,'Danielle Browning','F','2005-06-22','Civil'),
(6,'Stephanie Collins','M','2005-09-07','Civil'),
(7,'Samuel Rivera','M','2004-03-28','EE'),
(8,'Jeffrey Carr','M','2007-03-30','CSE'),
(9,'Juan Ramos','F','2003-11-29','Civil'),
(10,'Robert Dunn','M','1999-06-08','EE'),
(11,'Ryan Page','M','2006-02-26','DS'),
(12,'April Snyder','M','2006-11-09','DS'),
(13,'Nicholas Padilla','F','2000-01-05','ME'),
(14,'Keith Allen','M','2000-08-09','EE'),
(15,'Jo Miller','F','2002-03-14','EE'),
(16,'Yolanda Burns','M','2002-01-15','Civil'),
(17,'Michelle Kelley','F','2006-05-28','ME'),
(18,'Christina Lloyd','F','2004-02-18','CSE'),
(19,'Jill Carlson','M','2002-03-01','CSE'),
(20,'David White','F','2006-06-19','DS');

Create table course (
course_id int Primary key , course_name varchar(50),credit_hours INT );
INSERT INTO course (course_id, course_name, credit_hours) VALUES
(101, 'DBMS', 4),
(102, 'Operating Systems', 3),
(103, 'Data Structures', 3),
(104, 'Software Engineering', 3),
(105, 'Web Development', 4),
(106, 'Computer Networks', 3),
(107, 'AI Basics', 3),
(108, 'Web Development', 4),
(109, 'AI Basics', 4),
(110, 'Machine Learning', 4);

Create table results (
result_id int Primary key , marks_obtained INT ,
stud_id INT, course_id INT ,
foreign key(stud_id) REFERENCES students(stud_id) ON DELETE CASCADE,
foreign key(course_id)REFERENCES course(course_id) ON DELETE CASCADE
 );
 INSERT INTO results (result_id, marks_obtained, stud_id, course_id) VALUES
(10001, 89, 1, 101),(10002, 76, 2, 102),(10003, 54, 3, 103),(10004, 85, 4, 104),
(10005, 35, 5, 105),(10006, 98, 6, 106),(10007, 30, 7, 107),(10008, 78, 8, 108),
(10009, 69, 9, 109),(10010, 94, 10, 110),(10011, 39, 11, 110),(10012, 40, 12, 109),
(10013, 56, 13, 105),(10014, 74, 14, 104),(10015, 83, 15, 101),(10016, 22, 16, 108),
(10017, 87, 17, 103),(10018, 94, 18, 104),(10019, 43, 19, 105),(10020, 49, 20, 107);

-- BASIC QUERIES
-- 1.List all students 
SELECT * FROM students; 
-- 2.List all course 
SELECT * FROM course; 
-- 3.List all results 
SELECT * FROM results; 
-- 4. Find students in the 'Computer Science' department
SELECT * FROM students WHERE department = 'CSE';

-- JOIN QUERIES 
-- 5. List students with their course names and marks
SELECT s.name , c.course_name , r.marks_obtained FROM students s  
JOIN results r ON s.stud_id = r.stud_id 
JOIN course c ON c.course_id = r.course_id ; 
-- 6. Show students with course credits and their marks
SELECT s.name , c.course_name , r.marks_obtained, c.credit_hours FROM students s  
JOIN results r ON s.stud_id = r.stud_id 
JOIN course c ON c.course_id = r.course_id ; 
-- 7. Get marks of a student named 'Jo Miller' 
SELECT c.course_name, r.marks_obtained FROM students s
JOIN results r ON s.stud_id = r.stud_id 
JOIN course c ON c.course_id = r.course_id WHERE s.name = 'Jo Miller';
-- 8. Find all students who scored more than 80 in any course:
SELECT s.name, r.marks_obtained FROM students s
JOIN results r ON s.stud_id  = r.stud_id
WHERE r.marks_obtained > 80;

-- AGGREGATE FUNCTIONS 
-- 9. Find average marks of each student
SELECT s.name , AVG(r.marks_obtained) as avg_marks FROM students s 
JOIN results r ON s.stud_id = r.stud_id  
JOIN course c ON c.course_id = r.course_id 
GROUP BY s.name; 
-- 10. Show average marks per department:
SELECT AVG(r.marks_obtained) AS Avg_marks , s.department FROM students s 
JOIN results r ON s.stud_id = r.stud_id GROUP BY s.department;
-- 11. Find total number of students per department
SELECT department, COUNT(*) as total_student FROM students GROUP BY department ;
-- 12. Find highest marks obtained in each course
SELECT c.course_name , MAX(r.marks_obtained) AS highest_marks FROM course c 
JOIN results r ON c.course_id = r.course_id GROUP BY c.course_name;

-- CONDITIONAL QUERIES 
-- 13. Find students who scored less than 40 (fail)
SELECT s.name , c.course_name ,r.marks_obtained  FROM students s 
JOIN results r ON s.stud_id = r.stud_id 
JOIN course c ON c.course_id = r.course_id 
WHERE r.marks_obtained < 40 ;
-- 14. Find students who scored above 90 in any course
SELECT DISTINCT s.name,r.marks_obtained  FROM students s JOIN results r 
ON  s.stud_id = r.stud_id  WHERE r.marks_obtained > 90;
-- 15. List students who have not taken any course
SELECT s.name  FROM students s 
LEFT JOIN results r ON s.stud_id = r.stud_id WHERE r.result_id IS NULL;

-- ORDER BY and LIMIT
-- 16. Top 5 students by average marks 
SELECT s.name, AVG(r.marks_obtained) as avg_marks FROM  students s 
JOIN results r ON s.stud_id = r.stud_id GROUP BY s.name 
ORDER BY avg_marks DESC LIMIT 5;
-- 17. List all courses ordered by average marks
SELECT c.course_name ,AVG(r.marks_obtained) as avg_marks FROM course c
JOIN results r ON c.course_id = r.course_id GROUP BY c.course_name 
ORDER BY avg_marks DESC;

-- SUBQUERIES
-- 18. Find the student(s) who scored the highest in 'DBMS'
SELECT s.name, r.marks_obtained FROM students s 
JOIN results r ON s.stud_id = r.stud_id 
JOIN course c ON c.course_id = r.course_id 
 WHERE c.course_name = 'DBMS' 
 AND r.marks_obtained = (
 SELECT MAX(r2.marks_obtained) FROM results r2 
 JOIN course c2 ON r2.course_id = c2.course_id 
 WHERE c2.course_name = 'DBMS');
-- 19. List students whose average marks are above class average
SELECT s.name, AVG(r.marks_obtained) AS avg_marks FROM students s 
JOIN results r ON s.stud_id = r.stud_id
GROUP BY s.name HAVING avg_marks > 
(SELECT AVG(marks_obtained) FROM results );

-- Date-based Queries -dob is present
-- 20. List students born after 2002
SELECT name,dob FROM students WHERE dob> '2002-01-01'; 
-- 21. Find the youngest student
SELECT * FROM students ORDER BY dob DESC LIMIT 1; 

-- String Queries
-- 22. Find students whose names start with 'A'
SELECT * FROM students WHERE name LIKE 'A%';
-- 23. Find students with 6-letter names
SELECT * FROM students WHERE LENGTH(name) = 6;

-- Views and Indexes (Optional)
-- 24. Create a view for student marks summary
CREATE VIEW student_marks_summary AS SELECT s.name ,c.course_name,r.marks_obtained 
FROM students s JOIN results r ON s.stud_id = r.stud_id 
JOIN course c ON c.course_id = r.course_id  ;
-- 25. Use the view
SELECT * FROM student_marks_summary  WHERE marks_obtained > 80;



