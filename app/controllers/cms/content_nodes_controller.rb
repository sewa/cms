# encoding: utf-8
module Cms
  class ContentNodesController < ApplicationController

    include Cms::ControllerHelpers::ContentNodes

    helper_method :template_options
    helper_method :content_node_options

    before_filter :load_object, only: [:show, :edit, :update, :destroy, :sort]
    before_filter :load_parent, only: [:new, :create, :update]
    before_filter :load_assets, only: [:new, :edit, :create, :update]

    def index
      @content_nodes = ContentNode.where(:parent_id => nil).page(params[:page]).per(20)
    end

    def new
      type = params.delete(:type)
      @content_node = safe_new(type, content_node_types(@parent), parent_id: params[:parent_id])
      load_components
    end

    def create
      create_params = content_node_params
      type = create_params.delete('type')
      @content_node = safe_new(type, content_node_types(@parent))
      if @content_node.update_attributes(create_params)
        redirect_to_parent_or_index
      else
        load_components
        render action: :new
      end
    end

    def edit
      load_components
    end

    def update
      if @content_node.update_attributes(content_node_params)
        @content_node.save
        redirect_to_parent_or_index
      else
        load_components
        render action: :edit
      end
    end

    def sort
      @content_node.set_list_position(params[:position])
      render json: { status: :success }
    end

    def destroy
      @content_node.destroy
      flash.notice = I18n.t('cms.node_delete_success')
      redirect_to content_nodes_path
    end

    protected

    def redirect_to_parent_or_index
      if @parent.present?
        redirect_to content_node_path(@parent)
      else
        redirect_to content_nodes_path
      end
    end

    def base_attrs
      [:title, :type, :parent_id, :name, :template, :page_title, :keywords, :description, :url, :redirect, :access, content_category_ids: []]
    end

    def component_attrs
      return [] unless params[:content_node][:content_components_attributes].present?
      params[:content_node][:content_components_attributes].clone.map do |key, comp_attrs|
        type = comp_attrs[:type]
        node_type = params[:content_node][:type]
        klass = safe_type(type, content_component_types(node_type)).classify.constantize
        klass.permit_content_attributes + [:id, '_destroy']
      end.flatten + [:type]
    end

    def node_attrs
      params.require(:content_node).permit(base_attrs)
      type = params[:content_node][:type]
      safe_type(type, content_node_types(@parent)).classify.constantize.permit_content_attributes
    end

    def content_node_params
      permit = base_attrs + node_attrs + [ content_components_attributes: component_attrs ]
      params.require(:content_node).permit(permit)
    end

    def load_assets
      @images = ContentImage.all
      @documents = ContentDocument.all
    end

    def load_components
      @components = content_components(@content_node)
    end

    def load_parent
      parent_id = params[:parent_id] || (params[:content_node] || {})[:parent_id]
      if parent_id.present?
        @parent = ContentNode.find(parent_id)
      end
    end

    def load_object
      @content_node = ContentNode.find(params[:id])
    end

  end

end
