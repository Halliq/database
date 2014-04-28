--new register, full course
INSERT INTO Registrations(id, code) VALUES ('chr016','DAT230');
--waiting again
INSERT INTO Registrations(id, code) VALUES ('chr016','DAT230');
--test position sequence
INSERT INTO Registrations(id, code) VALUES ('chr005','DAT230');  
--new register, not full course
INSERT INTO Registrations(id, code) VALUES ('chr016','TDA357');
--new register, not restricted course
INSERT INTO Registrations(id, code) VALUES ('chr016','MAT001');
--register again
INSERT INTO Registrations(id, code) VALUES ('chr001','DAT230');
--register passed course
INSERT INTO Registrations(id, code) VALUES ('chr003','DAT230');
--register a course without passing all prerequisistes
INSERT INTO Registrations(id, code) VALUES ('chr016','DAT265');

--unregister a registered student which course has no waiting list
DELETE FROM Registrations WHERE id='ahr005' AND code='ERE350';
--unregister a registered student which course has waiting list
DELETE FROM Registrations WHERE id='chr006' AND code='DAT230';
--unregister a waiting student
DELETE FROM Registrations WHERE id='chr008' AND code='TDA357';
--unregister a non reg/wait student
DELETE FROM Registrations WHERE id='ahr005' AND code='DAT230';
