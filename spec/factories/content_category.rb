FactoryBot.define do
  sequence(:name) { |n| "name-#{n}" }
  factory :content_category, class: 'Cms::ContentCategory' do
    name
    trait :with_node do
      content_nodes { [create(:content_node)] }
    end
  end
end
