require 'rails_helper'

module Cms
  RSpec.describe ImageListAttribute, type: :model do

    [7, 1284, 8].each do |id|
      let("image_#{id}") { create(:content_image, id: id) }
    end

    def image_arr
      images = []
      [7, 1284, 8].each do |id|
        images << self.send("image_#{id}")
      end
      images
    end

    def image_ids
      image_arr.map(&:id)
    end

    it "assigns a string" do
      attr = ImageListAttribute.new
      attr.attributable = create(:content_node)
      attr.key = :images
      attr.value = image_ids.join('|')
      attr.save
      expect(attr.reload.value).to eq image_arr
    end

    it "assigns a string" do
      attr = ImageListAttribute.new
      attr.value = image_ids
      expect(attr.value).to eq image_arr
    end

  end
end
