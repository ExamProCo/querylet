$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "monster_queries/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "querylet"
  s.version     = Querylet::VERSION
  s.authors     = ["ExamPro"]
  s.email       = ["andrew@exampro.co"]
  s.homepage    = "http://exampro.co"
  s.summary     = 'Querylet'
  s.description = 'Querylet'
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency 'parslet'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rspec'
end
