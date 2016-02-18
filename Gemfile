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


gem 'hobo_fields',           '2.0.1',    git: 'git@github.com:Invoca/hobo_fields', ref: '248730363294ea30c836eda45ea34a714eacc5c2'
gem 'hobo_support',          '2.0.1',    git: 'git@github.com:Invoca/hobosupport'

group :test do
  gem 'test-unit', '3.1.3'
  gem 'minitest', '~> 4.7.5'
  gem 'rr', '1.1.2'
  gem 'shoulda', '3.5.0'
  gem 'pry'
end
