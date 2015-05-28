# encoding: utf-8
module Cms
  class ContentNodesController < ApplicationController

    include Cms::ControllerHelpers::ContentNodes

    before_filter :load_object, only: [:show, :edit, :update, :destroy]
    before_filter :load_parent, only: [:new, :create, :update]
    before_filter :load_assets, only: [:new, :edit, :create, :update]

    def index
      @content_nodes = ContentNode.where(:parent_id => nil).page(params[:page]).per(20)
    end

    def create
      create_params = content_node_params
      type = create_params.delete('type')
      @content_node = safe_new(type, content_node_types(@parent))
      if @content_node.update_attributes(create_params)
        redirect_to content_nodes_path
      else
        render action: :new
      end
    end

    def update
      if @content_node.update_attributes(content_node_params)
        @content_node.save
        redirect_to content_nodes_path
      else
        render :action => 'edit'
      end
    end

    def new
      type = params.delete(:type)
      @content_node = safe_new(type, content_node_types(@parent), parent_id: params[:parent_id])
    end

    def destroy
      @content_node.destroy
      flash.notice = I18n.t('cms.node_delete_success')
      redirect_to content_nodes_path
    end

    protected

    def base_attrs
      [:title, :type, :parent_id, :name, :template, :page_title, :keywords, :description, :url, :redirect, :access, content_category_ids: []]
    end

    def content_attrs
      params.require(:content_node).permit(base_attrs)
      type = params[:content_node][:type]
      safe_type(type, content_node_types(@parent)).classify.constantize.permit_content_attributes
    end

    def content_node_params
      params.require(:content_node).permit(base_attrs + content_attrs)
    end

    def load_assets
      @content_images = ContentImage.all
      @content_documents = ContentDocument.all
      @content_categories = ContentCategory.all
    end

    def load_parent
      parent_id = params[:parent_id] || params[:content_node][:parent_id]
      if parent_id.present?
        @parent = ContentNode.find(parent_id)
      end
    end

    def load_object
      @content_node = ContentNode.find(params[:id])
    end

  end

end
