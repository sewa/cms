# encoding: utf-8
module Cms
  class ContentCategoryNode < ActiveRecord::Base

    self.table_name = :content_category_nodes

    belongs_to :content_category

    belongs_to :content_node

  end
end
