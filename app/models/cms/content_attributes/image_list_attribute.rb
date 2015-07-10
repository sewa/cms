# endcoding: utf-8
class ImageListAttribute < Cms::ContentAttribute
  content_type :string

  include Cms::ContentAttributes::Concerns::ReferenceList

  def reference_class
    Cms::ContentImage
  end

end
