# encoding: utf-8
module Cms
  module Concerns
    module ContentCategories

      extend ActiveSupport::Concern

      included do
        has_and_belongs_to_many :content_categories

        scope :with_categories, -> (ids) { select('DISTINCT content_nodes.*').joins(:content_categories).where('content_category_id IN (?)', ids << -1) }
      end

    end
  end
end
