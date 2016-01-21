$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "cms/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "cms"
  s.version     = Cms::VERSION
  s.author     = "Severin Schwanck"
  s.email       = "s@schwanck.com"
  s.homepage    = "https://github.com/sewa/cms"
  s.summary     = "A simple rails cms engine"
  s.description = "A simple rails cms engine"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 4.2.2"
  s.add_dependency "cancancan", "~> 1.10.1"
  s.add_dependency "acts_as_tree", "~> 2.2.0"
  s.add_dependency "acts_as_list", "~> 0.7.2"
  s.add_dependency "dragonfly", "~> 1.0.10"
  s.add_dependency "paperclip"
  s.add_dependency "simple_form", "~> 3.1"
  s.add_dependency "kaminari", "~> 0.16.3"
  s.add_dependency "jquery-rails", "~> 4.0"
  s.add_dependency "jquery-ui-rails", "~> 5.0"
  s.add_dependency "select2-rails", "~> 3.5.9"
  s.add_dependency "foundation-rails", "~> 5.5.2.1"
  s.add_dependency "ckeditor_rails", "~> 4.5.1"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "shoulda-matchers"
  s.add_development_dependency "faker"
end
