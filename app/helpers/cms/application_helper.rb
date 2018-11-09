module Cms
  module ApplicationHelper

    def nav_link_to(title, url, opts = {})
      if can? opts[:can], opts[:object]
        css_class = params[:controller].split('/').last == opts[:object].to_s ? 'active' : ''
        content_tag('li', class: css_class) do
          concat link_to title, url
        end
      end
    end

    def nav_item_visible?(items)
      items.each do |item|
        return true if can? :index, item
      end
      false
    end

    def actions(options = {}, &block)
      content = with_output_buffer(&block)
      render(partial: 'cms/shared/actions', locals: options.merge!(content: content))
    end

    def cms_paginate(collection, params)
      remote = params.delete(:remote)
      remote = remote.nil? ? true : remote
      paginate collection, remote: remote, params: params, views_prefix: :cms, window: 2
    end

  end
end
