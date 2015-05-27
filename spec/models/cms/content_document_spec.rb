require 'rails_helper'

module Cms
  RSpec.describe ContentDocument, type: :model do

    it "creates the factory" do
      expect(create(:content_document)).to be_valid
    end

  end
end
