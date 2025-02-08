# import libraries for api call and csv export
import requests
import csv

url = "https://api.themoviedb.org/3/genre/movie/list?language=en"

headers = {
    "accept": "application/json",
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyY2EyOGRhZjNhYWRiZTAyYjM4ZjI3NmQyNGQyOWU4ZSIsInN1YiI6IjY2NTdjNjBmM2RhZTFmNGU4MWE1MmRkMyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.rH22EaFgcpt8uOZ0WrmePC9eIiyIj1wN1VMvhF-sEFE"
}

response = requests.get(url, headers=headers)

# JSON response to python dictionary

data = response.json()

# Extract genres data
genres = data['genres']

print(genres)

# CSV export
csv_file = 'genres.csv'
csv_headers = ['id', 'genre']

# Writing to csv
with open(csv_file, 'w', newline='', encoding='utf-8') as file:
    writer = csv.DictWriter(file, fieldnames=csv_headers)
    writer.writeheader()
    for genre in genres:
        writer.writerow({'id': genre['id'], 'genre': genre['name']})

print("Genres have been exported to 'genres.csv'")