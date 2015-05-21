# encoding: utf-8
module Cms
  class ContentCategoriesController < ApplicationController

    before_filter :load_content_category, only: [:edit, :update, :destroy]

    def index
      @content_categories = ContentCategory.page(params[:page]).per(20)
    end

    def new
      @content_category = ContentCategory.new
    end

    def create
      @content_category = ContentCategory.new(content_category_params)
      if @content_category.save
        redirect_to content_categories_path
      else
        render :new
      end
    end

    def update
      if @content_category.update_attributes(content_category_params)
        redirect_to content_categories_path
      else
        render :new
      end
    end

    def destroy
      @content_category.destroy
      flash.notice = I18n.t('cms.category_delete_success')
      redirect_to content_categories_path
    end

    protected

    def content_category_params
      params.require(:content_category).permit(:name, :description, :keywords)
    end

    def load_content_category
      @content_category ||= ContentCategory.find(params[:id])
    end

  end

end
