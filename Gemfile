source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.6'
# Use mysql2 as the database for Active Record
gem 'mysql2'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'bootstrap-sass', '3.4.1'

gem 'puma'

# Exception Notification to send exception emails
gem 'exception_notification'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'coveralls', require: false

group :development, :test do
  # Call 'binding.pry' anywhere in the code to stop execution and get a debugger console
  gem 'pry'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  # displays speed badge for every html page
  gem 'rack-mini-profiler'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'spring'
end

group :test do
  gem 'capybara'
  gem 'capybara-selenium'
  gem 'database_cleaner'
  gem 'factory_bot'
  gem 'launchy'
  gem 'rspec-collection_matchers'
  gem 'rspec-rails', '~> 3.5.0'
  gem 'timecop'
  # Keep webdriver in sync with chrome to prevent frustrating CI failures
  gem 'webdrivers', require: false
end
