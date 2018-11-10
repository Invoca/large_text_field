source "https://rubygems.org"

# Declare your gem's dependencies in large_text_field.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# jquery-rails is used by the dummy application
gem "jquery-rails"

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'debugger'

gem 'hobo_support', '2.0.1', git: 'git@github.com:Invoca/hobosupport', ref: 'b9086322274b474a2b5bae507c4885e55d4aa050'
gem 'protected_attributes', '1.1.3'

group :test do
  gem 'minitest',  '~> 5.1'
  gem 'pry'
  gem 'rr',        '1.1.2'
  gem 'shoulda',   '3.5.0'
  gem 'test-unit', '3.1.3'
end

group :development do
  gem 'rubocop', require: false
  gem 'invoca-utils', '0.0.2'
  gem 'sqlite3'
end
