class View
  def display_recipes(all_recipes)
    all_recipes.each_with_index do |recipe, index|
      puts "#{index + 1}. #{recipe.name} (#{recipe.prep_time})"
    end
  end

  def ask_for(label)
    puts "What's your recipe #{label}?"
    gets.chomp
  end

  def ask_for_index(action)
    puts "Which one do you want to #{action}?"
    gets.chomp.to_i
  end
end
