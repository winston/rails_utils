$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails_utils/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails_utils"
  s.version     = RailsUtils::VERSION
  s.authors     = ["Winston Teo"]
  s.email       = ["winston.yongwei+rails_utils@gmail.com"]
  s.homepage    = "https://github.com/winston/rails_utils"
  s.summary     = "Rails helpers based on opinionated project practices."
  s.description = "Rails helpers based on opinionated project practices. Currently useful for structuring CSS and JS."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.markdown"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 3.2"

  # Attempted to upgrade minitest to v5.0.6 on 22 Aug. Failed because turn v0.9.6 has a mismatched adapter to minitest v5.0.6
  # https://github.com/TwP/turn/issues/122

  s.add_development_dependency "minitest" , "~> 4.7.5"
  s.add_development_dependency "turn"     , "~> 0.9.6"
  s.add_development_dependency "mocha"    , "~> 0.14.0"
end
