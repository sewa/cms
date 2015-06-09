# encoding: utf-8
module Cms
  class ContentCategory < ActiveRecord::Base

    self.table_name = :content_categories

    has_and_belongs_to_many :content_nodes

    validates :name, presence: true

  end
end
