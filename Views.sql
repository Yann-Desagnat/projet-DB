use hogwarts;
-- a. Créer une vue logique qui affiche le nom, l'email et la maison de chaque étudiant qui suit un cours de potions.
create view view_student as select s.name as student_name, s.email, h.name as house_name from student s join house h on s.id_house = h.id join registration reg on s.id = reg.id_student join course c on reg.id_course = c.id where c.name = "potion" ;

-- b. Afficher le résultat de la vue.
select * from view_student;

-- c. Rajouter 2 étudiants qui suivent un cours de potion.
insert into student(name, email, year, id_house)
values
	("Ron Weasley", "ron.weasley@hogwarts.com", 4, 1),
    ("Hermione Granger", "hermione.grangeràhogwarts.com", 3, 1);
    
insert into registration(id_student, id_course)
values 
	(1, 1),
	(2, 1);

-- d. Afficher (encore) le résultat de la vue.
select * from view_student;

-- Créer une vue house_student_count qui regroupe les étudiants par maison et compte le nombre d'étudiants dans chaque maison.
create view house_student_count as select h.name as house_name, count(*) as student_count from student s join house h on s.id_house = h.id group by house_name;

-- Essayer de modifier la colonne contenant le nombre d'étudiants dans une maison.
ALTER TABLE view_count CHANGE COLUMN student_count count_student int;
