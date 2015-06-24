# encoding: utf-8
require "rails_helper"

module Cms
  RSpec.describe ContentAttribute do

    let(:content_node) { create(:content_node) }

    class TestText < Cms::ContentAttribute
      content_type :text
    end

    class Test < Cms::ContentAttribute
      content_type :integer
    end

    class TestImage < Cms::ContentAttribute
      content_type :reference, 'Cms::ContentImage'
    end

    it { validate_presence_of :content_node }
    it { validate_presence_of :content_value }
    it { validate_presence_of :key }
    it { validate_uniqueness_of(:key).scoped_to(:content_node_id) }

    it 'sets the correct value type' do
      expect(Test.new.build_content_value.class.name).to eq 'Cms::ContentValue::Integer'
    end

    def setup_attribute(value = nil)
      attr = Test.new
      attr.key = :number
      attr.value = value
      attr.attributable = content_node
      attr
    end

    it 'assigns and returns a value' do
      attr = setup_attribute(123)
      attr.save!
      expect(attr.reload.value).to eq 123
    end

    it 'checks for nil values' do
      attr = setup_attribute
      expect(attr.value).to eq nil
    end

      it 'has an error' do
        attr = Test.new
        attr.value = 1
        attr.valid?
        expect(attr.errors.count).to eq 1
        attr.value = nil
        attr.valid?
        expect(attr.errors.count).to eq 2
      end

    context "reference type" do

      it 'sets the type' do
        img = create(:content_image)
        attr = TestImage.new
        attr.key = :image
        attr.value = img.id
        expect(attr.value).to eq img
      end

    end

    context "destroy" do

      it "does not destroy related assets" do
        node = create(:test_node)
        expect{ node.content_attribute(:test2).destroy }.to change{ ContentAttribute.count }.by(-1)
        expect{ node.test2.destroy }.to change{ ContentImage.count }.by(-1)
      end

    end
  end
end
