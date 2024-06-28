/* Q1: Find the names of all reviewers who rated Gone with the Wind. */
select distinct name
from reviewer natural join rating natural join movie
where title = 'Gone with the Wind';
---

/* Q2: For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars. */
select name, title, stars
from reviewer natural join rating natural join movie
where director = name; 
---

/* Q3: Return all reviewer names and movie names together in a single list, alphabetized. */
select name from reviewer
union
select title from movie;
---

/* Q4: Find the titles of all movies not reviewed by Chris Jackson. */
select title  
from movie
except
select title 
from reviewer natural join rating natural join movie
where name in ('Chris Jackson');
---

/* Q5: For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. 
Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. 
For each pair, return the names in the pair in alphabetical order. */
select distinct re1.name, re2.name
from reviewer re1, reviewer re2, rating ra1, rating ra2
where re1.rID = ra1.rID
and re2.rID = ra2.rID
and ra1.mID = ra2.mID
and re1.name < re2.name
order by re1.name;
---

/* Q6: For each rating that is the lowest (fewest stars) currently in the database, 
return the reviewer name, movie title, and number of stars. */
select name, title, stars
from reviewer natural join rating natural join movie
where stars = (select min(stars) from rating);
---

/* Q7: List movie titles and average ratings, from highest-rated to lowest-rated. 
If two or more movies have the same average rating, list them in alphabetical order. */
select title, avg(stars)
from rating natural join movie
group by title
order by avg(stars) desc, title;
---

/* Q8: Find the names of all reviewers who have contributed three or more ratings. */
select name
from reviewer natural join rating
group by name
having count(*) > 2;
---

/* Q9: Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, 
along with the director name. Sort by director name, then movie title. */
select title, director
from movie
where director in (select director 
				   from movie 
				   group by director 
				   having count(*) > 1)
order by director, title;
---

/* Q10: Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. */
select title, avg(stars)
from movie inner join rating using (mID)
group by mID
having avg(stars) = (select max(avg_stars)
					 from (select title, avg(stars) as avg_stars
						   from movie inner join rating using (mID)
						  group by mID));
---

/* Q11: Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. */
select title, avg(stars)
from movie inner join rating using (mID)
group by mID
having avg(stars) = (select min(avg_stars)
					 from (select title, avg(stars) as avg_stars
						   from movie inner join rating using (mID)
						  group by mID));
---

/* Q12: For each director, return the director's name together with the title(s) of the movie(s) 
they directed that received the highest rating among all of their movies, and the value of that rating. 
Ignore movies whose director is NULL. */
select director, title, max(stars)
from movie, rating
where movie.mID = rating.mID
and director is not null
group by director;
---
