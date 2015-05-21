# encoding: utf-8
module Cms
  class ContentAttribute < ActiveRecord::Base

    self.table_name = 'content_attributes'

    belongs_to :content_node, class_name: Cms::ContentNode

    validates :content_node, presence: true
    validates :content_value, presence: true
    validates :key, uniqueness: { scope: 'content_node_id' }, presence: true

    def value
      content_value.value
    end

    def value=(value)
      assign_value(value)
    end

    class << self
      # specifies the type of the content_value
      def content_type(type, reference_scope = nil)
        @reference_scope ||= reference_scope
        belongs_to :content_value, class_name: "Cms::ContentValue::#{type.to_s.classify}", dependent: :destroy, autosave: true
      end

      def reference_scope
        @reference_scope
      end
    end

    alias_method :orig_valid?, :valid?
    def valid?(context = nil)
      ret = orig_valid?
      return ret if content_value.blank?
      unless content_value.valid?
        content_value.errors.each do |key, error|
          errors.add key, error
        end
      end
      ret && errors.empty?
    end

    protected

    # this can be used in actual attributes to persist the value
    def assign_value(value)
      unless value.nil?
        cv = (content_value || build_content_value)
        cv.value = value
        if cv.respond_to?(:type) && self.class.reference_scope
          cv.type = self.class.reference_scope
        end
      end
    end

  end
end
