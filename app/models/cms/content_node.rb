# encoding: utf-8
module Cms
  class ContentNode < ActiveRecord::Base
    self.table_name = :content_nodes

    include Cms::Concerns::ContentAttributes
    include Cms::Concerns::ContentCategories
    include Cms::Concerns::ContentProperties
    include Cms::Concerns::Template
    include Cms::Concerns::List
    include Cms::Concerns::Tree

    acts_as_tree
    # 'touch_on_update: false' here somehow works only for the content_nodes
    # which had higher position comparing to the node you're moving
    # see ContentNodesController#sort for additional info
    acts_as_list scope: :parent_id, touch_on_update: false

    has_many :content_components, -> { order :position }, autosave: true, dependent: :destroy, as: :componentable

    has_and_belongs_to_many :content_nodes,
                            join_table: "content_node_connections",
                            foreign_key: "content_node_id_1",
                            association_foreign_key: "content_node_id_2"
    has_and_belongs_to_many :content_nodes_inversed,
                            class_name: "ContentNode",
                            join_table: "content_node_connections",
                            foreign_key: "content_node_id_2",
                            association_foreign_key: "content_node_id_1"

    before_validation :slugalize_name
    before_validation :correct_url
    before_validation :correct_redirect

    validates :title, presence: true
    validates :url, uniqueness: true, allow_blank: true
    validates :name, uniqueness: { scope: :parent_id }

    default_scope -> { order(position: :asc).where('access = ?', 'public') }

    def unscoped_children
      Cms::ContentNode.unscoped.where(parent_id: id)
    end

    def unscoped_parent
      Cms::ContentNode.unscoped.find_by(id: parent_id)
    end

    # active record already defines a public method
    scope :public_nodes, -> { where('access = ?', 'public') }
    scope :without_node, -> (node_id) { where('content_nodes.id != ?', node_id) }
    scope :root_nodes, -> { where(parent_id: nil) }
    scope :unscoped_root_nodes, -> { unscoped.where(parent_id: nil) }

    scope :with_relations, -> { includes(:content_components, content_attributes: [:content_value]).merge(Cms::ContentComponent.with_relations) }

    content_property :child_nodes
    content_property :use_components

    # most of the code is taken from active_record/nested_attributes.rb
    # see https://github.com/rails/rails/blob/4-2-stable/activerecord/lib/active_record/nested_attributes.rb#L433
    # some modifications where made in order to make the single table inhertance and sorting work.
    def content_components_attributes=(attributes_collection)
      unless attributes_collection.is_a?(Hash) || attributes_collection.is_a?(Array)
        raise ArgumentError, "Hash or Array expected, got #{attributes_collection.class.name} (#{attributes_collection.inspect})"
      end

      if attributes_collection.is_a? Hash
        attributes_collection = attributes_collection.values
      end

      existing_records = -> do
        attribute_ids = attributes_collection.map {|a| a['id'] || a[:id] }.compact
        attribute_ids.empty? ? [] : content_components.where(id: attribute_ids)
      end.call

      association = association(:content_components)

      attributes_collection.each_with_index do |attributes, idx|
        attributes = attributes.with_indifferent_access
        type = attributes.delete(:type)
        if attributes[:id].blank?
          unless reject_new_record?(:content_components, attributes)
            component = content_components.build(type: type)
          end
        elsif component = existing_records.detect { |record| record.id.to_s == attributes['id'].to_s }
          target_record = content_components.target.detect { |record| record.id.to_s == attributes['id'].to_s }
          if target_record
            component = target_record
          else
            association.add_to_target(component, :skip_callbacks)
          end
        end
        if component.present?
          attributes[:position] = idx + 1
          component.load_attributes
          assign_to_or_mark_for_destruction(component, attributes, true)
        end
      end
    end

    def nested_attributes_options
      {
        content_components: {}
      }
    end

    def content_components_sorted_by_position
      self.content_components.sort_by { |comp| comp.position }
    end

    def destroy_content_attributes_including_components(attributes_collection)
      destroy_content_attributes(attributes_collection)
      if components_attributes = attributes_collection[:content_components_attributes]
        if components_attributes.is_a? Hash
           components_attributes = components_attributes.values
        end
        components_attributes.each do |attribute|
          attribute = attribute.first
          component_id = attribute.first
          if component = content_components.find_by_id(component_id)
            component.destroy_content_attributes(attribute.last)
          end
        end
      end
      reload
    end

    class << self
      def resolve(path)
        path = path.split('/').reject {|item| item.blank? } if String === path
        if path && node = unscoped_root_nodes.find_by_name(path.first)
          node.resolve(path[1..-1])
        end
      end

      def [](path)
        resolve(path)
      end
    end

    def slugalize_name
      self.name = self.title if name.blank?
      self.name = name.parameterize unless name.blank?
    end

    def correct_url
      if self.url && self.url.match(/^\/.*/)
        self.url = self.url[1..-1]
      end
    end

    def correct_redirect
      if self.redirect && self.redirect.match(/^\/.*/)
        self.redirect = self.redirect[1..-1]
      end
    end

    def redirect_path
      case redirect
      when /\.\.\/(.*)/
        parent.path + '/' + $1
      when /\.\/(.*)/
        path + '/' + $1
      else
        '/' + redirect
      end
    end

    def path_elements
      if unscoped_parent
        unscoped_parent.path_elements + [name]
      else
        [name]
      end
    end

    def path
      '/' + (self.url.present? ? self.url : path_elements.join('/'))
    end

    def resolve(path)
      path = path.split('/') if String === path
      if path.empty?
        self.class.with_relations.find(self.id)
      else
        if child = children.find_by_name(path.first)
          child.resolve(path[1..-1])
        end
      end
    end

    def public?
      self.access == 'public'
    end

    def meta_robots
      robots = []
      robots << 'noindex' if meta_noindex == true
      robots.join(',')
    end

    def copyable?
      unscoped_children.count == 0
    end
  end
end
