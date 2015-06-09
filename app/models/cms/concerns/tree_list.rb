# encoding: utf-8
module Cms
  module Concerns
    module TreeList

      extend ActiveSupport::Concern

      included do

        acts_as_tree

        acts_as_list scope: :parent_id

        has_many :children, -> { order('position ASC').where("content_nodes.access = 'public'") }, class_name: 'ContentNode', foreign_key: 'parent_id', dependent: :destroy

        has_many :all_children, ->  { order 'position ASC' }, class_name: 'ContentNode', foreign_key: 'parent_id', dependent: :destroy

      end

      # def next_item
      #   self.higher_item ? self.higher_item : self.last_item
      # end

      # def prev_item
      #   self.lower_item ? self.lower_item : self.first_item
      # end

      # def last_item
      #   conditions = scope_condition
      #   conditions = "#{conditions} AND access = 'public'"
      #   acts_as_list_class.unscoped.find(:first, :conditions => conditions, :order => "#{position_column} DESC")
      # end

      # def first_item
      #   conditions = scope_condition
      #   conditions = "#{conditions} AND access = 'public'"
      #   acts_as_list_class.unscoped.find(:first, :conditions => conditions, :order => "#{position_column} ASC")
      # end

      # def next_item_with_categories(ids, exclude_node_id = nil)
      #   nodes = self.parent.children.with_categories(ids).public
      #   idx = nodes.map(&:id).index(self.id)+1
      #   if exclude_node_id
      #     nodes = nodes.map {|n| n if n.id != exclude_node_id.to_i }.compact
      #     idx -= 1 if nodes.size > 2
      #   end
      #   nodes[idx < nodes.size ? idx : 0]
      # end

      # def prev_item_with_categories(ids, exclude_node_id = nil)
      #   nodes = self.parent.children.with_categories(ids).public
      #   idx = nodes.map(&:id).index(self.id)-1
      #   if exclude_node_id
      #     nodes = nodes.map {|n| n if n.id != exclude_node_id.to_i }.compact
      #     idx -= 1 if nodes.size > 2
      #   end
      #   nodes[idx < 0 ? nodes.size - 1 : idx]
      # end

    end
  end
end
