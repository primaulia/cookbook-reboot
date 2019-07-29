require_relative 'cookbook'    # You need to create this file!
require_relative 'controller'  # You need to create this file!
require_relative 'router'

# make sure pointing to file path relative to app.rb
csv_file   = File.join(__dir__, 'recipes.csv')
cookbook   = Cookbook.new(csv_file)
controller = Controller.new(cookbook)

router = Router.new(controller)

# Start the app
router.run
