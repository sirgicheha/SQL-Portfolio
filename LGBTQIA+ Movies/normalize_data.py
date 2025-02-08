import pandas as pd

# Load the movies data
movies_df = pd.read_csv('lgbtqia_movies.csv')

# We need to transform the 'genre_ids' column, which is currently in string form, into a list
# Convert string lists to actual lists
import ast
movies_df['genre_ids'] = movies_df['genre_ids'].apply(ast.literal_eval)

# Explode the DataFrame so each genre ID has its own row along with the movie ID
movie_genre_link_df = movies_df.explode('genre_ids')
movie_genre_link_df = movie_genre_link_df[['id', 'genre_ids']].rename(columns={'id': 'movie_id', 'genre_ids': 'genre_id'})

# Replace the genre IDs with their corresponding names in genres_csv

# Load the genres data
genres_df = pd.read_csv('genres.csv')

# Merge the movie_genre_link_df with the genres_df to get the genre names
movie_genre_name_df = movie_genre_link_df.merge(genres_df, left_on='genre_id', right_on='id', how='left')

# Drop the 'id' column as it is redundant
movie_genre_name_df = movie_genre_name_df.drop(columns=['id','genre_id'])

# Export the normalized data to a CSV file
movie_genre_name_df.to_csv('normalized_data.csv', index=False)