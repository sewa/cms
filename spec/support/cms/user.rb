module Cms
  class User
    attr_accessor :roles
    def has_role?(role)
      roles.include? role
    end
  end
end
