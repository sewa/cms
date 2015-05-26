module Cms
  module ApplicationHelper

    def nav_link_to(title, url, opts = {})
      content_tag 'li', class: ('active' if request.path.match(/#{url.split('/')[2]}/)) do
        concat link_to title, url, opts
      end.html_safe
    end

  end
end
