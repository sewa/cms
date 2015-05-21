# encoding: utf-8
module Cms
  module Concerns
    module ContentNode
      module ContentCategories

        extend ActiveSupport::Concern

        included do

          has_many :content_category_nodes
          has_many :content_categories, through: :content_category_nodes

          after_save :save_categories

        end

        class_methods do

          def with_categories(ids)
            select('DISTINCT content_nodes.*').joins(:content_category_nodes).where('content_category_id IN (?)', ids << -1)
          end

        end

        def category_ids
          content_category_nodes.map(&:content_category_id)
        end

        def category_ids=(ids)
          @category_ids = ids
        end

        def save_categories
          if @category_ids
            content_category_nodes.destroy_all

            @category_ids.each do |id|
              content_category_nodes.create(:content_category_id => id)
            end
          end

          @category_ids = nil
        end

      end
    end
  end
end
