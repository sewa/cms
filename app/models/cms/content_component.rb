# encoding: utf-8
module Cms
  class ContentComponent < ActiveRecord::Base

    self.table_name = :content_components

    include Cms::Concerns::ContentAttributes

    belongs_to :componentable, polymorphic: true

    acts_as_list scope: :componentable

    def icon
      self.class.instance_variable_get(:@icon)
    end

    class << self

      def icon(icon)
        @icon = icon
      end

    end

  end
end
