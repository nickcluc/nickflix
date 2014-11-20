require 'pry'
require 'csv'
require 'sinatra'
require 'sinatra/reloader'

def read_movies
  movies = []

  CSV.foreach('movies.csv', headers: true) do |row|
    movies << {
      id: row['id'],
      title: row['title'],
      year: row['year'],
      synopsis: row['synopsis'],
      rating: row['rating'],
      genre: row['genre'],
      studio: row['studio']
    }
  end
  movies
end

get '/movies' do
  @movies = read_moviesß
  erb :collection
end


get '/movies/:movie_id' do
  id = params[:movie_id]
  @movie = read_movies.find do |movie|
    movie[:id] == id
  end
  erb :movie
end
