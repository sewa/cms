module Cms
  class ApplicationController < ActionController::Base

    include Cms::ControllerHelpers::Auth
    include Cms::ControllerHelpers::Routing

    include SaferExecution

  end
end
