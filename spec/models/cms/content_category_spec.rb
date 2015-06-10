require 'rails_helper'

module Cms
  RSpec.describe ContentCategory, type: :model do

    it "can have content_nodes" do
      c = create(:content_category, :with_node)
      c.content_nodes << [create(:content_node)]
      c.save
      expect(c.content_nodes.count).to eq 2
    end

  end
end
