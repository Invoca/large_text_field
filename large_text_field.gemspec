# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require "large_text_field/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "large_text_field"
  spec.version     = LargeTextField::VERSION
  spec.authors     = ["Invoca"]
  spec.email       = ["development@invoca.com"]
  spec.homepage    = "https://github.com/invoca/large_text_field"
  spec.summary     = "Add large text fields to models without database migrations"
  spec.description = <<~DESCRIPTION
    Large text fields are kept in a central table, and polymorphically associated with your models.
    Access and assignment should behave as if it was a column on the same table.
  DESCRIPTION

  spec.metadata['allowed_push_host'] = "https://rubygems.org"
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir["{db,lib}/**/*"] + %w[
    MIT-LICENSE
    README.md
    Rakefile
  ]

  spec.required_ruby_version = '>= 2.7.5'

  spec.add_dependency "invoca-utils", "~> 0.3"
  spec.add_dependency "rails", ">= 5.2"
end
