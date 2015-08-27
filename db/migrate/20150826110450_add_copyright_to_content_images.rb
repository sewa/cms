class AddCopyrightToContentImages < ActiveRecord::Migration
  def change
    add_column :content_images, :copyright, :string
  end
end
