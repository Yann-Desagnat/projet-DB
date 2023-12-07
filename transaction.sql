-- Début de la transaction

START TRANSACTION;

-- Ajout d'un étudiant
INSERT into student(email, id_house, name, year)
VALUES ('harry.potter@hogwarts.com', 1, 'harry potter', '2025');

COMMIT;
