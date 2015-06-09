# encoding: utf-8
module Cms
  module ControllerHelpers
    module ContentNodes

      extend ActiveSupport::Concern

      included do

        include Cms::Filesystem

        helper_method :template_options
        helper_method :content_node_options

        protected

        def content_node_options(node = nil)
          content_node_types(node).map do |type|
            [t("content_nodes.#{type.downcase}"), type]
          end.sort{ |a,b| a.first <=> b.first }
        end

        def template_options
          templates
        end

      end

    end
  end
end
