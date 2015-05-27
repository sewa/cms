class CreateContentImages < ActiveRecord::Migration
  def change
    # baustoffe renamed href to url and removed the imageable relations
    # fliesen removed underline attr -> this has to be inserted in caption
    create_table :content_images do |t|
      t.string :caption
      t.string :tags
      t.string :text
      t.string :url
      t.string :alt
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
      t.timestamps null: false
    end
  end
end
