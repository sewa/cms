# endcoding: utf-8
class DocumentListAttribute < Cms::ContentAttribute
  content_type :string

  def documents
    (fetch_value || '').split(',').reject(&:blank?).map do |id|
      Cms::ContentDocument.find(id)
    end
  end

  def value=(value)
    assign_value(value.reject(&:blank?).join(','))
  end

end
