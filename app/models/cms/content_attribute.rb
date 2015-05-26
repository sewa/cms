# encoding: utf-8
module Cms
  class ContentAttribute < ActiveRecord::Base

    self.table_name = 'content_attributes'

    belongs_to :content_node, class_name: Cms::ContentNode

    validates :content_node, presence: true
    validates :key, uniqueness: { scope: 'content_node_id' }, presence: true

    def value
      fetch_value
    end

    def value=(value)
      assign_value(value)
    end

    def type_name
      self.class.name.chomp("Attribute").underscore
    end

    class << self
      # specifies the type of the content_value
      def content_type(type, scope = nil)
        @scope ||= scope
        has_one :content_value, foreign_key: :content_attribute_id, class_name: "Cms::ContentValue::#{type.to_s.classify}", dependent: :destroy, autosave: true
      end

      def scope
        @scope
      end
    end

    protected

    def assign_value(value)
      unless value.blank?
        cv = content_value || build_content_value
        cv.value = value
        if cv.respond_to?(:scope) && self.class.scope
          cv.scope = self.class.scope
        end
      end
    end

    def fetch_value
      content_value && content_value.value
    end

  end
end
