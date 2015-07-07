require 'rails_helper'

module Cms
  RSpec.describe ImageListAttribute, type: :model do

    3.times do |idx|
      let("image_#{idx}") { create(:content_image) }
    end

    def image_arr
      images = []
      3.times do |idx|
        images << self.send("image_#{idx}")
      end
      images
    end

    def image_ids
      image_arr.map(&:id)
    end

    it "assigns a string" do
      attr = ImageListAttribute.new
      attr.value = image_ids.join(',')
      expect(attr.value).to eq image_arr
    end

    it "assigns a string" do
      attr = ImageListAttribute.new
      attr.value = image_ids
      expect(attr.value).to eq image_arr
    end

  end
end
