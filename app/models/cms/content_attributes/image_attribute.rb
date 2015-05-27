# endcoding: utf-8
class ImageAttribute < Cms::ContentAttribute
  content_type :reference, 'Cms::ContentImage'

  def image
    self.value
  end

end
