class Page < Cms::ContentNode

  template 'page'

  sub_node 'SubPage'
  sub_node 'SubPage1'

  common_sub_nodes true

  content_group :test do
    content_attribute :body, :text
    content_attribute :overview_thumb, :image
    content_attribute :overview_text, :text
  end

  content_group :images do
    content_attribute :images, :image_list
  end

end
