create table Department(
name varchar(60),
abbr varchar(10),
primary key (name)
);

create table Program(
name varchar(60),
abbr varchar(10),
primary key (name)
);

create table dept_host_program(
dept varchar(60),
program varchar(60),
foreign key (dept) references department(name),
foreign key (program) references program(name),
primary key (dept, program)
);

create table branch(
program varchar(60),
name varchar(60),
foreign key (program) references program(name),
primary key (program,name)
);

create table course(
code char(6),
name varchar(60),
credit int,
dept varchar(60),
foreign key (dept) references department(name),
primary key (code)
);

create table classification(
type varchar(20),
constraint validclassification check (type in ('mathematical','research','seminar')),
primary key (type)
);

create table classified(
code char(6),
type varchar(20),
foreign key (code) references course(code),
foreign key (type) references classification(type),
primary key (code,type)
);

create table prerequisite(
course char(6),
precourse char(6),
foreign key (course) references course(code),
foreign key (precourse) references course(code),
primary key (course,precourse)
);

create table restricted_course(
code char(6),
restriction int,
foreign key (code) references course(code),
primary key (code),
constraint valid_restrction check (restriction>0)
);

create table program_assign_man_course(
name varchar(60),
code char(6),
foreign key (name) references program(name),
foreign key (code) references course(code),
primary key (name,code)
);

create table branch_assign_man_course(
program varchar(60),
branch varchar(60),
code char(6),
foreign key (program,branch) references branch(program,name),
foreign key (code) references course(code),
primary key (program,branch,code)
);

create table branch_assign_rec_course(
program varchar(60),
branch varchar(60),
code char(6),
foreign key (program,branch) references branch(program,name),
foreign key (code) references course(code),
primary key (program,branch,code)
);

create table student(
id char(6),
name varchar(60),
program varchar(60),
branch varchar(60),
foreign key (program,branch) references branch(program,name),
primary key (id)
);

create table enrollment(
id char(6),
code char(6),
grade char(1),
foreign key (id) references student(id),
foreign key (code) references course(code),
primary key (id,code),
constraint valid_grade check (grade in ('U','3','4','5'))
);

create table register_course(
id char(6),
code char(6),
foreign key (id) references student(id),
foreign key (code) references course(code),
primary key (id,code)
);

create table waitinglist(
id char(6),
code char(6),
position int,
foreign key (id) references student(id),
foreign key (code) references restricted_course(code),
primary key (id,code),
constraint valid_position check (position>0)
);



