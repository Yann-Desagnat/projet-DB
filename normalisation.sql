create database hogwarts;
use hogwarts;

create table if not exists house(
id int primary key auto_increment not null,
name enum("gryffindor", "slytherin", "ravenclaw", "hufflepuff")
);

create table if not exists student(
	id int primary key auto_increment not null,
    name varchar(100) not null,
    email varchar(150),
    year tinyint not null,
    id_house int not null,
    foreign key (id_house) references house(id)
);


create table if not exists prefet (
	id int primary key auto_increment not null,
    id_student int not null,
    id_house int not null,
    foreign key (id_house) references house(id),
    foreign key (id_student) references student(id)
);

create table if not exists course (
	id int primary key auto_increment not null,
    name varchar(100) not null
);

create table if not exists registration (
	id int primary key auto_increment not null,
    id_student int not null,
    id_course int not null,
    foreign key (id_course) references course(id),
    foreign key (id_student) references student(id)
    );

insert into 
	house (name) 
values
	("gryffindor"),
	("slytherin"),
	("ravenclaw"),
	("hufflepuff");
