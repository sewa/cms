# encoding: utf-8
module Cms
  class ContentCategory < ActiveRecord::Base

    self.table_name = :content_categories

    has_many :content_category_nodes

    validates :name, presence: true

  end
end
