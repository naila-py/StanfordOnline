/* Q1: For every situation where student A likes student B, but student B likes a different student C, 
return the names and grades of A, B, and C. */
select h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade
from highschooler h1, highschooler h2, highschooler h3, likes
where h1.ID = ID1 and h2.ID = ID2
and h1.ID not in (select ID2 from likes where ID1 = h2.ID)
and h3.ID in (select ID2 from likes where ID1 = h2.ID);
---

/* Q2: Find those students for whom all of their friends are in different grades from themselves. 
Return the students' names and grades. */
select distinct name, grade
from highschooler, friend
where ID not in (select ID1
				 from highschooler h1, highschooler h2, friend
				 where h1.ID = ID1 and h2.ID = ID2
				 and h1.grade = h2.grade);
---

/* Q3: What is the average number of friends per student? */
select avg(fr)
from (select count(ID2) as fr from friend group by ID1);
---

/* Q4: Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. 
Do not count Cassandra, even though technically she is a friend of a friend. */
select count(*)
from friend
where ID1 in (select ID2
			  from friend
			  where ID1 in (select ID
							from highschooler
							where name = 'Cassandra'));
---

/* Q5: Find the name and grade of the student(s) with the greatest number of friends. */
select name, grade
from highschooler, friend
where ID = ID1
group by ID1
having count(*) = (select max(friend_count)
				   from (select count(*) as friend_count
						 from friend
						 group by ID1));
---
