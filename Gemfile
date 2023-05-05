source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.3'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.0.4.3'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Added jquery for rails
gem 'jquery-rails'

# Adds Bootstrap to make more beautiful CSS designs
gem 'bootstrap-sass'

# Use the Puma web server [https://github.com/puma/puma] in loc de Heroku, e mai bun pentru trafic mai mare
gem 'puma', '~> 5.0'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Navigate your web application faster
gem 'turbolinks'

# Allow to connect to a Postgres DB
gem 'pg'

# Manage app-like JavaScript modules in Rails
gem 'webpacker'



# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem 'bcrypt', '~> 3.1.7'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo', '~> 2.0.4'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Sass to process CSS
gem 'sassc-rails'

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem 'image_processing'

# Allows to create sample users with semi-realistic names and emails
# It's better to place in development environment, but ok in production for learning purposes
gem 'faker'

# Allows you to paginate listings
gem 'will_paginate'

# Gives you designs for pagination
gem 'bootstrap-will_paginate'

# ImageMagick
gem 'mini_magick'

# Validates files
gem 'active_storage_validations'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[ mri mingw x64_mingw ]

  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'

  # Display code offenses
  gem 'rubocop'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  gem 'spring'

  # Listen to file modifications
  gem 'listen'

  # Makes spring watch files using the listen gem
  gem 'spring-watcher-listen'

end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'guard'
  gem 'guard-minitest'
  gem 'minitest'
  gem 'minitest-reporters'
  gem 'rails-controller-testing'
  gem 'selenium-webdriver'
  gem 'webdrivers'
  gem 'mutant-license'
  gem 'mutant-minitest'
  gem 'mutant', '~> 0.11.0'
end

group :production do
  gem 'pg'
  # To use cloud storage in production
  gem 'aws-sdk-s3', require: false
end