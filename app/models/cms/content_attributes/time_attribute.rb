# endcoding: utf-8
class TimeAttribute < Cms::ContentAttribute
  content_type :datetime

  def value=(time)
    if time.present? && value = Time.zone.parse(time)
      assign_value(value)
    end
  end

end
