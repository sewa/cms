# encoding: utf-8
module Cms
  class ContentComponent < ActiveRecord::Base
    self.table_name = :content_components

    include Cms::Concerns::ContentAttributes
    include Cms::Concerns::ContentProperties
    include Cms::Concerns::Template

    scope :with_relations, -> { includes(content_attributes: [:content_value]) }

    belongs_to :componentable, polymorphic: true

    acts_as_list scope: :componentable

    content_property :icon

    class << self
      def localize_name
        I18n.t('content_components.'+self.name.underscore.sub('_component', ''))
      end
    end

    def anchor
      "##{id}"
    end
  end
end
