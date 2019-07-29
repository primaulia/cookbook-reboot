require_relative 'view'
require 'nokogiri'
require 'pry-byebug'
require 'open-uri'

class Controller
  def initialize(cookbook)
    @cookbook = cookbook
    @view = View.new
  end

  def list
    # get all recipes from cookbook
    raw_data = @cookbook.all
    # pass it to a view
    @view.display_recipes(raw_data)
  end

  def create
    # ask my user for recipe name (View)
    new_recipe_name = @view.ask_for('name')
    # ask my user for recipe desc (View)
    new_recipe_description = @view.ask_for('description')
    # create a recipe instance
    new_recipe_instance = Recipe.new(
      name: new_recipe_name,
      description: new_recipe_description
    )
    # use cookbook to add the recipe in
    @cookbook.add_recipe(new_recipe_instance)
  end

  def destroy
    list
    puts
    deleted_index = @view.ask_for_index('delete')
    @cookbook.remove_recipe(deleted_index - 1)
  end

  def import
    # Ask a user for a keyword to search (V)
    keyword = @view.ask_for('keyword')
    puts "Looking for \"#{keyword}\" on LetsCookFrench..."
    puts

    # Make an HTTP request to the recipe's website with our keyword (C)
    # Parse the HTML document to extract the first 5 recipes suggested and store them in an Array (C)
    # Display them in an indexed list (V)
    url = "http://www.letscookfrench.com/recipes/find-recipe.aspx?aqt=#{keyword}" # or 'strawberry.html'
    doc = Nokogiri::HTML(open(url).read)

    scraped_recipes = []
    doc.search('.m_contenu_resultat').each do |element|
      recipe_name = element.search('.m_titre_resultat a').attribute('title').value.strip
      recipe_desc = element.search('.m_texte_resultat').text.strip
      recipe_prep_time = element.search(".m_detail_time > div:first-child").text.strip

      scraped_recipes << Recipe.new(
        name: recipe_name,
        description: recipe_desc,
        prep_time: recipe_prep_time
      ) #create an instance asap
    end

    @view.display_recipes(scraped_recipes)
    # Ask the user which recipe they want to import (ask for an index) (V)
    scraped_recipe_index = @view.ask_for_index('import')
    chosen_recipe = scraped_recipes[scraped_recipe_index - 1]
    # Add it to the Cookbook (Repo)
    @cookbook.add_recipe(chosen_recipe)
  end
end
