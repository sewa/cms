# encoding: utf-8
module Cms
  class ContentCategoriesController < ApplicationController

    before_filter :load_object, only: [:edit, :update, :destroy]

    def index
      @objects = ContentCategory.page(params[:page]).per(20)
    end

    def new
      @object = ContentCategory.new
    end

    def create
      @object = ContentCategory.new(object_params)
      if @object.save
        redirect_to content_categories_path
      else
        render :new
      end
    end

    def update
      if @object.update_attributes(object_params)
        redirect_to content_categories_path
      else
        render :new
      end
    end

    def destroy
      @object.destroy
      flash.notice = I18n.t('cms.category_delete_success')
      redirect_to content_categories_path
    end

    protected

    def object_params
      params.require(:content_category).permit(:name, :description, :keywords)
    end

    def load_object
      @object ||= ContentCategory.find(params[:id])
    end

  end

end
