# encoding: utf-8
module Cms
  module ControllerHelpers
    module ContentNodes

      extend ActiveSupport::Concern

      included do

        helper_method :template_options
        helper_method :content_node_options

        protected

        def content_node_types
          return @content_node_types if @content_node_types
          folder = Rails.root.join('app/models/content_nodes')
          if File.exist?(folder)
            Dir.chdir(folder) do
              @content_node_types = Dir.glob("**/*.rb").map do |file|
                file.chomp(".rb").classify
              end
            end
            @content_node_types.sort!{ |a,b| a.first <=> b.first }
          else
            fail 'Provide content nodes in app/models/content_nodes'
          end
        end

        def content_node_options
          @content_node_options ||= content_node_types.map do |type|
            [t("content_nodes.#{type.downcase}"), type]
          end
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

        def find_node
          @content_node = ContentNode.find(params[:id])
        end

      end

    end
  end
end
