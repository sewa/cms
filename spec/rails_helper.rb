ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../dummy/config/environment', __FILE__)
require 'rspec/rails'
require 'factory_girl_rails'
require 'shoulda-matchers'

ENGINE_RAILS_ROOT=File.join(File.dirname(__FILE__), '../')
Dir[Rails.root.join('../support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
end
