# encoding: utf-8
module Cms
  class ContentNodesController < ApplicationController

    include Cms::ControllerHelpers::ContentNodes

    before_filter :find_node, only: [:show, :edit, :update, :up, :down, :destroy, :set_version, :children]
    before_filter :load_assets, only: [:new, :edit, :create, :update]

    def index
      @content_nodes = ContentNode.where(:parent_id => nil).page(params[:page]).per(20)
    end

    def create
      create_params = content_node_params
      @content_node = safe_new(create_params.delete('type'), content_node_types)
      if @content_node.update_attributes(create_params)
        # @content_node.create_version!(current_user)
        redirect_to content_nodes_path
      else
        render action: :new
      end
    end

    def update
      if @content_node.update_attributes(content_node_params)
        # @content_node.create_version!(current_user)
        @content_node.save
        redirect_to content_nodes_path
      else
        render :action => 'edit'
      end
    end

    def version
      @version = ContentNodeVersion.where(:content_node_id => params[:id], :version => params[:version]).first
    end

    def set_current_version
      @content_node.set_version!(current_user, params[:version])
      redirect_to admin_content_node_path(@content_node)
    end

    def versions
      @content_node = ContentNode.find(params[:id])
      @versions = ContentNodeVersion.where(:content_node_id => params[:id])
    end

    def new
      @content_node = safe_new(params[:type], content_node_types, parent_id: params[:parent_id])
    end

    def up
      @content_node.move_higher
      redirect_to :back
    end

    def down
      @content_node.move_lower
      redirect_to :back
    end

    def destroy
      @content_node.destroy
      flash.notice = I18n.t('cms.node_delete_success')
      redirect_to content_nodes_path
    end

    protected

    def base_attrs
      [:title, :type, :parent_id, :name, :template, :page_title, :keywords, :description, :url, :redirect, :access]
    end

    def content_attrs
      params.require(:content_node).permit(base_attrs)
      safe_type(params[:content_node][:type], content_node_types).classify.constantize.permit_content_attributes
    end

    def content_node_params
      params.require(:content_node).permit(base_attrs + content_attrs)
    end

    def load_assets
      @content_images = ContentImage.all
      @content_documents = ContentDocument.all
    end

  end

end
