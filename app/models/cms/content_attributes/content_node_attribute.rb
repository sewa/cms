# endcoding: utf-8
class ContentNodeAttribute < Cms::ContentAttribute
  content_type :reference, 'Cms::ContentNode'

  include Cms::ContentAttributes::Concerns::ReferenceItem

  def reference_class
    Cms::ContentNode
  end

end
