# encoding: utf-8
module Cms
  class ContentComponent < ActiveRecord::Base

    self.table_name = :content_components

    include Cms::Concerns::ContentAttributes
    include Cms::Concerns::ContentProperties

    belongs_to :componentable, polymorphic: true

    acts_as_list scope: :componentable

    content_property :icon

  end
end
