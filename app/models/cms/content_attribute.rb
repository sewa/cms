# encoding: utf-8
module Cms
  class ContentAttribute < ActiveRecord::Base

    self.table_name = 'content_attributes'

    belongs_to :attributable, polymorphic: true

    alias_method :content_node=, :attributable=
    alias_method :content_node, :attributable

    validates :key, uniqueness: { scope: [:attributable_id, :attributable_type] }, presence: true

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
      # attributes marked with -1 get deleted
      if value == '-1' && content_value.present?
        content_value.destroy
      elsif value.present?
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
