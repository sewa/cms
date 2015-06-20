class Page < Cms::ContentNode

  template 'page'

  child_nodes ['Page2', 'Page3']

  use_components ['TestComponent', 'TestComponent2']

  content_group :test do
    content_attribute :body, :text
    content_attribute :overview_thumb, :image
    content_attribute :overview_text, :text
  end

  content_group :images do
    content_attribute :images, :image_list
  end

end
