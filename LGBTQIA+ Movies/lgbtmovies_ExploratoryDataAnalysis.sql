SELECT * FROM genres;

SELECT * FROM lgbtqia_movies;

-- Pre-join the tables for easier querying later on
CREATE VIEW joined_movie_data AS
SELECT m.*, g.genre
FROM lgbtqia_movies m
JOIN movie_genres g ON m.id = g.movie_id
;

-- q1: Are more LGBTQ+ movies being released over time?
SELECT
	YEAR(release_date) AS release_year,
	COUNT(*) AS number_of_movies
FROM
	lgbtqia_movies
GROUP BY
	release_year
ORDER BY
	release_year
;

# Seems like we have data that doesn't have release dates at all
SELECT title,release_date
FROM lgbtqia_movies
WHERE YEAR(release_date) IS NULL;

SELECT * FROM lgbtqia_movies
;

-- q2.1: Where do the most popular LGBTQ+ movies come from? (based on movie's language)
SELECT original_language, COUNT(*) AS number_of_movies
FROM lgbtqia_movies
GROUP BY original_language
ORDER BY number_of_movies DESC
;

-- q2.2: How about in the last 5 years?
SELECT original_language, COUNT(*) AS number_of_movies
FROM lgbtqia_movies
WHERE YEAR(release_date) >= YEAR(CURDATE()) - 5
/*
used current year just to show future updatability.
Will use the last year in the dataset from now on (2022)
*/
GROUP BY original_language
ORDER BY number_of_movies DESC
;

-- q3: What is the average popularity score of LGBTQ+ movies released in the last 5 years?
SELECT YEAR(release_date) AS release_year, ROUND(AVG(popularity),2) AS avg_popularity
FROM lgbtqia_movies
WHERE YEAR(release_date) > 2022 - 5
GROUP BY release_year
ORDER BY release_year
;

-- q4: Which year had the highest average viewer rating (vote_average) for LGBTQ+ movies?
WITH yearlyAvg AS (
	SELECT YEAR(release_date) AS release_year,
	AVG(vote_average) AS avg_rating
	FROM lgbtqia_movies
	GROUP BY release_year
)
SELECT release_year, avg_rating
FROM yearlyAvg
WHERE avg_rating = (SELECT MAX(avg_rating) FROM yearlyAvg)
;

-- q4.2: Seems incomplete. Let's also see its vote_count
WITH yearlyAvg AS (
	SELECT YEAR(release_date) AS release_year,
	AVG(vote_average) AS avg_rating,
	AVG(vote_count) AS avg_votes
	FROM lgbtqia_movies
	GROUP BY release_year
)
SELECT release_year, avg_rating, avg_votes
FROM yearlyAvg
WHERE avg_rating = (SELECT MAX(avg_rating) FROM yearlyAvg)
;

-- q4.3: Let's make it so that it only counts the value if there is at least 100 votes, and there are 5 movies in said year
# This is to avoid bias in the query; there might be a way to best set these thresholds. maybe using percentiles in the data distribution. For now, let's the thresholds be arbitrary
WITH yearlyAvgVoteThreshold AS (
    SELECT YEAR(release_date) AS release_year,
           AVG(vote_average) AS avg_rating,
           COUNT(*) AS movie_count  -- Count the number of movies per year
    FROM lgbtqia_movies
    WHERE vote_count >= 100
    GROUP BY release_year
    HAVING COUNT(*) >= 5  -- Ensure there are at least 5 movies in the year
)
SELECT release_year, avg_rating
FROM yearlyAvgVoteThreshold
WHERE avg_rating = (SELECT MAX(avg_rating) FROM yearlyAvgVoteThreshold)
;

-- q4.5; Interesting. Let's see movies released in 2001.
SELECT title, overview, release_date, popularity, vote_average, vote_count
FROM lgbtqia_movies
WHERE YEAR(release_date) = 2001
;

-- q5: How many LGBTQ+ movies have a vote_count greater than 100?
SELECT COUNT(*) AS movie_count
FROM lgbtqia_movies
WHERE vote_count > 100
;

-- q6: List all LGBTQ+ movies that are labeled as either 'Drama' or 'Romance'.
SELECT title, genre
FROM joined_movie_data
WHERE genre = "Romance" OR genre = "Drama";

-- q6.2: And are Adult
SELECT title, genre
FROM joined_movie_data
WHERE (genre = "Romance" OR genre = "Drama") AND adult = 'True';

-- q6.3: Both Drama and Romance, and is Adult
SELECT 
    title
FROM 
    joined_movie_data
WHERE 
    genre IN ('Drama', 'Romance') AND adult = 'TRUE'
GROUP BY 
    title
HAVING 
    COUNT(DISTINCT genre) = 2;

-- q7: How many LGBTQ+ movies are marked as adult content?
SELECT count(*)
FROM (
	SELECT title
	FROM lgbtqia_movies
	WHERE adult = 'TRUE'
) AS adultMovies
;

-- q8: Find the top 5 most popular LGBTQ+ movies based on their popularity score.
SELECT title, popularity, vote_count # good query to add a vote_count threshold
FROM lgbtqia_movies
ORDER BY popularity DESC
LIMIT 5
;

-- q9: Which month of the year has seen the most releases of LGBTQ+ movies?
SELECT MONTH(release_date) AS release_month, COUNT(*) AS num_movies
FROM lgbtqia_movies
GROUP BY release_month
ORDER BY release_month
;


-- q10: Count the number of LGBTQ+ movies released each year that have a vote_average of at least 8.
SELECT YEAR(release_date) AS release_year, AVG(vote_average) AS avg_vote, count(*) AS count
FROM lgbtqia_movies
WHERE vote_average >= 8 AND YEAR(release_date) IS NOT NULL
GROUP BY release_year
ORDER BY release_year
;

-- q11: Calculate the average popularity of LGBTQ+ movies by language, but only include languages with more than 10 movies released.
SELECT original_language, ROUND(AVG(popularity),2) AS avg_popularity, count(*) AS count
FROM lgbtqia_movies
GROUP BY original_language
HAVING COUNT(title) > 10
ORDER BY avg_popularity DESC
;

-- q12: Identify the year with the most significant increase in the number of LGBTQ+ movie releases compared to the previous year.
WITH yearlyReleases AS (
	SELECT YEAR(release_date) AS release_year, COUNT(*) AS count
	FROM lgbtqia_movies
	GROUP BY release_year
	ORDER BY release_year
)
SELECT
	release_year,
	count,
	count - LAG(count,1) OVER (ORDER BY release_year) AS increase
FROM yearlyReleases
ORDER BY increase DESC
LIMIT 1
;

-- q13: List the top 10 movies by popularity each year for the last decade.
WITH rankedMovies AS (
	SELECT
		title,
		YEAR(release_date) AS release_year,
		RANK() OVER (PARTITION BY
							YEAR(release_date) 
						ORDER BY
							popularity DESC
						) AS year_rank
	FROM
		lgbtqia_movies
	WHERE YEAR(release_date) >= (YEAR(CURDATE()) - 10)
)
SELECT *
FROM rankedMovies
WHERE year_rank <= 10
;

-- q14: What are the total counts for each genre in the dataset, and its percentage against the total? / Which genres are most prevalent in LGBT+ movies?

WITH GenreCounts AS ( # Get genre counts in joined view
    SELECT 
        genre, 
        COUNT(*) AS genre_count
    FROM 
        joined_movie_data
    WHERE genre != ''
    GROUP BY 
        genre
),
TotalMovies AS ( # Table to get total count in data
    SELECT 
        COUNT(*) AS total_count
    FROM 
        lgbtqia_movies
)
SELECT 
    g.genre,
    g.genre_count,
--     t.total_count,
    (g.genre_count * 100.0 / t.total_count) AS percentage
FROM 
	GenreCounts g, 
	TotalMovies t
ORDER BY percentage DESC
;

-- q15: Find the month which consistently has the highest release of LGBTQ+ movies over the years.
SELECT
	MONTH(release_date) AS release_month,
	COUNT(*) AS total_movies
FROM
	lgbtqia_movies
GROUP BY
	release_month
ORDER BY
    total_movies DESC
;

