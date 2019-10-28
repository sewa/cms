module Cms
  module ControllerHelpers
    module Routing

      extend ActiveSupport::Concern

      included do

        rescue_from ActionController::RoutingError, :with => :render_not_found
        rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found

        def raise_not_found!
          raise ActionController::RoutingError.new("No route matches #{params[:unmatched_route]}")
        end

        protected

        def render_not_found(_e)
          respond_to do |f|
            f.html { render template: "errors/404", layout: 'shared', status: 404 }
            f.json { render template: "errors/404", status: 404 }
            f.js { render template: "errors/404", formats: [:json], status: 404 }
          end
        end

      end

    end

  end

end
