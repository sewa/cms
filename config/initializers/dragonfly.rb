require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret "def14c825e95099a3ca82e4ad99322bd0e2bd45911a6b7ae55fb91f0c6e89223"

  url_format "/media/:job/:name"

  datastore :file,
    root_path: Rails.root.join('public/content/images', Rails.env),
    server_root: Rails.root.join('public')
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end
