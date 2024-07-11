# frozen_string_literal: true

require_relative "lib/large_text_field/version"

Gem::Specification.new do |spec|
  spec.name        = "large_text_field"
  spec.version     = LargeTextField::VERSION
  spec.authors     = ["Invoca"]
  spec.email       = ["development@invoca.com"]
  spec.homepage    = "https://github.com/invoca/large_text_field"
  spec.license     = "MIT"
  spec.summary     = "Add large text fields to models without database migrations"
  spec.description = <<~DESCRIPTION
    Large text fields are kept in a central table, and polymorphically associated with your models.
    Access and assignment should behave as if it was a column on the same table.
  DESCRIPTION

  spec.metadata['allowed_push_host'] = "https://rubygems.org"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata["documentation_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/master/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "#{spec.homepage}/issues"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.required_ruby_version = '>= 3.1'

  spec.add_dependency "invoca-utils", "~> 0.3"
  spec.add_dependency "rails", ">= 6.0"
end
