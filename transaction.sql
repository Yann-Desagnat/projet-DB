-- 3) Ajout d'un étudiant et rollback
USE hogwarts;

-- Début de la transaction
START TRANSACTION;

-- Ajout d'un étudiant
INSERT into student(email, id_house, name, year)
VALUES ('harry.potter@hogwarts.com', 1, 'harry potter', 4);

-- Afficher l'étudiant ajouté précédemment
SELECT * FROM student WHERE name= 'harry potter';

-- Annulation de l'ajout d'étudiant
ROLLBACK;

-- Verification du rollback
SELECT * FROM student WHERE name= 'harry potter';


-- 4) Modification mutliple et commit
Use hogwarts;

-- Début de la transaction
START TRANSACTION;

-- Changement des données d'un étudiant
UPDATE student
SET id_house = 2 WHERE name = 'harry potter';
UPDATE registration
SET id_course = 3 WHERE id_student = 9;

-- Affichage des données changées
SELECT * from student WHERE name = 'harry potter';
SELECT * FROM registration WHERE id_student = 9;

-- Validation des changements de la transaction
COMMIT;

-- On regarde si les nouvelles données ont bien été enragistrées 
SELECT * from student WHERE name = 'harry potter';
SELECT * FROM registration WHERE id_student = 9; 


-- 5) Transaction avec erreur et rollback

USE hogwarts;

-- Début de la transaction
START TRANSACTION;

-- Essais de modifications pour arriver à un echec
INSERT INTO student(email, id_house, name, year)
VALUES ('seamus.finnigan@hogwarts.com', 1, 'seamus finnegan', 4),('harry.potter@hogwarts.com', 3, 'harry bonheur', 3);

-- Annulation de toutes les opérations faites précédemment
COMMIT;
