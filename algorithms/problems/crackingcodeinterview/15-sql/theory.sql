
DROP DATABASE IF EXISTS cracking;
CREATE DATABASE cracking;

use cracking;

DROP TABLE IF EXISTS students;
CREATE TABLE students
(
id INTEGER AUTO_INCREMENT,
name CHAR(255) NOT NULL,
PRIMARY KEY (id)
);

DROP TABLE IF EXISTS student_courses;
CREATE TABLE student_courses
(
course_id INTEGER NOT NULL,
student_id INTEGER NOT NULL
);

DROP TABLE IF EXISTS teachers;
CREATE TABLE teachers
(
id INTEGER AUTO_INCREMENT,
name CHAR(255) NOT NULL,
PRIMARY KEY (id)
);

DROP TABLE IF EXISTS courses;
CREATE TABLE courses
(
id INTEGER AUTO_INCREMENT,
name CHAR(255) NOT NULL,
teacher_id INTEGER NOT NULL,
PRIMARY KEY (id)
);

ALTER TABLE student_courses ADD FOREIGN KEY course_id_idxfk (course_id) REFERENCES courses (id);

ALTER TABLE student_courses ADD FOREIGN KEY student_id_idxfk (student_id) REFERENCES students (id);

ALTER TABLE courses ADD FOREIGN KEY teacher_id_idxfk (teacher_id) REFERENCES teachers (id);

INSERT INTO students(name) VALUES
              ("Petr"),
              ("Michael"),
              ("Erik");

INSERT INTO teachers(name) VALUES
              ("Mr Boom"),
              ("Mrs Frau"),
              ("Jr Lenon");

INSERT INTO courses(name, teacher_id) VALUES
              ("Algorithms I", 1),
              ("Algorithms II", 1),
              ("Computer", 2),
              ("Math", 3),
              ("Theory", 3);

INSERT INTO student_courses(course_id, student_id) VALUES
              (1, 1),
              (1, 2),
              (1, 3),
              (2, 3),
              (4, 1),
              (3, 2);


-- "How many courses stundets have"
select s.id,s.name, count(sc.course_id) as courses
from students s
 left join student_courses sc on
  s.id = sc.student_id
group by s.id;

-- "How many studnets teacher have"
select t.id, t.name, count(sc.student_id) as students
from teachers t
 left join courses c on
  c.teacher_id = t.id
 left join student_courses sc on
  c.id = sc.course_id
group by t.id
order by students desc;
