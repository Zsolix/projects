/*A The Curriculum Planning Committee is attempting to fill in gaps in the current course offerings. You need to provide them with a query which lists each department and the number of courses offered by that department. The two columns should have headers “Department Name” and “# Courses”, and the output should be sorted by “# Courses” in each department (ascending).*/
SELECT department.name 'Department Name', COUNT(*) '# Courses'
FROM department JOIN course ON department.id = course.deptId
GROUP BY department.name
ORDER BY 2

/* B The recruiting department needs to know which courses are most popular with the students. Please provide them with a query which lists the name of each course and the number of students in that course. The two columns should have headers “Course Name” and “# Students”, and the output should be sorted first by # Students descending and then by course name ascending.*/
SELECT course.name 'Course Name', studentcourse.studentId '# Students'
FROM course JOIN studentcourse 
ON course.id = studentcourse.courseId
GROUP BY course.name
ORDER BY studentId DESC, courseid ASC;

/* C1  Write a query to list the names of all courses where the # of faculty assigned to those courses is zero. The output should be in alphabetical order by course name.*/ 
SELECT name, courseId '# of faculty assigned'
FROM course left JOIN facultycourse ON course.id=facultycourse.courseid
WHERE facultycourse.facultyId IS NULL
ORDER BY course.name ASC

/* C2 Using the above, write a query to list the course names and the # of students in those courses for all courses where there are no assigned faculty. The output should be ordered first by # of students descending and then by course name ascending.*/
SELECT name, studentId '# of students'
FROM course JOIN studentCourse ON course.id=studentCourse.courseid
WHERE course.name IN (select course.name FROM course LEFT JOIN facultycourse ON course.id=facultycourse.courseId
WHERE facultycourse.facultyId IS NULL)
GROUP BY course.name

/* D The enrollment team is gathering analytics about student enrollment throughout the years. Write a query that lists the total # of students that were enrolled in classes during each school year. The first column should have the header “Students”. Provide a second “Year” column showing the enrollment year.*/
SELECT count(studentId) 'Students', startDate 'Year'
FROM studentCourse 
GROUP BY YEAR(startDate)

/* E. The enrollment team is gathering analytics about student enrollment and they now want to know about August admissions specifically. Write a query that lists the Start Date and # of Students who enrolled in classes in August of each year. The output should be ordered by start date ascending.*/
SELECT startDate, count(studentid) '# of students'
FROM studentCourse
WHERE MONTH(startDate) = 8
GROUP BY YEAR(startDate)
ORDER BY startDate ASC

/* F. Students are required to take 4 courses, and at least two of these courses must be from the department of their major. Write a query to list students’ First Name, Last Name, and Number of Courses they are taking in their major department. The output should be sorted first in increasing order of the number of courses, then by student last name.*/
SELECT student.firstname, student.lastname, COUNT(course.name) 'Number of Courses'
FROM student JOIN department ON student.majorId=department.id JOIN course ON department.id=course.deptId
GROUP BY student.lastname
ORDER BY COUNT(course.name), student.lastname

/* G. Students making average progress in their courses of less than 50% need to be offered tutoring assistance. Write a query to list First Name, Last Name and Average Progress of all students achieving average progress of less than 50%. The average progress as displayed should be rounded to one decimal place. Sort the output by average progress descending.*/
SELECT student.firstname,student.lastname, round(avg(progress),1) 'Average Progress'
FROM studentCourse JOIN student ON studentCourse.studentId=student.id
WHERE progress < 50
GROUP BY studentId
ORDER BY avg(progress) desc

/* H1 Write a query to list each Course Name and the Average Progress of students in that course. The output should be sorted descending by average progress.*/
SELECT course.name, avg(progress) 'Average Progress'
FROM course JOIN studentCourse ON course.id=studentCourse.courseId
GROUP BY course.name
ORDER BY avg(progress) desc

/* H2 Write a query that selects the maximum value of the average progress reported by the previous query.*/
SELECT max(value) 
FROM (select avg(progress) 'value' 
FROM course JOIN studentCourse ON course.id=studentCourse.courseId
GROUP BY course.name) AS alias

/* H3 Write a query that outputs the faculty First Name, Last Name, and average of the progress (“Avg. Progress”) made over all of their courses.*/
select firstname, lastname, Avg(Progress) as Progress from
faculty join facultyCourse on id=FacultyId
join studentCourse on facultyCourse.CourseId=studentCourse.CourseId
where facultyCourse.CourseId=studentCourse.CourseId
group by 1;

/* H4  Write a query just like #3, but where only those faculty where average progress in their courses is 90% or more of the maximum observed in #2.*/
select concat(firstname, lastname), AVG(Progress) as Progress from
faculty join facultyCourse on id=FacultyId
join studentCourse on facultyCourse.CourseId=studentCourse.CourseId
WHERE progress >= ((SELECT .1 * MAX(VALUE) FROM (select avg(progress) 'value' 
FROM course JOIN studentCourse ON course.id=studentCourse.courseId
GROUP BY course.name) AS alias))
group BY 1
ORDER BY 2;

/* I Write a query that displays each student’s First Name, Last Name, Min Grade based on minimum progress, and Max Grade based on maximum progress.*/
SELECT firstname, lastname, MIN(studentCourse.progress) 'Min Grade', MAX(studentCourse.progress)'Max Grade'
FROM student JOIN studentCourse ON student.id=studentCourse.studentId
GROUP BY lastname
