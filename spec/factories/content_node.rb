# encoding: UTF-8

class TestNode < Cms::ContentNode

  content_attribute :test1, :text
  content_attribute :test2, :image

  content_attribute :float, :float
  validates :float, presence: true
  validates :float, numericality: true

end

class TestGroupNode < Cms::ContentNode

  content_group :test do

    content_attribute :test1, :text
    content_attribute :test2, :image

  end

end

FactoryGirl.define do
  sequence(:title) { |n| "node-#{n}" }
  factory :content_node, class: Cms::ContentNode do
    type TestNode.to_s
    title
    template 'template'

    trait :with_attrs do
      test1 'some text'
      float 12.1
    end

    trait :with_component do
      content_components { [create(:content_component)] }
    end

    trait :nil_type do
      type nil
    end

    trait :invalid_type do
      type 'SomeType'
    end

  end

  factory :test_node, class: TestNode do
    type TestNode.to_s
    title
    template 'template'
    float 12.1
    test1 'some text'
    test2 { create(:content_image).id }
  end

end
