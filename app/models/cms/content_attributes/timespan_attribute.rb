# encoding: utf-8
class TimespanAttribute < Cms::ContentAttribute
  serialize :value

  def value=(value)
    unless value[:start].blank? && value[:end].blank?
      write_attribute(:value, { start: Time.parse(value[:start]), end: Time.parse(value[:end]) })
    end
  end

end
