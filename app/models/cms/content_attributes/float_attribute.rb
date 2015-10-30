# encoding: utf-8
class FloatAttribute < Cms::ContentAttribute
  content_type :float

  # assgin 0.0 if value is blank
  def value=(value)
    assign_value(value.present? ? value : value.to_f)
  end

  # do not return 0.0 values
  def value
    val = fetch_value
    val if val.present? && val > 0
  end

end
