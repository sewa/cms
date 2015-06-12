# encoding: utf-8
module Cms
  module Filesystem

    extend ActiveSupport::Concern

    included do

      def content_components(node)
        content_component_types(node).map do |type|
          type.constantize.new
        end
      end

      def content_component_types(node)
        node = node.instance_of?(String) ? node.constantize : node
        limit(node.use_components, all_component_types)
      end

      def content_node_types(node = nil)
        node = node.instance_of?(String) ? node.constantize : node
        if node.present?
          limit(node.child_nodes, all_node_types)
        else
          all_node_types
        end
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

      def all_component_types
        return @all_component_types if @all_component_types.present?
        @all_component_types = collect_models('content_components')
      end

      def all_node_types
        return @all_node_types if @all_node_types.present?
        @all_node_types = collect_models('content_nodes')
      end

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
          fail "Provide objects in #{folder}"
        end
      end

      def limit(given, all)
        if given.instance_of?(Array) && given.present?
          return given
        elsif given.instance_of?(Hash)
          only = given[:only]
          except = given[:except]
          if only.present?
            return only.instance_of?(Array) ? only : [only]
          elsif except.present?
            return all - (except.instance_of?(Array) ? except : [except])
          end
        elsif given.instance_of?(String)
          return [given]
        elsif given == :all
          return all
        end
        []
      end

    end

  end
end
