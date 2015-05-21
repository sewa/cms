# endcoding: utf-8
class FileAttribute < ActiveRecord::Base
  content_type :string

  PATH = 'media/uploads'

  def value
    File.exists?("#{path}") ? self.read_attribute(:value) : ''
  end

  def value=(file)
    if content_node.respond_to? :validate_mime_type
      return unless content_node.send(:validate_mime_type, file.content_type)
    end

    if value && File.exists?("#{path}")
      File.delete(path)
    end

    if file_name = uniqe(file.original_filename)
      File.open("#{base_path}/#{file_name}", 'w') do |f|
        f.write(file.read)
      end
      write_attribute(:value, uniqe(file.original_filename))
    end
  end

  protected

  def base_url
    PATH
  end

  def base_path
    path = Rails.root.join('public', PATH)
    if !File.directory?(path)
      Dir.mkdir(path)
    end
    path
  end

  def path
    "#{base_path}/#{self.read_attribute(:value)}"
  end

  def uniqe(string)
    if string
      "#{Time.now.to_i}_#{string}"
    else
      nil
    end
  end

end
