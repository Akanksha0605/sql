#COMP.5730 Database I Project
#Chenchen Li student ID:01453262, 
#Khandelwal, AkankshaSanjay student ID:01688276


####################################Queries

#1 Find the student's name whose ID = "113".
SELECT name 
FROM student
WHERE ID = '113';


#2 List all courses which title starts with "G".
SELECT title
FROM course
Where title like 'G%';


#3 List all instructor IDs who did not teach any courses in Fall 2016.
SELECT i.ID
FROM instructor i, teaches t
WHERE i.ID = t.ID
EXCEPT
SELECT i1.ID
FROM instructor i1, teaches t1
WHERE i1.ID = t1.ID
	AND t1.semester = 'Fall'
	AND t1.year = '2016';

	
#4 Find the total number of students in each department. Display the number in ascending order.
SELECT dept_name, COUNT (ID) AS num_students
FROM student
GROUP BY dept_name
ORDER BY num_students asc;


#5 Find the name of instructor who teaches the most students.					
SELECT distinct name 
FROM instructor natural join teaches 
WHERE course_id IN (SELECT course_id 
					FROM (SELECT course_id, MAX(mycount)
						  FROM (SELECT course_id, count(ID) as mycount 
						  		FROM takes 
						  		GROUP BY course_id) 
				          GROUP BY course_id)) 
fetch first 1 rows only;						
				
															
#6 List all instructors who teach in all those years that the instructor "McKinnon" teaches.
SELECT ID
FROM instructor i
WHERE NOT EXISTS (SELECT year
				  FROM teaches t1, instructor i1
				  WHERE t1.ID = i1.ID
				  		 AND i1.name = 'McKinnon'
				  		 AND t1.year NOT IN (SELECT t2.year
				  					 FROM teaches t2
				  					 WHERE t2.ID = i.ID));

				  					 
#7 For the department where the instructors have the highest average salary, list the top 2 instructors who have the highest salaries and their salaries.
SELECT * 
FROM instructor 
WHERE salary in (SELECT max(salary)
 				FROM instructor 
 				where dept_name in (SELECT dept_name 
 									FROM (SELECT dept_name, max(average) 
 									      FROM (SELECT dept_name, avg(salary) as average 
 										  		From instructor 
 										  		group by dept_name)
 								          group by dept_name))) 
UNION 
SELECT * 
FROM instructor 
WHERE salary in (SELECT max(salary) 
				FROM instructor 
				WHERE salary NOT IN (select max(salary) 
									 from instructor) 
				and dept_name in (SELECT dept_name from (SELECT dept_name, max(average) 
				      			  						 FROM (SELECT dept_name, avg(salary) as average 
				      			  							   from instructor 
				      			                               group by dept_name)
				      			                         group by dept_name)));
 
		
		
#8 Generate "transcript records" for all students of "Comp. Sci." department. A transcript record should include student name, course title, the year and semester when the student took this course, the credits of this course and the grade of the student on this course. The transcript records from one student should be shown together, and in year, semester descending order. Return only 5 of those transcript records.
SELECT name, title, year, semester, credits, grade 
FROM student, takes, course 
WHERE student.id = takes.id 
      and takes.course_id = course.course_id 
      and student.dept_name='Comp. Sci.' 
order by name, year desc, semester desc
fetch first 5 rows only;
      
      
#9 Increase the salary of instructors whose salary <= 50000 by 10000.
UPDATE instructor
	SET salary = salary + 10000
	WHERE salary <= 50000;

#10 Delete all the records in table "takes" which students' name = "Tomason".			  					
DELETE from takes 
WHERE ID in (select t.ID
			 from takes t, student s
		     WHERE s.name = 'Tomason'
		     AND t.ID = s.ID);



