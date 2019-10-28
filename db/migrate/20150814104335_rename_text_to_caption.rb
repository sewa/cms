class RenameTextToCaption < ActiveRecord::Migration[5.2]
  def change
    remove_column :content_images, :caption
    rename_column :content_images, :text, :caption
  end
end
