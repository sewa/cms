module Cms
  class ApplicationController < ActionController::Base

    include SaferExecution

    helper_method :try_current_user

    rescue_from CanCan::AccessDenied do |exception|
      redirect_unauthorized_access
    end

    # before_action :authorize_user

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
      if respond_to?(:current_user)
        current_user
      else
        nil
      end
    end

    def redirect_unauthorized_access
      if try_current_user
        flash[:error] = Cms.t(:authorization_failure)
        redirect_to '/unauthorized'
      else
        store_location
        if respond_to?(:cms_login_path)
          redirect_to cms_login_path
        else
          redirect_to cms.respond_to?(:root_path) ? cms.root_path : main_app.root_path
        end
      end
    end

  end
end
