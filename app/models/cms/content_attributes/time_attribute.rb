# endcoding: utf-8
class TimeAttribute < Cms::ContentAttribute
  content_type :datetime

  def value=(time)
    if time.present? && value = Time.zone.parse(time)
      assign_value(value)
    else
      if content_value.present?
        content_value.destroy
      end
    end
  end
end
