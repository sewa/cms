# encoding: utf-8
module Cms
  class ContentComponent < ActiveRecord::Base

    self.table_name = :content_components

    include Cms::Concerns::ContentAttributes

    has_and_belongs_to_many :content_nodes

    acts_as_list scope: :content_node_id

    def icon
      self.class.instance_variable_get(:@component_icon)
    end

    class << self

      def icon(icon)
        @component_icon = icon
      end

    end

  end
end
