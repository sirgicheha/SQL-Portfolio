# Dataset Details

>The data is pulled from the TMDB API using LGBT+ keywords, which then returned keywords used in the database. Most keywords were used for the final query, but a few were discarded due to not being relevant (e.g. - 'gender differences').
>
> The keyword array is as follows: ['lgbt', 'gay', 'lesbian','transgender','bisexual','intersex','queer','genderqueer','non-binary','gender', 'asexual']
>
> Source: [TidyRainbow](https://github.com/r-lgbtq/tidyrainbow/tree/main/data/LGBTQ-movie-database)

 Each entry in the [dataset](lgbtqia_movies.csv) includes information such as the movie title, release date, original language, genres, popularity scores, and viewer ratings. This data has been utilized to conduct a comprehensive analysis of trends within LGBTQ+ cinema over recent years.

# Project Overview

The primary objective of this analysis was to explore trends in the release and reception of LGBTQIA+ movies, and insights into their specific genres. Using SQL queries, the project delves into several aspects:

- **Release Trends**: Assessing the frequency and timing of LGBTQ+ movie releases.
- **Geographical Distribution**: Evaluating the languages and countries of origin of these films.
- **Popularity and Ratings**: Analyzing how these movies are received in terms of viewer ratings and popularity metrics.
- **Genre Analysis**: Investigating the genres associated with LGBTQ+ movies and their distribution.

 Despite the main goal of the project being exploration, I still had to employ Python scripts to gather genre data from the TMDB API, as the original dataset did not include the names, but only the `genre ids`. The Python script can be found [here](gather_data.py), which resulted in the dataset [here](genres.csv).

 I also created a way to normalize the main dataset for me to have an accessible table for genre analysis, since the original dataset has a column of list values. The SQL script for this can be found [here](normalize_data.py), and the dataset can be found [here](normalized_data.csv).

  - **SQL Skills Used**: Common Table Expressions (CTEs), Window Functions, Aggregations, Group By, Joins, Date Functions, Data Cleaning, Data Normalization.
  - View EDA SQL Script here: [LGBTQIA+ Movies EDA SQL Script](lgbtmovies_ExploratoryDataAnalysis.sql)
