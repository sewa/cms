module Cms
  module ApplicationHelper

    def nav_link_to(title, url, opts = {})
      css_class = params[:controller].split('/').last == opts[:object].to_s ? 'active' : ''
      if can? opts[:can], opts[:object]
        [
          content_tag('li', '', class: 'divider'),
          content_tag('li', class: css_class) do
            concat link_to title, url, opts
          end
        ].join('').html_safe
      end
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
