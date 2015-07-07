# endcoding: utf-8
class DocumentListAttribute < Cms::ContentAttribute
  content_type :string

  include Cms::ContentAttributes::Concerns::List

  def reference_class
    Cms::ContentDocument
  end

end
