# encoding: utf-8
module Cms
  module Concerns
    module ContentNode
      module SubNodes

        extend ActiveSupport::Concern

        included do

          def common_sub_nodes
            self.class.instance_variable_get(:@common_sub_nodes)
          end

          def sub_nodes
            self.class.sub_nodes
          end

        end

        class_methods do

          def common_sub_nodes(bool = nil)
            unless bool.nil?
              @common_sub_nodes = bool
            else
              @common_sub_nodes
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
end
