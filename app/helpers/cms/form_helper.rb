module Cms
  module FormHelper

    def show_components
      @components.any?
    end

    def show_categories?
      Cms::ContentCategory.count > 0
    end

    def node_errors?(node, attrs)
      attrs.each do |attr|
        return true if node.errors[attr].any?
      end
      false
    end

    def attributes_errors?(node_or_component, attrs)
      attrs.each do |attr|
        return true if attr.errors.any? || node_or_component.errors[attr.key].any?
      end
      false
    end

    def attribute_errors(node_or_component, attr)
      return if attr.errors.blank? && node_or_component.errors[attr.key].blank?
      values = []
      node_or_component.errors[attr.key].each do |value|
        values << value
      end
      attr.errors.map do |key, value|
        values << value
      end
      content_tag(:small, values.join('<br />').html_safe, class: 'error')
    end

    def content_label(attribute, opts)
      text = attribute.has_content_option?(:field_label) ? attribute.content_options[:field_label] : t(attribute.key)
      label_tag content_field_name(attribute.key, opts), text, class: 'right inline'
    end

    def content_input(opts)
      name = opts[:name] || content_field_name(opts[:key], opts)
      case opts[:as]
      when :text
        return text_area_tag name, opts[:value], class: opts[:class], type: opts[:as]
      when :select
        return select_tag name, opts[:value], class: opts[:class], type: opts[:as]
      when :hidden
        type = opts[:as]
      else
        type = :text
      end
      text_field_tag name, opts[:value], class: opts[:class], type: type
    end

    def asset_destroy_input(attribute, opts)
      if attribute.attributable.is_a? Cms::ContentNode
        return content_input(opts.merge(as: :hidden, class: 'destroy', name: content_field_name(attribute.key, opts.merge(for_destroy: true))))
      elsif attribute.attributable.is_a? Cms::ContentComponent
        name = content_field_name(attribute.attributable.id, opts.merge(for_destroy: true))
        content_input(opts.merge(as: :hidden, class: 'destroy', name: name + "[#{attribute.key}]"))
      end
    end

    def content_attribute_input(attribute, opts)
      content_input(opts.merge(
                               value: opts.keys.include?(:value) ? opts[:value] : attribute.value,
                               name: content_field_name(opts[:key] || attribute.key, opts)
                              )
                   )
    end

    def content_field_name(key, opts)
      ret = if opts[:component_idx].nil?
              if opts[:for_destroy].nil?
                "content_node[#{key}]"
              else
                "destroy[content_node][#{key}]"
              end
      else
              if opts[:for_destroy].nil?
                "content_node[content_components_attributes][#{opts[:component_idx]}][#{key}]"
              else
                "destroy[content_node][content_components_attributes][#{opts[:component_idx]}][#{key}]"
              end
      end
      opts[:array] ? ret + "[]" : ret
    end

    def content_options_for_select(object, attribute, default)
      options_for_select(cache_options(object, attribute), default)
    end

    protected

    def cache_options(object, attribute)
      value = attribute.content_options[:select_options]
      name = "@#{object.class.name.underscore}_#{attribute.class.name.underscore}_#{attribute.key}_options"
      unless ret = instance_variable_get(name)
        options = if value.instance_of? Symbol
                    object.send(value)
                  elsif value.instance_of? Array
                    value
                  else
                    raise "Only an array or a symbol is allowed"
                  end
        ret = instance_variable_set(name, options)
      end
      ret
    end

  end
end
