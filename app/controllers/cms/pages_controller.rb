module Cms
  class PagesController < ApplicationController

    skip_before_action :authorize_user, only: [:unauthorized]

    def unauthorized
    end

  end
end
