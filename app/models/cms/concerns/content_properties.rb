# encoding: utf-8
module Cms
  module Concerns
    module ContentProperties

      extend ActiveSupport::Concern

      class_methods do

        def content_property(property)
          instance_variable = "@#{property}"
          define_property_accessor(property, instance_variable)
          define_method(property) do
            self.class.instance_variable_get(instance_variable)
          end
        end

        protected

        def define_property_accessor(property, instance_variable)
          define_singleton_method(property) do |value = nil|
            if value.present? && !instance_variable_defined?(instance_variable)
              instance_variable_set(instance_variable, value)
            else
              instance_variable_get(instance_variable)
            end
          end
        end

      end
    end
  end
end
