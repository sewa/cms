# encoding: utf-8
module Cms
  class ContentImage < ActiveRecord::Base

    self.table_name = :content_images

    dragonfly_accessor :image

    validates_property :format, of: :image, in: ['jpeg', 'png', 'gif']

    validates :tags, presence: true
    validates :alt, presence: true
    validates :image, presence: true

  end
end
