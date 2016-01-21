module TestComponents

  class Contact < Cms::ContentComponent
    icon '/some/path/contact.png'

    template 'contact'

    content_attribute :first_name, :string
    content_attribute :last_name, :string
    content_attribute :size, :float

    after_initialize :load_attributes
  end

  class Text < Cms::ContentComponent
    icon '/some/path/text.png'

    template 'text'

    content_attribute :test_text, :text

    validates :test_text, presence: true

    after_initialize :load_attributes
  end

end

FactoryGirl.define do
  factory :content_component, class: Cms::ContentComponent do

    template 'default'

    trait :with_node do
      componentable { create(:content_node) }
    end

    factory :contact_component, class: TestComponents::Contact, parent: :content_component do
      type TestComponents::Contact.to_s
      first_name Faker::Name.first_name
      last_name Faker::Name.last_name
      size 12.1
    end

    factory :text_component, class: TestComponents::Text, parent: :content_component do
      type TestComponents::Text.to_s
      trait :valid do
        test_text Faker::Lorem.paragraph
      end
    end
  end
end
