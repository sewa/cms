# encoding: utf-8
module Cms
  module BreadcrumbHelper

    def controller?(controller)
      request[:controller] == "cms/#{controller}"
    end

    def new?
      request[:action] == 'new' || request[:action] == 'create' || request[:action] == 'copy'
    end

    def edit?
      request[:action] == 'edit' || request[:action] == 'update'
    end

    def index?
      request[:action] == 'index'
    end

    def breadcrumb_item(text, url, options = {})
      content_tag :li, class: options.delete(:li_class) do
        concat link_to text, url, options
      end
    end

  end
end
