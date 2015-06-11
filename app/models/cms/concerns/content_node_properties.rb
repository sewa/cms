# encoding: utf-8
module Cms
  module Concerns
    module ContentNodeProperties

      extend ActiveSupport::Concern

      included do

        [:common_node_childs, :show_components].each do |property|
          define_property_accessor(property)
          define_method(property) do
            self.class.instance_variable_get("@#{property}")
          end
        end

        def sub_nodes
          self.class.sub_nodes
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

        def sub_nodes
          @sub_nodes ||= []
        end

        def sub_node(node)
          sub_nodes << node
        end

      end
    end
  end
end
