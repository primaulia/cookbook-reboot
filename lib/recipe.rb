class Recipe
  attr_reader :name, :description, :prep_time

  def initialize(attributes = {})
    @name = attributes[:name]
    @description = attributes[:description] || 'N/A'
    @prep_time = attributes[:prep_time] || 'N/A'
    @difficulty = attributes[:difficulty] || 'easy'
  end
end
