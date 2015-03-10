require 'pg'
require 'pry'

def db_connection
  begin
    connection = PG.connect(dbname: "recipes")
    yield(connection)
  ensure
    connection.close
  end
end

#db_connection { |conn| conn.exec('SELECT * FROM recipes') }

class Recipe


  def initialize(id, name, instructions, description)
    @id = id
    @name = name
    @instructions = instructions
    @description = description
  end

  attr_reader :id, :name, :instructions, :description

  def self.all
  recipe_list = []
    results = db_connection { |conn| conn.exec("SELECT * FROM recipes ORDER BY name") }
    results.each do |result|
      recipe_list << Recipe.new( result['id'], result['name'], result['instructions'], result['description'] )
    end
  recipe_list
  #binding.pry
  end

  def self.find( id )
    db_connection do |conn|
      results = conn.exec_params('SELECT * FROM recipes WHERE id = $1',[id])[0]
      Recipe.new( results['id'], results['name'], results['instructions'], results['description'] )
    end
  rescue IndexError
    Recipe.new(id, "This recipe doesn't have a name.",
    "This recipe doesn't have any instructions.",
    "This recipe doesn't have a description.")
  end

  def ingredients
    ingredients_list = []
    db_connection do |conn|
      results = conn.exec_params('SELECT ingredients.id, ingredients.name, ingredients.recipe_id FROM ingredients JOIN recipes ON ingredients.recipe_id = recipes.id' \
        ' WHERE ingredients.recipe_id = $1',[@id])
        results.each do |row|
          ingredients_list << Ingredient.new( row['id'], row['name'], row['recipe_id'] )
        end
    end
    ingredients_list
  end


end

#puts Recipe.all
