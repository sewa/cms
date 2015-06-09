# encoding: utf-8
require "rails_helper"

module Cms
  RSpec.describe ContentComponent do

    it "can have content_nodes" do
      c = create(:content_component, :with_node)
      c.content_nodes << [create(:content_node)]
      expect(c.content_nodes.count).to eq 2
    end

    it "has a component name and icon" do
      expect(TestComponent.new.component_name).to eq "test"
      expect(TestComponent.new.component_icon).to eq "/some/path/icon.png"
    end

  end
end
