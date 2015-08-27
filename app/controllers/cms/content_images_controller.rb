# encoding: utf-8
require_dependency "cms/application_controller"

module Cms
  class ContentImagesController < ApplicationController

    include Cms::ControllerHelpers::Paginate

    before_filter :find_objects, only: [:index, :sidebar_search, :index_search]
    before_filter :load_object, only: [:edit, :update, :destroy]

    def index
      @objects = @query.page(params[:page]).per(assets_per_page)
    end

    def sidebar_search
      @objects = @query.page(params[:page]).per(assets_per_page)
      respond_to do |format|
        format.js { render :sidebar_search }
      end
    end

    def index_search
      @objects = @query.page(params[:page]).per(assets_per_page)
      respond_to do |format|
        format.js { render :index_search }
      end
    end

    def new
      @object = ContentImage.new
    end

    def create
      @object = ContentImage.new(object_params)
      if @object.save
        redirect_to content_images_path
      else
        render 'new'
      end
    end

    def update
      if @object.update_attributes(object_params)
        redirect_to content_images_path
      else
        render 'edit'
      end
    end

    def destroy
      @object.destroy
      flash.notice = I18n.t('cms.image_delete_success')
      redirect_to content_images_path
    end

    protected

    def object_params
      params.require(:content_image).permit(:image, :caption, :copyright, :alt, :href, :url, :tags, :text)
    end

    def load_object
      @object ||= ContentImage.find(params[:id])
    end

    def find_objects
      @query = ContentImage.all
      if params[:q]
        queries = params[:q].gsub(' ', ',').split(',').map(&:strip).reject(&:blank?).map{|p| "%#{p}%" }
        queries.each do |q|
          @query = @query.where('caption LIKE ? OR alt LIKE ? OR tags LIKE ?', q, q, q)
        end
      end
    end

  end
end
