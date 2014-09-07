#################
	#REQUIREMENTS
#################
require 'sinatra'
require 'sinatra/reloader'
require 'pg'

require_relative 'models/recipe'
require_relative 'models/ingredient'

DATABASE = 'recipes'

#################
	#CONFIGURE
#################

configure :development, :test do
  require 'pry'
end


#################
#SERVER METHODS
#################

def db_connection
  begin
    connection = PG.connect(dbname: DATABASE)

    yield(connection)

  ensure
    connection.close
  end
end 


#################
		#ROUTES
#################

get '/' do
  erb :'index'
end

get '/recipes' do
  @recipes = Recipe.all

  erb :'recipes/index'
end

get '/recipes/:id' do
  @recipe = Recipe.find(params[:id])

  erb :'recipes/show'
end
