# encoding: utf-8
require "rails_helper"

module Cms
  RSpec.describe ContentNode, type: :model do

    let(:node) { create(:content_node) }

    it { validate_presence_of :title }
    it { validate_presence_of :template }
    it { have_many :content_attributes }

    it "can be created" do
      expect(node).to be_persisted
    end

    it "can have many content_components" do
      node.content_components << [create(:content_component)]
      expect(node.content_components.count).to eq 1
    end

    context "content_categories" do

      it "saves the categories" do
        c1 = build(:content_category)
        node.content_categories = [c1]
        expect(node.content_categories.count).to eq 1
      end

    end

    context "content_groups" do

      it "adds an content_attribute" do
        expect(TestGroupNode.content_groups[:test].size).to eq 2
      end

      it "adds all other nodes to default group" do
        expect(TestNode.content_groups[:default].size).to eq 3
      end

      it "has the content_gropus if the node was saved" do
        node = TestGroupNode.new(attributes_for(:content_node, type: TestGroupNode.to_s))
        node.test1 = 'bla bal'
        node.save!
        expect(node.save).to eq true
        node = TestGroupNode.last
        expect(node.content_groups[:test].size).to eq 2
      end

    end

    context "content_attributes" do

      it "retruns the keys" do
        class TestNode1 < ContentNode
          content_attribute :string, :string
          content_attribute :list, :image_list
        end
        expect(TestNode1.permit_content_attributes).to eq [:string, :list => []]
      end

      it "responds to the methods" do
        node = TestNode.new
        expect(node.respond_to?(:test1=)).to eq true
        expect(node.respond_to?(:test2=)).to eq true
        expect(node.respond_to?(:test3=)).to eq false
      end

      it "assigns the values" do
        node = TestNode.new(attributes_for(:content_node))
        node.test1 = 'bla bal'
        img = create(:content_image)
        node.test2 = img.id
        node.float = 12.2
        expect(node.save).to eq true
        expect(node.reload.test2).to eq img
        expect(node.reload.test1).to eq 'bla bal'
      end

      it "returns nil values" do
        node = TestNode.new(attributes_for(:content_node))
        node.test1 = 'bla bal'
        node.float = 12.2
        expect(node.save).to eq true
        expect(node.reload.test2).to eq nil
        expect(node.reload.test1).to eq 'bla bal'
      end

      it "validates the attributes" do
        node = TestNode.new(attributes_for(:content_node))
        expect(node.valid?).to eq false
        expect(node.errors[:float].count).to eq 2
      end

    end

    context "#path" do

      it "returns path" do
        expect(node.path).to match /node-\d/
      end

      it "returns url if url is present" do
        url = 'test/url'
        node.url = url
        expect(node.path).to eq '/' + url
      end

    end

    context "#correct_redirect" do

      it "does nothing if redirect doesn't start with a slash" do
        node.redirect = 'test/test'
        node.valid?
        expect(node.redirect).to eq 'test/test'
      end

      it "removes slash before validation" do
        node.redirect = '/test/test'
        node.valid?
        expect(node.redirect).to eq 'test/test'
      end

      it "not raise an error if redirect is blank" do
        expect{node.valid?}.not_to raise_error
      end

    end

    context "#correct_url" do

      it "does nothing if url doesn't start with a slash" do
        node.url = 'test/test'
        node.valid?
        expect(node.url).to eq 'test/test'
      end

      it "removes slash before validation" do
        node.url = '/test/test'
        node.valid?
        expect(node.url).to eq 'test/test'
      end

      it "not raises an error if url is blank" do
        expect{node.valid?}.not_to raise_error
      end

    end

  end
end
