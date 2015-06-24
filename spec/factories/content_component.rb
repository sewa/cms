
class TestComponent < Cms::ContentComponent

  icon '/some/path/icon.png'

  content_attribute :text, :text
  content_attribute :float, :float

end

class TestComponent1 < Cms::ContentComponent

  icon '/some/path/icon.png'

  content_attribute :test1, :text
  content_attribute :test2, :string

end

FactoryGirl.define do
  factory :content_component, class: 'Cms::ContentComponent' do

    template :page

    trait :with_node do
      componentable { create(:content_node) }
    end

  end

  factory :test_comp, class: TestComponent, parent: :content_component do |u|
    type 'TestComponent'
    text 'some text'
    float 12.1
  end

  factory :test_comp_1, class: TestComponent1, parent: :content_component do |u|
    type 'TestComponent1'
    test1 'test1'
    test2 'test2'
  end

end
