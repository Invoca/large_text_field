# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require "large_text_field/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "large_text_field"
  s.version     = LargeTextField::VERSION
  s.authors     = ["Invoca"]
  s.email       = ["development@invoca.com"]
  s.homepage    = "http://github.com/invoca"
  s.summary     = "Add large text fields to models without database migrations"
  s.description = "Large text fields are kept in a central table, and polymorphically associated with your models.  Access and assignment should behave as if it was a column on the same table."

  s.metadata['allowed_push_host'] = "https://rubygems.org"

  s.files = Dir["{db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "invoca-utils", "~> 0.3"
  s.add_dependency "rails", "~> 4.2"
end
