require_relative 'recipe'
require 'csv'
require 'pry-byebug'

class Cookbook
  # @recipes = array of Recipe instance
  def initialize(csv_file_path)
    @recipes = [] # short term memory
    @file_path = csv_file_path

    # parse the csv file
    parse_csv if File.exist? @file_path # from LONG TERM to SHORT TERM
  end

  # behavior
  def all
    @recipes # return all Recipe instances
  end

  def add_recipe(recipe)
    @recipes << recipe # add new Recipe instance to the @recipes array
    # STORE TO CSV - FROM SHORT TERM TO LONG TERM
    store_csv
  end

  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index) # remove Recipe instance from @recipes array
    # STORE TO CSV - FROM SHORT TERM TO LONG TERM
    store_csv
  end

  # def edit_recipe(recipe_index, new_description)
  #   # get the recipe by index
  #   recipe_to_edit = @recipes[recipe_index]
  #   # change the description
  #   recipe_to_edit.description = new_description
  #   # store that to csv again
  #   store_csv
  # end

  private

  def store_csv
    csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }

    CSV.open(@file_path, 'wb', csv_options) do |csv|
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description] # writing one row to csv
      end
    end
  end

  def parse_csv
    CSV.foreach(@file_path) do |row|
      @recipes << Recipe.new(
        name: row[0],
        description: row[1]
      )
    end
  end
end












