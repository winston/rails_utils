$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails_page_class/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "Rails Page Class"
  s.version     = RailsPageClass::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = ""
  s.description = ""

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.13"

  s.add_development_dependency "minitest" , "~> 4.7.0"
  s.add_development_dependency "turn"     , "~> 0.9.6"
  s.add_development_dependency "mocha"    , "~> 0.13.3"
end
