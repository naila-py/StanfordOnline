/* Q1: Find the names of all students who are friends with someone named Gabriel. */
select name
from highschooler, friend
where ID = ID1
and ID2 in (select ID from highschooler where name = 'Gabriel');
---

/* Q2: For every student who likes someone 2 or more grades younger than themselves, 
return that student's name and grade, and the name and grade of the student they like. */
select h1.name, h1.grade, h2.name, h2.grade
from highschooler h1, highschooler h2, likes
where h1.ID = ID1 and h2.ID = ID2
and h2.grade <= h1.grade - 2;
---

/* Q3: For every pair of students who both like each other, return the name and grade of both students. 
Include each pair only once, with the two names in alphabetical order. */
select h1.name, h1.grade, h2.name, h2.grade
from highschooler h1, highschooler h2, likes
where h1.ID = ID1 and h2.ID = ID2
and (ID1, ID2) in (select h1.ID, h2.ID
				 from highschooler h1, highschooler h2, likes
				 where h2.ID = ID1 and h1.ID = ID2)
and h1.name < h2.name;
---

/* Q4: Find all students who do not appear in the Likes table (as a student who likes or is liked) 
and return their names and grades. Sort by grade, then by name within each grade. */
select distinct name, grade
from highschooler
where ID not in (select ID1 from likes
				 union
				 select ID2 from likes)
order by grade, name;
---

/* Q5: For every situation where student A likes student B, but we have no information about whom B likes 
(that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades. */
select h1.name, h1.grade, h2.name, h2.grade
from highschooler h1, highschooler h2, likes
where h1.ID = ID1 and h2.ID = ID2
and h2.ID not in (select ID1 from likes);
---

/* Q6: Find names and grades of students who only have friends in the same grade. 
Return the result sorted by grade, then by name within each grade. */
select distinct name, grade
from highschooler, friend
where ID not in (select ID1
				 from highschooler h1, highschooler h2, friend
				 where h1.ID = ID1 and h2.ID = ID2
				 and h1.grade <> h2.grade)
order by grade, name;
---

/* Q7: For each student A who likes a student B where the two are not friends, find if they have a friend C in common 
(who can introduce them!). For all such trios, return the name and grade of A, B, and C. */
select h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade
from highschooler h1, highschooler h2, highschooler h3, likes
where h1.ID = ID1 and h2.ID = ID2
and h1.ID not in (select ID2 from friend where ID1 = h2.ID)
and h3.ID in (select ID2 from friend where ID1 = h1.ID 
			  intersect 
			  select ID2 from friend where ID1 = h2.ID);
---

/* Q8: Find the difference between the number of students in the school and the number of different first names. */
select count(name) - count(distinct(name))
from highschooler;
---

/* Q9: Find the name and grade of all students who are liked by more than one other student. */
select name, grade
from highschooler, likes
where ID = ID2 
group by ID
having count(*) > 1;
---
