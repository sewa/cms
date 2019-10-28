# encoding: utf-8
module Cms
  module Concerns
    module ContentAttributes

      extend ActiveSupport::Concern

      included do

        has_many :content_attributes, autosave: true, dependent: :destroy, as: :attributable

        def destroy_content_attributes(attrs)
          attrs.reject {|_, value| value.blank? }.each do |key, _|
            if attribute = content_attribute(key)
              attribute.destroy
            end
          end
        end

        def content_attribute(key)
          key = key.to_s
          content_attributes.detect {|attr| attr.key == key }
        end

        def has_content_attribute?(key)
          !!self.content_attributes.select{ |a| a.key == key }
        end

        def content_groups
          @content_groups ||= {}
        end

        # Hack to get around the reinitialization of content_attributes
        # when using the original destroy method.
        # This also requires the dependent: :destroy method not to be set
        # when defining the relation.
        alias_method :orig_destroy, :destroy
        def destroy
          orig_destroy
          content_attributes.destroy_all
        end

        def load_attributes
          self.class.content_groups.each do |group, attrs|
            attrs.each do |attr|
              unless content_attr = content_attribute(attr[:key])
                type = (attr[:type].to_s.classify + 'Attribute').constantize
                content_attr = type.new(type: type.to_s, key: attr[:key])
                content_attributes << content_attr
              end
              content_attr.content_options = attr.reject { |k,_| [:type, :key].include?(k) }
              content_groups[group] ||= []
              content_groups[group] << content_attr
            end
          end
        end

      end

      class_methods do

        def content_attributes
          @content_attributes ||= []
        end

        def content_groups
          @content_groups ||= {}
        end

        def content_group(key)
          @content_group = key
          yield
          @content_group = :default
        end

        def content_attribute(key, type, options = {})
          content_attributes << options.merge(key: key.to_s, type: type.to_s)
          content_groups[@content_group || :default] ||= []
          content_groups[@content_group || :default] << content_attributes.last
          unless method_defined? key
            define_method(key) do
              if attr = content_attribute(key)
                attr.value
              end
            end
          end
          assign_key = "#{key}="
          unless method_defined? assign_key
            define_method(assign_key) do |value|
              content_attribute(key).value = value
            end
          end
        end

        def sanitize_content_attributes
          self.content_attributes.map do |attr|
            if attr[:type].match(/list/)
              { attr[:key].to_sym => [] }
            else
              attr[:key].to_sym
            end
          end
        end

      end

    end
  end
end
