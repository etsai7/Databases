delimiter $$
DROP PROCEDURE IF EXISTS ShowRawScores $$
CREATE PROCEDURE ShowRawScores(IN id INT)
    BEGIN 
        IF EXISTS (SELECT SSN FROM Rawscores WHERE SSN = id) THEN 
            SELECT * FROM Rawscores WHERE SSN = id; 
        ELSE 
            SELECT 'ERROR: SSN NOT FOUND' AS 'Result'; 
        END IF; 
    END$$
delimiter ;

delimiter $$
DROP PROCEDURE IF EXISTS ShowPercentages $$
CREATE PROCEDURE ShowPercentages(IN id INTEGER)
    BEGIN
        IF EXISTS (SELECT ssn FROM Rawscores WHERE ssn = id) THEN 
            SELECT R1.SSN AS SSN, R1.FName AS 'FName', R1.LName AS LName,
            (R1.HW1*(1/R2.HW1)*100) AS 'HW1%',
            (R1.HW2a * (1/R2.HW2a) *100) AS 'HW2a%', (R1.HW2b * (1/R2.HW2b)*100) AS 'HW2b%',
            (R1.Midterm * (1/R2.Midterm)*100) AS 'Midterm%',
            (R1.HW3 * (1/R2.HW3) *100) AS 'HW3%',
            (R1.FExam * (1/R2.FExam)*100) AS 'FExam%',
            weight.WeightedScore AS 'WeightedScore'
            FROM Rawscores R1, Rawscores R2, (
              SELECT ((R1.hw1 * (1/R2.hw1) * R3.hw1 + R1.hw2a * (1/R2.hw2a) * R3.hw2a + R1.hw2b * (1/R2.hw2b) * R3.hw2b + R1.midterm * (1/R2.midterm) * R3.midterm +  R1.hw3 * (1/R2.hw3) * R3.hw3 + R1.fexam * (1/R2.fexam) * R3.fexam) * 100.0) AS 'WeightedScore'
              FROM Rawscores R1, Rawscores R2, Rawscores R3
              WHERE R1.ssn = id AND R2.ssn = 0001 AND R3.ssn = 0002
            ) AS weight
            WHERE R2.ssn=0001 AND R1.ssn = id;
           
       ELSE SELECT 'ERROR: SSN NOT FOUND' AS 'Result'; 
       END IF; 
END$$
delimiter ;

delimiter $$
DROP PROCEDURE IF EXISTS AllRawScores $$
CREATE PROCEDURE AllRawScores(IN pass VARCHAR(15))
    BEGIN
      IF EXISTS (SELECT CurPasswords FROM Passwords WHERE pass = CurPasswords) THEN 
        SELECT * FROM Rawscores WHERE SSN != 0001 AND SSN != 0002
        ORDER BY Section, LName, FName;
      ELSE 
         SELECT 'ERROR: INVALID PASSWORD WHAT A BADDIE' AS 'Result'; 
      END IF; 
END$$
delimiter ;

delimiter $$
DROP PROCEDURE IF EXISTS AllPercentages $$
CREATE PROCEDURE AllPercentages(IN pass VARCHAR(15))
    BEGIN
        IF EXISTS (SELECT CurPasswords FROM Passwords WHERE pass = CurPasswords) THEN 
            SELECT R1.SSN AS SSN, R1.FName AS 'FName', R1.LName AS LName,
            (R1.HW1*(1/R2.HW1)*100) AS 'HW1%',
            (R1.HW2a * (1/R2.HW2a) *100) AS 'HW2a%', (R1.HW2b * (1/R2.HW2b)*100) AS 'HW2b%',
            (R1.Midterm * (1/R2.Midterm)*100) AS 'Midterm%',
            (R1.HW3 * (1/R2.HW3) *100) AS 'HW3%',
            (R1.FExam * (1/R2.FExam)*100) AS 'FExam%',
            weight.WeightedScore AS 'WeightedScore'
            FROM Rawscores R1, Rawscores R2, (
              SELECT R1.SSN AS SSN, ((R1.hw1 * (1/R2.hw1) * R3.hw1 + R1.hw2a * (1/R2.hw2a) * R3.hw2a + R1.hw2b * (1/R2.hw2b) * R3.hw2b + R1.midterm * (1/R2.midterm) * R3.midterm +  R1.hw3 * (1/R2.hw3) * R3.hw3 + R1.fexam * (1/R2.fexam) * R3.fexam) * 100.0) AS 'WeightedScore'
              FROM Rawscores R1, Rawscores R2, Rawscores R3
              WHERE R1.ssn != 0001 AND R1.ssn != 0002 AND R2.ssn = 0001 AND R3.ssn = 0002
            ) AS weight
            WHERE R2.ssn=0001 AND R1.ssn != 0001 AND R1.ssn != 0002 AND weight.SSN = R1.SSN
            GROUP BY R1.SSN
            ORDER BY R1.Section, weight.WeightedScore;
           
       ELSE 
         SELECT 'ERROR: INVALID PASSWORD WHAT A BADDIE' AS 'Result'; 
       END IF; 
END$$
delimiter ;

delimiter $$
DROP PROCEDURE IF EXISTS UpdateMidterms $$
CREATE procedure UpdateMidterms(IN id INTEGER, IN pass VARCHAR(15), IN score DECIMAL(5,2)) 
    BEGIN 
        IF EXISTS (SELECT SSN FROM Rawscores WHERE SSN = id) AND EXISTS (SELECT CurPasswords FROM Passwords WHERE pass = CurPasswords) THEN 
            SELECT 'Successfully updated!' AS 'Result';
            UPDATE Rawscores SET Midterm = score WHERE ssn = id;
        ELSE
            SELECT 'ERROR: UPDATE FAILED INVALID SSN OR PASSWORD' AS 'Result'; 
        END IF; 
    END$$
delimiter ;

