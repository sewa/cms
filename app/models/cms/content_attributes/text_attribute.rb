# encoding: utf-8
class TextAttribute < Cms::ContentAttribute
  content_type :text

  def value
    read_attribute(:value).to_s.html_safe
  end

end
