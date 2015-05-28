class Page2 < Cms::ContentNode

  template 'page'

  sub_node 'SubPage'
  sub_node 'SubPage1'

  content_group :overview do
    content_attribute :body, :text

    content_attribute :overview_thumb, :image
    content_attribute :overview_text, :text
  end

  content_group :list do
    content_attribute :images, :image_list
  end

end
