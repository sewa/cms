# encoding: utf-8
require "rails_helper"

module Cms
  RSpec.describe ContentImage do

    let(:image) { create(:content_image) }

    it "has an image" do
      expect(image.image_name).to eq 'test_image.jpg'
      expect(image.image_uid).to be_present
      expect(image.image_width).to eq 1000
      expect(image.image_height).to eq 398
      expect(image.image.url).to be_present
    end

    it "validates the image" do
      image = build(:content_image, :with_invalid_image)
      image.valid?
      expect(image.errors[:image]).to be_present
    end

  end
end
