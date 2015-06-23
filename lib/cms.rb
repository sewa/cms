require 'cancan'
require 'acts_as_tree'
require 'acts_as_list'
require 'foundation-rails'
require 'jquery-rails'
require 'jquery-ui-rails'
require 'ckeditor_rails'
require 'simple_form'
require 'paperclip'

require "cms/engine"
require "cms/filesystem"
require "cms/controller_helpers/content_nodes"
require "cms/safer_execution"
require "cms/content_value"

module Cms
  mattr_accessor :user_class
  mattr_accessor :current_user_method
end
