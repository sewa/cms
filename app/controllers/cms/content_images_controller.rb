# encoding: utf-8
require_dependency "cms/application_controller"

module Cms
  class ContentImagesController < ApplicationController

    before_filter :find_content_images, only: [:index, :search]
    before_filter :load_content_image, only: [:edit, :update, :destroy]

    def index
      @content_images = @query.page(params[:page]).per(20)
    end

    def search
      @content_images = @query.page(params[:page]).per(20)
      render :layout => false
    end

    def new
      @content_image = ContentImage.new
    end

    def create
      @content_image = ContentImage.new(content_image_params)
      if @content_image.save
        redirect_to(content_images_path)
      else
        render 'new'
      end
    end

    def update
      if @content_image.update_attributes(content_image_params)
        redirect_to(content_images_path)
      else
        render 'edit'
      end
    end

    def destroy
      @content_image.destroy
      flash.notice = I18n.t('cms.image_delete_success')
      redirect_to content_images_path
    end

    protected

    def content_image_params
      params.require(:content_image).permit(:image, :caption, :alt, :href, :tags, :text)
    end

    def load_content_image
      @content_image ||= ContentImage.find(params[:id])
    end

    def find_content_images
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
