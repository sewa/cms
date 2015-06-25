module Cms
  class ApplicationController < ActionController::Base

    include Cms::ControllerHelpers::Auth
    include Cms::ControllerHelpers::Routing

    include SaferExecution

    before_action :authorize_user

  end
end
