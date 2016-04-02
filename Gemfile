source 'https://rubygems.org'
ruby '2.1.2'

gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg'
gem 'sluggable_riggs'
gem 'bootstrap_form'
gem 'bcrypt'
gem 'sidekiq'
gem 'carrierwave'
gem 'mini_magick'
gem 'puma'
gem 'foreman'
gem 'sinatra', require: nil
gem 'stripe'


group :development do
  gem 'letter_opener'
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '2.99'
  gem 'fabrication'
  gem 'faker'
  gem 'figaro'
end

group :test do
  gem 'database_cleaner', '1.2.0'
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'capybara-email'
end

group :production, :staging do
  gem "sentry-raven"
  gem 'rails_12factor'
  gem 'carrierwave-aws'
end
