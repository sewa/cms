module Cms
  class Engine < ::Rails::Engine
    isolate_namespace Cms

    config.autoload_paths << File.expand_path("../../../app/models/cms/content_attributes", __FILE__)

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot, :dir => 'spec/factories'
    end
  end
end
