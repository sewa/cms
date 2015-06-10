# encoding: utf-8
module Cms
  module Filesystem

    extend ActiveSupport::Concern

    included do

      def content_components
        content_component_types.map do |type|
          type.constantize.new
        end
      end

      def content_component_types
        return @component_types if @component_types.present?
        @component_types = collect_models('content_components')
      end

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
            ret += common_node_types
          end
          ret
        else
          common_node_types
        end
      end

      def common_node_types
        return @common_nodes if @common_nodes.present?
        @common_nodes = collect_models('content_nodes')
      end

      def templates
        return @templates if @templates
        collect('views/content_nodes') do
          @templates = Dir.glob("**/*.html.erb").map do |file|
            unless file.match(/^_.*|\/_.*/)
              file.chomp(".html.erb")
            end
          end.compact
        end
        @templates.sort!
      end

      protected

      def collect_models(folder, &block)
        collect('models/' + folder) do
          Dir.glob("*.rb").map do |file|
            file.chomp(".rb").classify
          end
        end
      end

      def collect(folder, &block)
        path = Rails.root.join("app/#{folder}")
        if File.exist?(path)
          Dir.chdir(path) do
            yield
          end
        else
          fail "Provide content nodes in #{folder}"
        end
      end

    end

  end
end
