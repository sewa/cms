
class TestComponent < Cms::ContentComponent

  icon '/some/path/icon.png'

  content_attribute :text, :text
  content_attribute :float, :float

end

FactoryGirl.define do
  factory :content_component, :class => 'Cms::ContentComponent' do
    type 'TestComponent'
    content_node { create(:content_node) }

    trait :without_node do
      content_node { nil }
    end

    trait :with_attrs do
      text 'some text'
      float 12.1
    end
  end
end
