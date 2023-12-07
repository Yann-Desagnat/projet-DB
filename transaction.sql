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

