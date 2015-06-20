$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "cms/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "cms"
  s.version     = Cms::VERSION
  s.authors     = ["Severin Schwanck"]
  s.email       = ["s@schwanck.com"]
  s.homepage    = "TODO"
  s.summary     = "Cms"
  s.description = "Cms"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "4.2.1"
  s.add_dependency "jquery-rails"
  s.add_dependency "jquery-ui-rails"
  s.add_dependency "cancancan"
  s.add_dependency "acts_as_tree"
  s.add_dependency "acts_as_list"
  s.add_dependency "foundation-rails", "5.5.2.1"
  s.add_dependency "ckeditor_rails"
  s.add_dependency "paperclip"
  s.add_dependency "simple_form"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "shoulda-matchers"
end
