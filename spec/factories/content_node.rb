# encoding: UTF-8

module TestNodes

  class Page < Cms::Page

    content_group :content do
      content_attribute :test_text, :text
      content_attribute :test_image, :image
      content_attribute :test_document, :document
      content_attribute :test_float, :float

      validates :test_float, presence: true, numericality: true
    end

    after_initialize :load_attributes

  end

end

FactoryGirl.define do
  sequence(:title) { |n| "name-#{n}" }

  factory :content_node, class: Cms::ContentNode do
    type Cms::ContentNode.to_s
    title
    template 'template'

    trait :with_component do
      after :create do |node|
        create(:text_component, componentable: node)
      end
    end

    trait :nil_type do
      type nil
    end

    trait :invalid_type do
      type 'SomeType'
    end

    trait :public do
      access 'public'
    end

    factory :page, class: TestNodes::Page do
      type TestNodes::Page.to_s
      trait :valid do
        test_float 12.1
      end
      trait :test_document do
        test_document { create(:content_document).id }
      end
      trait :test_image do
        test_image { create(:content_image).id }
      end
      trait :test_text do
        test_text Faker::Lorem.paragraph
      end
      trait :contact do
        after :create do |node|
          create(:contact_component, componentable: node)
        end
      end
    end

  end

end
