class Page4 < Cms::ContentNode

  template 'page'

  child_nodes except: ['Page1', 'Page2']

  use_components except: ['TestComponent2']

  content_group :test do
    content_attribute :body, :text
    content_attribute :overview_thumb, :image
    content_attribute :overview_text, :text
  end

  content_group :images do
    content_attribute :images, :image_list
  end

end
