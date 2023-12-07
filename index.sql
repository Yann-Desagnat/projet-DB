USE hogwarts;

-- 2) compter le nombre d'étudiants qui sont dans la maison "Gryffindor"
SELECT COUNT(*) AS nb_student_gryffindor
FROM student
WHERE id_house = (SELECT id FROM house WHERE name = 'gryffindor');

-- - mesurer le temps de la requête avec la commande SHOW PROFILE
SET profiling = 1;
SELECT COUNT(*) AS nb_student_gryffindor
FROM student
WHERE id_house = (SELECT id FROM house WHERE name = 'gryffindor');
SHOW PROFILES;
SHOW PROFILE FOR QUERY 2;


-- ajouter un index sur la colonne "house_id" de la table "students" ;
CREATE INDEX idx_house_id ON student(id_house);

-- mesurer à nouveau le temps de la requête après l'ajout de l'index ;
SET profiling = 1;
SELECT COUNT(*) AS nb_student_gryffindor
FROM student
WHERE id_house = (SELECT id FROM house WHERE name = 'gryffindor');
SHOW PROFILES;
SHOW PROFILE FOR QUERY 10;

-- mesurer à nouveau le temps de la requête mais sans index
SET profiling = 1;
SELECT COUNT(*) AS nb_student_gryffindor
FROM student IGNORE INDEX (idx_house_id)
WHERE id_house = (SELECT id FROM house WHERE name = 'gryffindor');
SHOW PROFILES;
SHOW PROFILE FOR QUERY 13;

-- 3)
-- Requête a
-- ajouter une foreign key dans student ? 
ALTER TABLE student
ADD COLUMN course_id INT,
ADD FOREIGN KEY (course_id) REFERENCES course(id);

SELECT house.name, course.name, COUNT(*) AS
num_student
FROM student
JOIN house ON student.id_house = house.id
JOIN course ON student.course_id = course.id
GROUP BY house.name, course.name
ORDER BY num_student DESC;

-- mesurer le temps de la requête
SET profiling = 1;
SELECT house.name, course.name, COUNT(*) AS
num_student
FROM student 
JOIN house ON student.id_house = house.id
JOIN course ON student.course_id = course.id
GROUP BY house.name, course.name
ORDER BY num_student DESC;
SHOW PROFILES;
SHOW PROFILE FOR QUERY 48;

-- rajouter un index, mesurer encore une fois le temps de la requête.
CREATE INDEX idx_course_id ON course(id);
SET profiling = 1;
-- La requête a
SHOW PROFILES;
SHOW PROFILE FOR QUERY 55;

-- Requête b
SELECT name, email
FROM student
WHERE course_id IS NULL;

-- mesurer le temps de la requête
SET profiling = 1;
SELECT name, email
FROM student
WHERE course_id IS NULL;
SHOW PROFILES;
SHOW PROFILE FOR QUERY 60;

-- rajouter un index, mesurer encore une fois le temps de la requête
CREATE INDEX idx_student_course ON student(course_id);
SET profiling = 1;
SELECT name, email
FROM student
WHERE course_id IS NULL;
SHOW PROFILES;
SHOW PROFILE FOR QUERY 62;

-- requete c 
SELECT house.name, COUNT(*) AS num_student FROM student
JOIN house on student.id_house = house.id WHERE exists ( select * from course WHERE name IN ('Potions', 'Sortilèges', 'Botanique') AND id = student.course_id)
GROUP BY house.name;

-- mesurer le temps de la requête
SET profiling = 1;
SELECT house.name, COUNT(*) AS num_student FROM student
JOIN house on student.id_house = house.id WHERE exists ( select * from course WHERE name IN ('Potions', 'Sortilèges', 'Botanique') AND id = student.course_id)
GROUP BY house.name;
SHOW PROFILES;
SHOW PROFILE FOR QUERY 71;

-- rajouter un index, mesurer encore une fois le temps de la requête
CREATE INDEX idx_house_id ON house(id);
SET profiling = 1;
SELECT house.name, COUNT(*) AS num_student FROM student
JOIN house on student.id_house = house.id WHERE exists ( select * from course WHERE name IN ('Potions', 'Sortilèges', 'Botanique') AND id = student.course_id)
GROUP BY house.name;
SHOW PROFILES;
SHOW PROFILE FOR QUERY 75;


-- requete d
SELECT s.name, s.email
FROM student s
JOIN ( SELECT id, year, COUNT(DISTINCT course_id) AS num_course FROM student
GROUP BY id, year
) AS sub ON s.id = sub.id AND s.year= sub.year JOIN (
SELECT year, COUNT(DISTINCT course_id) AS num_course FROM student GROUP BY year
) AS total
ON s.year= total.year AND sub.num_course = total.num_course WHERE sub.num_course = total.num_course;

-- mesurer le temps de la requête
SET profiling = 1;
SELECT s.name, s.email
FROM student s
JOIN ( SELECT id, year, COUNT(DISTINCT course_id) AS num_course FROM student
GROUP BY id, year
) AS sub ON s.id = sub.id AND s.year= sub.year JOIN (
SELECT year, COUNT(DISTINCT course_id) AS num_course FROM student GROUP BY year
) AS total
ON s.year= total.year AND sub.num_course = total.num_course WHERE sub.num_course = total.num_course;
SHOW PROFILES;
SHOW PROFILE FOR QUERY 80;

-- rajouter un index, mesurer encore une fois le temps de la requête
CREATE INDEX idx_student_year_id ON student(id, year);
SET profiling = 1;
SELECT s.name, s.email
FROM student s
JOIN ( SELECT id, year, COUNT(DISTINCT course_id) AS num_course FROM student
GROUP BY id, year
) AS sub ON s.id = sub.id AND s.year= sub.year JOIN (
SELECT year, COUNT(DISTINCT course_id) AS num_course FROM student GROUP BY year
) AS total
ON s.year= total.year AND sub.num_course = total.num_course WHERE sub.num_course = total.num_course;
SHOW PROFILES;
SHOW PROFILE FOR QUERY 84;