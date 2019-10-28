class ChangeContentImagesTextToText < ActiveRecord::Migration[5.2]
  def change
    change_column :content_images, :text, :text
  end
end
