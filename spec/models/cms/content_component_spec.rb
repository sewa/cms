# encoding: utf-8
require "rails_helper"

module Cms
  RSpec.describe ContentComponent do

    it "has a valid factory" do
      expect{ create(:contact_component, :with_node) }.to change{ContentComponent.count}.by 1
    end

    it "has a component name and icon" do
      expect(TestComponents::Contact.icon).to eq "/some/path/contact.png"
      expect(TestComponents::Contact.new.icon).to eq "/some/path/contact.png"
    end

    context "content_attributes" do

      it "retruns the keys" do
        class Test < ContentComponent
          content_attribute :string, :string
          content_attribute :list, :image_list
        end
        expect(Test.sanitize_content_attributes).to eq [:string, :list => []]
      end

      it "responds to the methods" do
        node = TestComponents::Contact.new
        expect(node.respond_to?(:first_name=)).to eq true
        expect(node.respond_to?(:last_name=)).to eq true
      end

      it "assigns the values" do
        component = TestComponents::Contact.new(attributes_for(:content_component, :with_node))
        component.first_name = 'first'
        component.last_name = 'last'
        expect(component.save).to eq true
        expect(component.reload.first_name).to eq 'first'
        expect(component.reload.last_name).to eq 'last'
      end

    end

  end
end
