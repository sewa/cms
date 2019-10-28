# encoding: utf-8
module Cms
  class ContentNodesController < ApplicationController
    include Cms::ControllerHelpers::ContentNodes
    include Cms::ControllerHelpers::Paginate

    helper_method :template_options
    helper_method :content_node_options

    before_action :load_object, only: [:show, :edit, :update, :destroy, :sort, :toggle_access, :copy]
    before_action :load_children, only: [:show]
    before_action :load_parent, only: [:new, :create, :update]
    before_action :load_assets, only: [:new, :edit, :create, :update, :copy]

    def index
      @content_nodes = unscoped.where(parent_id: nil)
    end

    def new
      type = params.delete(:type)
      @content_node = safe_new(type, content_node_types(@parent), parent_id: params[:parent_id])
      @content_node.load_attributes
      load_components
    end

    def create
      create_params = content_node_params
      type = create_params.delete('type')
      @content_node = safe_new(type, content_node_types(@parent))
      @content_node.load_attributes
      if @content_node.update_attributes(create_params)
        touch_parent_node
        redirect_to edit_content_node_path(@content_node)
      else
        load_components
        render action: :new
      end
    end

    def edit
      @content_node.load_attributes
      @content_node.content_components.map(&:load_attributes)
      load_components
    end

    def update
      @content_node.load_attributes
      if destroy_params = params[:destroy]
        @content_node.destroy_content_attributes_including_components(destroy_params[:content_node])
      end
      if @content_node.update_attributes(content_node_params)
        touch_parent_node
        @content_node.touch
        @content_node.save
        redirect_to edit_content_node_path(@content_node)
      else
        load_components
        render action: :edit
      end
    end

    def toggle_access
      touch_parent_node
      @content_node.update_attribute(:access, @content_node.public? ? 'private' : 'public')
    end

    def sort
      touch_parent_node
      current_updated_at = @content_node.updated_at
      @content_node.set_list_position(params[:position])
      # 'touch_on_update: false' should do the trick here but it does not
      # so this is used to preserve timestamps for the content_node
      # which position has been changed
      # see 'acts_as_list' statement in ContentNode model for additional info
      @content_node.update_column('updated_at', current_updated_at)
      render json: { status: :success }
    end

    def index_search
      @content_nodes = find_objects
      respond_to do |format|
        format.js { render :index_search }
      end
    end

    def destroy
      touch_parent_node
      @content_node.destroy
      flash.notice = I18n.t('cms.node_delete_success')
      redirect_to content_nodes_path
    end

    def copy
      @content_node.title = "#{@content_node.title} (Kopie)"
      @content_node.name = @content_node.title.parameterize
      @content_node.access = "private"
      @content_node.id = nil
      @content_node.instance_variable_set("@new_record", true)
      @content_node.load_attributes
      @content_node.content_components.each do |comp|
        comp.load_attributes
        comp.id = nil
      end
      load_components
    end

    protected

    def touch_parent_node
      parent = Cms::ContentNode.unscoped.find_by(id: @content_node.parent_id)
      if parent.present?
        parent.touch
      end
    end

    def redirect_to_parent_or_index
      if @parent.present?
        redirect_to content_node_path(@parent)
      else
        redirect_to content_nodes_path
      end
    end

    def base_attrs
      [:title, :type, :parent_id, :name, :template, :meta_title, :meta_keywords, :meta_description, :meta_noindex, :meta_canonical, :url, :redirect, :access, content_category_ids: []]
    end

    def component_attrs
      return [] unless params[:content_node][:content_components_attributes].present?
      params[:content_node][:content_components_attributes].to_unsafe_h.clone.map do |_, comp_attrs|
        type = comp_attrs[:type]
        node_type = params[:content_node][:type]
        klass = safe_type(type, content_component_types(node_type)).classify.constantize
        klass.sanitize_content_attributes + [:id, '_destroy', 'template']
      end.flatten + [:type]
    end

    def node_attrs
      params.require(:content_node).permit(base_attrs)
      type = params[:content_node][:type]
      safe_type(type, content_node_types(@parent)).classify.constantize.sanitize_content_attributes
    end

    def content_node_params
      permit = base_attrs + node_attrs + [ content_components_attributes: component_attrs ]
      params.require(:content_node).permit(permit)
    end

    def load_assets
      @images = ContentImage.page(params[:page]).per(assets_per_page)
      @documents = ContentDocument.page(params[:page]).per(assets_per_page)
    end

    def unscoped
      ContentNode.unscoped.order(position: :asc)
    end

    def load_components
      @components = content_components(@content_node)
      @components.map(&:load_attributes)
    end

    def load_parent
      parent_id = params[:parent_id] || (params[:content_node] || {})[:parent_id]
      if parent_id.present?
        @parent = unscoped.find(parent_id)
      end
    end

    def load_object
      @content_node = unscoped.with_relations.find(params[:id])
    end

    def load_children
      @children ||= unscoped.where(parent_id: load_object.id)
    end

    def find_objects
      query = unscoped.where(parent_id: params[:parent_id])
      if params[:q]
        queries = params[:q].gsub(' ', ',').split(',').map(&:strip).reject(&:blank?).map{|p| "%#{p}%" }
        queries.each do |q|
          query = query.where('title LIKE ? OR access LIKE ? OR name LIKE ?', q, q, q)
        end
      end
      query
    end
  end
end
