-- a. Afficher l’ensemble des tables en SQL
show tables;
-- b. Afficher les colonnes de la table "project"
Describe project;
-- c. Le nombre d'étudiants dans la base de données
select count(student_name) from (Select * from project group by(student_name)) as new;
-- d. Les différents cours dans la base de données
Select registered_course from project group by(registered_course);
-- e. Les différentes maisons dans la base de données
Select house from project group by(house);
-- f. Les différents préfets dans la base de données
Select prefet from project group by(prefet);
-- g. Quel est le préfet pour chaque maison ?
Select house, prefet from project group by(prefet);
-- h. Pour compter le nombre d'étudiants par année
select year, count(student_name) from (Select year, student_name from project group by(student_name)) as new group by year;
-- i. Pour afficher les noms et les emails des étudiants qui suivent le cours "potion"
select student_name, email from project where registered_course = "potion" group by (student_name);
-- j. Pour trouver le nombre d'étudiants de chaque maison qui suivent le cours "potion"
select count(student_name), house from (Select student_name, house, registered_course from project where registered_course = "potion" group by(student_name)) as new group by house ;
-- k. Afficher les maisons des étudiants et le nombre d'étudiants dans chaque maison
select count(student_name), house from (Select student_name, house from project group by(student_name)) as new group by house ;
-- l. Afficher les maisons des étudiants et le nombre d'étudiants dans chaque maison, triés
select count(student_name) as nb_students, house from (Select student_name, house from project group by(student_name)) as new group by house order by nb_students DESC ;
-- m. Afficher le nombre d'étudiants inscrits à chaque cours, triés par ordre décroissant
select registered_course, count(student_name) as nb from (select registered_course, student_name from project group by student_name, registered_course) as new group by registered_course order by nb desc;
-- n. Afficher les préfets de chaque maison, triés par ordre alphabétique des maisons
select house, prefet from project group by house order by prefet;
