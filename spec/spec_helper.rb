require 'chefspec'

RSpec.configure do |config|
  # Specify the Chef log_level (default: :warn)
  # config.log_level = :debug
  
  config.cookbook_path = [ File.expand_path('../..', File.dirname(__FILE__)), File.expand_path('cookbooks', File.dirname(__FILE__)) ]
end
