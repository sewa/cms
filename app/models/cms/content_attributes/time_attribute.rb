# endcoding: utf-8
class TimeAttribute < Cms::ContentAttribute
  content_type :datetime

  def value=(time)
    if time.present?
      assign_value(Time.zone.parse(time))
    end
  end

end
