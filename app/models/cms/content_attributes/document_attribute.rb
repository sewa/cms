# endcoding: utf-8
class DocumentAttribute < Cms::ContentAttribute
  content_type :reference, 'Cms::ContentDocument'

  include Cms::ContentAttributes::Concerns::ReferenceItem

  def reference_class
    Cms::ContentDocument
  end

end
