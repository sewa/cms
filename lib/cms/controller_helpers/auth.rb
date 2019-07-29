# encoding: utf-8
module Cms
  module ControllerHelpers
    module Auth

      extend ActiveSupport::Concern

      included do

        before_action :authorize_user

        helper_method :try_current_user

        rescue_from CanCan::AccessDenied do |_exception|
          redirect_unauthorized_access
        end

        protected

        def action
          params[:action].to_sym
        end

        def authorize_user
          return if action == :unauthorized
          if respond_to?(:model_class, true) && model_class
            record = model_class
          else
            record = controller_name.to_sym
          end
          authorize! action, record
        end

        def current_ability
          @current_ability ||= Cms::Ability.new(try_current_user)
        end

        def try_current_user
          if respond_to?(Cms.current_user_method)
            self.send(Cms.current_user_method)
          else
            raise "You have to set the current_user_method in the Cms module. Add e.g. Cms.current_user_method = current_cms_user to config/initializers/cms.rb."
          end
        end

        def redirect_unauthorized_access
          if try_current_user
            flash[:error] = I18n.t(:authorization_failure)
            if methods.include?(:unauthorized_path)
              redirect_to unauthorized_path
            else
              raise "unauthorized_path must be specified in the controller."
            end
          else
            if methods.include?(:sign_in_path)
              redirect_to sign_in_path
            else
              raise "sign_in_path must be specified in the controller."
            end
          end
        end

      end

    end
  end
end
