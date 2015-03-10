class Ingredient
  def initialize (id, name, recipe_id)
    @id = id
    @name = name
    @recipe_id = recipe_id
  end

  attr_reader :id, :name, :recipe_id



end
