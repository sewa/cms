# encoding: UTF-8

class TestNode < Cms::ContentNode

  content_attribute :test1, :text
  content_attribute :test2, :image

end

FactoryGirl.define do

  factory :content_node, class: Cms::ContentNode do
    type TestNode.to_s
    title 'some title'
    template 'template'

    trait :node_with_attrs do
      test1 'some text'
      test2 12
    end

    trait :nil_type do
      type nil
    end

    trait :invalid_type do
      type 'SomeType'
    end

  end

end
