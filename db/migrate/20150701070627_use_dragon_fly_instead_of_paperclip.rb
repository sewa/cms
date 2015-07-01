class UseDragonFlyInsteadOfPaperclip < ActiveRecord::Migration
  def up
    remove_column :content_images, :image_file_name
    remove_column :content_images, :image_content_type
    remove_column :content_images, :image_file_size
    remove_column :content_images, :image_updated_at

    add_column :content_images, :image_uid, :string
    add_column :content_images, :image_name, :string
    add_column :content_images, :image_width, :integer
    add_column :content_images, :image_height, :integer
  end

  def down
    add_column :content_images, :image_file_name, :string
    add_column :content_images, :image_content_type, :string
    add_column :content_images, :image_file_size, :integer
    add_column :content_images, :image_updated_at, :datetime

    remove_column :content_images, :image_uid
    remove_column :content_images, :image_name
    remove_column :content_images, :image_width
    remove_column :content_images, :image_height
  end

end
