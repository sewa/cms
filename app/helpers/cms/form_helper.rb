module Cms
  module FormHelper

    def content_attribute_input(attribute, opts)
      value = opts.keys.include?(:value) ? opts[:value] : attribute.value
      name = content_attribute_field_name(attribute.key, opts)
      text_field_tag name, value, class: opts[:class], type: opts[:as]
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
