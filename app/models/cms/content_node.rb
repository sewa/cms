# encoding: utf-8
module Cms
  class ContentNode < ActiveRecord::Base

    self.table_name = :content_nodes

    include Cms::Concerns::ContentNode::ContentAttributes
    include Cms::Concerns::ContentNode::ContentCategories
    include Cms::Concerns::ContentNode::TreeList

    validates :title, presence: true
    validates :template, presence: true, if: -> (n) { n.class.template.nil? }
    validates :url, uniqueness: true, allow_blank: true
    validates :name, uniqueness: { scope: :parent_id }

    has_and_belongs_to_many :content_nodes, join_table: "content_node_connections", foreign_key: "content_node_id_1", association_foreign_key: "content_node_id_2"
    has_and_belongs_to_many :content_nodes_inversed, class_name: "ContentNode", join_table: "content_node_connections", foreign_key: "content_node_id_2", association_foreign_key: "content_node_id_1"

    before_validation :slugalize_name
    before_validation :correct_url
    before_validation :correct_redirect

    # active record already defines a public method
    scope :public_nodes, -> { where('access = ?', 'public') }
    scope :without_node, -> (node_id) { where('content_nodes.id != ?', node_id) }

    class << self

      def resolve(path)
        path = path.split('/').reject {|item| item.blank? } if String === path

        if path && node = find_by_name(path.first)
          node.resolve(path[1..-1])
        end
      end

      def [](path)
        resolve(path)
      end

      def template(template = nil)
        if template
          @template = template
        else
          @template
        end
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
      if parent
        parent.path_elements + [name]
      else
        [name]
      end
    end

    def path
      if self.url.present?
        '/' + self.url
      else
        '/' + path_elements.join('/')
      end
    end

    def resolve(path)
      path = path.split('/') if String === path

      if path.empty?
        self
      else
        if child = children.find_by_name(path.first)
          child.resolve(path[1..-1])
        end
      end
    end

    def public?
      self.access == 'public'
    end

    def template
      if read_attribute(:template).blank?
        self.class.template
      else
        read_attribute(:template)
      end
    end

  end
end
