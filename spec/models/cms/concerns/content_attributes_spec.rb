# encoding: utf-8
require "rails_helper"

module Cms
  RSpec.describe Cms::Concerns::ContentAttributes do

    context "attributes" do

      class TestBase < ActiveRecord::Base
        self.table_name = :content_nodes
        include Cms::Concerns::ContentAttributes
        content_attribute :firstname, :string
        validates :firstname, presence: true
        content_attribute :rotator, :image_list
      end

      let(:node) { TestBase.new(position: 1, type: 'Cms::TestBase', template: 'test', title: 'test', name: 'test') }

      it "retruns the keys" do
        expect(TestBase.permit_content_attributes).to eq [:firstname, :rotator => []]
      end

      it "responds to the methods" do
        expect(node.respond_to?(:firstname=)).to eq true
        expect(node.respond_to?(:rotator=)).to eq true
        expect(node.respond_to?(:test3=)).to eq false
      end

      it "assigns the values" do
        img = create(:content_image)
        node.rotator = [img.id]
        node.firstname = 'bla bal'
        expect(node.firstname).to eq 'bla bal'
        expect(node.rotator).to eq [img]
      end

      it "returns nil values" do
        expect(node.firstname).to eq nil
      end

      it "validates the attributes" do
        node.valid?
        expect(node.errors[:firstname]).to be_present
      end

      it "destroys the content_attributes" do
        node.firstname = 'test'
        node.save!
        expect(Cms::ContentAttribute.count).to eq 2
        node.destroy
        expect(Cms::ContentAttribute.count).to eq 0
      end

    end

    context "groups" do

      class TestGroupBase < ActiveRecord::Base
        include Cms::Concerns::ContentAttributes

        content_attribute :generic, :text

        content_group :data do
          content_attribute :firstname, :string
          content_attribute :lastname, :string
        end

        content_group :images do
          content_attribute :rotator, :image_list
        end

      end

      it "adds an content_attribute" do
        expect(TestGroupBase.content_groups[:data].size).to eq 2
      end

      it "adds all other nodes to default group" do
        expect(TestGroupBase.content_groups[:default].size).to eq 1
      end

    end

  end

end
