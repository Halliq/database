CREATE OR REPLACE TRIGGER CourseRegistration
INSTEAD OF INSERT ON Registrations
REFERENCING NEW AS newregister
FOR EACH ROW
DECLARE
maxNum INT;
currentNum INT;
limited INT;
reg INT;
pass INT;
wait INT;
cl INT;
BEGIN
SELECT COUNT(*) INTO reg
FROM register_course
WHERE id = :newregister.id AND code = :newregister.code;
IF reg =0 THEN   -- not registered
  SELECT COUNT(*) INTO pass
  FROM enrollment
  WHERE id=:newregister.id AND code=:newregister.code AND grade in ('3','4','5');
  IF pass=0 THEN  -- not passed
	SELECT COUNT(*) INTO wait
	FROM waitinglist
	WHERE id=:newregister.id AND code=:newregister.code;
	IF wait=0 THEN  -- not waited
	    WITH courseleft AS
		( (SELECT precourse
		  	FROM prerequisite
		  	WHERE course =:newregister.code)
		  	MINUS
		  	(SELECT code
		  	FROM enrollment
		  	WHERE id=:newregister.id AND grade in ('3','4','5')) 
		)
		SELECT COUNT(*) INTO cl FROM courseleft;
	  	IF cl =0 THEN --passed all prerequisites
		   SELECT COUNT (*) INTO limited FROM  restricted_course WHERE code = :newregister.code;
		   IF limited > 0 THEN
		      SELECT restriction INTO maxNum FROM restricted_course WHERE code = :newregister.code;
		      SELECT COUNT (*) INTO currentNum --The num of students registered this course
		      FROM  register_course
		      WHERE code = :newregister.code;
		      IF currentNum < maxNum THEN
		         INSERT INTO register_course(id,code) VALUES (:newregister.id,:newregister.code);
		      ELSE
		         INSERT INTO waitinglist(id,code) VALUES (:newregister.id,:newregister.code);		
		      END IF;
		   ELSE 
		      INSERT INTO register_course(id,code) VALUES (:newregister.id,:newregister.code);
		   END IF; -- end of limited >0
		ELSE -- not all prerequisites passed
		RAISE_APPLICATION_ERROR(-20000,'Not all prerequisites of this course passed before register');
		END IF; -- end of pass prerequisites
	ELSE --waited 
	RAISE_APPLICATION_ERROR(-20000,'Course already waiting in line');
 	END IF; -- end of exist already waited	
  ELSE  -- passed
  RAISE_APPLICATION_ERROR(-20000,'Course already passed');
  END IF; -- end of exist already passed
ELSE  --registered
  RAISE_APPLICATION_ERROR(-20000,'Course already registered');
 END IF; -- end of exist already registered
END;
/

CREATE OR REPLACE TRIGGER CourseUnregistration
INSTEAD OF DELETE ON Registrations
REFERENCING OLD AS oldregister
FOR EACH ROW
DECLARE
firstStuInQueue student.id%TYPE;
waitingNum INT;
exist INT;
BEGIN
SELECT COUNT(id) INTO exist
FROM waitinglist
WHERE id=:oldregister.id AND code=:oldregister.code;
IF exist=0 THEN
   DELETE FROM register_course
   WHERE id=:oldregister.id AND code=:oldregister.code;
   SELECT COUNT(id) INTO waitingNum     -- waitingnum in this unregistered course
   FROM WaitingList
   WHERE code = :oldregister.code;       -- Get the course of unregistered
   IF waitingNum > 0 THEN			--there are waiting students
      SELECT id INTO firstStuInQueue
      FROM coursequeuepositions
      WHERE code =:oldregister.code 
			AND position = '1';
      INSERT INTO register_course(id,code)  
      VALUES(firstStuInQueue,:oldregister.code);
      DELETE FROM WaitingList where id = firstStuInQueue AND code = :oldregister.code;
      --UPDATE FROM WaitingList... --update the priority if necessary
   END IF;
ELSE
DELETE FROM waitinglist
WHERE id=:oldregister.id AND code=:oldregister.code;
--RAISE_APPLICATION_ERROR(-20000,'Student unwait from waitinglist');
END IF;
END;
/