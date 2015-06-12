# encoding: utf-8
module Cms
  module Concerns
    module ContentNodeProperties

      extend ActiveSupport::Concern

      included do

        [:child_nodes, :use_components].each do |property|
          define_property_accessor(property)
          define_method(property) do
            self.class.instance_variable_get("@#{property}")
          end
        end

      end

      class_methods do

        def define_property_accessor(property)
          define_singleton_method(property) do |value = nil|
            unless value.nil?
              instance_variable_set("@#{property}", value)
            else
              instance_variable_get("@#{property}")
            end
          end
        end

        def child_node(node)
          @child_nodes ||= []
          @child_nodes << node
        end

        def use_component(component)
          @use_components ||= []
          @use_components << component
        end

      end
    end
  end
end
