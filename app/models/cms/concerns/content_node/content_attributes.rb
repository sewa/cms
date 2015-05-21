# encoding: utf-8
module Cms
  module Concerns
    module ContentNode
      module ContentAttributes

        extend ActiveSupport::Concern

        included do

          has_many :content_attributes, autosave: true, dependent: :destroy

          after_initialize :load_attributes
          # todo: implement this -> before_validate :skip_empty_attributes

        end

        class_methods do

          def content_attributes
            @content_attributes ||= []
          end

          def content_attribute(key, type, options = {})
            content_attributes << options.merge(:key => key.to_s, :type => type.to_s)

            define_method(key) do
              content_attribute(key).value
            end

            define_method("#{key}=") do |value|
              content_attribute(key).value = value
            end
          end

          def content_attribute_keys
            self.content_attributes.map {|attr| attr[:key].to_sym }
          end

        end

        def content_attribute_list
          self.class.content_attributes.map {|attr| content_attribute(attr[:key]) }
        end

        def content_attribute(key)
          key = key.to_s
          content_attributes.detect {|attr| attr.key == key }
        end

        def has_content_attribute?(key)
          !!self.content_attributes.select{ |a| a.key == key }
        end

        protected

        def load_attributes
          self.class.content_attributes.each do |attr|
            unless content_attribute(attr[:key])
              type = (attr[:type].to_s.classify + 'Attribute').constantize
              self.content_attributes << type.new(type: type.to_s, key: attr[:key])
            end
          end
        end

      end
    end
  end
end
