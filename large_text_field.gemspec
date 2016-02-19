$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "large_text_field/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "large_text_field"
  s.version     = LargeTextField::VERSION
  s.authors     = ["Bob Smith"]
  s.email       = ["bob@invoca.com"]
  s.homepage    = "http://github.com/invoca"
  s.summary     = "Large text fields on active record models that can be defined without migrations."
  s.description = "TODO: Description of LargeTextField."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails",        "~> 3.2.22.1"
  s.add_dependency "hobo_support", "2.0.1"

  s.add_development_dependency "invoca-utils", "0.0.2"
  s.add_development_dependency "sqlite3"
end
