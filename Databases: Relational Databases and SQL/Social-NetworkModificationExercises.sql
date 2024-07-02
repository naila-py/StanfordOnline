/* Q1: It's time for the seniors to graduate. Remove all 12th graders from Highschooler. */
delete from highschooler
where grade = 12;
---

/* Q2: If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple. */
delete from likes
where ID1 in (select L.ID1
			  from likes L inner join friend F
			  using (ID1)
			  where L.ID2 = F.ID2)
and ID2 not in (select L.ID1
			  	from likes L inner join friend F
			  	using (ID1)
			  	where L.ID2 = F.ID2);
---

/* Q3: For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. 
Do not add duplicate friendships, friendships that already exist, or friendships with oneself. */
insert into friend
select f1.ID1, f2.ID2
from friend f1 join friend f2
on f1.ID2 = f2.ID1
where f1.ID1 <> f2.ID2
except select * from friend;
---
