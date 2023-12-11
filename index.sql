
USE hogwarts;

-- création étudiant

INSERT INTO registration (id_student, id_course) VALUES (1, 1);

INSERT INTO student(email, id_house, name, year) VALUES
    ('hermione.granger@hogwarts.com', 3, 'Hermione Granger', 4);

INSERT INTO registration(id_student, id_course) VALUES (2, 2);

INSERT INTO student(email, id_house, name, year) VALUES
    ('ron.weasley@hogwarts.com', 1, 'Ron Weasley', 4);

INSERT INTO registration(id_student, id_course) VALUES (3, 3);

INSERT INTO student(email, id_house, name, year) VALUES
    ('luna.lovegood@hogwarts.com', 4, 'Luna Lovegood', 4);

INSERT INTO registration(id_student, id_course) VALUES (4, 1);

INSERT INTO student(email, id_house, name, year) VALUES
    ('draco.malfoy@hogwarts.com', 2, 'Draco Malfoy', 4);

INSERT INTO registration(id_student, id_course) VALUES (5, 2);

INSERT INTO student(email, id_house, name, year) VALUES
    ('ginny.weasley@hogwarts.com', 1, 'Ginny Weasley', 4);

INSERT INTO registration(id_student, id_course) VALUES (6, 3);

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
SHOW PROFILE FOR QUERY 9;


-- ajouter un index sur la colonne "house_id" de la table "students" ;
CREATE INDEX idx_house_id ON student(id_house);

-- mesurer à nouveau le temps de la requête après l'ajout de l'index ;
SET profiling = 1;
SELECT COUNT(*) AS nb_student_gryffindor
FROM student
WHERE id_house = (SELECT id FROM house WHERE name = 'gryffindor');
SHOW PROFILES;
SHOW PROFILE FOR QUERY 13;

-- mesurer à nouveau le temps de la requête mais sans index
SET profiling = 1;
SELECT COUNT(*) AS nb_student_gryffindor
FROM student IGNORE INDEX (idx_house_id)
WHERE id_house = (SELECT id FROM house WHERE name = 'gryffindor');
SHOW PROFILES;
SHOW PROFILE FOR QUERY 16;

-- 3)
-- Requête a

SELECT house.name AS house_name, course.name AS course_name, COUNT(*) AS num_student
FROM student
JOIN house ON student.id_house = house.id
JOIN registration ON student.id = registration.id_student
JOIN course ON registration.id_course = course.id
GROUP BY house.name, course.name
ORDER BY num_student DESC;

-- mesurer le temps de la requête
SET profiling = 1;
SELECT house.name AS house_name, course.name AS course_name, COUNT(*) AS num_student
FROM student
JOIN house ON student.id_house = house.id
JOIN registration ON student.id = registration.id_student
JOIN course ON registration.id_course = course.id
GROUP BY house.name, course.name
ORDER BY num_student DESC;
SHOW PROFILES;
SHOW PROFILE FOR QUERY 19;

-- rajouter un index, mesurer encore une fois le temps de la requête.
CREATE INDEX idx_course_id ON course(id);
SET profiling = 1;
SELECT house.name AS house_name, course.name AS course_name, COUNT(*) AS num_student
FROM student
JOIN house ON student.id_house = house.id
JOIN registration ON student.id = registration.id_student
JOIN course ON registration.id_course = course.id
GROUP BY house.name, course.name
ORDER BY num_student DESC;
SHOW PROFILES;
SHOW PROFILE FOR QUERY 23;

-- Requête b
SELECT name, email
FROM student
WHERE id NOT IN (SELECT id_student FROM registration);
 -- 0 PARCE QUE FORCEMENT ETUDIANT EST DANS REGISTRATION DONC DANS UN COURS
-- mesurer le temps de la requête
SET profiling = 1;
SELECT name, email
FROM student
WHERE id NOT IN (SELECT id_student FROM registration);
SHOW PROFILES;
SHOW PROFILE FOR QUERY 27;

-- rajouter un index, mesurer encore une fois le temps de la requête
CREATE INDEX idx_registration_student ON registration(id_student);
SET profiling = 1;
SELECT name, email
FROM student
WHERE id NOT IN (SELECT id_student FROM registration);
SET profiling = 0;
SHOW PROFILES;
SHOW PROFILE FOR QUERY 62;

-- requete c 
SELECT house.name, COUNT(*) AS num_student
FROM student
JOIN house ON student.id_house = house.id
WHERE EXISTS (
    SELECT *
    FROM registration
    JOIN course ON registration.id_course = course.id
    WHERE student.id = registration.id_student
        AND course.name IN ('Potion', 'Sortilege', 'Botanique')
)
GROUP BY house.name;

-- mesurer le temps de la requête
SET profiling = 1;
SELECT house.name, COUNT(*) AS num_student
FROM student
JOIN house ON student.id_house = house.id
WHERE EXISTS (
    SELECT *
    FROM registration
    JOIN course ON registration.id_course = course.id
    WHERE student.id = registration.id_student
        AND course.name IN ('Potion', 'Sortilege', 'Botanique')
)
GROUP BY house.name;
SHOW PROFILES;
SHOW PROFILE FOR QUERY 71;

-- rajouter un index, mesurer encore une fois le temps de la requête
CREATE INDEX idx_house_id ON house(id);
SET profiling = 1;
SELECT house.name, COUNT(*) AS num_student
FROM student
JOIN house ON student.id_house = house.id
WHERE EXISTS (
    SELECT *
    FROM registration
    JOIN course ON registration.id_course = course.id
    WHERE student.id = registration.id_student
        AND course.name IN ('Potion', 'Sortilege', 'Botanique')
)
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