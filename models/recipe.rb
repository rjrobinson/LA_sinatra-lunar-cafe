require_relative '../server'
require_relative 'ingredient'
require 'pry'


class Recipe

	attr_reader :id, :name, :description, :instructions, :ingredients


	def initialize(hash)
		@id = hash['id']
		@name = hash['name']
		@instructions = hash['instructions'] || "This recipe doesn't have any instructions."
		@description = hash['description'] || "This recipe doesn't have a description."
		@ingredients = get_ingredients

	end

	def get_ingredients
		Ingredient.all(id)
	end


	def self.db_connection
		begin
		connection = PG.connect(dbname: 'recipes')

		yield(connection)

		ensure
		connection.close
		end
	end 

  def self.all
  	sql = 'Select * FROM recipes'
  	all_recpies = []
  	results = db_connection do |conn|
  		conn.exec(sql)
  	end
  	results.each do |result|
  		all_recpies << Recipe.new(result)
  	end
  	all_recpies
  end

  def self.find(primary_key)
  	sql = 'SELECT * FROM recipes WHERE id = $1 LIMIT 1'

  	selected = db_connection do |conn|
  		conn.exec_params(sql, [primary_key])
  	end
  	 recipe = Recipe.new(selected.first)
  end

end #CLASS END

