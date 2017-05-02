require './spec/support/active_record'
require 'database_cleaner'
require 'factory_girl'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'sinatra'
require 'timecop'
require File.expand_path '../../app.rb', __FILE__

ActiveRecord::Base.logger = nil

Capybara.app = SmWorkflowLims

Capybara.javascript_driver = :poltergeist

RSpec.configure do |config|

  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    FactoryGirl.find_definitions
  end

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end