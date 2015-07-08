# encoding: utf-8
module Cms
  module Concerns
    module List

      extend ActiveSupport::Concern

      included do

        def public_items
          Cms::ContentNode.where(scope_condition).public_nodes
        end

        def first_public_item
          public_items.first
        end

        def last_public_item
          public_items.last
        end

        def public_siblings_with_categories(category_ids)
          public_items.with_categories(category_ids).without_node(id)
        end

        def next_public_item(category_ids = nil)
          if category_ids.present?
            siblings = public_siblings_with_categories(category_ids)
            siblings.where('content_nodes.position > ?', position).first || siblings.first
          else
            item = public_items.where('content_nodes.position > ?', position).first
            item.present? ? item : first_public_item
          end
        end

        def prev_public_item(category_ids = nil)
          if category_ids.present?
            siblings = public_siblings_with_categories(category_ids)
            siblings.where('content_nodes.position < ?', position).last || siblings.last
          else
            item = public_items.where('content_nodes.position < ?', position).last
            item.present? ? item : last_public_item
          end
        end

      end

    end

  end

end
