# endcoding: utf-8
class ImageListAttribute < Cms::ContentAttribute
  content_type :string

  def value
    read_attribute(:value).to_s.split(',').map {|id| Cms::ContentImage.find_by_id(id) }
  end

  def value=(json)
    images = ActiveSupport::JSON.decode(json)
    ids = images.map {|p| p['id'] }.join(',')
    write_value(ids)
  end

end
