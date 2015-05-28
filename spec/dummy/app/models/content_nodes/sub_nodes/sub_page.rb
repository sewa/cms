class SubPage < Cms::ContentNode

  content_group :body do
    content_attribute :body, :text

    content_attribute :overview_thumb, :image
    content_attribute :overview_text, :text
  end

  content_group :documents do
    content_attribute :documents, :document_list
  end

  template 'page'
end
