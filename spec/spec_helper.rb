ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment",__FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'database_cleaner'
require 'factory_girl'
require 'haml'
require 'support/controller_macros'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include Haml::Helpers, type: :helper
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :view
  config.extend ControllerMacros
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :view
  config.before(:each, type: :helper) do |_config|
    init_haml_helpers
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # config.before(:all) do
  #   FactoryGirl.reload
  # end
  module RequestSpecHelper
    def login(user)
      post_via_redirect user_session_path, 'user[email]' => user.email, 'user[password]' => user.password
    end
  end
end
