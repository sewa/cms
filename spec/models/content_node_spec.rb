# encoding: utf-8
require "rails_helper"

RSpec.describe Cms::ContentNode, type: :model do

  let(:node) { create(:content_node) }

  it { validate_presence_of :title }
  it { validate_presence_of :template }
  it { have_many :content_attributes }

  it "can be created" do
    expect(node).to be_persisted
  end

  context "content_attributes" do

    it "retruns the kes" do
      expect(TestNode.content_attribute_keys).to eq [:test1, :test2]
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
      node.test2 = create(:content_image).id
      expect(node.save).to eq true
    end

  end

  context "#path" do

    it "returns path" do
      expect(node.path).to eq '/some-title'
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
