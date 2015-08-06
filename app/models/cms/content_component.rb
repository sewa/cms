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

    after_initialize :ensure_template

    class << self
      def localize_name
        I18n.t('content_components.'+self.name.underscore.sub('_component', ''))
      end
    end

    protected

    def ensure_template
      unless self.class.template.present?
        raise "#{self.class.name} must define a template. Use the template class method to define one."
      end
    end

  end
end
