require 'pry'
require 'csv'
require 'sinatra'
require 'sinatra/reloader'
require './youtube.rb'



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
  @movies = @movies[(@page.to_i-1)*20...(@page.to_i*20)]
  @query = params[:query]
  # @title = @movies[:title]

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
  erb :collection
end


get '/movies/:movie_id' do
  show_layout = params[:layout] ||= false
  id = params[:movie_id]
  @movie = read_movies.find do |movie|
    movie[:id] == id
  end
  @title = @movie[:title]
  @url = get_url(@title)
  # binding.pry
  erb :movie, layout: show_layout
end
