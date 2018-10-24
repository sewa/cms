class AddCopyrightToContentImages < ActiveRecord::Migration[5.2]
  def change
    add_column :content_images, :copyright, :string
  end
end
