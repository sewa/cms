# Implementation class for Cancan gem.  Instead of overriding this class, consider adding new permissions
# using the special +register_ability+ method which allows extensions to add their own abilities.
#
# See http://github.com/ryanb/cancan for more details on cancan.
require 'cancan'
module Cms
  class Ability
    include CanCan::Ability

    class_attribute :abilities
    self.abilities = Set.new

    # Allows us to go beyond the standard cancan initialize method which makes it difficult for engines to
    # modify the default +Ability+ of an application.  The +ability+ argument must be a class that includes
    # the +CanCan::Ability+ module.  The registered ability should behave properly as a stand-alone class
    # and therefore should be easy to test in isolation.
    def self.register_ability(ability)
      self.abilities.add(ability)
    end

    def self.remove_ability(ability)
      self.abilities.delete(ability)
    end

    def initialize(user)
      self.clear_aliased_actions

      user ||= Cms.user_class.new

      unless user.respond_to?(Cms.user_roles_attribute)
        raise "User does not have a #{Cms.user_roles_attrbiute} method defined."
      end

      roles = user.send(Cms.user_roles_attribute)
      if roles.include?('admin') || roles.include?('cms_editor')
        can :manage, :all
      end

      # Include any abilities registered by extensions, etc.
      Ability.abilities.each do |clazz|
        ability = clazz.send(:new, user)
        @rules = rules + ability.send(:rules)
      end

      # Protect admin and user roles
      # cannot [:update, :destroy], Role, name: ['admin']
    end
  end
end
