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
  movies.sort_by!{|movie| movie[:title]}
end

get '/' do
  redirect '/movies'
end

get '/movies' do
  @movies = read_movies
  @page = params[:page]
  @page ||= 1
  @query = params[:query]
  @movies = @movies[(@page.to_i-1)*20..(@page.to_i*20)]
  if params[:query]
    @matches = []
    read_movies.each do |movie|
      # binding.pry
      if movie[:title].downcase.include?(@query) || movie[:synopsis].to_s.downcase.include?(@query)
        # binding.pry
        @matches << movie
      end
    end
    @movies = @matches
  end
  # binding.pry
  erb :collection
end


get '/movies/:movie_id' do
  id = params[:movie_id]
  @movie = read_movies.find do |movie|
    movie[:id] == id
  end
  erb :movie
end
