# endcoding: utf-8
class ImageListAttribute < Cms::ContentAttribute
  content_type :string

  def value
    (fetch_value || '').split(',').reject(&:blank?).map do |id|
      Cms::ContentImage.find_by_id(id)
    end.compact
  end

  def value=(value)
    assign_value((value || []).reject(&:blank?).join(','))
  end

end
