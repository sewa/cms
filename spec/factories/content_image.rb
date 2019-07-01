# encoding: UTF-8
include ActionDispatch::TestProcess

FactoryBot.define do
  factory :content_image, class: Cms::ContentImage do
    alt { 'Alternative Text' }
    tags { 'test, test2' }
    image { fixture_file_upload(Rails.root.join('../../spec/fixtures/test_image.jpg'), 'image/jpg') }
    trait :with_invalid_image do
      image { fixture_file_upload(Rails.root.join('../../spec/fixtures/test.pdf'), 'application/pdf') }
    end
  end
end
