module Cms
  module ControllerHelpers
    module Auth

      extend ActiveSupport::Concern

      included do

        helper_method :try_current_user

        rescue_from CanCan::AccessDenied do |exception|
          redirect_unauthorized_access
        end

        protected

        def action
          params[:action].to_sym
        end

        def authorize_user
          if respond_to?(:model_class, true) && model_class
            record = model_class
          else
            record = controller_name.to_sym
          end
          authorize! :admin, record
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

        def store_location
          # disallow return to login, logout, signup pages
          authentication_routes = [:signup_path, :login_path, :logout_path]
          disallowed_urls = []
          authentication_routes.each do |route|
            if respond_to?(route)
              disallowed_urls << send(route)
            end
          end

          disallowed_urls.map!{ |url| url[/\/\w+$/] }
          unless disallowed_urls.include?(request.fullpath)
            session['user_return_to'] = request.fullpath.gsub('//', '/')
          end
        end

        def redirect_unauthorized_access
          if try_current_user
            flash[:error] = I18n.t(:authorization_failure)
            redirect_to cms.unauthorized_path
          else
            store_location
            if respond_to?(:cms_login_path)
              redirect_to cms_login_path
            else
              redirect_to main_app.new_cms_user_session_path
            end
          end
        end

      end
    end
  end
end
