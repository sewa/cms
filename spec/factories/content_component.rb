
class TestComponent < Cms::ContentComponent

  component_name 'test'
  component_icon '/some/path/icon.png'

end

FactoryGirl.define do
  factory :content_component, :class => 'Cms::ContentComponent' do
    name
    type 'Cms::ContentComponent'
    trait :with_node do
      content_nodes { [create(:content_node)] }
    end
  end
end
