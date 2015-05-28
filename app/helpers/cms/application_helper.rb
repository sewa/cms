module Cms
  module ApplicationHelper

    def nav_link_to(title, url, opts = {})
      content_tag 'li', class: ('active' if request.path.match(/#{url.split('/')[2]}/)) do
        concat link_to title, url, opts
      end.html_safe
    end

    def actions(options = {}, &block)
      content = with_output_buffer(&block)
      render(partial: 'cms/shared/actions', locals: options.merge!(content: content))
    end

  end
end
