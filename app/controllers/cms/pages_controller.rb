module Cms
  class PagesController < ApplicationController

    skip_before_filter :authorize_user, only: [:unauthorized]

    def unauthorized
    end

  end
end
