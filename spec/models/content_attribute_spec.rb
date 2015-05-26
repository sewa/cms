# encoding: utf-8
require "rails_helper"

RSpec.describe Cms::ContentAttribute do

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
    attr.content_node = content_node
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

  [1, nil].each do |val|
    it 'has an error' do
      attr = Test.new
      attr.value = val
      attr.valid?
      expect(attr.errors.count).to eq 2
    end
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

end
