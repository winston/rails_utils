$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails_page_class/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails_page_class"
  s.version     = RailsPageClass::VERSION
  s.authors     = ["Winston Teo"]
  s.email       = ["winston.yongwei+rails_page_class@gmail.com"]
  s.homepage    = "https://github.com/winston/rails_page_class"
  s.summary     = "Rails helper that returns controller name and action name as a string for use as a CSS class."
  s.description = "This gem provides a Rails helper method that returns controller name and action name as a single value.
                   This can be used to target CSS styles specifically at this controller or action."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.markdown"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.13"

  s.add_development_dependency "minitest" , "~> 4.7.0"
  s.add_development_dependency "turn"     , "~> 0.9.6"
  s.add_development_dependency "mocha"    , "~> 0.13.3"
end
