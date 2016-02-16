$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "large_text_field/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "large_text_field"
  s.version     = LargeTextField::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of LargeTextField."
  s.description = "TODO: Description of LargeTextField."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.22.1"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
