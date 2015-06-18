# encoding: utf-8
module Cms
  class ContentImage < ActiveRecord::Base

    self.table_name = :content_images

    validates :tags, presence: true
    validates :alt, presence: true
    validates :image, presence: true

    has_attached_file :image,
      styles: { mini: '48x48>', thumb: '146x146>', medium: '240x240>', rotator: '944x944>' },
      default_style: :thumb,
      url: '/content/images/:id/:style/:basename.:extension',
      path: ':rails_root/public/content/images/:id/:style/:basename.:extension'

    validates_attachment :image,
      :presence => true,
      :content_type => { :content_type => %w(image/jpeg image/jpg image/png image/gif) }

  end
end
