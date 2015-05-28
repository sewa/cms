# encoding: utf-8
require_dependency "cms/application_controller"

module Cms
  class ContentImagesController < ApplicationController

    before_filter :find_objects, only: [:index, :search]
    before_filter :load_object, only: [:edit, :update, :destroy]

    def index
      @objects = @query.page(params[:page]).per(20)
    end

    def search
      @objects = @query.page(params[:page]).per(20)
      render :layout => false
    end

    def new
      @object = ContentImage.new
    end

    def create
      @object = ContentImage.new(object_params)
      if @object.save
        redirect_to(objects_path)
      else
        render 'new'
      end
    end

    def update
      if @object.update_attributes(object_params)
        redirect_to(objects_path)
      else
        render 'edit'
      end
    end

    def destroy
      @object.destroy
      flash.notice = I18n.t('cms.image_delete_success')
      redirect_to objects_path
    end

    protected

    def object_params
      params.require(:content_image).permit(:image, :caption, :alt, :href, :tags, :text)
    end

    def load_object
      @object ||= ContentImage.find(params[:id])
    end

    def find_objects
      @query = ContentImage.order('caption ASC')
      if params[:q]
        queries = params[:q].gsub(' ', ',').split(',').map(&:strip).reject(&:blank?).map{|p| "%#{p}%" }
        queries.each do |q|
          @query = @query.where('caption LIKE ? OR alt LIKE ? OR tags LIKE ?', q, q, q)
        end
      end
    end

  end

end
