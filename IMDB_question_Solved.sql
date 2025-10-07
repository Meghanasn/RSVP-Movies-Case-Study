USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

-- Finding Total no of Rows for Table movie
SELECT COUNT(*) AS movie_table_total_row FROM movie;
-- Ans : 7997

-- Finding Total no of Rows for Table genre
SELECT COUNT(*) AS genre_table_total_row FROM genre;
-- Ans : 14662

-- Finding Total no of Rows for Table director_mapping
SELECT COUNT(*) AS director_mapping_table_total_row FROM director_mapping;
-- Ans : 3867

-- Finding Total no of Rows for Table role_mapping
SELECT COUNT(*) AS role_mapping_table_total_row FROM role_mapping;
-- Ans : 15615

-- Finding Total no of Rows for Table names
SELECT COUNT(*) AS names_table_total_row FROM names;
-- Ans : 25735

-- Finding Total no of Rows for Table ratings
SELECT COUNT(*) AS ratings_table_total_row FROM ratings;
-- Ans : 7997






-- Q2. Which columns in the movie table have null values?
-- Type your code below:
-- id, title, year, date_published, duration, country, worlwide_gross_income, languages, production_company

-- Data Exploration
select count(*) AS id_NULL from movie
where id IS NULL;
select count(*) AS title_NULL  from movie
where title IS NULL;
select count(*) AS year_NULL from movie
where year IS NULL;
select count(*)AS date_published_NULL from movie
where date_published IS NULL;
select count(*) AS duration_NULL from movie
where duration IS NULL;
select count(*) AS country_NULL from movie
where country IS NULL;
select count(*) AS worlwide_gross_income_NULL from movie
where worlwide_gross_income IS NULL;
select count(*) AS languages_NULL from movie
where languages IS NULL;
select count(*)AS production_company_NULL from movie
where production_company IS NULL;


-- Query to find the Column Names with NULL values Together 
SELECT
    COUNT(CASE WHEN id IS NULL THEN 1 END) AS id_null,
    COUNT(CASE WHEN title IS NULL THEN 1 END) AS title_null,
    COUNT(CASE WHEN year IS NULL THEN 1 END) AS year_null,
    COUNT(CASE WHEN date_published IS NULL THEN 1 END) AS date_published_null,
    COUNT(CASE WHEN duration IS NULL THEN 1 END) AS duration_null,
    COUNT(CASE WHEN country IS NULL THEN 1 END) AS country_null,
    COUNT(CASE WHEN worlwide_gross_income IS NULL THEN 1 END) AS worlwide_gross_income_null,
    COUNT(CASE WHEN languages IS NULL THEN 1 END) AS languages_null,
    COUNT(CASE WHEN production_company IS NULL THEN 1 END) AS production_company_null
FROM movie;


-- Ans : country, worlwide_gross_income, languages, production_company. These 4 columns has Null values





-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Query for the first part: -- Year wise movie count
SELECT year AS Year, COUNT(id) AS number_of_movies 
FROM movie
GROUP BY YEAR;


-- Query for the second part: -- month wise movie count
SELECT MONTH(date_published) AS month_num, count(id) AS number_of_movies 
FROM movie
GROUP BY MONTH(date_published)
ORDER BY count(id) DESC;

-- Added Order By to match next query requirement.


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

-- Exploring the data
SELECT 
	COUNT(CASE WHEN UPPER(country) LIKE '%USA%' THEN 1 END) AS USA_Movies,
    COUNT(CASE WHEN UPPER(country) LIKE '%INDIA%' THEN 1 END) AS INDIA_Movies
FROM movie WHERE year = 2019;

-- USA - 758, India - 309

-- Calculating the movie count which were produced in the USA or India in the year 2019
SELECT count(id) AS USA_India_total_movie_count
from movie
WHERE year = 2019 AND (UPPER(country) LIKE '%USA%' OR UPPER(country) LIKE '%INDIA%');

-- Ans : 1059





/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:


SELECT DISTINCT genre AS Unique_List_of_Genre FROM genre;

-- Ans :
/*
# Unique_List_of_Genre
'Thriller'
'Sci-Fi'
'Romance'
'Others'
'Mystery'
'Horror'
'Fantasy'
'Family'
'Drama'
'Crime'
'Comedy'
'Adventure'
'Action'
*/



/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

WITH count_of_movies_per_genre AS (
	SELECT genre, count(movie_id) AS genre_count,
		RANK() OVER(ORDER BY count(genre) DESC) AS genre_count_Rank
	FROM genre
	GROUP BY genre
) 
SELECT * FROM count_of_movies_per_genre 
	WHERE genre_count_Rank = 1;

-- Ans : Drama




/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:


WITH find_movies_with_only_1_genre AS (
	SELECT  count(movie_id) AS Movie_Count
	FROM genre
	group by movie_id
	HAVING count(movie_id) = 1
)
SELECT count(Movie_Count) AS Total_Movie_Count
FROM find_movies_with_only_1_genre;

-- Ans : 3289






/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:



SELECT genre, AVG(duration) AS avg_duration
	FROM genre as g
	INNER JOIN movie as m
	ON g.movie_id = m.id
GROUP BY genre
ORDER BY avg(duration) DESC ;





/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:


WITH thriller_rank AS (
	SELECT genre, count(genre) AS movie_count,
		RANK() OVER(ORDER BY count(genre) DESC) AS genre_rank
		FROM genre as g
		INNER JOIN movie as m
		ON g.movie_id = m.id
	GROUP BY genre
	ORDER BY count(genre) DESC
) 
SELECT * FROM thriller_rank 
	WHERE genre = 'thriller';



-- Ans : Genre Thriller secures rank 3.



/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

-- movie_id,	avg_rating,	total_votes,	median_rating


SELECT
    ROUND(MIN(avg_rating)) AS min_avg_rating,		-- Rounding the avg_rating min and max values as in Output structure whole integer numbers expected.
    ROUND(MAX(avg_rating)) AS max_avg_rating,		-- Without any Decimal points
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
    
FROM ratings;


    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- Keep in mind that multiple movies can be at the same rank. You only have to find out the top 10 movies (if there are more than one movies at the 10th place, consider them all.)

WITH rating_rank AS (
	SELECT title, avg_rating,
		RANK() OVER(ORDER BY avg_rating DESC) AS movie_rank
		FROM ratings as r
			INNER JOIN movie as m
			ON r.movie_id = m.id
)
SELECT * FROM rating_rank
WHERE movie_rank <= 10;




/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

-- ORDER BY median_rating
SELECT median_rating, count(movie_id) AS movie_count
FROM ratings
GROUP BY median_rating 
ORDER BY median_rating;

-- ORDER BY count(movie_id) to find highest number for the next Question
SELECT median_rating, count(movie_id) AS movie_count
FROM ratings
GROUP BY median_rating 
ORDER BY count(movie_id) DESC;







/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:


SELECT production_company, COUNT(movie_id) AS movie_count, 
	DENSE_RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS prod_company_rank
	FROM movie m
	INNER JOIN ratings r 
	ON m.id = r.movie_id
WHERE production_company IS NOT NULL AND avg_rating > 8
GROUP BY production_company ;





-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:



SELECT genre, COUNT(m.id) AS movie_count
	FROM genre as g
    INNER JOIN movie m 
		ON g.movie_id = m.id 
	INNER JOIN 
	ratings r
		ON m.id = r.movie_id 
WHERE m.year = 2017 
	AND month(m.date_published) = 3 
	AND UPPER(m.country) LIKE '%USA%'
    AND r.total_votes > 1000
GROUP BY year, genre
ORDER BY genre DESC;  -- DESC used to get the output format starting with Thriller as shown in the sample





-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:





SELECT title, avg_rating, genre
	FROM genre as g
    INNER JOIN movie m 
		ON g.movie_id = m.id 
	INNER JOIN 
	ratings r
		ON m.id = r.movie_id 
WHERE avg_rating > 8 
	AND lower(title) LIKE 'the%'
ORDER BY genre DESC;  -- Added order by to sync with the output format starting with Thriller






-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:



select count(id) AS movie_count_with_MR8		-- MR8 signifies as Median rating of 8
from movie m
INNER JOIN 
	ratings r
		ON m.id = r.movie_id  
where r.median_rating = 8
AND m.date_published between '2018/04/01' AND '2019/04/01';


-- Ans : 361





-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT 
	SUM(CASE WHEN UPPER(country) LIKE '%GERMANY%' THEN total_votes END) 
		AS vote_count_For_Germany,
    SUM(CASE WHEN UPPER(country) LIKE '%ITALY%' THEN total_votes END) 
		AS vote_count_For_Italy
FROM movie m
INNER JOIN 
	ratings r
		ON m.id = r.movie_id ;


-- The Ans is below
# vote_count_For_Germany, vote_count_For_Italy
# '2026223', '703024'
-- So, yes, German movies do get more votes than Italian movies

-- Answer is Yes




/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:


SELECT
    COUNT(CASE WHEN name IS NULL THEN 1 END) AS name_nulls,
    COUNT(CASE WHEN height IS NULL THEN 1 END) AS height_nulls,
    COUNT(CASE WHEN date_of_birth IS NULL THEN 1 END) AS date_of_birth_nulls,
    COUNT(CASE WHEN known_for_movies IS NULL THEN 1 END) AS known_for_movies_nulls
FROM names;





/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:



WITH TOP_3_Director AS (	-- This section finds out the ranks of the directors based on condition given in the question
	WITH Top_3_genre AS ( 	-- This section counts the top 3 Genre from as per condition given in the Question
		SELECT genre from (
				SELECT genre, count(genre) AS genre_count,
					DENSE_RANK() OVER(ORDER BY count(genre) DESC) AS genre_rank
				FROM genre
					INNER JOIN ratings USING (movie_id)
				WHERE avg_rating > 8 
				GROUP BY genre
				ORDER BY count(genre) DESC) 
			AS genre_rank_top3
		WHere genre_rank <= 3
	)
	SELECT name AS director_name, count(movie_id) AS movie_count,
		RANK() OVER (ORDER BY count(movie_id) DESC) AS movie_count_rank
	FROM names n
		LEFT JOIN director_mapping d
			ON n.id = d.name_id
		INNER JOIN ratings USING (movie_id)
		INNER JOIN genre USING (movie_id)
	WHERE avg_rating > 8 
		AND genre IN (SELECT * FROM Top_3_genre) 	-- Here Filteration happening based on the genre
	GROUP BY name_id
)
SELECT director_name, movie_count  		-- This section filters out exact top 3 directors from the above query.
	FROM TOP_3_Director
	WHERE movie_count_rank <= 3;





/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH Top_2_Actor AS (
SELECT DISTINCT name AS actor_name, count(movie_id) AS movie_count,
		RANK() OVER (ORDER BY count(movie_id) DESC) AS movie_count_rank
	FROM names n
		INNER JOIN role_mapping r
			ON n.id = r.name_id
		INNER JOIN ratings USING (movie_id)
	WHERE median_rating >= 8 
	GROUP BY name_id
)
select actor_name, movie_count
FROM Top_2_Actor
WHERE movie_count_rank <= 2;




/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


WITH Top_3_Production_House AS (
	SELECT production_company, SUM(total_votes) AS vote_count,
		RANK() OVER (ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
	FROM ratings r
		INNER JOIN movie m
		ON r.movie_id = m.id
	GROUP BY production_company
) 
SELECT production_company, vote_count, prod_comp_rank
	FROM Top_3_Production_House
    WHERE prod_comp_rank <= 3;







/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:



select n.name AS actor_name, 
	SUM(r.total_votes) AS total_votes,
	COUNT(rm.movie_id) AS movie_count,
    ROUND(SUM(avg_rating*total_votes)/SUM(total_votes) ,2) AS actor_avg_rating, 	-- Calculating weighted average here
    RANK() OVER (ORDER BY ROUND(SUM(avg_rating*total_votes)/SUM(total_votes) ,2) DESC) AS actor_rank		-- creating rank based on the weighted average and displaying them
from role_mapping rm
	INNER JOIN names n
		ON rm.name_id = n.id
	INNER JOIN movie m
		ON rm.movie_id = m.id
	INNER JOIN ratings r
		ON m.id = r.movie_id
where category IN ('actor') 
	AND LOWER(country) LIKE '%india%'
GROUP BY name_id
HAVING COUNT(rm.movie_id) >= 5;







-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:



select n.name AS actress_name, 
	SUM(r.total_votes) AS total_votes,
	COUNT(rm.movie_id) AS movie_count,
    ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actress_avg_rating,		-- Calculating weighted average here
    RANK() OVER (ORDER BY ROUND( SUM(avg_rating*total_votes)/SUM(total_votes) ,2) DESC) AS actress_rank	-- creating rank based on the weighted average and displaying them
from role_mapping rm
	INNER JOIN names n
		ON rm.name_id = n.id
	INNER JOIN movie m
		ON rm.movie_id = m.id
	INNER JOIN ratings r
		ON m.id = r.movie_id
where category IN ('actress') 
	AND LOWER(country) LIKE '%india%'
	AND LOWER(languages) LIKE '%hindi%'
GROUP BY name_id
HAVING COUNT(rm.movie_id) >= 3;





/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories:  

			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop
	
    Note: Sort the output by average ratings (desc).
--------------------------------------------------------------------------------------------*/
/* Output format:
+---------------+-------------------+
| movie_name	|	movie_category	|
+---------------+-------------------+
|	Get Out		|			Hit		|
|		.		|			.		|
|		.		|			.		|
+---------------+-------------------+*/

-- Type your code below:


select title AS movie_name,
	CASE
		when avg_rating > 8 THEN 'Superhit'
		when avg_rating between 7 and 8 then 'Hit'
		when avg_rating between 5 and 7 then 'One-time-watch'
		else 'Flop'
    END  AS movie_category
from genre g
	INNER JOIN ratings r
		ON g.movie_id = r.movie_id
    INNER JOIN movie m
		ON g.movie_id = m.id
where genre = 'Thriller'
	AND total_votes >= 25000
ORDER BY avg_rating DESC;





/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:


select genre, 
	ROUND(avg(duration),2) AS avg_duration,
	SUM(ROUND(avg(duration),2)) OVER (ORDER by genre ROWS UNBOUNDED PRECEDING) as running_total_duration,
	ROUND(AVG(avg(duration)) OVER (ORDER by genre ROWS UNBOUNDED PRECEDING),2) as moving_avg_duration
FROM genre g
	INNER JOIN movie m
	ON m.id = g.movie_id
GROUP BY genre
ORDER BY genre;





-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

-- Data Exploration

SELECT * from movie
where worlwide_gross_income LIKE '%INR%' OR worlwide_gross_income NOT LIKE('%$%');

-- Found 3 values in worlwide_gross_income with INR value and rest all are in dollers. 
-- So, to compare in dollers I need to convert the INR to doller by dividing it to current rate of Doller 84.38

-- Removing INR from the column worlwide_gross_income
UPDATE imdb.movie 
	SET worlwide_gross_income = TRIM(REPLACE(CAST(worlwide_gross_income AS CHAR(4000)), 'INR', ''))
	where id IN ( 'tt6203302', 'tt6417204', 'tt6568474');


-- Now dividing the INR Value with 84.38 to turn it to Doller
UPDATE imdb.movie 
	SET worlwide_gross_income = ROUND(worlwide_gross_income / 84.38, 0)
	where id IN ( 'tt6203302', 'tt6417204', 'tt6568474');


-- Verifying the values after the Doller conversion
select * from movie 
where ID IN ( 'tt6203302', 'tt6417204', 'tt6568474');


-- To Calculate the comparison in the question we need to remove the $ sign as well from the table.
-- We will add a $ symbol later in the output as shown in the sample

select count(*) from movie;

UPDATE imdb.movie 
	SET worlwide_gross_income = TRIM(REPLACE(CAST(worlwide_gross_income AS CHAR(4000)), '$', ''))
	where worlwide_gross_income LIKE '%$%';

-- Checking the update after the removal of $ sign
select * from movie 
where worlwide_gross_income LIKE '%$%';

-- No records came from above query. So, we can consider all the values now in doller value

select * from movie;

-- Final Query to find five highest-grossing movies of each year that belong to the top three genres

WITH TOP_3_Genre AS (			-- Calculating top 3 genre
	select genre, count(DISTINCT movie_id), 
		RANK() OVER (ORDER BY count(DISTINCT movie_id) DESC) AS movie_count
	from genre
	group by genre
	limit 3
),
all_movie_rank AS (				-- Calculating the movie rank as per question
	select genre, year, 
		title as movie_name, 
		CONCAT('$', worlwide_gross_income) AS worlwide_gross_income , 		-- Adding $ sign in the output to get expected sample format
		RANK() OVER(PARTITION BY year, genre ORDER BY CONVERT(worlwide_gross_income, UNSIGNED INT) DESC) AS movie_rank
	from movie m
		INNER JOIN genre g
		ON m.id = g.movie_id
	where worlwide_gross_income IS NOT NULL
		AND genre IN (select genre from TOP_3_Genre)
)
select * from all_movie_rank
where movie_rank <= 5;				-- Selecting top 5 among that




/* -- Ans for Top 3 genre
Drama
Comedy
Thriller
*/





-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH Find_Prod_Comp_List AS (
	select production_company,
		count(id) AS movie_count,
		RANK() OVER ( ORDER BY count(id) DESC) AS prod_comp_rank
	from ratings r 
		INNER JOIN movie m
		ON r.movie_id = m.id
	where median_rating >= 8
		AND production_company IS NOT NULL		
		AND POSITION(',' IN languages)>0	-- Checking if movie is multilingual
	GROUP BY production_company
)
SELECT * from Find_Prod_Comp_List
WHERE prod_comp_rank <= 2;


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (Superhit movie: average rating of movie > 8) in 'drama' genre?

-- Note: Consider only superhit movies to calculate the actress average ratings.
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker. If number of votes are same, sort alphabetically by actress name.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	  actress_avg_rating |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.6000		     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:

WITH Full_Actress_List AS (
	select n.name AS actress_name, 
		SUM(total_votes) AS total_votes,
		COUNT(rm.movie_id) AS movie_count,
		ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actress_avg_rating,		-- Calculating weighted average here
		RANK() OVER (ORDER BY ROUND( SUM(avg_rating*total_votes)/SUM(total_votes) ,2) DESC, name) AS actress_rank	-- creating rank based on the weighted average and displaying them
	from role_mapping rm
		INNER JOIN names n
			ON rm.name_id = n.id
		INNER JOIN genre USING (movie_id)
		INNER JOIN ratings USING (movie_id)
	where category IN ('actress') 
		AND LOWER(genre) LIKE '%drama%'
		AND avg_rating > 8
	GROUP BY name_id
)
select * from Full_Actress_List
where actress_rank <= 3;











/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH TOP_9_Director AS (		-- Finding top 9 director List
	WITH Top_Director_List AS (			-- Calculating the top director List
		select name_id AS director_id, 
			name AS director_name, 
			count(movie_id) AS number_of_movies,
			-- LEAD(date_published) OVER (PARTITION BY name_id ORDER BY date_published, m.id) AS next_date_published,
			ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS avg_rating,		-- Calculating weighted average here
			SUM(total_votes) AS total_votes,
			MIN(avg_rating) AS min_rating,
			MAX(avg_rating) AS max_rating,
			SUM(duration) AS total_duration,
			RANK() OVER(ORDER BY count(movie_id) DESC, name_id) AS director_rank
		from director_mapping d
			INNER JOIN names n
				ON d.name_id = n.id
			INNER JOIN ratings USING (movie_id)
			INNER JOIN movie m
				ON d.movie_id = m.id
		group by name_id
	)
	select * from Top_Director_List
	WHERE director_rank <= 9
),
calculate_inter_diff AS (		-- Calculating the diff between 2 Dates of movie released
	select director_name, date_published,
		LEAD(date_published) OVER (PARTITION BY name_id ORDER BY date_published, m.id) AS next_date_published,
		datediff(LEAD(date_published) OVER (PARTITION BY name_id ORDER BY date_published, m.id), date_published) AS inter_diff
	from TOP_9_Director t
		INNER JOIN director_mapping d
			ON t.director_id = d.name_id
		INNER JOIN movie m
			ON m.id = d.movie_id
),
calculate_avg_inter_diff AS (		-- Calculating average of the diff between 2 Dates of movie released
	select director_name AS dname,
		ROUND(avg(inter_diff), 0) AS avg_inter_movie_days
	FROM calculate_inter_diff
	GROUP BY director_name
)
select director_id, 			-- Building the final structure of the output
	director_name,
    number_of_movies,
    (select avg_inter_movie_days from calculate_avg_inter_diff where dname = director_name) AS avg_inter_movie_days,
    avg_rating,
    total_votes,
    min_rating,
    max_rating,
    total_duration
	from TOP_9_Director 
ORDER BY number_of_movies DESC, avg_rating DESC;

