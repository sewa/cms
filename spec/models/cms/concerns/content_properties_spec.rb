# encoding: utf-8
require "rails_helper"

module Cms
  RSpec.describe Cms::Concerns::ContentProperties do

    it "defines a property" do
      class PropNode
        include Cms::Concerns::ContentProperties

        content_property :child_nodes

        child_nodes ['SomeNode']
      end

      expect(PropNode.child_nodes).to eq ['SomeNode']
      expect(PropNode.new.child_nodes).to eq ['SomeNode']
    end
  end

end
