$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rpages/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rpages"
  s.version     = Rpages::VERSION
  s.authors     = ["Maxim Roubintchik"]
  s.email       = ["maxim@roubintchik.com"]
  s.homepage    = "https://github.com/maximr/rpages"
  s.summary     = "ContentManagement for Rails Apps"
  s.description = "Here comes the description...."
  s.licenses    = ["MIT"]

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 5.0"
  s.add_development_dependency "rake"
  s.files = Dir["{lib,vendor}/**/*"]
end