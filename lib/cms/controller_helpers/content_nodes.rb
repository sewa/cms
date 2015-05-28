# encoding: utf-8
module Cms
  module ControllerHelpers
    module ContentNodes

      extend ActiveSupport::Concern

      included do

        helper_method :template_options
        helper_method :content_node_options

        protected

        def content_node_types(node = nil)
          if node.instance_of? String
            node = node.constantize
          end
          if node.present?
            ret = []
            if node.sub_nodes.present?
              ret = node.sub_nodes
            end
            if node.common_sub_nodes
               ret += collect_common_nodes
            end
            ret
          else
            collect_common_nodes
          end
        end

        def collect_common_nodes
          return @common_nodes if @common_nodes.present?
          folder = Rails.root.join('app/models/content_nodes')
          if File.exist?(folder)
            Dir.chdir(folder) do
              @content_node_types = Dir.glob("*.rb").map do |file|
                file.chomp(".rb").classify
              end
            end
          else
            fail "Provide content nodes in #{folder}"
          end
        end

        def content_node_options(node = nil)
          content_node_types(node).map do |type|
            [t("content_nodes.#{type.downcase}"), type]
          end.sort{ |a,b| a.first <=> b.first }
        end

        def template_options
          return @templates if @templates
          folder = "#{Rails.root}/app/views/content_nodes"
          if File.exist?(folder)
            Dir.chdir(folder) do
              @templates = Dir.glob("**/*.html.erb").map do |file|
                unless file.match(/^_.*|\/_.*/)
                  file.chomp(".html.erb")
                end
              end.compact
            end
            @templates.sort!
          else
            fail 'Provide views in app/views/content_nodes'
          end
        end

      end

    end
  end
end
