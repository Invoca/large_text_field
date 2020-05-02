# frozen_string_literal: true

source "https://rubygems.org"

gemspec

# jquery-rails is used by the dummy application
gem "jquery-rails"

# To use debugger
# gem 'debugger'

group :test do
  gem 'minitest', '~> 5.1'
  gem 'minitest-reporters'
  gem 'pry'
  gem 'rr',        '1.1.2'
  gem 'shoulda',   '3.5.0'
  gem 'test-unit', '3.1.3'
end

group :development do
  gem 'rubocop', require: false
  gem 'sqlite3'
end
