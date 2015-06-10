module Cms
  module FormHelper

    def content_label(attribute, opts)
      label_tag content_attribute_field_name(attribute.key, opts), t(attribute.key), class: 'right inline'
    end

    def content_attribute_input(attribute, opts)
      value = opts.keys.include?(:value) ? opts[:value] : attribute.value
      name = content_attribute_field_name(attribute.key, opts)
      case opts[:as]
      when :text
        return text_area_tag name, value, class: opts[:class], type: opts[:as]
      when :hidden
        type = opts[:as]
      else
        type = :text
      end
      text_field_tag name, value, class: opts[:class], type: type
    end

    def content_attribute_field_name(key, opts)
      ret = if opts[:component_idx].nil?
        "content_node[#{key}]"
      else
        "content_node[content_components_attributes][#{opts[:component_idx]}][#{key}]"
      end
      opts[:array] ? ret + "[]" : ret
    end

  end
end
