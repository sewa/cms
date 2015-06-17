# encoding: utf-8
require "rails_helper"

module Cms
  RSpec.describe ContentImage do

    let(:image) { create(:content_image) }

    it "can have many content_components" do
      image.content_components << [create(:test_comp, :with_node)]
      expect(image.content_components.count).to eq 1
    end

  end
end
