FactoryGirl.define do
  factory :content_document, :class => 'Cms::ContentDocument' do
    name 'test'
    attachment { fixture_file_upload(Rails.root.join('../../spec/fixtures/test.pdf'), 'application/pdf') }
  end
end
