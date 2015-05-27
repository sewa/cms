# encoding: utf-8
require_dependency "cms/application_controller"

module Cms
  class ContentDocumentsController < ApplicationController

    before_filter :find_objects, only: [:index, :search]
    before_filter :load_object, only: [:edit, :update, :destroy]

    def index
      @objects = @query.page(params[:page]).per(20)
    end

    def search
      @objects = @query.page(params[:page]).per(20)
      render layout: false
    end

    def new
      @object = ContentDocument.new
    end

    def create
      @object = ContentDocument.new(object_params)
      if @object.save
        redirect_to(content_documents_path)
      else
        render 'new'
      end
    end

    def update
      if @object.update_attributes(object_params)
        redirect_to(content_documents_path)
      else
        render 'edit'
      end
    end

    def destroy
      @object.destroy
      flash.notice = I18n.t('cms.image_delete_success')
      redirect_to content_documents_path
    end

    protected

    def object_params
      params.require(:content_document).permit(:attachment, :name, :tags)
    end

    def load_object
      @object ||= ContentDocument.find(params[:id])
    end

    def find_objects
      @query = ContentDocument.order('created_at ASC')
      if params[:q]
        queries = params[:q].gsub(' ', ',').split(',').map(&:strip).reject(&:blank?).map{|p| "%#{p}%" }
        queries.each do |q|
          @query = @query.where('name LIKE ? OR tags LIKE ?', q, q)
        end
      end
    end

  end
end
