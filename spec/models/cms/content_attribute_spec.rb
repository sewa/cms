# encoding: utf-8
require "rails_helper"

module Cms
  RSpec.describe ContentAttribute, type: :model do

    def setup(klass)
      attrib = klass.new
      attrib.key = :key
      attrib.attributable = content_node
      attrib
    end

    let(:content_node) { create(:content_node) }
    let(:subject) { setup(TestAttributes::Integer) }

    module TestAttributes
      class Text < Cms::ContentAttribute
        content_type :text
      end
      class Integer < Cms::ContentAttribute
        content_type :integer
      end
      class Image < Cms::ContentAttribute
        content_type :reference, 'Cms::ContentImage'
      end
    end

    it { is_expected.to belong_to :attributable }
    # it { should validate_presence_of :attributable }
    it { is_expected.to validate_presence_of :key }
    it { is_expected.to validate_uniqueness_of(:key).scoped_to([:attributable_id, :attributable_type]) }

    context '#content_value' do

      it 'sets the correct type' do
        expect(TestAttributes::Text.new.build_content_value.class.name).to eq 'Cms::ContentValue::Text'
        expect(TestAttributes::Integer.new.build_content_value.class.name).to eq 'Cms::ContentValue::Integer'
        expect(TestAttributes::Image.new.build_content_value.class.name).to eq 'Cms::ContentValue::Reference'
      end

      it 'creates a value' do
        attr = setup(TestAttributes::Integer)
        attr.value = 123
        expect{ attr.save }.to change{ Cms::ContentValue::Integer.count }.by(1)
      end

      it 'checks for nil values' do
        attr = setup(TestAttributes::Text)
        expect(attr.content_value).to eq nil
      end

      it 'has an error' do
        attr = TestAttributes::Integer.new
        attr.attributable = content_node
        attr.value = 1
        attr.valid?
        expect(attr.errors.count).to eq 1
        attr.value = nil
        attr.valid?
        expect(attr.errors.count).to eq 2
      end

    end

    context "reference type" do

      it 'sets the type' do
        img = create(:content_image)
        attr = setup(TestAttributes::Image)
        attr.value = img.id
        attr.save
        expect(attr.value).to eq img
      end

    end

    context "destroy" do

      it "removes the content_values" do
        node = create(:page, :valid, :test_image, :test_text)

        expect{ node.content_attribute(:test_float).destroy }.to change{ ContentValue::Float.count }.by(-1)
        expect{ node.content_attribute(:test_image).destroy }.to change{ ContentValue::Reference.count }.by(-1)
        expect{ node.content_attribute(:test_text).destroy }.to change{ ContentValue::Text.count }.by(-1)
      end

      it "does not destroy referenced records" do
        node = create(:page, :valid, :test_image)
        expect{ node.content_attribute(:test_image).destroy }.to change{ ContentImage.count }.by(0)
      end

    end

  end

end
