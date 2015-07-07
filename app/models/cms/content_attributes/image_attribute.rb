# endcoding: utf-8
class ImageAttribute < Cms::ContentAttribute
  content_type :reference, 'Cms::ContentImage'

  def value=(value)
    if image = image(value)
      assign_value(image.id)
    end
  end

  protected

  def image(value)
    Cms::ContentImage.find_by_id(value)
  end

end
