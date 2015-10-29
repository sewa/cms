# encoding: utf-8
module Cms
  module Concerns
    module Tree

      extend ActiveSupport::Concern

      included do

        def unscoped_ancestors
          node, nodes = self, []
          nodes << node = node.unscoped_parent while node.unscoped_parent
          nodes
        end

      end

    end
  end
end
