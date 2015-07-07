# encoding: utf-8
require "rails_helper"

module Cms
  RSpec.describe ContentComponent do

    it "has a valid factory" do
      expect{ create(:test_comp, :with_node) }.to change{ContentComponent.count}.by 1
    end

    it "has a component name and icon" do
      expect(TestComponent.icon).to eq "/some/path/icon.png"
      expect(TestComponent.new.icon).to eq "/some/path/icon.png"
    end

    context "content_attributes" do

      it "retruns the keys" do
        class TestComponent1 < ContentComponent
          content_attribute :string, :string
          content_attribute :list, :image_list
        end
        expect(TestComponent1.sanitize_content_attributes).to eq [:string, :list => []]
      end

      it "responds to the methods" do
        node = TestComponent.new
        expect(node.respond_to?(:text=)).to eq true
        expect(node.respond_to?(:float=)).to eq true
      end

      it "assigns the values" do
        component = TestComponent.new(attributes_for(:content_component, :with_node))
        component.text = 'bla bal'
        component.float = 12.2
        expect(component.save).to eq true
        expect(component.reload.text).to eq 'bla bal'
        expect(component.reload.float).to eq 12.2
      end

    end

  end
end
