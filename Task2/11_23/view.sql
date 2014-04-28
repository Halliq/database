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

SELECT ac.student, ac.passedcredit,pc.branchcredits, pp.programnotpass,pm.mathcredit, pr.researchcredit,ps.seminarcourse, 
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