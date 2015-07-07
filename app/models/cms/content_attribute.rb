# encoding: utf-8
module Cms
  class ContentAttribute < ActiveRecord::Base

    self.table_name = :content_attributes

    belongs_to :attributable, polymorphic: true

    validates :key, uniqueness: { scope: [:attributable_id, :attributable_type] }, presence: true

    attr_accessor :content_options

    default_scope -> { includes(:content_value) }

    def has_content_option?(key)
      (content_options || {}).has_key?(key)
    end

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
      def content_type(type, reference_type = nil)
        if type == :reference && reference_type.nil?
          raise 'A class_name must be set if a reference attribute is defined. e.g. content_attribute :name, :reference, class_name: SomeClass'
        end
        @reference_type = reference_type
        has_one :content_value, foreign_key: :content_attribute_id, class_name: "Cms::ContentValue::#{type.to_s.classify}", dependent: :destroy, autosave: true
      end

      def reference_type
        @reference_type
      end

    end

    protected

    def assign_value(val)
      attrs = if self.class.reference_type.present?
                { reference_type: self.class.reference_type}
              else
                {}
              end
      cv = content_value || build_content_value(attrs)
      cv.value = val
    end

    def fetch_value
      content_value && content_value.value
    end

  end
end
