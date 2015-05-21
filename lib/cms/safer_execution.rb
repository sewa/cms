module Cms
  module SaferExecution
    class ClassNotAllowed < ActionController::NotImplemented; end

    def safe_type(type, whitelist)
      return type if type.in?(whitelist)
      fail ClassNotAllowed, whitelist
    end

    def safe_send(method, whitelist)
      return send(method.to_sym) if method.in?(whitelist)
      fail ActionController::MethodNotAllowed, whitelist
    end

    def safe_new(klass, whitelist, *args)
      return klass.constantize.new(*args) if klass.in?(whitelist)
      fail ClassNotAllowed, whitelist
    end
  end
end
