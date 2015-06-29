module Cms
  module ApplicationHelper

    def nav_link_to(title, url, opts = {})
      if can? :manage, opts[:object]
        content_tag 'li', class: ('active' if request.path.match(/#{url.split('/')[2]}/)) do
          concat link_to title, url, opts
        end.html_safe
      end
    end

    def actions(options = {}, &block)
      content = with_output_buffer(&block)
      render(partial: 'cms/shared/actions', locals: options.merge!(content: content))
    end

    def cms_paginate(collection, params)
      paginate collection, remote: true, params: params, views_prefix: :cms, window: 2
    end

  end
end
