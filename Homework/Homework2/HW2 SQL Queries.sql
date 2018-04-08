-- Comments
/*
    READ THIS
    15. I assumed highest grade in the course meant A+
    39. Need to uncomment out UPDATE to run it. 
*/

-- 1. List the name of dorms only housing female students 
-- Working
SELECT dorm_name FROM Dorm WHERE gender = "F";

-- 2. List the student name and major name of all students who are 
--	  enrolled in a course taught by Russell Taylor.
-- Working
SELECT DISTINCT(S.Lname), S.Fname, S.Major 
FROM Student as S, Course as C, Enrolled_in as E, Faculty as F
WHERE S.StuID = E.StuID AND E.CID = C.CID AND C.Instructor = F.FacID
	AND F.Lname = "Taylor" AND F.Fname = "Russell";

-- 3. List the name, age and sex of all students with no roommates
-- Working
SELECT DISTINCT(S.Lname), S.Fname, S.Sex
FROM Student as S, Lives_in as L,
(
    SELECT L.dormid, COUNT(L.room_number) as no, L.room_number, L.stuid as LSI
    FROM Lives_in as L
    GROUP BY L.dormid, L.room_number
) as t
WHERE t.LSI = S.StuID AND t.no < 2;

-- 4. List the student names and major names of all students who are 
-- 	  not enrolled in any courses from his/her major
-- Working - Check
SELECT DISTINCT(Lname), Fname, Major 
FROM Student as S, Enrolled_in as E, Course as C
WHERE (S.StuID) NOT IN 
(SELECT DISTINCT(S.StuID)
	FROM Student as S, Enrolled_in as E, Course as C
	WHERE S.StuID = E.StuID AND E.CID = C.CID AND S.Major = C.CID
);

-- 5. List the names of activities with the most faculty participation
-- Working
SELECT fs.ActivityName
FROM (
    SELECT F.FacID as FI, A.activity_name as ActivityName
    FROM Activity as A, Faculty_Participates_in as FP, Faculty as F
    WHERE A.actid = FP.actid AND FP.FacID = F.FacID
    ) as fs
    GROUP BY fs.ActivityName
    HAVING COUNT(fs.FI) = 
        (SELECT MAX(t.ct) 
            FROM
                (
                    SELECT A.activity_name as AName, COUNT(F.FacID) as ct
                    FROM Activity as A, Faculty_Participates_in as FP, Faculty as F
                    WHERE A.actid = FP.actid AND FP.FacID = F.FacID
                    GROUP BY A.activity_name
                ) as t
        );

-- 7. List the student name and major name of the students who participate
--	  in at least 2 activities including either Mountain Climbing or Spelunking
-- Working
SELECT DISTINCT(S.Lname), S.Fname, S.Major 
FROM Participates_in as PI, Student as S
WHERE S.StuID IN (
    	SELECT S.StuID as SI
    	FROM Student as S, Activity as A, Participates_in as P
    	WHERE S.StuID = P.StuID AND P.actID = A.actID 
                AND (A.activity_name = "Mountain Climbing" OR A.activity_name = "Spelunking")   
    )
    AND S.StuID = PI.StuID 
GROUP BY S.StuID
HAVING COUNT(PI.actID) >= 2;

-- 8. List the student name and major name of the students who participate
--	  in at least 2 activities and never received a grade below B- in any 
--	  courses s/he is enrolled in
-- Working 
SELECT *
FROM Student as S
WHERE S.StuID IN
(SELECT t.SSI
    FROM
    (
        SELECT S.StuID as SSI, COUNT(P.StuID) as count
        FROM Student as S, Activity as A, Participates_in as P, Department as D
        WHERE S.StuID = P.StuID AND P.actID = A.actID AND S.Major = D.DNO
        GROUP BY S.StuID 
    ) as t
    WHERE t.count >= 2 
)
    AND S.StuID NOT IN (SELECT S.StuID as ss
                            FROM Student as S, Enrolled_in as EI, Gradeconversion as GC
                            WHERE S.StuID = EI.StuID AND EI.grade = GC.lettergrade
                                    AND GC.gradepoint < 2.7
                        );

-- 10. Find the name of all faculty members whoe building is different from 
--	   his/her department's building. Report the faculty name, department name,
--	   faculty office building, and department building
-- Should be Working
SELECT F.Lname, F.Fname, D.Dname, F.Building, D.Building
FROM Faculty as F, Department as D, Member_of as M
WHERE F.FacID = M.FacID AND D.DNO = M.DNO AND F.Building != D.Building;

-- 12. List the dormname and student capacity for female dorms where there are
--	   no amenities
-- Working, Empty Set
SELECT D.dorm_name, D.student_capacity
FROM Dorm as D, Dorm_amenity as DA, Has_amenity as HA
WHERE D.gender = "F" AND D.dormid NOT IN (SELECT dormid FROM Has_amenity);

-- 13. List the dormid and student capacity for the dorm with the most amentiies.
--	   If there is a tie, list all tying dorms
-- Working
SELECT fs.DormID, fs.student_Capacity, COUNT(fs.ct)
FROM (
    SELECT D.dormid as DormID, D.student_capacity as student_Capacity, (HA.dormid) as ct
    FROM Dorm  as D, Dorm_amenity as DA, Has_amenity as HA
    WHERE D.dormid = HA.dormid AND DA.amenid = HA.amenid
    ) as fs
    GROUP BY fs.DormID
    HAVING COUNT(fs.ct) = 
        (SELECT MAX(t.ct) 
            FROM
                (
                    SELECT D.dormid, COUNT(HA.dormid) as ct
                    FROM Dorm  as D, Dorm_amenity as DA, Has_amenity as HA
                    WHERE D.dormid = HA.dormid AND DA.amenid = HA.amenid
                    GROUP BY D.dormid
                ) as t
        );

/*SELECT a,b FROM table
WHERE b = (SELECT MAX(b) FROM table)
*/

-- 14. List the student names, major name and advisor name of all students who have
--	   received an A+ in "Computer Vision"
-- Working, Empty Set????
SELECT S.Lname, S.Fname, S.Major, F.Lname, F.Fname
FROM Student as S, Faculty as F, Course as C, Enrolled_in as E
WHERE S.StuID = E.StuID AND E.CID = C.CID AND C.CName = "COMPUTER VISION"
	AND E.Grade = "A+" AND F.FacID = S.Advisor;

-- 15. List the coursename, coursenumber, student name, major name and advisor name of
--	   the students who have achieved the highest grade in each course in the database. 
--	   If there is a tie, list all tying students
-- Working Check
SELECT C.CName, C.CID, S.Lname, S.Fname, S.Major, F.Lname, F.Fname
FROM Course as C, Student as S, Faculty as F, Enrolled_in as E
WHERE E.Grade = "A+" AND S.StuID = E.StuID AND C.CID = E.CID  AND S.Advisor = F.FacID;

/*
SELECT EI.CID, MAX(GC.gradepoint)
FROM Enrolled_in as EI, Gradeconversion as GC
WHERE EI.Grade = GC.lettergrade
GROUP BY EI.CID;

SELECT fs.ActivityName
FROM (
    SELECT F.FacID as FI, A.activity_name as ActivityName
    FROM Activity as A, Faculty_Participates_in as FP, Faculty as F
    WHERE A.actid = FP.actid AND FP.FacID = F.FacID
    ) as fs
    GROUP BY fs.ActivityName
    HAVING COUNT(fs.FI) = 
        (SELECT t.EIC, t.GCG 
            FROM
                (
                    SELECT EI.CID as EIC, (GC.gradepoint) as GCG
                    FROM Enrolled_in as EI, Gradeconversion as GC
                    WHERE EI.Grade = GC.lettergrade
                ) as t
                HAVING t.GCG = 
                    (
                    SELECT MAX(t.GCG) 
                        FROM
                        (
                            SELECT EI.CID as EIC, (GC.gradepoint) as GCG
                            FROM Enrolled_in as EI, Gradeconversion as GC
                            WHERE EI.Grade = GC.lettergrade
                            ORDER BY EIC
                        ) as s
                    ) AND t.EIC = s.EIC

        );
*/

-- 16. List the average age of the students who do not participate in any activity.
-- Working
SELECT AVG(S.Age)
FROM Student as S, Participates_in as PI, Activity as A
WHERE S.StuID NOT IN (SELECT S.StuID 
        FROM Student as S, Participates_in as PI, Activity as A 
        WHERE S.StuID = PI.StuID AND A.actid = PI.actid
        );

-- 17. List the student name, major name and advisor name of the student in the database
--     who lives the farthest from Baltimore, MD. You should not include the city code for
--     Baltimore in the query, just the name "Baltimore" and state "MD"
-- Comment: Not sure why seeting MAX to the SQRT messes it up
-- Working
SELECT S.Lname, S.Fname, S.Major, F.Lname, F.Fname
FROM Student as S, Faculty as F, 
(
    SELECT C.city_name as ccn, S.Lname, S.Fname,(SQRT(POW(C.latitude - Balt.Blat,2) + POW(C.longitude - Balt.Blon,2))) as md, S.StuID as SCT
    FROM Student as S, City as C,
    (
        SELECT DISTINCT(C.latitude) as Blat, (C.longitude) as Blon
        FROM City as C
        WHERE C.city_name = "Baltimore" AND C.state = "MD"
    ) as Balt
    WHERE S.city_code = C.city_code
) as Stu_cit
WHERE Stu_cit.SCT = S.StuID AND S.Advisor = F.FacID
ORDER BY Stu_cit.md DESC
LIMIT 1; 

-- 20. List all students who smoke and have working fireplaces in their dorms.
-- Working
SELECT S.Lname, S.Fname 
FROM Student as S, Lives_in as LI, Has_amenity as HA, Dorm_amenity as DA, Preferences as P
WHERE S.StuID = P.StuID AND P.Smoking = "Yes" AND S.StuID = LI.StuID AND LI.dormid = HA.dormid 
    AND HA.amenid = DA.amenid AND DA.amenity_name = "Working Fireplaces"; 

-- 21. Print the names of all students from NY, who live in Wolman,  who major
--     in CS, who are allergic to peanut butter and who are majors in the 
--     CS Department
-- Working - Empty Set
SELECT DISTINCT(S.Lname), S.Fname
FROM Student as S, City as C, Has_Allergy as HA
WHERE S.city_code = C.city_code AND C.state = "NY" AND S.StuID = HA.StuID AND HA.Allergy = "Nuts"
    AND S.major = 600;

-- 22. List the names of all activities that at least one boy likes and no girl loves
-- Working
SELECT DISTINCT(A.activity_name)
FROM Activity as A, Student as S, Participates_in as PI
WHERE A.actid NOT IN (SELECT DISTINCT(A.actid)
                        FROM Student as S, Participates_in as PI, Activity as A
                        WHERE S.Sex = 'F' AND S.StuID = PI.StuID AND PI.actID = A.actid
                     )
AND A.actID IN ( SELECT DISTINCT(A.actid)
                        FROM Student as S, Participates_in as PI, Activity as A
                        WHERE S.Sex = 'M' AND S.StuID = PI.StuID AND PI.actID = A.actid
                     );

-- 24. List the names of students who suffer from every allergy type
-- Can compare number of allergies 
-- Working Empty Set --Check

SELECT stud.SL, stud.SF
FROM 
    (
        SELECT S.StuID as SSI, S.Lname as SL, S.Fname as SF, (AT.Allergy) as at
        FROM Student as S, Allergy_Type as AT, Has_Allergy as HA   
        WHERE S.StuID = HA.StuID AND HA.Allergy = AT.Allergy
    ) as stud
    GROUP BY stud.SSI
    HAVING COUNT(stud.at) = ((
                        SELECT COUNT(AT.Allergy) as ct
                        FROM Allergy_Type as AT
                    ) );

-- 25. List the most common allergy name (and its allergy type) suffered by students older
--     than 25.
-- Working
SELECT al.Allergy, al.AllergyType
FROM
    (
        SELECT  AT.Allergy as Allergy, AT.AllergyType as AllergyType
        FROM Student as S, Allergy_Type as AT, Has_Allergy as HA
        WHERE S.Age > 25 AND S.StuID = HA.StuID AND AT.Allergy = HA.Allergy
    ) as al
    GROUP BY al.Allergy
    HAVING COUNT(al.Allergy) = 
        (SELECT MAX(t.ct)
            FROM
                (
                    SELECT COUNT(AT.Allergy) as ct, AT.Allergy as ATA
                    FROM Student as S, Allergy_Type as AT, Has_Allergy as HA
                    WHERE S.Age > 25 AND S.StuID = HA.StuID AND AT.Allergy = HA.Allergy
                    GROUP BY AT.Allergy 
                ) as t
        );

-- 27. List the name, age, and major of all students enrolled in a class taught by their advisor
--     (also include the name of the advisor)
-- Working
SELECT S.Lname, S.Fname, S.Age, S.Major, F.Lname, F.Fname
FROM Student as S, Faculty as F, Enrolled_in as EI, Course as C
WHERE S.StuID = EI.StuID AND EI.CID = C.CID AND C.Instructor = F.FacID AND S.Advisor = C.Instructor;

-- 28. List the student name, course name, instructor name, and letter grade for all classes
--     enrolled in by students who are early risers and have no allergies and do not smoke
-- Working
SELECT DISTINCT(S.Lname), S.Fname, C.CName, F.Lname, F.Fname, EI.Grade
FROM Student as S, Preferences as P, Has_Allergy as HA, Course as C, Faculty as F, Enrolled_in as EI
WHERE S.StuID = P.StuID AND P.SleepHabits = "EarlyRiser" AND P.Smoking = "no" 
    AND S.StuID != HA.StuID AND S.StuID = EI.StuID AND F.FacID = C.Instructor
    AND EI.CID = C.CID;

-- 29. List the name and age of both the oldest and the youngest student in the database
--     (include in a single table with 6 columns, FN1, LN1, Age1, FN2, LN2, Age2)
-- Working
SELECT S.Fname as FN1, S.Lname as LN1, S.Age as Age1 
    FROM Student as S 
    WHERE S.Age = ( SELECT MAX(S.Age) From Student as S)
union
SELECT S.Fname as FN2, S.Lname as LN2, S.Age as Age2
    FROM Student as S 
    WHERE S.Age = ( SELECT MIN(S.Age) From Student as S);

-- 30. List all pairs of students enrolled in the same course and sharing the same first name
--     (give FN1,LN1,FN2,LN2 where FN1=FN2). Make sure that students are not paired
--     with themselves. Also, because of symmetry, each pair will appear twice as a result
--     in reversed order(e.g. (John Smith, John Winters) and (John Winters,John Smith)).
--     Eliminate this duplication (this can be done as a simple change when eliminating 
--     self pairings)
-- Working
SELECT DISTINCT(S.Fname) as FN1, S.Lname as LN1, S2.Fname as FN2, S2.Lname as LN2
    FROM Student as S, Student as S2, Enrolled_in as EI1, Enrolled_in as EI2, Course as C
    WHERE S.Fname = S2.Fname AND S.Lname != S2.Lname
        AND S.StuID = EI1.StuID AND EI1.CID = C.CID
        AND S2.StuID = EI2.StuID AND EI2.CID = EI2.CID
        AND EI1.CID = EI2.CID
        AND S.StuID < S2.StuID;

-- 31. Find the total number of CS majors who are smokers and who do not like anyone in 
--     the database. 
-- Working
SELECT COUNT(DISTINCT(S.StuID)) as count
FROM Student as S, Preferences as P, Likes as L, Department as D
WHERE S.StuID =  P.StuID AND P.Smoking = "Yes" AND 
        D.DName = "Computer Science" AND S.Major = D.DNO AND S.StuID != L.WhoLikes;

-- 32. List all the students who have minored in Math, but also have an 'A+' or 'A' from a
--     computer science course.
-- Working Empty Set
SELECT DISTINCT(S.Lname), S.Fname, C.CName, EI.Grade
FROM Student as S, Department as D, Minor_in as MI, Enrolled_in as EI, Course as C 
WHERE (S.StuID = EI.StuID AND EI.CID = C.CID AND C.DNO = D.DNO 
    AND D.Dname = "Computer Science") AND (EI.Grade = 'A+' OR EI.Grade = 'A')
    AND S.StuID = MI.StuID AND (MI.DNO = D.DNO AND D.Dname = "Mathematics");

-- 33. List all courses Bruce Wilson is enrolled in, giving the course name, the number of
--     credits offered by the class (e.g. 3), Bruce's letter grade in the class, and his 
--     numberic gradepoint for the class.
-- Working
SELECT C.CID as CID, C.CName as CourseName, C.Credits as Credits, 
    EI.Grade as LetGrade, GC.gradepoint  as Gradepoint
FROM Student as S, Enrolled_in as EI, Course as C, Gradeconversion as GC 
WHERE S.Lname = "Wilson" AND S.Fname = "Bruce" AND S.StuID = EI.StuID AND EI.CID = C.CID
    AND EI.Grade = GC.lettergrade;

-- 34. Compute Bruce Wilson's gpa (for all courses listed for him in the enrolled_in)
--     ,restricted to courses in his major. The GPA is defined as the sum of 
--     (gradepoint xcourse.cfredits) for all his major courses divided by the sum of 
--     his course.credits for all his major courses. For the exampole above, assuming
--     his major is 340, his major GPA would be (12 + 6.2)/5. You need only to list his 
--     student ID number, total number of recdits he has enrolled in and his major GPA.
-- Working
SELECT (SUM((C.Credits * GC.gradepoint))/SUM(C.Credits)) as MajorGPA
FROM Student as S, Enrolled_in as EI, Course as C, Gradeconversion as GC,
    Department as D
WHERE S.Lname = "Wilson" AND S.Fname = "Bruce" AND S.Major = D.DNO AND S.StuID = EI.StuID 
    AND EI.CID = C.CID AND EI.Grade = GC.lettergrade AND C.DNO = S.Major; 

-- 39. Create a table (filled with appropriate values) that maps between a letter grade and
--     the next lower letter grade. Assume that the grade lower than F is F.
drop table LowerGrade;
create table LowerGrade (
       LetterGrade      VARCHAR(2),
       NextLower        VARCHAR(2)
);
insert into LowerGrade values ( 'A+', 'A');
insert into LowerGrade values ( 'A', 'A-');
insert into LowerGrade values ( 'A-', 'B+');
insert into LowerGrade values ( 'B+', 'B');
insert into LowerGrade values ( 'B', 'B-');
insert into LowerGrade values ( 'B-', 'C+');
insert into LowerGrade values ( 'C+', 'C');
insert into LowerGrade values ( 'C', 'C-');
insert into LowerGrade values ( 'C-', 'D+');
insert into LowerGrade values ( 'D+', 'D');
insert into LowerGrade values ( 'D', 'D-');
insert into LowerGrade values ( 'D-', 'F+');
insert into LowerGrade values ( 'F+', 'F');
insert into LowerGrade values ( 'F', 'F');

/* -- This is the Update Part. Uncomment to run
UPDATE  Student as S, Course as C, Enrolled_in as EI, Faculty as F, LowerGrade as LG
SET EI.Grade = LG.NextLower
WHERE S.Advisor = F.FacID AND S.StuID = EI.StuID 
        AND EI.CID = C.CID AND EI.Grade = LG.LetterGrade
        AND F.FacID = C.Instructor;
*/

/* This is not related to query
SELECT DISTINCT(S.Lname), S.Fname, C.CID, S.Advisor, F.FacID
FROM Student as S, Course as C, Enrolled_in as EI, Faculty as F
WHERE S.Advisor = F.FacID AND S.StuID = EI.StuID 
        AND EI.CID = C.CID
        AND F.FacID = C.Instructor;
*/

-- 40. List names of all students in the CS department who are in a unilateral love
--     (i.e. they love someone who does not love them back).
-- Working
SELECT DISTINCT(S1.Lname), S1.Fname, S1.StuID,L.WhoIsLoved
FROM Student as S1, Student as S2, Department as D, Loves as L
WHERE S1.Major = D.DNO AND D.Dname = "Computer Science" AND S2.Major = 600
    AND S1.StuID = L.WhoLoves 
    AND S1.StuID NOT IN (
        SELECT L.WhoIsLoved
        FROM Student as S1, Student as S2, Department as D, Loves as L
        WHERE S1.Major = D.DNO AND D.Dname = "Computer Science" AND S2.Major = 600
            AND S1.StuID = L.WhoLoves);

-- 41. List sleep habits of all students who have two majors and have Mark Guiliano as
--     advisor.
-- Working Empty Set
SELECT DISTINCT(S.Lname), S.Fname
FROM Student as S, Faculty as F,
(
    SELECT S.LName as SL, S.Fname as SF, (MI.StuID) as SM
    FROM Student as S, Minor_in as MI
    WHERE S.StuID = MI.StuID
    GROUP BY S.StuID
) as t 
WHERE S.Advisor = F.FacID AND F.Lname = "Guiliano" AND F.Fname = "Mark"
HAVING COUNT(t.SM) = 2;


-- 42. List the names of clubs which have members who have not taken a course that is 
--     taught by a faculty that works in the sam building as Yair Amir.
-- Working
SELECT DISTINCT(Cl.ClubName)
FROM Student as S, Enrolled_in as EI, Course as C, Member_of_club as MoC, Club as Cl,
(
    SELECT F.Lname, F.Fname, F.FacID as FFI
    FROM Faculty as F,
    (
        SELECT F.Building as FB
        FROM Faculty as F
        WHERE F.Lname = "Amir" AND F.Fname = "Yair"
    ) as t
    WHERE F.Building = t.FB
) as si
WHERE S.StuID = EI.StuID AND EI.CID = C.CID AND C.Instructor != si.FFI
    AND S.StuID = MoC.StuID AND MoC.ClubID = Cl.ClubID;

-- 43. List the names, course titles and minimum grade given for courses where the minimum 
--     grade is greater than or equal to a B- (grade point conversion of at least 2.7)
-- Working
SELECT *
FROM (
    SELECT C.CID, C.CName, MIN(GC.gradepoint) as Minimum
    FROM Course as C, Enrolled_in as EI, Gradeconversion as GC
    WHERE C.CID = EI.CID AND EI.Grade = GC.lettergrade
    GROUP BY C.CID
    ORDER BY C.CName
) as t
WHERE t.Minimum >= 2.7;

-- 45. List the names, course titles and average grade (converted to grade points) for all
--     courses where the average grade in the class is at least 2.7
-- Working
SELECT *
FROM (
    SELECT C.CID, C.CName, AVG(GC.gradepoint) as av
    FROM Course as C, Enrolled_in as EI, Gradeconversion as GC
    WHERE C.CID = EI.CID AND EI.Grade = GC.lettergrade
    GROUP BY C.CID
) as t
WHERE t. av >=2.7; 

/*
SELECT *
    FROM Course as C, Enrolled_in as EI, Gradeconversion as GC
    WHERE C.CID = EI.CID AND EI.Grade = GC.lettergrade
    ORDER BY C.CName;
*/

-- 47. List the name and total enrollement of the course with the largest number of enrolled
--     students.
-- Working
SELECT t.CC as CourseName,(t.ct)
FROM
(
    SELECT C.CName as CC, (COUNT(EI.StuID)) as ct, C.CID as CCID
    FROM Course as C, Enrolled_in as EI, Student as S
    WHERE S.StuID = EI.StuID AND EI.CID = C.CID
    GROUP BY C.CID
) as t
HAVING t.ct = 
    (SELECT MAX(t.ct) 
            FROM
                (
                    SELECT C.CName as CC, (COUNT(EI.StuID)) as ct, C.CID as CCID
                    FROM Course as C, Enrolled_in as EI, Student as S
                    WHERE S.StuID = EI.StuID AND EI.CID = C.CID
                    GROUP BY C.CID
                ) as t
        );

-- 49. List the first and last names of all pairs of dorm mates (and their StuID's) who
--     have taken at least oe course together. You should only list a given pair of roommates
--     once (do not repeate duplicates), and your answer should have 6 columns
-- Working
SELECT DISTINCT(S.Fname) as FN1, S.Lname as LN1, LI1.dormid, LI1.room_number,
                 S2.Fname as FN2, S2.Lname as LN2, LI1.dormid, LI2.room_number
    FROM Student as S, Student as S2, Enrolled_in as EI1, Enrolled_in as EI2, Course as C,
         Lives_in as LI1, Lives_in as LI2
    WHERE S.StuID = EI1.StuID  AND EI1.CID = C.CID AND S2.StuID = EI2.StuID 
        AND EI1.CID = EI2.CID AND S.StuID < S2.StuID
        AND S.StuID = LI1.StuID AND S2.StuID = LI2.StuID
        AND LI1.room_number = LI2.room_number AND LI1.dormid = LI2.dormid;

-- 50. List the first and last names of all pairs of roommates (and their StuID's) who
--     have taken at least one course together. You should only list a given pair of room-
--     -mates once (do not repeat), and your answer should have 6 columns
-- Working
SELECT DISTINCT(S.Fname) as FN1, S.Lname as LN1, LI1.dormid, LI1.room_number,
                 S2.Fname as FN2, S2.Lname as LN2, LI1.dormid, LI2.room_number
    FROM Student as S, Student as S2, Preferences as P1, Preferences as P2,
         Lives_in as LI1, Lives_in as LI2
    WHERE S.Major = S2.Major  
        AND S.StuID = P1.StuID AND S2.StuID = P2.StuID
        AND P1.SleepHabits = P2.SleepHabits
        AND P1.MusicType = P2.MusicType
        AND P1.Smoking = P2.Smoking
        AND S.StuID < S2.StuID
        AND S.StuID = LI1.StuID AND S2.StuID = LI2.StuID
        AND LI1.room_number = LI2.room_number AND LI1.dormid = LI2.dormid;
/*
SELECT DISTINCT(S.Fname) as FN1, S.Lname as LN1, LI1.dormid, LI1.room_number,
                 S2.Fname as FN2, S2.Lname as LN2, LI1.dormid, LI2.room_number
    FROM Student as S, Student as S2, 
         Lives_in as LI1, Lives_in as LI2
    WHERE S.StuID < S2.StuID
        AND S.StuID = LI1.StuID AND S2.StuID = LI2.StuID
        AND LI1.room_number = LI2.room_number AND LI1.dormid = LI2.dormid;
*/
-- 51. List the names, primary department, office roomnumber and office building of
--     professors who have their offices in the same building as the office of their primary
--     department, and teaches at least one course in their primary department
SELECT DISTINCT(F.FacID), F.Lname, F.Fname, F.Room, F.Building 
FROM Faculty as F, Department as D, Member_of as Mo
WHERE F.Building = D.Building AND Mo.DNO = D.DNO AND Mo.Appt_Type = "Primary"
        AND F.FacID IN (   
                            SELECT DISTINCT(F.FacID) 
                            FROM Faculty as F, Course as C, Member_of as Mo
                            WHERE C.DNO = Mo.DNO AND Mo.Appt_Type = "Primary" AND
                                    F.FacID = C.Instructor
                        );


-- 52. What is the average GPA of female students who come from Maryland?
-- Working
SELECT SUM(t.MajorGPA)/COUNT(t.SL) as AverageFemaleGPA
FROM(
    SELECT (SUM((C.Credits * GC.gradepoint))/SUM(C.Credits)) as MajorGPA, S.Lname as SL
    FROM Student as S, Enrolled_in as EI, Course as C, Gradeconversion as GC,
         City as Ci
    WHERE S.Sex = 'F' AND S.StuID = EI.StuID 
        AND S.city_code = Ci.city_code AND Ci.state = "MD"
        AND EI.CID = C.CID AND EI.Grade = GC.lettergrade 
        GROUP BY S.StuID 
) as t;

/*
SELECT DISTINCT(S.Lname), S.Fname
FROM Student as S, Enrolled_in as EI, Course as C, Gradeconversion as GC,
    Department as D, City as Ci
WHERE S.Sex = 'F' AND S.city_code = Ci.city_code AND Ci.state = "MD"; 
*/

-- 54. List the name and StuID of the student in the database who lives farthest
--     from Baltimore
-- Working
SELECT DISTINCT(S.Lname), S.Fname, S.StuID
FROM Student as S, Faculty as F, 
(
    SELECT C.city_name as ccn, S.Lname, S.Fname,(SQRT(POW(C.latitude - Balt.Blat,2) + POW(C.longitude - Balt.Blon,2))) as md, S.StuID as SCT
    FROM Student as S, City as C,
    (
        SELECT DISTINCT(C.latitude) as Blat, (C.longitude) as Blon
        FROM City as C
        WHERE C.city_name = "Baltimore" AND C.state = "MD"
    ) as Balt
    WHERE S.city_code = C.city_code
) as Stu_cit
WHERE Stu_cit.SCT = S.StuID AND S.Advisor = F.FacID
ORDER BY Stu_cit.md DESC
LIMIT 1; 

-- 56. What is the minimum GPA of a student who lives in Maryland, along with that
--     studen'ts Name, Major, city, and GPA
-- Working
SELECT t.SL, t.SF, MIN(t.MajorGPA)
FROM(
    SELECT (SUM((C.Credits * GC.gradepoint))/SUM(C.Credits)) as MajorGPA,S.Fname as SF, S.Lname as SL
    FROM Student as S, Enrolled_in as EI, Course as C, Gradeconversion as GC,
         City as Ci
    WHERE S.StuID = EI.StuID 
        AND S.city_code = Ci.city_code AND Ci.state = "MD"
        AND EI.CID = C.CID AND EI.Grade = GC.lettergrade 
        GROUP BY S.Lname 
) as t;

-- 58. List the name and student ID of the student (or students) with the highest GPA
--     who play Lacrosse more than 16 hours per week.
-- Working
SELECT fs.SL as LastName, fs.SF as FirstName, fs.SSI as StudentID, fs.MajorGPA as MaxGPa
FROM (
    SELECT (SUM((C.Credits * GC.gradepoint))/SUM(C.Credits)) as MajorGPA,S.Fname as SF, S.Lname as SL, S.StuID as SSI
    FROM Student as S, Enrolled_in as EI, Course as C, Gradeconversion as GC,
        SportsInfo as SI
    WHERE S.StuID = EI.StuID AND S.StuID = SI.StuID AND SI.SportName = "Lacrosse"
        AND SI.HoursPerWeek > 16  
        AND EI.CID = C.CID AND EI.Grade = GC.lettergrade 
        GROUP BY SL 
    ) as fs
    HAVING fs.MajorGPA = 
        (SELECT MAX(t.MajorGPA) as gpa
            FROM(
                SELECT (SUM((C.Credits * GC.gradepoint))/SUM(C.Credits)) as MajorGPA,S.Fname as SF, S.Lname as SL
                FROM Student as S, Enrolled_in as EI, Course as C, Gradeconversion as GC,
                    SportsInfo as SI
                WHERE S.StuID = EI.StuID AND S.StuID = SI.StuID AND SI.SportName = "Lacrosse"
                    AND SI.HoursPerWeek > 16 
                    AND EI.CID = C.CID AND EI.Grade = GC.lettergrade 
                GROUP BY S.Lname 
                ) as t
        );

-- 59. List the names of students who either live with someone who plays video games
--     OR are not members of any club
-- Working
SELECT *
 FROM       ( 
        SELECT S.StuID as ID1, LI.dormid as Dorm, LI.room_number as Room, S.Lname as LastName, S.Fname as FirstName
        FROM Student as S, Lives_in as LI
        WHERE S.stuid IN(SELECT PG.StuID FROM Plays_Games as PG) 
                AND S.StuID = LI.StuID 
        union
        SELECT S.StuID as S2, LI.dormid as SD2, LI.room_number as SR2, S.Lname as SL, S.Fname as SF
        FROM Student as S, Lives_in as LI
        WHERE S.StuID NOT IN(SELECT MoC.StuID FROM Member_of_club as MoC)
                AND S.StuID = LI.StuID
        )  as t,
        (
        SELECT S.StuID as ID2, LI.dormid as Dorm, LI.room_number as Room, S.Lname as LastName, S.Fname as FirstName
        FROM Student as S, Lives_in as LI
        WHERE S.stuid IN(SELECT PG.StuID FROM Plays_Games as PG) 
                AND S.StuID = LI.StuID 
        union
        SELECT S.StuID as S2, LI.dormid as SD2, LI.room_number as SR2, S.Lname as SL, S.Fname as SF
        FROM Student as S, Lives_in as LI
        WHERE S.StuID NOT IN(SELECT MoC.StuID FROM Member_of_club as MoC)
                AND S.StuID = LI.StuID
        )  as t1
    WHERE t.Dorm = t1.Dorm AND t.Room = t1.Room AND t.ID1 != t1.ID2 AND t1.ID2 < t.ID1;

-- 60. List the names of every department and the total number of hours their majors play
--     video games (you can omit departments where no major plays video games)
-- Working
SELECT D.DNO, SUM(PG.Hours_Played)
FROM Plays_Games as PG, Department as D, Student as S
WHERE S.StuID = PG.StuID AND S.Major = D.DNO
GROUP BY D.DNO;

-- 62. List the names of courses that are taught by faculty who participate in the same
--     activity as at least one of the students in that course.    
-- Working
SELECT DISTINCT(A.activity_name)
FROM Course as C, Student as S, Faculty as F, Enrolled_in as EI, Participates_in as PI,
    Activity as A, Faculty_Participates_in as FPI
WHERE C.CID = EI.CID AND EI.StuID = S.StuID
        AND C.Instructor = F.FacID
        AND S.StuID = PI.StuID
        AND F.FacID = FPI.FacID 
        AND PI.actid = FPI.actid
        AND A.actid = FPI.actid;

/*
SELECT C.CID, C.CName, S.StuID
FROM Course as C, Student as S, Enrolled_in as EI
WHERE C.CID = EI.CID AND EI.StuID = S.StuID 
GROUP BY C.CID;
*/

-- 64. List the average money spent at restaurants by students who only visit "Sandwich"
--     type restaurants
-- Working
SELECT VR.StuID, AVG(VR.Spent)
FROM Restaurant_Type as RT, Type_Of_Restaurant as ToR, Restaurant as R, Visits_Restaurant as VR
WHERE RT.ResTypeID = ToR.ResTypeID AND RT.ResTypeName = "Sandwich" AND R.ResID = ToR.ResID
    AND VR.ResID = R.ResID;

-- 65. List names and StuID's of all students who have at least one allergy and have at least
--     one roommate.
-- Working
SELECT DISTINCT(S.Fname) as FN1, S.Lname as LN1, LI1.dormid, LI1.room_number
    FROM Student as S, Student as S2, Enrolled_in as EI1, Enrolled_in as EI2, Course as C,
         Lives_in as LI1, Lives_in as LI2
    WHERE S.StuID = EI1.StuID  AND EI1.CID = C.CID AND S2.StuID = EI2.StuID 
        AND EI1.CID = EI2.CID  AND (S.Fname != S2.Fname AND S.LName != S2.LName)
        AND S.StuID = LI1.StuID AND S2.StuID = LI2.StuID
        AND LI1.room_number = LI2.room_number AND LI1.dormid = LI2.dormid
        AND S.StuID IN (SELECT StuID FROM Has_Allergy) 
        AND S2.StuID IN (SELECT StuID FROM Has_Allergy); 

-- 66. List the name of the dorm with the highest percentage of students who own pets and
--     what that percentage is
-- Working
SELECT fs.TL as DormID, fs.tDN as DormName, fs.pc as Percent
FROM (
    SELECT t.LID as TL, t.DN as tDN, (s.cct/t.ct) as pc
        FROM
        (
            SELECT LI.DormID as LID, D.dorm_name as DN, COUNT(LI.StuID) as ct
            FROM Lives_in as LI, Dorm as D
            WHERE LI.dormid = D.dormid
            GROUP BY LI.DormID
        ) as t, 
        (
            SELECT DISTINCT(LI.DormID) as LID, COUNT(HP.StuID) as cct
            FROM Has_Pet as HP, Lives_in as LI
            WHERE HP.StuID = LI.StuID
            GROUP BY LI.DormID
        ) as s
        WHERE t.LID = s.LID
    ) as fs
    HAVING ABS ((fs.pc) -
        (SELECT MAX(s.cct/t.ct)
            FROM
            (
                SELECT LI.DormID as LID, COUNT(LI.StuID) as ct
                FROM Lives_in as LI
                GROUP BY LI.DormID
            ) as t, 
            (
                SELECT DISTINCT(LI.DormID) as LID, COUNT(HP.StuID) as cct
                FROM Has_Pet as HP, Lives_in as LI
                WHERE HP.StuID = LI.StuID
                GROUP BY LI.DormID
            ) as s
            WHERE t.LID = s.LID
        )) <=.0001;

-- 67. Be Creative, or something
--     List all student names and major by name who are not from Baltimore, but own a cat
SELECT DISTINCT(S.Lname), S.Fname, D.DName
From Student as S, Department as D, Has_Pet as HP, Pets as P, City as C
WHERE S.StuID = HP.StuID AND S.Major = D.DNO
    AND S.city_code = C.city_code AND C.city_name != "Baltimore"
    AND HP.PetID = P.PetID AND P.PetType = "cat";

    -- To show it works, look for only those who live in Baltimore
SELECT DISTINCT(S.Lname), S.Fname, D.DName
From Student as S, Department as D, Has_Pet as HP, Pets as P, City as C
WHERE S.StuID = HP.StuID AND S.Major = D.DNO
    AND S.city_code = C.city_code AND C.city_name = "Baltimore"
    AND HP.PetID = P.PetID AND P.PetType = "cat";
