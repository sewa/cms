# endcoding: utf-8
class UrlAttribute < Cms::ContentAttribute
  content_type :string

  validate :value_valid?

  protected

  def value_valid?
    return if value.blank?
    unless value.match(/^http:\/\/|^https:\/\/|^\//)
      errors.add(:value, I18n.t('errors.url_attribute.invalid'))
    end
  end

end
