class ChangeContentImagesTextToText < ActiveRecord::Migration
  def change
    change_column :content_images, :text, :text
  end
end
