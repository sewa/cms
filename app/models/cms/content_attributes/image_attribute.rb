# endcoding: utf-8
class ImageAttribute < Cms::ContentAttribute
  content_type :reference, 'Cms::ContentImage'

  include Cms::ContentAttributes::Concerns::ReferenceItem

  def reference_class
    Cms::ContentImage
  end

end
