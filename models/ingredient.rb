require 'pg'
require_relative 'recipe'

class Ingredient

attr_reader :id, :name, :recipe_id


	def initialize(hash)
		@id = hash['id']
		@name = hash['name']
		@recipe_id = hash['recipe_id']
	end

	def self.db_connection
		begin
		connection = PG.connect(dbname: 'recipes')

		yield(connection)

		ensure
		connection.close
		end
	end 

  def self.all(recipe_id)
  	sql = 'Select * FROM ingredients WHERE recipe_id = $1'
  	all_ingredients = []

  	results = db_connection do |conn|
  		conn.exec(sql, [recipe_id])
  		end
  	results.each do |result|
  		all_ingredients << Ingredient.new(result)
  	end
  	all_ingredients
  	end



end # END OF CLASS  #