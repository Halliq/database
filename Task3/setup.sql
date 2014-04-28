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
position INT,
foreign key (id) references student(id),
foreign key (code) references restricted_course(code),
primary key (id,code,position),
constraint valid_position check (position>0)
);
CREATE SEQUENCE pos_seq;
CREATE OR REPLACE TRIGGER position 
BEFORE INSERT ON waitinglist 
FOR EACH ROW
BEGIN
  SELECT pos_seq.NEXTVAL
  INTO   :new.position
  FROM   dual;
END;
/

INSERT INTO department (name, abbr) VALUES ('Computer Science','CS');   
INSERT INTO department(name, abbr) VALUES ('Computer Engineering','CE');
INSERT INTO department(name, abbr) VALUES ('Automation Engineering','AE');

INSERT INTO program(name, abbr) VALUES ('Computer Science and Engineering Programme','CSEP');
INSERT INTO program(name, abbr) VALUES ('Automation Technology','AT');

INSERT INTO dept_host_program(dept, program) VALUES ('Computer Science','Computer Science and Engineering Programme');
INSERT INTO dept_host_program(dept, program) VALUES ('Computer Engineering','Computer Science and Engineering Programme');
INSERT INTO dept_host_program(dept, program) VALUES ('Automation Engineering','Automation Technology');

INSERT INTO branch(program, name) VALUES ('Automation Technology','Interaction Design');
INSERT INTO branch(program, name) VALUES ('Computer Science and Engineering Programme','Interaction Design');
INSERT INTO branch(program, name) VALUES ('Computer Science and Engineering Programme','Software Engineering');
INSERT INTO branch(program, name) VALUES ('Computer Science and Engineering Programme','Algorithms');

INSERT INTO course(code, name,credit,dept) VALUES('MAT001','Advanced Math','15','Computer Science');
INSERT INTO course(code, name,credit,dept) VALUES('TDA357','Database','7','Computer Science');
INSERT INTO course(code, name,credit,dept) VALUES ('DAT265','Software Evolution Project','15','Computer Engineering');
INSERT INTO course(code, name,credit,dept) VALUES ('DAT230','Requirement Engineering','7','Computer Engineering');
INSERT INTO course(code, name,credit,dept) VALUES ('DAT397','Agile Development','7','Computer Engineering');
INSERT INTO course(code, name,credit,dept) VALUES ('ERE091','Automatic control','4','Automation Engineering');
INSERT INTO course(code, name,credit,dept) VALUES ('ERE350','System Design ','7','Automation Engineering');

INSERT INTO classification(type) VALUES ('mathematical');
INSERT INTO classification(type) VALUES ('seminar');
INSERT INTO classification(type) VALUES ('research');

INSERT INTO classified(code, type) VALUES ('MAT001','mathematical');
INSERT INTO classified(code, type) VALUES ('TDA357','seminar');
INSERT INTO classified(code, type) VALUES ('TDA357','mathematical');
INSERT INTO classified(code, type) VALUES ('DAT265','research');
INSERT INTO classified(code, type) VALUES ('DAT230','seminar');
INSERT INTO classified(code, type) VALUES ('DAT230','research');
INSERT INTO classified(code, type) VALUES ('ERE091','mathematical');

INSERT INTO prerequisite(course, precourse) VALUES ('DAT265','DAT230');
INSERT INTO prerequisite(course, precourse) VALUES ('DAT265','DAT397');
INSERT INTO prerequisite(course, precourse) VALUES ('DAT397','DAT230');

INSERT INTO restricted_course(code,restriction) VALUES ('TDA357','80');
INSERT INTO restricted_course(code,restriction) VALUES ('DAT397','60');
INSERT INTO restricted_course(code,restriction) VALUES ('DAT265','60');

INSERT INTO program_assign_man_course(name, code) VALUES ('Computer Science and Engineering Programme','MAT001');
INSERT INTO program_assign_man_course(name, code) VALUES ('Computer Science and Engineering Programme','DAT230');
INSERT INTO program_assign_man_course(name, code) VALUES ('Computer Science and Engineering Programme','TDA357');
INSERT INTO program_assign_man_course(name, code) VALUES ('Automation Technology','ERE091');


INSERT INTO branch_assign_man_course(program, branch, code) VALUES ('Automation Technology','Interaction Design','ERE091');

INSERT INTO branch_assign_rec_course(program, branch, code) VALUES ('Computer Science and Engineering Programme','Software Engineering','DAT265');

INSERT INTO student(id, name, program, branch) VALUES ('chr001','Chris Young','Computer Science and Engineering Programme','Interaction Design');
INSERT INTO student(id, name, program, branch) VALUES ('chr002','Johan Johansson','Computer Science and Engineering Programme','Interaction Design');
INSERT INTO student(id, name, program, branch) VALUES ('chr003','Maria Andersson','Computer Science and Engineering Programme','Software Engineering');
INSERT INTO student(id, name, program, branch) VALUES ('chr004','Sofia Olsson','Computer Science and Engineering Programme','Software Engineering');
INSERT INTO student(id, name, program, branch) VALUES ('ahr005','David Larsson','Automation Technology','Interaction Design');

INSERT INTO enrollment(id, code, grade) VALUES ('chr001', 'MAT001', '3');
INSERT INTO enrollment(id, code, grade) VALUES ('chr001', 'TDA357', 'U');
INSERT INTO enrollment(id, code, grade) VALUES ('chr002', 'MAT001', '4');
INSERT INTO enrollment(id, code, grade) VALUES ('chr002', 'DAT230', '5');
INSERT INTO enrollment(id, code, grade) VALUES ('chr003', 'MAT001', '5');
INSERT INTO enrollment(id, code, grade) VALUES ('chr003', 'TDA357', '4');
INSERT INTO enrollment(id, code, grade) VALUES ('chr003', 'DAT230', '4');
INSERT INTO enrollment(id, code, grade) VALUES ('chr003', 'DAT397', '4');
INSERT INTO enrollment(id, code, grade) VALUES ('chr003', 'DAT265', '3');
INSERT INTO enrollment(id, code, grade) VALUES ('chr004', 'MAT001', '5');
INSERT INTO enrollment(id, code, grade) VALUES ('chr004', 'DAT230', '5');
INSERT INTO enrollment(id, code, grade) VALUES ('chr004', 'DAT397', 'U');
INSERT INTO enrollment(id, code, grade) VALUES ('ahr005', 'ERE091', '3');

INSERT INTO register_course(id, code) VALUES ('chr001','DAT230');
INSERT INTO register_course(id, code) VALUES ('chr002','TDA357');
INSERT INTO register_course(id, code) VALUES ('chr004','DAT397');
INSERT INTO register_course(id, code) VALUES ('ahr005','ERE350');

INSERT INTO waitinglist(id,code) VALUES ('chr001','TDA357');
INSERT INTO waitinglist(id,code) VALUES ('chr004','TDA357');
INSERT INTO waitinglist(id,code) VALUES ('chr004','DAT265');

INSERT INTO student(id, name, program, branch) VALUES ('chr005','Antony Rodge','Computer Science and Engineering Programme','Software Engineering');
INSERT INTO student(id, name, program, branch) VALUES ('chr006','Shannon Rafe','Computer Science and Engineering Programme','Software Engineering');
INSERT INTO student(id, name, program, branch) VALUES ('chr007','Raimundo Smith','Computer Science and Engineering Programme','Software Engineering');
INSERT INTO student(id, name, program, branch) VALUES ('chr008','Marlin Benjy','Computer Science and Engineering Programme','Software Engineering');
INSERT INTO student(id, name, program, branch) VALUES ('chr009','Bridger Keith','Computer Science and Engineering Programme','Software Engineering');
INSERT INTO student(id, name, program, branch) VALUES ('chr010','Tylor Gregory','Computer Science and Engineering Programme','Software Engineering');
INSERT INTO student(id, name, program, branch) VALUES ('chr011','Gale Kameron','Computer Science and Engineering Programme','Software Engineering');
INSERT INTO student(id, name, program, branch) VALUES ('chr012','Tyson Osbourne','Computer Science and Engineering Programme','Software Engineering');
INSERT INTO student(id, name, program, branch) VALUES ('chr013','Bobby Rudolph','Computer Science and Engineering Programme','Software Engineering');
INSERT INTO student(id, name, program, branch) VALUES ('chr014','Julyan Sonnie','Computer Science and Engineering Programme','Software Engineering');
INSERT INTO student(id, name, program, branch) VALUES ('chr015','Geoff Kent','Computer Science and Engineering Programme','Software Engineering');
INSERT INTO student(id, name, program, branch) VALUES ('chr016','Damon Dewey','Computer Science and Engineering Programme','Software Engineering');
INSERT INTO student(id, name, program, branch) VALUES ('chr017','Dezi Arlie','Computer Science and Engineering Programme','Software Engineering');


INSERT INTO restricted_course(code,restriction) VALUES ('DAT230','8');


INSERT INTO register_course(id, code) VALUES ('chr006','DAT230');
INSERT INTO register_course(id, code) VALUES ('chr007','DAT230');
INSERT INTO register_course(id, code) VALUES ('chr009','DAT230');
INSERT INTO register_course(id, code) VALUES ('chr010','DAT230');
INSERT INTO register_course(id, code) VALUES ('chr011','DAT230');
INSERT INTO register_course(id, code) VALUES ('chr012','DAT230');
INSERT INTO register_course(id, code) VALUES ('chr013','DAT230');

INSERT INTO waitinglist(id,code) VALUES ('chr014','DAT230');
INSERT INTO waitinglist(id,code) VALUES ('chr015','DAT230');
INSERT INTO waitinglist(id,code) VALUES ('chr008','TDA357');


CREATE VIEW StudentFollowing AS
SELECT name,program,branch
FROM student;

CREATE VIEW FinishCourses AS
SELECT student.name as StudentName,course.name as CourseName,enrollment.grade
FROM enrollment,student,course
WHERE enrollment.id = student.id 
AND enrollment.code = course.code;

CREATE VIEW Registrations AS
SELECT id,code, 'registered' AS registerStatus 
FROM register_course
UNION
SELECT id,code, 'waiting' AS  registerStatus 
FROM waitinglist;

CREATE VIEW PassedCourses AS
SELECT student.id,student.name StudentName,course.code,course.name CourseName,grade
FROM enrollment en, student,course
WHERE en.id = student.id
AND en.code = course.code
AND en.grade not in ('U');

CREATE VIEW UnreadMandatory AS
/* Get all mandatory courses for each students for his program and branch */
(
	(SELECT student.id Student, pm.code ManCourse
	FROM student INNER JOIN program_assign_man_course pm 
     		on student.program = pm.name)
	UNION
	(SELECT student.id Student, bm.code ManCourse
	FROM student INNER JOIN branch_assign_man_course bm 
    		 on student.program = bm.program
     		AND student.branch = bm.branch)
)
MINUS -- UnreadMandatory = AllMandatory-AllPassedMandatory
/* Get all the students with their passed Mandatory courses*/
(
	(SELECT en.id Student,en.code ManCourse
	FROM enrollment en INNER JOIN program_assign_man_course pm 
     		on en.code = pm.code
	WHERE en.grade in ('3','4','5'))
	UNION
	(SELECT en.id Student,en.code ManCourse
	FROM enrollment en INNER JOIN branch_assign_man_course bm 
     		on en.code = bm.code
	WHERE en.grade in ('3','4','5'))
);

CREATE VIEW PassedCourseWithType AS
SELECT pc.id studentid,pc.code coursecode,classified.type,course.credit
FROM  PassedCourses pc
INNER JOIN classified 
	ON pc.code=classified.code
INNER JOIN course
	ON pc.code = course.code
ORDER BY pc.id;


CREATE VIEW PathToGraduation AS
WITH
allcredits AS
	(SELECT en.id student, SUM(course.credit) passedcredit
	FROM enrollment en INNER JOIN course ON en.code = course.code 
	WHERE grade in ('3','4','5')
	GROUP BY id), 
passedbranchcredits AS
	(SELECT student.id, bc.credits branchcredits
	FROM student 
	LEFT OUTER JOIN
	(SELECT ac.student, SUM(course.credit) credits
	FROM   course
	INNER JOIN
		(SELECT en.id student, en.code passedcourse
		FROM enrollment en INNER JOIN branch_assign_man_course bm
			on en.code = bm.code
		WHERE grade in ('3','4','5')
		UNION
		SELECT en.id student, en.code passedcourse
		FROM enrollment en INNER JOIN branch_assign_rec_course br
		on en.code = br.code
		WHERE grade in ('3','4','5')) ac
	ON course.code= ac.passedcourse
	GROUP BY ac.student) bc
	ON student.id=bc.student), 
programnotpass AS
	(
	SELECT  notpassedman.student, count(notpassedman.ManCourse) programnotpass
	FROM
		((SELECT student.id Student, pm.code ManCourse
		FROM student INNER JOIN program_assign_man_course pm 
     			on student.program = pm.name) 
		MINUS
		/* Get all the students with their passed Mandatory courses assigned by program*/
		(SELECT en.id Student,en.code ManCourse
		FROM enrollment en INNER JOIN program_assign_man_course pm 
     			on en.code = pm.code
		WHERE en.grade in ('3','4','5')) ) notpassedman
	GROUP BY notpassedman.student
	),
passedmath AS
	(
	SELECT pcwt.studentid, SUM(pcwt.credit) mathcredit
	FROM PassedCourseWithType pcwt
	WHERE  pcwt.type = 'mathematical'
	GROUP BY pcwt.studentid
	),
passedresearch AS
	(
	SELECT pcwt.studentid, SUM(pcwt.credit) researchcredit
	FROM PassedCourseWithType pcwt
	WHERE  pcwt.type = 'research'
	GROUP BY pcwt.studentid
	),
passedseminar AS
(
	SELECT pcwt.studentid, COUNT(pcwt.coursecode) seminarcourse
	FROM PassedCourseWithType pcwt
	WHERE  pcwt.type = 'seminar'
	GROUP BY pcwt.studentid
)

SELECT ac.student, NVL(ac.passedcredit,0) passedcredit,NVL(pc.branchcredits,0) branchcredits, NVL(pp.programnotpass,0) programnotpass,NVL(pm.mathcredit,0) mathcredit, NVL(pr.researchcredit,0) researchcredit,NVL(ps.seminarcourse,0) seminarcourse, 
(CASE
WHEN    pp.programnotpass is NULL
	AND pc.branchcredits >= 10
	AND pm.mathcredit >= 20
	AND pr.researchcredit >= 10
	AND ps.seminarcourse > 0
THEN 'Qualified'
ELSE 'Unqualified'
END) "GraduationStatus"
FROM allcredits ac 
	LEFT OUTER JOIN passedbranchcredits pc 
		ON ac.student = pc.id
	LEFT OUTER JOIN programnotpass pp
		ON ac.student = pp.student
	LEFT OUTER JOIN passedmath pm
		ON ac.student = pm.studentid
	LEFT OUTER JOIN passedresearch pr
		ON ac.student = pr.studentid
	LEFT OUTER JOIN passedseminar ps
		ON ac.student = ps.studentid;

CREATE VIEW CourseQueuePositions AS
SELECT id,code, ROW_NUMBER() OVER (partition by code ORDER BY position) AS position
FROM waitinglist
ORDER BY code;







