class SubPage2 < Cms::ContentNode

  content_group :body do
    content_attribute :body, :text

    content_attribute :overview_thumb, :image
    content_attribute :overview_text, :text
  end

  content_group :images do
    content_attribute :images, :image_list
  end

  template 'page'
end
