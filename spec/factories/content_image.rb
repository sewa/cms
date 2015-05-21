# encoding: UTF-8
include ActionDispatch::TestProcess

FactoryGirl.define do

  factory :content_image, class: Cms::ContentImage do
    alt "Alternative Text"
    image { fixture_file_upload(Rails.root.join('../../spec/fixtures/test_image.jpg'), 'image/jpg') }
  end

end
